-- Chamado: Vendas - Campo automatico na analise de credito (parte "data de emissao")
-- 04) Existe titulo gravado SEM data de emissao? (amostra de ate 20 de cada tabela)
-- Datas no Protheus sao CHAR(8) 'AAAAMMDD'; "vazio" = espacos, por isso o TRIM(...) IS NULL
-- (mesma armadilha do CHAR vazio que pegamos no chamado anterior).
-- Resultado VAZIO = bom sinal: a emissao esta gravada em todos os titulos e o problema e
-- de EXIBICAO/uso no fluxo, nao de dado faltando.
-- SOMENTE LEITURA (SELECT). Sem COUNT(*) de proposito (zTiSQL trava com agregacao + alias).
SELECT 'SE1' AS ORIGEM, E1_FILIAL AS FILIAL, E1_PREFIXO AS PREFIXO, E1_NUM AS NUMERO,
       E1_PARCELA AS PARCELA, E1_TIPO AS TIPO, E1_CLIENTE AS CLIFOR, E1_LOJA AS LOJA,
       E1_EMISSAO AS EMISSAO, E1_VENCTO AS VENCTO, E1_VENCREA AS VENCREA
FROM SE1010
WHERE D_E_L_E_T_ <> '*'
  AND TRIM(E1_EMISSAO) IS NULL
  AND ROWNUM <= 20
UNION ALL
SELECT 'SE2' AS ORIGEM, E2_FILIAL AS FILIAL, E2_PREFIXO AS PREFIXO, E2_NUM AS NUMERO,
       E2_PARCELA AS PARCELA, E2_TIPO AS TIPO, E2_FORNECE AS CLIFOR, E2_LOJA AS LOJA,
       E2_EMISSAO AS EMISSAO, E2_VENCTO AS VENCTO, E2_VENCREA AS VENCREA
FROM SE2010
WHERE D_E_L_E_T_ <> '*'
  AND TRIM(E2_EMISSAO) IS NULL
  AND ROWNUM <= 20
