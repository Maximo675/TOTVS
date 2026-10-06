-- Pedidos emitidos desde 30/09: a condicao entra na regra? e o que a SC9 diz?
-- Nao precisa editar. Procure o pedido antecipado do seu teste.
--
-- REGRA = NAO PEGA                    -> condicao fora do criterio (cadastro/escopo)
-- REGRA = PEGA  e BLCRED vazio        -> FURO: a regra nao foi chamada
-- REGRA = PEGA  e BLCRED preenchido   -> funcionou
SELECT
  TRIM(C5.C5_FILIAL)   AS FILIAL,
  C5.C5_NUM            AS PEDIDO,
  C5.C5_EMISSAO        AS EMISSAO,
  TRIM(C5.C5_CONDPAG)  AS COND,
  SE4.E4_DESCRI        AS DESCRICAO,
  SE4.E4_ZTPMOV        AS TPMOV,
  SE4.E4_CTRADT        AS CTRADT,
  CASE
    WHEN SE4.E4_ZTPMOV = 'V'
     AND ( SE4.E4_CTRADT = '1' OR UPPER(SE4.E4_DESCRI) LIKE '%VENDAS - CC%' )
    THEN 'PEGA'
    ELSE 'NAO PEGA'
  END                  AS REGRA,
  C5.C5_LIBEROK        AS LIBEROK,
  C9.C9_ITEM           AS ITEM,
  C9.C9_BLCRED         AS BLCRED,
  C9.C9_BLEST          AS BLEST
FROM SC5010 C5
LEFT JOIN SE4010 SE4
       ON TRIM(SE4.E4_FILIAL) = SUBSTR(TRIM(C5.C5_FILIAL),1,4)
      AND TRIM(SE4.E4_CODIGO) = TRIM(C5.C5_CONDPAG)
      AND SE4.D_E_L_E_T_ = ' '
LEFT JOIN SC9010 C9
       ON C9.C9_FILIAL = C5.C5_FILIAL
      AND C9.C9_PEDIDO = C5.C5_NUM
      AND C9.D_E_L_E_T_ = ' '
WHERE C5.D_E_L_E_T_ = ' '
  AND C5.C5_EMISSAO >= '20260930'
ORDER BY C5.C5_FILIAL, C5.C5_NUM, C9.C9_ITEM
