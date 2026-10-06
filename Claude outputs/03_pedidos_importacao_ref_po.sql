-- Chamado Comex - relatorios perdidos SAP -> TOTVS
-- 03) Pedidos de compra em moeda estrangeira (proxy de importacao) emitidos
--     desde 01/07/2026 (pos-migracao) e o que esta gravado no campo de
--     referencia da PO (C7_PO_EIC), criado pelos fontes PO.prw / PO_Linhas.prw.
-- Responde: o campo existe? esta sendo preenchido? em que formato?
-- Se der ORA-00904 (C7_PO_EIC invalido) -> o campo nao existe neste ambiente:
-- isso ja e a resposta (fontes no repositorio, dicionario nao atualizado).
-- SOMENTE LEITURA. DISTINCT = 1 linha por pedido (o campo e repetido por item).
SELECT DISTINCT
    C7_FILIAL,
    C7_NUM,
    C7_EMISSAO,
    C7_FORNECE,
    C7_LOJA,
    C7_MOEDA,
    C7_TXMOEDA,
    C7_PO_EIC
FROM SC7010
WHERE D_E_L_E_T_ <> '*'
  AND C7_MOEDA <> 1
  AND C7_EMISSAO >= '20260701'
ORDER BY C7_NUM
