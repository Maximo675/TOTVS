-- Chamado Comex - relatorios perdidos SAP -> TOTVS
-- 06) Complemento de importacao da NF-e (CD5: numero da DI/DUIMP, data, local
--     de desembaraco, adicao...). Amostra dos registros mais recentes.
-- Se vier vazio, a DI/DUIMP nao esta sendo registrada no Protheus na entrada
-- (o dado do "+ DI" do relatorio teria que vir de outro lugar).
-- SOMENTE LEITURA. Ate 30 linhas.
SELECT *
FROM CD5010
WHERE D_E_L_E_T_ <> '*'
  AND ROWNUM <= 30
