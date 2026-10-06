-- Chamado Comex - relatorios perdidos SAP -> TOTVS
-- 07) Como os campos do produto que o Rascunho DUIMP vai usar estao gravados
--     FISICAMENTE no Oracle. Importante sobretudo para o memo B1_ZDETDI
--     ("Detalhes DI" = descricao para a DUIMP): memo pode ser BLOB, CLOB ou
--     nem existir como coluna (guardado na SYP). Cada caso exige uma forma
--     diferente de ler no relatorio - por isso medimos antes de escrever.
-- Linha ausente no resultado = a coluna nao existe na tabela fisica.
-- SOMENTE LEITURA. Apelidos <= 10 caracteres.
SELECT
    COLUMN_NAME AS COLUNA,
    DATA_TYPE   AS TIPO,
    DATA_LENGTH AS TAMANHO
FROM USER_TAB_COLUMNS
WHERE TABLE_NAME = 'SB1010'
  AND COLUMN_NAME IN ('B1_COD', 'B1_DESC', 'B1_POSIPI', 'B1_EX_NCM',
                      'B1_ZCODSAP', 'B1_ZDETDI', 'B1_XDETALH', 'B1_FABRIC')
ORDER BY COLUMN_NAME
