-- Valor EXATO do parametro, entre colchetes, com o tamanho real do nome.
-- Compara com um parametro nativo que sabidamente funciona (MV_BLOQUEI),
-- para ver se o X6_FIL do nosso esta no mesmo formato do dele.
SELECT
  '[' || X6_FIL     || ']' AS FIL,
  '[' || X6_VAR     || ']' AS VAR,
  LENGTH(RTRIM(X6_VAR))    AS TAMVAR,
  X6_TIPO                  AS TIPO,
  X6_PROPRI                AS PROPRI,
  '[' || X6_CONTEUD || ']' AS CONT
FROM SX6010
WHERE ( X6_VAR LIKE '%AKCR%' OR RTRIM(X6_VAR) = 'MV_BLOQUEI' )
  AND D_E_L_E_T_ = ' '
ORDER BY X6_VAR
