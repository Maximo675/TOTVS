"""Analisa o diretorio de spool do Protheus (TOTVS Cloud, via SFTP) e tenta casar cada
arquivo .prt com um Fonte da Lista_TOTVS (comparando o texto do cabecalho do relatorio
com a Descricao de cada Fonte), pra montar a evidencia de uso do passo 6 do chamado.

COMO USAR
---------
1. Rode este script NO SEU COMPUTADOR (nunca envie sua senha do SFTP pra mim/pro chat).
2. Instale a dependencia, se ainda nao tiver:
       pip install paramiko
3. Confirme HOST / PORT / USERNAME logo abaixo (mesmos dados do FileZilla). A SENHA
   nao fica mais gravada no arquivo -- o script vai perguntar ela toda vez que voce
   rodar (cola a senha direto do TCloud ali na hora, igual voce faz no FileZilla;
   ela nao aparece na tela enquanto voce cola, isso e normal do getpass).
4. Confirme REMOTE_SPOOL_DIR (ja preenchido com o caminho que voce achou:
   /ftp_C94DEB_production/dev/spool). Se o caminho no seu FileZilla for diferente, ajuste.
5. Coloque o arquivo lista_totvs_fontes.csv (baixado junto com este script) na MESMA pasta
   deste .py antes de rodar.
6. Rode:  python analisar_spool.py
   Vai demorar um pouco (sao ~1500 arquivos, mas so le os primeiros bytes de cada um,
   nao baixa o arquivo inteiro).
7. No final, ele gera 2 arquivos nesta mesma pasta:
   - spool_por_fonte.csv         -> resumo por Fonte (quantos arquivos, primeira/ultima
                                     data, meses em que apareceu) -> entra na aba Uso.
   - spool_sem_match_amostra.csv -> amostra dos arquivos que nao bateram com nenhuma
                                     Descricao da Lista_TOTVS, pra conferir manualmente
                                     (nao e necessariamente um problema -- pode ser spool
                                     de coisas fora do escopo do chamado).
   Me manda os dois (ou so cola o conteudo) que eu incorporo na planilha.
"""

import csv
import datetime
import difflib
import getpass
import logging
import re
import sys
from collections import defaultdict

try:
    import paramiko
    import paramiko.message
    import paramiko.sftp_client
except ImportError:
    print("Falta instalar a biblioteca paramiko. Rode: pip install paramiko")
    sys.exit(1)


def _decodificar_tolerante(valor, encoding="utf8"):
    """Substitui a funcao interna do paramiko que transforma bytes em texto.

    O servidor de spool do Protheus manda alguns nomes de arquivo com acento
    (comum em ambiente Windows) que NAO estao em UTF-8 -- por isso o paramiko
    quebra com 'UnicodeDecodeError' ao listar o diretorio. Aqui a gente tenta
    UTF-8 primeiro (o padrao) e, se falhar, cai pra latin-1 (cobre a acentuacao
    tipica de Windows/PT-BR) em vez de travar o script inteiro."""
    if isinstance(valor, bytes):
        try:
            return valor.decode(encoding)
        except UnicodeDecodeError:
            return valor.decode("latin-1")
    if isinstance(valor, str):
        return valor
    raise TypeError(f"Esperava str ou bytes, recebi {valor!r}")


# Precisa "trocar" a funcao nos 3 lugares porque cada modulo do paramiko
# importou a sua propria copia da referencia (from paramiko.util import u).
paramiko.util.u = _decodificar_tolerante
paramiko.message.u = _decodificar_tolerante
paramiko.sftp_client.u = _decodificar_tolerante

# ============================================================
# PREENCHA AQUI (mesmos dados do FileZilla / Site Manager).
# A senha NAO fica aqui -- o script pede ela no terminal a cada execucao (ver
# obter_senha() mais abaixo), assim ela nunca fica salva em texto puro no
# arquivo nem sofre corrupcao de encoding ao salvar o .py.
# ============================================================
HOST = "akiyamasa204909.protheus.cloudtotvs.com.br"  # CONFERIDO com o Maximo em 24/09: e 09 mesmo, nao mexer
PORT = 11202  # porta do SFTP (nao e a 11204 do webapp)
USERNAME = "ftp_C94DEB_production"  # ATENCAO Maximo: confira este valor contra o campo
# "Usuario"/"User" do FileZilla, letra por letra, ANTES de rodar. Esse username aqui
# nao e sensivel (nao e senha), pode me confirmar aqui no chat se bateu ou nao.

REMOTE_SPOOL_DIR = "/ftp_C94DEB_production/dev/spool"
LISTA_TOTVS_CSV = "lista_totvs_fontes.csv"  # baixado junto com este script

HEADER_BYTES = 4096  # quantos bytes ler do inicio de cada .prt (so o cabecalho)
MATCH_THRESHOLD = 0.55  # confianca minima (0-1) pra considerar que achou o Fonte certo
PROGRESS_EVERY = 100  # a cada quantos arquivos processados imprime um "..."
DEBUG_SSH = True  # True = mostra o log detalhado da negociacao SSH (pra diagnosticar
                   # o "Authentication failed"). Depois que conectar, pode voltar pra False.

# ============================================================


def carregar_lista_totvs(path):
    """Le o CSV Modulo_Chamado,Fonte,Descricao,Modulo_TDN_original,EmEscopo e devolve
    uma lista de (fonte, descricao, modulo) para as linhas que tem descricao."""
    fontes = []
    with open(path, newline="", encoding="utf-8") as f:
        reader = csv.reader(f)
        next(reader)  # cabecalho
        for row in reader:
            modulo, fonte, desc, _modulo_tdn, _em_escopo = row
            if desc.strip():
                fontes.append((fonte.strip().upper(), desc.strip(), modulo.strip()))
    return fontes


def normalizar(txt):
    """Deixa o texto maiusculo, só letras/numeros/espaço, pra comparar sem ruído."""
    txt = txt.upper()
    txt = re.sub(r"[^A-Z0-9 ]", " ", txt)
    txt = re.sub(r"\s+", " ", txt).strip()
    return txt


def extrair_texto_cabecalho(raw_bytes):
    """Decodifica os bytes do cabeçalho do .prt (Protheus grava em cp1252)."""
    return raw_bytes.decode("cp1252", errors="replace")


def achar_melhor_fonte(cabecalho_norm, fontes_norm):
    """Tenta achar, entre as descricoes da Lista_TOTVS, a que mais aparece dentro do
    cabecalho do spool. Primeiro tenta 'contem' direto (mais confiavel); se nao achar
    nenhuma, cai pra similaridade aproximada (fuzzy) trecho por trecho."""
    contidas = [f for f in fontes_norm if f[1] and f[1] in cabecalho_norm]
    if contidas:
        contidas.sort(key=lambda f: len(f[1]), reverse=True)
        return contidas[0][0], contidas[0][2], 1.0

    melhor = (None, None, 0.0)
    palavras = cabecalho_norm.split()
    for fonte, desc_norm, desc_original in fontes_norm:
        if not desc_norm:
            continue
        n = len(desc_norm.split())
        if n == 0:
            continue
        for i in range(0, max(1, len(palavras) - n + 1)):
            janela = " ".join(palavras[i:i + n])
            score = difflib.SequenceMatcher(None, janela, desc_norm).ratio()
            if score > melhor[2]:
                melhor = (fonte, desc_original, score)
    return melhor


def titulo_provavel(cabecalho):
    """Pega a primeira linha do cabecalho que não parece ser metadado de rodapé
    padrão (SIGA/..., Hora:, Grupo de Empresa:, Dt.Ref, Emissão) -- é o melhor
    palpite pro título do relatório quando não achamos Fonte correspondente."""
    ignorar = ("siga", "hora:", "grupo de empresa", "dt.ref", "emiss")
    linhas = [l.strip() for l in cabecalho.splitlines() if l.strip()]
    for linha in linhas[:8]:
        if not linha.lower().startswith(ignorar):
            return linha
    return linhas[0] if linhas else ""


def processar_arquivo(sftp, entry, fontes, fontes_norm):
    """Le o cabecalho de 1 arquivo de spool e devolve (matched, dados) onde matched
    é True/False e dados é a tupla pronta pra ir no CSV correspondente."""
    remote_path = f"{REMOTE_SPOOL_DIR}/{entry.filename}"
    with sftp.open(remote_path, "rb") as fh:
        raw = fh.read(HEADER_BYTES)

    cabecalho = extrair_texto_cabecalho(raw)
    cabecalho_norm = normalizar(cabecalho)
    fonte, desc_original, score = achar_melhor_fonte(cabecalho_norm, fontes_norm)
    mtime = datetime.datetime.fromtimestamp(entry.st_mtime)

    if fonte and score >= MATCH_THRESHOLD:
        modulo = next((m for f, _d, m in fontes if f == fonte), "")
        return True, (fonte, desc_original, modulo, mtime)

    return False, (entry.filename, mtime.strftime("%d/%m/%Y %H:%M"), titulo_provavel(cabecalho))


def gravar_resumo_por_fonte(resumo):
    """Grava spool_por_fonte.csv: 1 linha por Fonte com contagem e datas."""
    with open("spool_por_fonte.csv", "w", newline="", encoding="utf-8-sig") as f:
        writer = csv.writer(f)
        writer.writerow(["Fonte", "Descricao", "Modulo", "Qtde_arquivos_spool",
                          "Primeira_data", "Ultima_data", "Meses"])
        for fonte, info in sorted(resumo.items()):
            datas = sorted(info["datas"])
            meses = sorted({d.strftime("%m/%Y") for d in datas})
            writer.writerow([
                fonte, info["desc"], info["modulo"], info["qtd"],
                datas[0].strftime("%d/%m/%Y"), datas[-1].strftime("%d/%m/%Y"),
                ", ".join(meses),
            ])


def gravar_amostra_sem_match(sem_match, limite=300):
    """Grava spool_sem_match_amostra.csv com ate `limite` linhas para revisao manual."""
    with open("spool_sem_match_amostra.csv", "w", newline="", encoding="utf-8-sig") as f:
        writer = csv.writer(f)
        writer.writerow(["Arquivo", "Data", "Titulo_provavel_no_cabecalho"])
        for row in sem_match[:limite]:
            writer.writerow(row)


SENHA_VISIVEL = False  # True = a senha aparece na tela ao colar. So usar True
# temporariamente pra depurar tamanho/caracteres, e nesse caso CUIDADO: nao cole o
# log do terminal de volta no chat sem apagar a linha da senha primeiro (isso ja
# aconteceu -- se foi o seu caso, regenere a credencial no TCloud). No dia a dia
# deixe False (senha mascarada, oculta na tela).


def obter_senha():
    """Pede a senha no terminal. Colar aqui direto do TCloud evita o problema de a
    senha ficar salva (e potencialmente corrompida por encoding) dentro do
    arquivo .py."""
    if SENHA_VISIVEL:
        return input(
            "Cola aqui a senha do SFTP (copiada agora do TCloud) e ENTER "
            "(vai aparecer na tela, e normal): "
        )
    return getpass.getpass("Cola aqui a senha do SFTP (copiada agora do TCloud) e ENTER: ")


def conectar_e_listar():
    """Abre a conexao SFTP e devolve (sftp, cliente_ssh, lista de .prt validos).

    Usa SSHClient (em vez do Transport de baixo nivel) porque ele negocia
    sozinho entre os metodos de autenticacao que o servidor aceitar (senha
    simples ou keyboard-interactive) -- alguns gateways de SFTP gerenciado,
    como o da TOTVS Cloud, so aceitam um dos dois, e o Transport puro so
    tenta 'senha simples'."""
    if DEBUG_SSH:
        logging.basicConfig(level=logging.DEBUG)
        paramiko.util.log_to_file("paramiko_debug.log", level=logging.DEBUG)
        print("  [DEBUG_SSH=True: log detalhado tambem sendo salvo em paramiko_debug.log]")

    usuario = USERNAME.strip()
    senha = obter_senha().strip()
    print(f"Conectando em {HOST}:{PORT} (usuario '{usuario}', senha com "
          f"{len(senha)} caracteres) ...")

    cliente = paramiko.SSHClient()
    cliente.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        cliente.connect(
            HOST, port=PORT, username=usuario, password=senha,
            look_for_keys=False, allow_agent=False,
        )
    except paramiko.AuthenticationException as e:
        print(
            "Autenticacao falhou de novo, mesmo digitando a senha na hora. Confira:\n"
            "  1) colou a senha certinha, sem apertar espaco ou outra tecla antes/"
            "depois de colar (o getpass nao mostra nada na tela, mas aceita colar "
            "normalmente com Ctrl+V);\n"
            "  2) o USERNAME e o HOST la em cima do script batem, letra por letra, com "
            "o campo 'Usuario' e 'Host' do FileZilla (o mesmo que funciona no "
            "FileZilla);\n"
            "  3) se continuar falhando, roda de novo com um print(repr(senha)) logo "
            "apos o obter_senha() (temporariamente) so pra conferir visualmente se "
            "nao colou nenhum caractere estranho -- so nao me manda esse print."
        )
        raise e

    sftp = cliente.open_sftp()
    print("Conectado. Listando diretorio de spool...")

    entries = sftp.listdir_attr(REMOTE_SPOOL_DIR)
    prt_files = [e for e in entries
                 if e.filename.lower().endswith(".prt") and e.st_size and e.st_size > 0]
    print(f"{len(entries)} itens no diretorio, {len(prt_files)} arquivos .prt validos "
          f"(ignorando .lck e vazios).")
    return sftp, cliente, prt_files


def processar_todos(sftp, prt_files, fontes, fontes_norm):
    """Percorre todos os .prt, casando cada um com um Fonte quando possivel.
    Devolve (resumo_por_fonte, lista_sem_match, quantidade_de_erros_de_leitura)."""
    resumo = defaultdict(lambda: {"desc": "", "modulo": "", "qtd": 0, "datas": []})
    sem_match = []
    erros = 0

    for i, entry in enumerate(prt_files, start=1):
        try:
            matched, dados = processar_arquivo(sftp, entry, fontes, fontes_norm)
        except (OSError, paramiko.SSHException) as e:
            erros += 1
            print(f"  [erro lendo {entry.filename}: {e}]")
            continue

        if matched:
            fonte, desc_original, modulo, mtime = dados  # type: ignore[misc]
            # (o Pylance nao sabe que quando matched=True, dados sempre tem 4 posicoes --
            # processar_arquivo() devolve tupla de tamanho diferente dependendo do caso.
            # Isso e so aviso de tipagem, o codigo roda certo.)
            resumo[fonte]["desc"] = desc_original
            resumo[fonte]["modulo"] = modulo
            resumo[fonte]["qtd"] += 1
            resumo[fonte]["datas"].append(mtime)
        else:
            sem_match.append(dados)

        if i % PROGRESS_EVERY == 0:
            print(f"  ... {i}/{len(prt_files)} processados")

    return resumo, sem_match, erros


def main():
    """Ponto de entrada: conecta no SFTP, cruza o spool com a Lista_TOTVS e grava
    os dois CSVs de resultado (spool_por_fonte.csv e spool_sem_match_amostra.csv)."""
    fontes = carregar_lista_totvs(LISTA_TOTVS_CSV)
    fontes_norm = [(fonte, normalizar(desc), desc) for fonte, desc, _mod in fontes]
    print(f"Lista_TOTVS carregada: {len(fontes)} fontes.")

    sftp, cliente, prt_files = conectar_e_listar()
    resumo, sem_match, erros = processar_todos(sftp, prt_files, fontes, fontes_norm)
    sftp.close()
    cliente.close()

    gravar_resumo_por_fonte(resumo)
    gravar_amostra_sem_match(sem_match)

    print()
    print(f"PRONTO. {len(resumo)} fontes da Lista_TOTVS encontraram pelo menos 1 spool.")
    print(f"{len(sem_match)} arquivos .prt nao bateram com nenhuma Descricao "
          f"(amostra salva, ate 300 linhas). {erros} arquivos deram erro de leitura.")
    print("Arquivos gerados nesta pasta: spool_por_fonte.csv e spool_sem_match_amostra.csv")
    print("Manda os dois de volta no chat que eu incorporo na planilha.")


if __name__ == "__main__":
    main()
