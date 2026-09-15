-- Diagnostico: ultimos pedidos e seus registros de liberacao.
-- LEFT JOIN so por numero do pedido (sem casar filial) de proposito:
-- se C9_FILIAL vier preenchido com formato diferente de C5_FILIAL,
-- descobrimos aqui. Se vier tudo nulo, nao existe SC9 para o pedido.
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
LEFT JOIN SC9010 C9 ON C9.C9_PEDIDO = C5.C5_NUM
                   AND C9.D_E_L_E_T_ <> '*'
WHERE C5.D_E_L_E_T_ <> '*'
ORDER BY C5.C5_NUM DESC
FETCH FIRST 40 ROWS ONLY
