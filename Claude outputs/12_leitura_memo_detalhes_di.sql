-- Chamado Comex - relatorios perdidos SAP -> TOTVS
-- 12) VERSAO CORRIGIDA (02/10/2026). Le o memo B1_ZDETDI ("Detalhes DI" =
--     descricao para a DUIMP, gravado como BLOB) em texto, para os 15 itens da
--     PO 886.
--
-- POR QUE A 1a VERSAO QUEBROU (ORA-00910 em ROP_CREATEFILE): o zTiSQL nao mostra
-- o resultado direto - ele cria uma TABELA TEMPORARIA com o formato de cada
-- coluna e copia o resultado para ela. A funcao UTL_RAW.CAST_TO_VARCHAR2 nao
-- informa tamanho (o Oracle trata como ate 32767 bytes), o zTiSQL tentou criar
-- uma coluna desse tamanho e o Oracle recusou ("specified length too long").
-- CORRECAO: toda coluna CALCULADA agora tem tamanho fixo via CAST, e o texto
-- vem em pedacos de 250 bytes (o zTiSQL tambem corta qualquer campo acima de
-- 254 caracteres na grade/exportacao). 4 pedacos = 1000 bytes; a maior
-- descricao do modelo tem ~575. Se TAM_DETDI > 1000, ha texto alem do PARTE4.
--
-- O que observar: texto legivel? acentos certos? bate com "DESCRICAO DI" do
-- modelo? TAM_DETDI vazio = memo nao preenchido.
-- SOMENTE LEITURA. Apelidos <= 10 caracteres.
SELECT
    CAST(TRIM(B1_COD) AS VARCHAR2(15)) AS COD,
    B1_FILIAL,
    CAST(DBMS_LOB.GETLENGTH(B1_ZDETDI)  AS NUMBER(10)) AS TAM_DETDI,
    CAST(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(B1_ZDETDI, 250,   1)) AS VARCHAR2(250)) AS PARTE1,
    CAST(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(B1_ZDETDI, 250, 251)) AS VARCHAR2(250)) AS PARTE2,
    CAST(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(B1_ZDETDI, 250, 501)) AS VARCHAR2(250)) AS PARTE3,
    CAST(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(B1_ZDETDI, 250, 751)) AS VARCHAR2(250)) AS PARTE4,
    CAST(DBMS_LOB.GETLENGTH(B1_XDETALH) AS NUMBER(10)) AS TAM_DETAL
FROM SB1010
WHERE D_E_L_E_T_ <> '*'
  AND TRIM(B1_COD) IN ('RV-002-00015','RV-002-00017','RV-002-00020','RV-002-00021','RV-002-00023',
                          'RV-002-00025','RV-002-00028','RV-002-00033','RV-002-00041','RV-002-00132',
                          'RV-002-00154','RV-002-00166','RV-002-00167','RV-002-00168','RV-002-00171')
ORDER BY 1, B1_FILIAL
