-- Quando a SC9 nasce?
-- Lista TODOS os pedidos emitidos hoje e diz se ja existe liberacao gravada.
-- Nao precisa trocar nada: crie o pedido em cartao, salve, e rode.
--
-- Pedido recem-criado aparecendo como COM SC9  -> nasce na inclusao
-- Pedido recem-criado aparecendo como SEM SC9  -> nasce na liberacao
SELECT
  C5.C5_FILIAL   AS FILIAL,
  C5.C5_NUM      AS PEDIDO,
  C5.C5_CONDPAG  AS COND,
  C9.C9_ITEM     AS ITEM,
  C9.C9_BLCRED   AS BLQCRED,
  C9.C9_BLEST    AS BLQEST,
  CASE WHEN C9.C9_PEDIDO IS NULL THEN 'SEM SC9' ELSE 'COM SC9' END AS SITUACAO
FROM SC5010 C5
LEFT JOIN SC9010 C9
       ON C9.C9_FILIAL = C5.C5_FILIAL
      AND C9.C9_PEDIDO = C5.C5_NUM
      AND C9.D_E_L_E_T_ = ' '
WHERE C5.D_E_L_E_T_ = ' '
  AND C5.C5_EMISSAO = '20260914'
ORDER BY C5.C5_FILIAL, C5.C5_NUM, C9.C9_ITEM
