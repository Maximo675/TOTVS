-- Panorama da SC9: em que estados os registros existem neste ambiente.
-- Se so houver '10' (faturado), a SC9 nasce no faturamento e nao antes.
SELECT
  C9_BLCRED,
  C9_BLEST,
  COUNT(*) AS QTD,
  MIN(C9_DATLIB) AS PRIMEIRA_LIB,
  MAX(C9_DATLIB) AS ULTIMA_LIB
FROM SC9010
WHERE D_E_L_E_T_ <> '*'
GROUP BY C9_BLCRED, C9_BLEST
ORDER BY QTD DESC
