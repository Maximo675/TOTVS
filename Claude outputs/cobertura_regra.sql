-- COBERTURA DA REGRA  (v2 - com TRIM nas chaves do join)
-- Quais condicoes de pagamento sao realmente usadas em PEDIDOS DE VENDA,
-- e quais delas a regra AKCRED pega ou deixa passar.
--
-- Linhas "PASSA DIRETO" cuja descricao fale de antecipado/PIX/cartao = furo.
--
-- v1 falhou porque E4_FILIAL vem com brancos a direita ('1001   ') e o
-- SUBSTR do C5_FILIAL produz texto sem preenchimento: o join nunca casava.
-- Apelidos de coluna com no maximo 10 caracteres (limite do zTiSQL).
SELECT
  SUBSTR(TRIM(C5.C5_FILIAL),1,4) AS FILIAL,
  TRIM(C5.C5_CONDPAG)            AS COND,
  SE4.E4_DESCRI                  AS DESCRICAO,
  SE4.E4_ZTPMOV                  AS TPMOV,
  SE4.E4_CTRADT                  AS CTRADT,
  COUNT(*)                       AS QTDPED,
  CASE
    WHEN SE4.E4_ZTPMOV = 'V'
     AND ( SE4.E4_CTRADT = '1' OR UPPER(SE4.E4_DESCRI) LIKE '%VENDAS - CC%' )
    THEN 'REGRA PEGA'
    WHEN SE4.E4_CODIGO IS NULL
    THEN 'SEM SE4 NA FILIAL'
    ELSE 'PASSA DIRETO'
  END AS SITUACAO
FROM SC5010 C5
LEFT JOIN SE4010 SE4
       ON TRIM(SE4.E4_FILIAL) = SUBSTR(TRIM(C5.C5_FILIAL),1,4)
      AND TRIM(SE4.E4_CODIGO) = TRIM(C5.C5_CONDPAG)
      AND SE4.D_E_L_E_T_ = ' '
WHERE C5.D_E_L_E_T_ = ' '
GROUP BY
  SUBSTR(TRIM(C5.C5_FILIAL),1,4),
  TRIM(C5.C5_CONDPAG),
  SE4.E4_DESCRI,
  SE4.E4_ZTPMOV,
  SE4.E4_CTRADT,
  SE4.E4_CODIGO
ORDER BY FILIAL, QTDPED DESC
