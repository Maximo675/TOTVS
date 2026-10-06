-- Chamado Comex - relatorios perdidos SAP -> TOTVS
-- 16) Exporta codigo Protheus x codigo SAP x NCM x EX de todos os produtos.
--     Uso: eu cruzo este arquivo com a aba "ITENS COM EX - 2026" da planilha do
--     Comex (3.248 itens, 3.104 so com codigo SAP) para medir quantos EX daria
--     para carregar no campo padrao B1_EX_NCM (hoje vazio em todos os
--     produtos - query 09). Nada e gravado: e so a conta de cobertura.
-- ~4.600 linhas: se o zTiSQL avisar que e pesado, use "Export. Resultado".
-- SOMENTE LEITURA.
SELECT
    B1_FILIAL,
    B1_COD,
    B1_ZCODSAP,
    B1_POSIPI,
    B1_EX_NCM,
    B1_DESC
FROM SB1010
WHERE D_E_L_E_T_ <> '*'
ORDER BY B1_COD, B1_FILIAL
