-- Chamado Comex - relatorios perdidos SAP -> TOTVS
-- 04b) Versao da 04 que FUNCIONA EM DEV. A copia de dev vai ate ~13/08/2026
--      (ultimo pedido em moeda estrangeira na query 03), entao a PO 886 da
--      Entrust (setembro) nao existe la - o "000886" de dev e outro pedido
--      (caixa de papelao, filial 1001002). Aqui usamos o pedido 000697 da filial
--      3001001, que esta em dev e ja tem a referencia "PO 697.APE.26" gravada.
-- Monta as colunas do Rascunho DUIMP: codigo, codigo SAP, descricao, qtd, FOB,
-- NCM, EX. (Descricao DI = memo B1_ZDETDI fica de fora ate a query 07 dizer
-- como o memo esta gravado.)
-- Pode repetir linha se o SB1 for exclusivo por filial (por isso B1_FILIAL).
-- SOMENTE LEITURA.
SELECT
    C7.C7_FILIAL,
    C7.C7_NUM,
    C7.C7_PO_EIC,
    C7.C7_ITEM,
    C7.C7_PRODUTO,
    B1.B1_ZCODSAP,
    C7.C7_DESCRI,
    C7.C7_QUANT,
    C7.C7_PRECO,
    C7.C7_TOTAL,
    C7.C7_MOEDA,
    B1.B1_FILIAL,
    B1.B1_POSIPI,
    B1.B1_EX_NCM,
    C7.C7_EX_NCM
FROM SC7010 C7
LEFT JOIN SB1010 B1
       ON TRIM(B1.B1_COD) = TRIM(C7.C7_PRODUTO)
      AND B1.D_E_L_E_T_ <> '*'
WHERE C7.D_E_L_E_T_ <> '*'
  AND TRIM(C7.C7_FILIAL) = '3001001'
  AND TRIM(C7.C7_NUM) = '000697'
ORDER BY C7.C7_ITEM, B1.B1_FILIAL
