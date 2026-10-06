-- Chamado Comex - relatorios perdidos SAP -> TOTVS
-- 10) Substitui a 05 em DEV. A 05 voltou vazia porque as NFs dos pedidos 860 e
--     887 (agosto) sao posteriores a copia de dev. Aqui pegamos uma NF de
--     importacao que EXISTE em dev e tem complemento de importacao (CD5) com
--     12 adicoes: NF 000088436, fornecedor F00213, filial 3001001, DI registrada
--     em 04/05/2026 (veio na query 06).
-- SELECT * de proposito: mapear quais colunas da nota guardam FOB, II, despesas,
-- custo de entrada (base do DDP e do MKPI) e o vinculo com o pedido (D1_PEDIDO).
-- SOMENTE LEITURA. ~12 linhas.
SELECT *
FROM SD1010
WHERE D_E_L_E_T_ <> '*'
  AND TRIM(D1_FILIAL)  = '3001001'
  AND TRIM(D1_DOC)     = '000088436'
  AND TRIM(D1_FORNECE) = 'F00213'
