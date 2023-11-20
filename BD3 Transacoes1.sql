SELECT * FROM fones_clientes;
SELECT * FROM clientes;
--SAVEPOINT
BEGIN;
INSERT INTO clientes(codcliente, nome, endereco, tipo_cliente) VALUES (80, 'Umberto', 'Rua 1', 'F');
SAVEPOINT savepoint_cliente_inserido;
INSERT INTO fones_clientes(cliente, num_telefone) VALUES (80, '2123456789');
ROLLBACK TO SAVEPOINT savepoint_cliente_inserido;
COMMIT;

-----------------------------------------------------------------------------------------------------
SELECT * FROM clientes
SELECT * FROM itens
--DEADLOCK
-- Transação 1
BEGIN;
UPDATE clientes SET nome = 'Novo Nome' WHERE codcliente = 100;

UPDATE itens SET valor = 100 WHERE codigo = 4;
COMMIT;
----------------------------------------------------------------------------------------------------
--LEITURA FANTASMA-
-- Transação 1
BEGIN;
SELECT * FROM clientes WHERE tipo_cliente = 'F';

SELECT * FROM clientes WHERE tipo_cliente = 'F';

COMMIT;
--------------------------------------------------------------------------------------------------
--LEITURA NÃO REPETÍVEL
-- Transação 1
BEGIN;
SELECT * FROM itens WHERE tipo = 'p';

SELECT * FROM itens WHERE tipo = 'p';

COMMIT;


