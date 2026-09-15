-- Pedidos emitidos hoje, com LEFT JOIN na SC9.
-- Se as colunas C9_* vierem vazias, a SC9 nao existe para o pedido.
SELECT
  C5.C5_FILIAL,
  C5.C5_NUM,
  C5.C5_EMISSAO,
  C5.C5_CONDPAG,
  C9.C9_FILIAL,
  C9.C9_ITEM,
  C9.C9_BLCRED,
  C9.C9_BLEST
FROM SC5010 C5
LEFT JOIN SC9010 C9 ON C9.C9_FILIAL = C5.C5_FILIAL
                   AND C9.C9_PEDIDO = C5.C5_NUM
                   AND C9.D_E_L_E_T_ <> '*'
WHERE C5.D_E_L_E_T_ <> '*'
AND C5.C5_EMISSAO = '20260911'
ORDER BY C5.C5_FILIAL, C5.C5_NUM
