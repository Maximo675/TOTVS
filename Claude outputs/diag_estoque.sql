-- O bloqueio de estoque (C9_BLEST) e' falta de saldo de verdade?
-- Para cada item liberado desde 30/09, mostra o saldo do produto no MESMO
-- armazem e na MESMA filial do pedido.
-- Nao precisa editar.
--
-- DISPON < QTDLIB  (ou SALDO vazio)  -> falta saldo: bloqueio legitimo
-- DISPON >= QTDLIB e BLEST = 02      -> tem saldo e bloqueou: investigar
SELECT
  TRIM(C9.C9_FILIAL)  AS FILIAL,
  C9.C9_PEDIDO        AS PEDIDO,
  C9.C9_ITEM          AS ITEM,
  TRIM(C9.C9_PRODUTO) AS PRODUTO,
  C6.C6_LOCAL         AS ARMAZEM,
  C9.C9_QTDLIB        AS QTDLIB,
  C9.C9_BLCRED        AS BLCRED,
  C9.C9_BLEST         AS BLEST,
  B2.B2_QATU          AS SALDO,
  B2.B2_RESERVA       AS RESERVA,
  B2.B2_QEMP          AS EMPENHO,
  NVL(B2.B2_QATU,0) - NVL(B2.B2_RESERVA,0) - NVL(B2.B2_QEMP,0) AS DISPON,
  CASE
    WHEN B2.B2_COD IS NULL THEN 'SEM SALDO CADASTRADO'
    WHEN NVL(B2.B2_QATU,0) - NVL(B2.B2_RESERVA,0) - NVL(B2.B2_QEMP,0)
         < C9.C9_QTDLIB THEN 'FALTA SALDO'
    ELSE 'TEM SALDO'
  END AS SITUACAO
FROM SC9010 C9
INNER JOIN SC6010 C6
        ON C6.C6_FILIAL = C9.C9_FILIAL
       AND C6.C6_NUM    = C9.C9_PEDIDO
       AND C6.C6_ITEM   = C9.C9_ITEM
       AND C6.D_E_L_E_T_ = ' '
LEFT JOIN SB2010 B2
       ON TRIM(B2.B2_FILIAL) = TRIM(C9.C9_FILIAL)
      AND TRIM(B2.B2_COD)    = TRIM(C9.C9_PRODUTO)
      AND TRIM(B2.B2_LOCAL)  = TRIM(C6.C6_LOCAL)
      AND B2.D_E_L_E_T_ = ' '
WHERE C9.D_E_L_E_T_ = ' '
  AND C9.C9_DATALIB >= '20260930'
ORDER BY C9.C9_FILIAL, C9.C9_PEDIDO, C9.C9_ITEM
