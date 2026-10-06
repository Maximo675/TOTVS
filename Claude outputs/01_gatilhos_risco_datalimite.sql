-- Chamado: Vendas - Campo automatico na analise de credito
-- 01) Quem preenche a "data limite" quando o Risco e informado no cadastro do cliente?
-- Procura gatilhos (SX7) disparados pelo campo de Risco OU que gravam no vencimento
-- do limite de credito (A1_VENCLC), OU cuja regra mencione esse campo.
-- SOMENTE LEITURA (SELECT). Rodar primeiro em dev (C94deb_dev2), via "Abrir .sql" + F5.
-- Se a empresa nao for 01, trocar o sufixo 010 da tabela.
SELECT
    X7_CAMPO,
    X7_SEQUENC,
    X7_CDOMIN,
    X7_REGRA,
    X7_CONDIC,
    X7_TIPO,
    X7_SEEK,
    X7_ALIAS,
    X7_ORDEM,
    X7_CHAVE,
    X7_PROPRI
FROM SX7010
WHERE D_E_L_E_T_ <> '*'
  AND (   X7_CAMPO  LIKE '%RISCO%'
       OR X7_CDOMIN LIKE '%VENCLC%'
       OR X7_REGRA  LIKE '%VENCLC%'
       OR X7_REGRA  LIKE '%RISCO%')
ORDER BY X7_CAMPO, X7_SEQUENC
