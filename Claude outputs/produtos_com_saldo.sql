-- Produtos COM saldo disponivel na filial 1001001, para testar o fluxo
-- completo (pedido -> analise de credito -> liberacao -> faturamento)
-- sem esbarrar no bloqueio de estoque.
-- Escolha um armazem ao qual o seu usuario tenha acesso.
-- Nao precisa editar.
SELECT
  TRIM(B2.B2_COD)   AS PRODUTO,
  ( SELECT MAX(B1.B1_DESC)
      FROM SB1010 B1
     WHERE TRIM(B1.B1_COD) = TRIM(B2.B2_COD)
       AND B1.D_E_L_E_T_ = ' ' )                    AS DESCRICAO,
  B2.B2_LOCAL       AS ARMAZEM,
  B2.B2_QATU        AS SALDO,
  B2.B2_RESERVA     AS RESERVA,
  B2.B2_QEMP        AS EMPENHO,
  B2.B2_QATU - B2.B2_RESERVA - B2.B2_QEMP          AS DISPON
FROM SB2010 B2
WHERE B2.D_E_L_E_T_ = ' '
  AND TRIM(B2.B2_FILIAL) = '1001001'
  AND B2.B2_QATU - B2.B2_RESERVA - B2.B2_QEMP > 0
ORDER BY DISPON DESC
