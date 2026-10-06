-- Chamado Comex - relatorios perdidos SAP -> TOTVS
-- 01) Quais tabelas de importacao existem fisicamente no banco e quantas linhas
--     (aprox.) elas tem. Responde a pergunta-chave: a Akiyama usa o modulo de
--     importacao do Protheus (SIGAEIC: SW2/SW3/SW6...) ou faz importacao pelo
--     Compras + Nota de Entrada (SC7/SF1/SD1 + CD5 = complemento de importacao)?
-- NUM_ROWS vem da estatistica do Oracle (pode estar um pouco desatualizado);
-- serve como ordem de grandeza. Tabela ausente do resultado = nao criada.
-- SOMENTE LEITURA. Rodar em dev via "Abrir .sql" + F5. Apelidos <= 10 caracteres.
SELECT
    TABLE_NAME,
    NUM_ROWS,
    LAST_ANALYZED AS DT_STAT
FROM USER_TABLES
WHERE TABLE_NAME IN (
    'SW2010', 'SW3010', 'SW5010', 'SW6010', 'SW7010', 'SW8010', 'SW9010',
    'SWN010', 'SWV010', 'EIJ010', 'EIK010',
    'SC7010', 'SF1010', 'SD1010', 'CD5010', 'SB1010', 'SB5010', 'SA5010'
)
ORDER BY TABLE_NAME
