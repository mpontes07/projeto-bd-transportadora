-- 04_testes.sql : testes de integridade (Transportadora)
-- Rodar DEPOIS dos scripts 01, 02 e 03.
-- Cada teste de 01 a 15 e um comando que DEVE FALHAR. Execute UM POR VEZ
-- (clique na linha do comando e aperte Ctrl+Enter) e tire print do erro no painel Output.
-- Anote o erro real do seu MySQL ao lado do esperado (a redacao varia conforme a versao).

USE transportadora;

-- =====================================================================
-- INTEGRIDADE DE ENTIDADE (chave primaria e valores unicos)
-- =====================================================================

-- Teste 01 (entidade): PK duplicada
-- Regra: toda tabela tem chave primaria unica
INSERT INTO cidade (id_cidade, nome, estado) VALUES (1, 'Cidade Teste', 'SP');
-- Esperado: ERROR 1062: Duplicate entry '1' for key 'cidade.PRIMARY'

-- Teste 02 (entidade): UNIQUE repetido (e-mail do cliente) - RN1
INSERT INTO cliente (nome, cpf_cnpj, email, id_cidade)
VALUES ('Cliente Repetido', '999.999.999-99', 'mariana@email.com', 1);
-- Esperado: ERROR 1062: Duplicate entry 'mariana@email.com' for key 'cliente.email'

-- Teste 03 (entidade): UNIQUE repetido (CPF/CNPJ do cliente) - RN1
INSERT INTO cliente (nome, cpf_cnpj, email, id_cidade)
VALUES ('Cliente Repetido', '111.222.333-44', 'novo@email.com', 1);
-- Esperado: ERROR 1062: Duplicate entry '111.222.333-44' for key 'cliente.cpf_cnpj'

-- Teste 04 (entidade): placa repetida - RN5
INSERT INTO veiculo (placa, modelo, capacidade_kg)
VALUES ('ABC1D23', 'Veiculo Duplicado', 2000.00);
-- Esperado: ERROR 1062: Duplicate entry 'ABC1D23' for key 'veiculo.placa'

-- Teste 05 (entidade): segunda habilitacao para o mesmo motorista (1:1) - RN7
INSERT INTO habilitacao (id_motorista, numero_cnh, categoria, validade)
VALUES (1, '11111111111', 'C', '2030-01-01');
-- Esperado: ERROR 1062: Duplicate entry '1' for key 'habilitacao.id_motorista'

-- Teste 06 (entidade): mesma encomenda na mesma rota (PK composta) - RN6
INSERT INTO encomenda_rota (id_encomenda, id_rota, id_motorista, id_veiculo, data_saida)
VALUES (1, 1, 1, 1, '2026-10-01 08:00:00');
-- Esperado: ERROR 1062: Duplicate entry '1-1' for key 'encomenda_rota.PRIMARY'

-- =====================================================================
-- INTEGRIDADE REFERENCIAL (chaves estrangeiras)
-- =====================================================================

-- Teste 07 (referencial): encomenda para cliente inexistente - RN4
INSERT INTO encomenda (id_cliente, id_armazem_origem, id_cidade_destino, peso_kg, valor_frete, data_postagem, prazo_entrega)
VALUES (999, 1, 2, 10.00, 50.00, '2026-10-24', '2026-10-30');
-- Esperado: ERROR 1452: Cannot add or update a child row: a foreign key constraint fails

-- Teste 08 (referencial): apagar cliente que possui encomendas
DELETE FROM cliente WHERE id_cliente = 1;
-- Esperado: ERROR 1451: Cannot delete or update a parent row: a foreign key constraint fails

-- Teste 09 (referencial): apagar veiculo que ja realizou trechos
DELETE FROM veiculo WHERE id_veiculo = 1;
-- Esperado: ERROR 1451: Cannot delete or update a parent row: a foreign key constraint fails

-- =====================================================================
-- INTEGRIDADE DE DOMINIO (NOT NULL e CHECK)
-- =====================================================================

-- Teste 10 (dominio): NOT NULL - cliente sem nome
INSERT INTO cliente (nome, cpf_cnpj, email) VALUES (NULL, '555.555.555-55', 'semnome@email.com');
-- Esperado: ERROR 1048: Column 'nome' cannot be null

-- Teste 11 (dominio): CHECK - peso igual a zero - RN2
INSERT INTO encomenda (id_cliente, id_armazem_origem, id_cidade_destino, peso_kg, valor_frete, data_postagem, prazo_entrega)
VALUES (1, 1, 2, 0, 50.00, '2026-10-24', '2026-10-30');
-- Esperado: ERROR 3819: Check constraint 'ck_enc_peso' is violated.

-- Teste 12 (dominio): CHECK - frete negativo - RN8
UPDATE encomenda SET valor_frete = -10.00 WHERE id_encomenda = 1;
-- Esperado: ERROR 3819: Check constraint 'ck_enc_frete' is violated.

-- Teste 13 (dominio): CHECK - status invalido
UPDATE encomenda SET status = 'perdida' WHERE id_encomenda = 1;
-- Esperado: ERROR 3819: Check constraint 'ck_enc_status' is violated.

-- Teste 14 (dominio): CHECK - rota com origem igual ao destino - RN9
INSERT INTO rota (id_cidade_origem, id_cidade_destino, distancia_km) VALUES (1, 1, 100.00);
-- Esperado: ERROR 3819: Check constraint 'ck_rota_cidades' is violated.

-- Teste 15 (dominio): CHECK - chegada antes da saida no trecho
UPDATE encomenda_rota SET data_chegada = '2026-08-01 00:00:00'
WHERE id_encomenda = 1 AND id_rota = 1;
-- Esperado: ERROR 3819: Check constraint 'ck_er_datas' is violated.

-- =====================================================================
-- TESTES POSITIVOS (devem FUNCIONAR; ROLLBACK desfaz tudo no final)
-- Execute cada bloco INTEIRO, do START TRANSACTION ate o ROLLBACK.
-- =====================================================================

-- Teste 16 (DEFAULT): encomenda sem informar o status comeca como 'postada' - RN3
START TRANSACTION;
INSERT INTO encomenda (id_cliente, id_armazem_origem, id_cidade_destino, peso_kg, valor_frete, data_postagem, prazo_entrega)
VALUES (1, 1, 2, 5.00, 40.00, '2026-10-24', '2026-10-30');
SELECT id_encomenda, status FROM encomenda WHERE id_encomenda = LAST_INSERT_ID();
-- Esperado: status = 'postada'
ROLLBACK;

-- Teste 17 (CASCADE): apagar uma encomenda apaga os trechos dela - RN11
START TRANSACTION;
SELECT COUNT(*) AS trechos_antes FROM encomenda_rota WHERE id_encomenda = 11;   -- esperado: 2
DELETE FROM encomenda WHERE id_encomenda = 11;
SELECT COUNT(*) AS trechos_depois FROM encomenda_rota WHERE id_encomenda = 11;  -- esperado: 0
ROLLBACK;
SELECT COUNT(*) AS trechos_apos_rollback FROM encomenda_rota WHERE id_encomenda = 11;  -- esperado: 2
