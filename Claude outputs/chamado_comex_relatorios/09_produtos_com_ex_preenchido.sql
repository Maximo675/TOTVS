-- Chamado Comex - relatorios perdidos SAP -> TOTVS
-- 09) O campo padrao de EX-tarifario do produto (B1_EX_NCM, titulo "Ex-NCM",
--     descricao "Ex-NCM - determina % I.I.") esta preenchido em algum produto?
--     Amostra de ate 100 produtos com EX preenchido. Vazio = o campo existe mas
--     ninguem preenche (aproveitar o campo, nao criar outro).
-- Comparar com a aba "ITENS COM EX - 2026" da planilha do Comex.
-- SOMENTE LEITURA.
SELECT
    B1_FILIAL,
    B1_COD,
    B1_DESC,
    B1_POSIPI,
    B1_EX_NCM,
    B1_ZCODSAP
FROM SB1010
WHERE D_E_L_E_T_ <> '*'
  AND TRIM(B1_EX_NCM) IS NOT NULL
  AND ROWNUM <= 100
ORDER BY B1_COD
