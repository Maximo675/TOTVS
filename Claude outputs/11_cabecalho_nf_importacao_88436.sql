-- Chamado Comex - relatorios perdidos SAP -> TOTVS
-- 11) Cabecalho da mesma NF da query 10 (SF1): FOB do cabecalho (F1_FOB_R),
--     taxa da moeda, frete, seguro, despesas - o que compoe o DDP.
-- SOMENTE LEITURA. 1 linha esperada.
SELECT *
FROM SF1010
WHERE D_E_L_E_T_ <> '*'
  AND TRIM(F1_FILIAL)  = '3001001'
  AND TRIM(F1_DOC)     = '000088436'
  AND TRIM(F1_FORNECE) = 'F00213'
