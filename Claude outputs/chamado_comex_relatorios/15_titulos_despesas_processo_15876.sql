-- Chamado Comex - relatorios perdidos SAP -> TOTVS
-- 15) Titulos a pagar (despachante, armazenagem, frete, impostos...) cujo
--     historico cita o processo 15876 / 15338 ou a DI 475509. Terceira hipotese
--     de onde estao os custos extras do DDP (ver 13): lancados direto no
--     Financeiro, sem nota de entrada.
-- SOMENTE LEITURA.
SELECT
    E2_FILIAL,
    E2_PREFIXO,
    E2_NUM,
    E2_PARCELA,
    E2_TIPO,
    E2_FORNECE,
    E2_LOJA,
    E2_EMISSAO,
    E2_VALOR,
    E2_NATUREZ,
    E2_HIST
FROM SE2010
WHERE D_E_L_E_T_ <> '*'
  AND (   UPPER(E2_HIST) LIKE '%15876%'
       OR UPPER(E2_HIST) LIKE '%15338%'
       OR UPPER(E2_HIST) LIKE '%475509%')
ORDER BY E2_EMISSAO, E2_NUM
