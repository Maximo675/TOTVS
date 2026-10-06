-- Chamado Comex - relatorios perdidos SAP -> TOTVS
-- 14) Todas as notas de entrada que citam o processo na mensagem da nota
--     (F1_MENNOTA - foi la que a referencia "PO 15876.LEA.26" apareceu na NF
--     000088436). Na planilha do Comex o processo e "PO 15338.PHK.25 +
--     PO 15876.LEA.26" (Panasonic + Leadshine, mesma DI 475509-0), entao deve
--     haver pelo menos mais uma NF (Panasonic) e talvez NFs de despesa.
-- SOMENTE LEITURA.
SELECT
    F1_FILIAL,
    F1_DOC,
    F1_SERIE,
    F1_FORNECE,
    F1_LOJA,
    F1_EMISSAO,
    F1_TIPO,
    F1_EST,
    F1_VALMERC,
    F1_VALBRUT,
    F1_FRETE,
    F1_DESPESA,
    F1_SEGURO,
    F1_II,
    F1_MENNOTA
FROM SF1010
WHERE D_E_L_E_T_ <> '*'
  AND (   UPPER(F1_MENNOTA) LIKE '%15876%'
       OR UPPER(F1_MENNOTA) LIKE '%15338%'
       OR UPPER(F1_MENNOTA) LIKE '%475509%')
ORDER BY F1_EMISSAO, F1_DOC
