-- Por que a bolinha da tela de Pedidos de Venda fica verde?
-- A legenda da MATA410 olha a SC5 (C5_LIBEROK), nao a SC9.
--
-- Compare:
--   pedidos liberados pelo fluxo nativo  -> LIBEROK = 'S' esperado
--   pedidos que passaram pela regra AKCRED (cartao/antecipado)
--                                        -> suspeita: LIBEROK vazio
--
-- Lista todos os pedidos emitidos desde 01/09 que ja tem SC9.
-- Nao precisa editar nada. Rodar no ambiente onde o pessoal reclamou.
SELECT
  C5.C5_FILIAL       AS FILIAL,
  C5.C5_NUM          AS PEDIDO,
  C5.C5_CONDPAG      AS COND,
  C5.C5_EMISSAO      AS EMISSAO,
  C5.C5_LIBEROK      AS LIBEROK,
  C5.C5_BLQ          AS BLQ,
  C5.C5_NOTA         AS NOTA,
  MAX(C9.C9_BLCRED)  AS BLCRED,
  COUNT(C9.C9_ITEM)  AS QTDSC9
FROM SC5010 C5
INNER JOIN SC9010 C9
        ON C9.C9_FILIAL = C5.C5_FILIAL
       AND C9.C9_PEDIDO = C5.C5_NUM
       AND C9.D_E_L_E_T_ = ' '
WHERE C5.D_E_L_E_T_ = ' '
  AND C5.C5_EMISSAO >= '20260901'
GROUP BY
  C5.C5_FILIAL, C5.C5_NUM, C5.C5_CONDPAG, C5.C5_EMISSAO,
  C5.C5_LIBEROK, C5.C5_BLQ, C5.C5_NOTA
ORDER BY C5.C5_FILIAL, C5.C5_NUM
