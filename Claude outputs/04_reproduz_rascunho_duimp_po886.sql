-- Chamado Comex - relatorios perdidos SAP -> TOTVS
-- 04) TESTE DE ACEITE do Rascunho DUIMP: tenta reproduzir, a partir do banco,
--     o modelo "RASCUNHO DUIMP - PO 886.ENT.26" enviado pelo Comex (15 itens,
--     ex.: RV-002-00015 qtd 3 FOB 5,71 NCM 8443.99.50).
-- Hipotese: "PO 886" = pedido de compra 000886. Se vier vazio, a hipotese cai
-- e precisamos saber com o Comex qual e o numero do pedido no Protheus.
-- B1_POSIPI = NCM (padrao). B1_EX_NCM = EX da NCM (padrao; conferir se e o mesmo
-- EX-tarifario de II que o Comex usa). Se algum campo der ORA-00904, me avise.
-- Pode repetir linha se o cadastro de produtos (SB1) for exclusivo por filial:
-- por isso vem B1_FILIAL junto.
-- SOMENTE LEITURA.
SELECT
    C7.C7_FILIAL,
    C7.C7_NUM,
    C7.C7_ITEM,
    C7.C7_PRODUTO,
    C7.C7_DESCRI,
    C7.C7_QUANT,
    C7.C7_PRECO,
    C7.C7_TOTAL,
    C7.C7_MOEDA,
    C7.C7_PO_EIC,
    B1.B1_FILIAL,
    B1.B1_DESC,
    B1.B1_POSIPI,
    B1.B1_EX_NCM
FROM SC7010 C7
LEFT JOIN SB1010 B1
       ON TRIM(B1.B1_COD) = TRIM(C7.C7_PRODUTO)
      AND B1.D_E_L_E_T_ <> '*'
WHERE C7.D_E_L_E_T_ <> '*'
  AND TRIM(C7.C7_NUM) = '000886'
ORDER BY C7.C7_FILIAL, C7.C7_ITEM
