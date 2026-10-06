-- Chamado Comex - relatorios perdidos SAP -> TOTVS
-- 05) Base do Relatorio de Importacao (PO + NF-e + DI): itens das notas de
--     entrada ligadas aos pedidos 000860 e 000887 (os dois "PO" pos-migracao que
--     aparecem na planilha do Comex, entrada fiscal 25/08 e 31/08/2026).
-- SELECT * de proposito: queremos ver TODAS as colunas que a nota de importacao
-- tem preenchidas (custo, II, despesas, taxa...) para mapear o DDP e o MKPI,
-- sem chutar nome de campo.
-- SOMENTE LEITURA. Ate 60 linhas.
SELECT *
FROM SD1010
WHERE D_E_L_E_T_ <> '*'
  AND TRIM(D1_PEDIDO) IN ('000860', '000887')
  AND ROWNUM <= 60
