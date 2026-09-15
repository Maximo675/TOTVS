-- Existe liberacao gravada para o pedido 001345?
-- Nenhuma linha = a regra segurou, o pedido nao foi liberado.
-- Linha com C9_BLCRED em branco = o pedido passou, o retorno .F. foi ignorado.
SELECT *
FROM SC9010
WHERE C9_PEDIDO = '001345'
  AND D_E_L_E_T_ = ' '
