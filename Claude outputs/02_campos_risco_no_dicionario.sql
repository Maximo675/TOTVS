-- Chamado: Vendas - Campo automatico na analise de credito
-- 02) Em quais tabelas/campos existe "Risco" e "Vencimento do limite de credito"?
-- Serve para descobrir se a OUTRA tela de analise de credito usa o mesmo campo do
-- cadastro (A1_RISCO / A1_VENCLC) ou um campo diferente (ex.: tabela customizada Z*).
-- X3_TRIGGER = 'S' indica que o campo tem gatilho; X3_PROPRI = 'U' indica campo de usuario.
-- SOMENTE LEITURA (SELECT). Rodar primeiro em dev (C94deb_dev2), via "Abrir .sql" + F5.
SELECT
    X3_ARQUIVO,
    X3_CAMPO,
    X3_TITULO,
    X3_TIPO,
    X3_TAMANHO,
    X3_TRIGGER,
    X3_PROPRI,
    X3_VALID,
    X3_VLDUSER,
    X3_RELACAO,
    X3_WHEN
FROM SX3010
WHERE D_E_L_E_T_ <> '*'
  AND (   X3_CAMPO LIKE '%RISCO%'
       OR X3_CAMPO LIKE '%VENCLC%'
       OR UPPER(X3_TITULO) LIKE '%RISCO%'
       OR UPPER(X3_TITULO) LIKE '%LIM%CRED%')
ORDER BY X3_ARQUIVO, X3_CAMPO
