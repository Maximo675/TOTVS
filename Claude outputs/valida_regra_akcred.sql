-- Simula exatamente o criterio da funcao U_AKBLQCRED.
-- A coluna DECISAO mostra o que a regra faria com cada condicao de pagamento.
SELECT
  E4_FILIAL,
  E4_CODIGO,
  E4_DESCRI,
  E4_ZTPMOV,
  E4_CTRADT,
  CASE
    WHEN E4_ZTPMOV = 'V'
     AND ( E4_CTRADT = '1' OR UPPER(E4_DESCRI) LIKE '%VENDAS - CC%' )
    THEN 'BLOQUEIA'
    ELSE 'passa'
  END AS DECISAO
FROM SE4010
WHERE D_E_L_E_T_ <> '*'
ORDER BY DECISAO DESC, E4_FILIAL, E4_CODIGO
