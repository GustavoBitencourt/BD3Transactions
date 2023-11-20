--DEADLOCK
--Transação 2
BEGIN;
UPDATE itens SET descricao = 'Nova Descrição' WHERE codigo = 4;

UPDATE clientes SET endereco = 'Novo Endereço' WHERE codcliente = 100;
COMMIT;
--------------------------------------------------------------------------
--LEITURA FANTASMA
-- Transação 2
SELECT * FROM clientes

BEGIN;
INSERT INTO clientes (codcliente, nome, endereco, tipo_cliente)
VALUES (112, 'Fantasma1', 'Rua Fantasma 1', 'F'),
       (114, 'Fantasma2', 'Rua Fantasma 2', 'F');

COMMIT;
---------------------------------------------------------------------------
--LEITURA NÃO REPETÍVEL
-- Transação 2
BEGIN;
UPDATE itens SET valor = valor * 1.1 WHERE tipo = 'p';
COMMIT;




