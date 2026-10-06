-- Chamado Comex - relatorios perdidos SAP -> TOTVS
-- 13) Procura notas COMPLEMENTARES (frete, despesas, preco) amarradas a NF de
--     importacao 000088436 (D1_NFORI = nota original).
-- Motivo: o DDP da planilha do Comex para esse processo e R$ 4.915 MAIOR que o
-- custo de entrada da NF, e a diferenca e rateada por PESO (~R$ 65,88/kg em
-- todos os itens). Esses custos extras (despachante, armazenagem, frete
-- interno...) tem que estar em algum lugar do Protheus para o relatorio calcular
-- o DDP sozinho. Vazio = nao estao em NF complementar (ver 14 e 15).
-- SOMENTE LEITURA.
SELECT *
FROM SD1010
WHERE D_E_L_E_T_ <> '*'
  AND TRIM(D1_NFORI) = '000088436'
