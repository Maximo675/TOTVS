-- Tudo que foi LIBERADO HOJE (C9_DATALIB), independente da data de emissao.
-- Pega os pedidos antigos que voce liberou no teste.
-- Nao precisa editar.
--
-- REGRA = NAO PEGA                   -> condicao fora do criterio
-- REGRA = PEGA  e BLCRED vazio       -> FURO (ou credito ja liberado pelo Financeiro)
-- REGRA = PEGA  e BLCRED preenchido  -> funcionou
SELECT
  TRIM(C9.C9_FILIAL)   AS FILIAL,
  C9.C9_PEDIDO         AS PEDIDO,
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
FROM SC9010 C9
INNER JOIN SC5010 C5
        ON C5.C5_FILIAL = C9.C9_FILIAL
       AND C5.C5_NUM    = C9.C9_PEDIDO
       AND C5.D_E_L_E_T_ = ' '
LEFT JOIN SE4010 SE4
       ON TRIM(SE4.E4_FILIAL) = SUBSTR(TRIM(C5.C5_FILIAL),1,4)
      AND TRIM(SE4.E4_CODIGO) = TRIM(C5.C5_CONDPAG)
      AND SE4.D_E_L_E_T_ = ' '
WHERE C9.D_E_L_E_T_ = ' '
  AND C9.C9_DATALIB = '20261001'
ORDER BY C9.C9_FILIAL, C9.C9_PEDIDO, C9.C9_ITEM
