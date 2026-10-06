-- Chamado Comex - relatorios perdidos SAP -> TOTVS
-- 02) Onde estao (ou nao estao) no dicionario os dados que os relatorios pedem:
--     numero de referencia da PO, part number, NCM, EX-tarifario, descricao
--     para DI/DUIMP, FOB, taxa do dolar, DI/DUIMP.
-- Traz TODOS os campos customizados (X3_PROPRI = 'U') das tabelas envolvidas
-- + campos padrao cujo titulo/descricao bate com as palavras-chave.
-- SOMENTE LEITURA. Rodar em dev via "Abrir .sql" + F5.
SELECT
    X3_ARQUIVO,
    X3_CAMPO,
    X3_TITULO,
    X3_DESCRIC,
    X3_TIPO,
    X3_TAMANHO,
    X3_PROPRI,
    X3_BROWSE,
    X3_CONTEXT
FROM SX3010
WHERE D_E_L_E_T_ <> '*'
  AND X3_ARQUIVO IN ('SB1', 'SB5', 'SA5', 'SC7', 'SF1', 'SD1', 'CD5',
                     'SW2', 'SW3', 'SW6', 'SW7', 'SW8', 'SW9', 'EIJ')
  AND (   X3_PROPRI = 'U'
       OR X3_CAMPO LIKE '%PO_EIC%'
       OR X3_CAMPO LIKE '%POSIPI%'
       OR X3_CAMPO LIKE '%EX_NCM%'
       OR UPPER(X3_TITULO)  LIKE '%NCM%'
       OR UPPER(X3_DESCRIC) LIKE '%NCM%'
       OR UPPER(X3_DESCRIC) LIKE '%TARIF%'
       OR UPPER(X3_TITULO)  LIKE '%PART%'
       OR UPPER(X3_DESCRIC) LIKE '%PART NUMBER%'
       OR UPPER(X3_DESCRIC) LIKE '%FABRICANTE%'
       OR UPPER(X3_DESCRIC) LIKE '%DUIMP%'
       OR UPPER(X3_TITULO)  LIKE '%DUIMP%'
       OR UPPER(X3_DESCRIC) LIKE '%DECLARA%IMPORT%'
       OR UPPER(X3_TITULO)  LIKE '%FOB%'
       OR UPPER(X3_DESCRIC) LIKE '%FOB%'
       OR UPPER(X3_TITULO)  LIKE '%REF%'
       OR UPPER(X3_DESCRIC) LIKE '%REFERENCIA%')
ORDER BY X3_ARQUIVO, X3_CAMPO
