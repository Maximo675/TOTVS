"""Diagnostico rapido: NAO mostra sua senha, so informacoes sobre o formato dela,
pra ver se voce colou mais coisa do que devia (rotulo, espaco, quebra de linha etc).
Rode: python diagnostico_senha.py
"""

senha = input(
    "Cola aqui a senha do SFTP (copiada agora do TCloud) e ENTER "
    "(vai aparecer na tela -- e assim mesmo, e so pra diagnostico local): "
)

print()
print(f"Tamanho (com tudo que foi colado): {len(senha)} caracteres")
print(f"Tamanho depois de tirar espaco/quebra de linha do inicio e fim: {len(senha.strip())}")
print(f"Tem espaco no MEIO da senha? {'SIM' if ' ' in senha.strip() else 'nao'}")
print(f"Tem quebra de linha (Enter) no MEIO? {'SIM' if chr(10) in senha.strip() or chr(13) in senha.strip() else 'nao'}")
print(f"Tem tabulacao (Tab) em algum lugar? {'SIM' if chr(9) in senha else 'nao'}")

palavras_suspeitas = ["senha", "password", "usuario", "username", "host", "porta", "port", "sftp"]
achou = [p for p in palavras_suspeitas if p in senha.lower()]
if achou:
    print(f"ATENCAO: a senha colada contem a(s) palavra(s) {achou} -- isso e forte "
          f"indicio de que voce copiou um pedaco de texto maior do que so a senha "
          f"(por exemplo, um rotulo tipo 'Senha:' junto). Volta no TCloud e copia "
          f"so o valor da senha, de preferencia usando o botao/icone de copiar ao "
          f"lado do campo, se tiver um.")
else:
    print("Nao encontrei rotulos conhecidos misturados na senha.")

print()
print(f"Primeiros 2 caracteres: {senha.strip()[:2]!r}")
print(f"Ultimos 2 caracteres:   {senha.strip()[-2:]!r}")
print()
print("Guarda essas informacoes so pra voce -- nao precisa me mandar a senha, so me "
      "conta o que apareceu aqui (tamanho, se tinha espaco/quebra de linha/rotulo).")
