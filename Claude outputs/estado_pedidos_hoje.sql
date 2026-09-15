-- Estado de liberacao dos pedidos emitidos hoje (11/09/2026).
-- C9_BLCRED preenchido = retido para Analise de Credito.
SELECT
  C5.C5_FILIAL,
  C5.C5_NUM,
  C5.C5_CONDPAG,
  E4.E4_DESCRI,
  C9.C9_ITEM,
  C9.C9_BLCRED,
  C9.C9_BLEST,
  CASE WHEN C9.C9_BLCRED IS NULL OR TRIM(C9.C9_BLCRED) = ''
       THEN 'liberado p/ credito'
       ELSE 'RETIDO - analise de credito'
  END AS SITUACAO
FROM SC5010 C5
JOIN SC9010 C9 ON C9.C9_FILIAL = C5.C5_FILIAL
              AND C9.C9_PEDIDO = C5.C5_NUM
              AND C9.D_E_L_E_T_ <> '*'
LEFT JOIN SE4010 E4 ON E4.E4_CODIGO = C5.C5_CONDPAG
                   AND E4.D_E_L_E_T_ <> '*'
WHERE C5.D_E_L_E_T_ <> '*'
AND C5.C5_EMISSAO >= '20260911'
ORDER BY C5.C5_NUM, C9.C9_ITEM
