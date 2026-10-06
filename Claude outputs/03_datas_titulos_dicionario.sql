-- Chamado: Vendas - Campo automatico na analise de credito (parte "data de emissao")
-- 03) Como estao configurados no dicionario os campos de data dos titulos
-- a receber (SE1) e a pagar (SE2)? Em especial:
--   X3_BROWSE  = 'S' -> aparece na grade (browse) das telas padrao
--   X3_RELACAO -> valor inicial preenchido automaticamente
--   X3_TRIGGER -> se tem gatilho
-- A ideia e ver se a Emissao existe e e preenchida, mas so nao esta sendo EXIBIDA
-- no ponto do fluxo que a equipe usa (vs. nao estar sendo gravada).
-- SOMENTE LEITURA (SELECT). Rodar primeiro em dev (C94deb_dev2), via "Abrir .sql" + F5.
SELECT
    X3_ARQUIVO,
    X3_CAMPO,
    X3_TITULO,
    X3_BROWSE,
    X3_CONTEXT,
    X3_TRIGGER,
    X3_PROPRI,
    X3_RELACAO,
    X3_VALID,
    X3_VLDUSER,
    X3_WHEN
FROM SX3010
WHERE D_E_L_E_T_ <> '*'
  AND X3_ARQUIVO IN ('SE1', 'SE2')
  AND (   X3_CAMPO LIKE '%EMIS%'
       OR X3_CAMPO LIKE '%VENC%')
ORDER BY X3_ARQUIVO, X3_CAMPO
