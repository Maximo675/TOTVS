-- Chamado: Vendas - Campo automatico na analise de credito
-- 05) Consistencia entre Risco (A1_RISCO) e Data limite (A1_VENCLC) no cadastro de clientes.
-- Regra do gatilho A1_RISCO seq 501 (achado na query 01):
--   B = +6 meses, C = +5 meses, D = +3 meses, E = +1 mes (a partir de dDataBase), A = data vazia.
-- Lista uma AMOSTRA (ate 200) de clientes que fogem dessa regra, com o motivo em PROBLEMA.
-- Sem COUNT(*) de proposito (zTiSQL trava com agregacao + alias).
-- SOMENTE LEITURA (SELECT). Rodar em dev para validar a query; depois vale rodar em
-- producao (continua sendo so leitura), porque o dado de dev pode estar desatualizado.
SELECT
    A1_FILIAL,
    A1_COD,
    A1_LOJA,
    A1_NREDUZ,
    A1_RISCO,
    A1_VENCLC,
    A1_LC,
    CASE
        WHEN TRIM(A1_RISCO) IS NULL
            THEN 'SEM RISCO'
        WHEN A1_RISCO IN ('B', 'C', 'D', 'E') AND TRIM(A1_VENCLC) IS NULL
            THEN 'RISCO B-E SEM DATA LIMITE'
        WHEN A1_RISCO = 'A' AND TRIM(A1_VENCLC) IS NOT NULL
            THEN 'RISCO A COM DATA LIMITE (VERIFICAR)'
        WHEN A1_VENCLC < TO_CHAR(SYSDATE, 'YYYYMMDD')
            THEN 'DATA LIMITE JA VENCIDA'
    END AS PROBLEMA
FROM SA1010
WHERE D_E_L_E_T_ <> '*'
  AND (   TRIM(A1_RISCO) IS NULL
       OR (A1_RISCO IN ('B', 'C', 'D', 'E') AND TRIM(A1_VENCLC) IS NULL)
       OR (A1_RISCO = 'A' AND TRIM(A1_VENCLC) IS NOT NULL)
       OR (TRIM(A1_VENCLC) IS NOT NULL AND A1_VENCLC < TO_CHAR(SYSDATE, 'YYYYMMDD')))
  AND ROWNUM <= 200
ORDER BY PROBLEMA, A1_RISCO, A1_COD
