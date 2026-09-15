-- Parametros que controlam a analise de credito neste ambiente.
-- MV_BLOQUEI = .F. explica a SC9 nao ser criada/avaliada na inclusao.
SELECT X6_FIL, X6_VAR, X6_TIPO, X6_CONTEUD, X6_DESCRIC
FROM SX6010
WHERE D_E_L_E_T_ <> '*'
AND X6_VAR IN ('MV_BLOQUEI', 'MV_CREDCLI', 'MV_MCUSTO', 'MV_LIBPED', 'MV_BLOQPED')
ORDER BY X6_VAR, X6_FIL
