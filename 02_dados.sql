-- 02_dados.sql : dados de teste (Transportadora)
-- Rodar DEPOIS do 01_criacao.sql. Mesma ordem de criacao: pais primeiro, filhos depois.
-- Data de referencia dos dados: 24/10/2026.

SET NAMES utf8mb4;
USE transportadora;

-- CIDADE (12)
INSERT INTO cidade (nome, estado) VALUES
  ('São Paulo', 'SP'),        -- 1
  ('Rio de Janeiro', 'RJ'),   -- 2
  ('Belo Horizonte', 'MG'),   -- 3
  ('Curitiba', 'PR'),         -- 4
  ('Porto Alegre', 'RS'),     -- 5
  ('Salvador', 'BA'),         -- 6
  ('Brasília', 'DF'),         -- 7
  ('Goiânia', 'GO'),          -- 8
  ('Campinas', 'SP'),         -- 9
  ('Niterói', 'RJ'),          -- 10
  ('Florianópolis', 'SC'),    -- 11
  ('Vitória', 'ES');          -- 12

-- CLIENTE (15): cliente 14 sem cidade (NULL) e cliente 15 sem encomendas (casos-limite)
INSERT INTO cliente (nome, cpf_cnpj, email, id_cidade) VALUES
  ('Mariana Alves',               '111.222.333-44',     'mariana@email.com',      2),
  ('Rafael Costa',                '222.333.444-55',     'rafael@email.com',       10),
  ('Comércio Ação Ltda',          '12.345.678/0001-90', 'contato@acao.com.br',    1),
  ('João Conceição',              '333.444.555-66',     'joao.c@email.com',       3),
  ('Indústria São José S.A.',     '23.456.789/0001-01', 'logistica@saojose.com',  6),
  ('Luciana Torres',              '444.555.666-77',     'luciana@email.com',      4),
  ('Papelaria Estação ME',        '34.567.890/0001-12', 'vendas@estacao.com.br',  9),
  ('Marcos Pinto',                '555.666.777-88',     'marcos@email.com',       12),
  ('Distribuidora Açaí Brasil',   '45.678.901/0001-23', 'pedidos@acaibr.com',     1),
  ('Fernanda Lopes',              '666.777.888-99',     'fernanda@email.com',     11),
  ('Renato Alves',                '777.888.999-00',     'renato@email.com',       9),
  ('Tech Sul Informática',        '56.789.012/0001-34', 'compras@techsul.com',    5),
  ('Ana Beatriz Souza',           '888.999.000-11',     'anabeatriz@email.com',   7),
  ('Cliente Sem Cidade',          '999.000.111-22',     'semcidade@email.com',    NULL),
  ('Cliente Sem Encomendas',      '000.111.222-33',     'semencomendas@email.com', 8);

-- TELEFONE_CLIENTE (atributo multivalorado: alguns clientes com 2 telefones, outros com nenhum)
INSERT INTO telefone_cliente (id_cliente, numero) VALUES
  (1, '(21) 99999-1111'), (1, '(21) 3333-1111'),
  (2, '(21) 98888-2222'),
  (3, '(11) 3000-4000'), (3, '(11) 97777-3333'),
  (4, '(31) 96666-4444'),
  (5, '(71) 3500-5555'),
  (6, '(41) 95555-6666'),
  (7, '(19) 3200-7777'),
  (8, '(27) 94444-8888'),
  (9, '(11) 3100-9999'), (9, '(11) 98765-0000'),
  (10, '(48) 93333-1010'),
  (11, '(19) 92222-1212'),
  (12, '(51) 3400-1313'),
  (13, '(61) 91111-1414'),
  (15, '(62) 90000-1515');
-- clientes 14 e 15(n) ficam sem telefone ou com apenas um: casos de teste do LEFT JOIN

-- MOTORISTA (10): motorista 10 nunca fez trecho
INSERT INTO motorista (nome, data_admissao) VALUES
  ('Carlos Eduardo Lima',  '2018-03-12'),  -- 1
  ('José Antônio Ferreira','2019-07-01'),  -- 2
  ('Paulo Sérgio Nunes',   '2020-02-17'),  -- 3
  ('Ricardo Gonçalves',    '2017-11-05'),  -- 4
  ('Sandra Regina Melo',   '2021-05-24'),  -- 5
  ('Wagner Moraes',        '2016-09-30'),  -- 6
  ('Tiago Barbosa',        '2022-01-10'),  -- 7
  ('Luís Fernando Dias',   '2023-04-03'),  -- 8
  ('Marcelo Tavares',      '2015-06-15'),  -- 9
  ('Beatriz Cardoso',      '2024-08-19');  -- 10

-- HABILITACAO (1:1 com motorista)
-- m3 e m7: vencem nos proximos 30 dias; m9: CNH ja vencida
INSERT INTO habilitacao (id_motorista, numero_cnh, categoria, validade) VALUES
  (1,  '01234567890', 'E', '2028-05-10'),
  (2,  '12345678901', 'D', '2027-03-22'),
  (3,  '23456789012', 'E', '2026-11-10'),
  (4,  '34567890123', 'E', '2029-01-15'),
  (5,  '45678901234', 'C', '2027-09-30'),
  (6,  '56789012345', 'E', '2028-12-01'),
  (7,  '67890123456', 'D', '2026-11-20'),
  (8,  '78901234567', 'C', '2030-02-14'),
  (9,  '89012345678', 'E', '2026-08-15'),
  (10, '90123456789', 'B', '2028-07-07');

-- VEICULO (10): veiculo 10 nunca fez trecho e esta em manutencao
INSERT INTO veiculo (placa, modelo, capacidade_kg, status) VALUES
  ('ABC1D23', 'Mercedes-Benz Accelo',   3500.00,  'disponivel'),  -- 1
  ('BCD2E34', 'Volvo FH 460',           25000.00, 'em_viagem'),   -- 2
  ('CDE3F45', 'Scania R450',            27000.00, 'em_viagem'),   -- 3
  ('DEF4G56', 'Iveco Daily',            3000.00,  'disponivel'),  -- 4
  ('EFG5H67', 'Volkswagen Delivery',    5000.00,  'em_viagem'),   -- 5
  ('FGH6I78', 'Ford Cargo 816',         8000.00,  'em_viagem'),   -- 6
  ('GHI7J89', 'Fiat Ducato',            1500.00,  'disponivel'),  -- 7
  ('HIJ8K90', 'Volvo VM 270',           14000.00, 'disponivel'),  -- 8
  ('IJK9L01', 'Renault Master',         1600.00,  'em_viagem'),   -- 9
  ('JKL0M12', 'Mercedes-Benz Atego',    9000.00,  'manutencao');  -- 10

-- ARMAZEM (6)
INSERT INTO armazem (nome, id_cidade) VALUES
  ('Centro de Distribuição SP',   1),  -- 1
  ('Terminal Rio',                2),  -- 2
  ('Hub Minas',                   3),  -- 3
  ('Armazém Sul Curitiba',        4),  -- 4
  ('Terminal Nordeste',           6),  -- 5 (sem encomendas: caso-limite)
  ('Hub Centro-Oeste Brasília',   7);  -- 6

-- ROTA (13): rota 13 nunca foi usada
INSERT INTO rota (id_cidade_origem, id_cidade_destino, distancia_km) VALUES
  (1, 2, 430.00),    -- 1  SP -> Rio
  (1, 3, 586.00),    -- 2  SP -> BH
  (1, 4, 408.00),    -- 3  SP -> Curitiba
  (1, 9, 95.00),     -- 4  SP -> Campinas
  (2, 3, 434.00),    -- 5  Rio -> BH
  (2, 10, 22.00),    -- 6  Rio -> Niterói
  (3, 7, 740.00),    -- 7  BH -> Brasília
  (3, 6, 1372.00),   -- 8  BH -> Salvador
  (4, 5, 711.00),    -- 9  Curitiba -> Porto Alegre
  (4, 11, 300.00),   -- 10 Curitiba -> Florianópolis
  (7, 8, 209.00),    -- 11 Brasília -> Goiânia
  (2, 12, 520.00),   -- 12 Rio -> Vitória
  (5, 4, 711.00);    -- 13 Porto Alegre -> Curitiba (nunca usada)

-- ENCOMENDA (32)
-- colunas: cliente, armazem_origem, cidade_destino, peso, frete, postagem, prazo, status
-- Atrasadas em 24/10/2026: ids 17, 18, 19 e 24 (em transito com prazo vencido)
INSERT INTO encomenda (id_cliente, id_armazem_origem, id_cidade_destino, peso_kg, valor_frete, data_postagem, prazo_entrega, status) VALUES
  (1,  1, 2,  12.50,  85.00,   '2026-08-03', '2026-08-07', 'entregue'),     -- 1
  (2,  1, 3,  45.00,  190.00,  '2026-08-05', '2026-08-10', 'entregue'),     -- 2
  (3,  1, 4,  8.20,   70.00,   '2026-08-08', '2026-08-12', 'entregue'),     -- 3
  (1,  2, 3,  150.00, 420.00,  '2026-08-12', '2026-08-18', 'entregue'),     -- 4
  (4,  3, 7,  30.00,  260.00,  '2026-08-15', '2026-08-22', 'entregue'),     -- 5
  (5,  3, 6,  75.50,  640.00,  '2026-08-20', '2026-08-30', 'entregue'),     -- 6
  (6,  4, 5,  20.00,  150.00,  '2026-08-22', '2026-08-28', 'entregue'),     -- 7
  (7,  1, 9,  0.50,   25.00,   '2026-08-25', '2026-08-27', 'entregue'),     -- 8 (peso minimo)
  (8,  2, 12, 60.00,  310.00,  '2026-09-01', '2026-09-06', 'entregue'),     -- 9
  (9,  1, 2,  500.00, 1200.00, '2026-09-03', '2026-09-10', 'entregue'),     -- 10 (carga pesada)
  (2,  3, 8,  22.00,  310.00,  '2026-09-05', '2026-09-15', 'entregue'),     -- 11 (2 trechos)
  (10, 4, 11, 14.00,  95.00,   '2026-09-08', '2026-09-12', 'entregue'),     -- 12
  (11, 1, 9,  9.90,   60.00,   '2026-09-10', '2026-09-13', 'entregue'),     -- 13
  (3,  2, 10, 3.00,   0.00,    '2026-09-12', '2026-09-14', 'entregue'),     -- 14 (frete zero: promocao)
  (12, 1, 5,  88.00,  520.00,  '2026-09-15', '2026-09-25', 'entregue'),     -- 15 (2 trechos)
  (13, 6, 8,  18.00,  120.00,  '2026-09-18', '2026-09-22', 'entregue'),     -- 16
  (5,  3, 6,  40.00,  380.00,  '2026-09-20', '2026-09-29', 'em_transito'),  -- 17 ATRASADA
  (6,  1, 3,  55.00,  240.00,  '2026-09-22', '2026-09-27', 'em_transito'),  -- 18 ATRASADA
  (1,  2, 12, 33.30,  190.00,  '2026-09-25', '2026-09-30', 'em_transito'),  -- 19 ATRASADA
  (7,  4, 11, 7.00,   55.00,   '2026-10-01', '2026-10-04', 'entregue'),     -- 20
  (4,  3, 7,  120.00, 680.00,  '2026-10-03', '2026-10-10', 'entregue'),     -- 21
  (8,  1, 4,  26.00,  140.00,  '2026-10-05', '2026-10-09', 'entregue'),     -- 22
  (9,  1, 9,  15.00,  70.00,   '2026-10-08', '2026-10-11', 'entregue'),     -- 23
  (10, 2, 3,  64.00,  290.00,  '2026-10-10', '2026-10-16', 'em_transito'),  -- 24 ATRASADA
  (2,  1, 2,  11.00,  80.00,   '2026-10-12', '2026-10-16', 'entregue'),     -- 25
  (12, 4, 5,  95.00,  610.00,  '2026-10-15', '2026-10-25', 'em_transito'),  -- 26 no prazo
  (14, 1, 3,  28.00,  150.00,  '2026-10-16', '2026-10-22', 'cancelada'),    -- 27 (cliente sem cidade)
  (13, 6, 8,  5.00,   45.00,   '2026-10-18', '2026-10-24', 'em_transito'),  -- 28 (prazo = hoje)
  (11, 1, 4,  19.00,  110.00,  '2026-10-20', '2026-10-26', 'postada'),      -- 29
  (3,  2, 10, 6.00,   40.00,   '2026-10-21', '2026-10-27', 'postada'),      -- 30
  (9,  3, 6,  200.00, 900.00,  '2026-10-22', '2026-11-02', 'postada'),      -- 31
  (1,  1, 3,  1.00,   35.00,   '2026-10-23', '2026-10-28', 'postada');      -- 32

-- ENCOMENDA_ROTA (trechos): data_chegada NULL = trecho ainda em andamento
-- Encomendas 27 a 32 nao tem trechos (cancelada ou ainda sem rota)
INSERT INTO encomenda_rota (id_encomenda, id_rota, id_motorista, id_veiculo, data_saida, data_chegada) VALUES
  (1,  1,  9, 1, '2026-08-03 08:00:00', '2026-08-04 14:00:00'),  -- motorista 9, CNH ainda valida na epoca
  (2,  2,  1, 2, '2026-08-05 07:30:00', '2026-08-06 05:00:00'),
  (3,  3,  2, 3, '2026-08-08 09:00:00', '2026-08-09 03:00:00'),
  (4,  5,  3, 2, '2026-08-12 06:00:00', '2026-08-13 02:00:00'),
  (5,  7,  4, 4, '2026-08-15 05:00:00', '2026-08-17 10:00:00'),
  (6,  8,  5, 5, '2026-08-20 06:00:00', '2026-08-23 18:00:00'),
  (7,  9,  6, 6, '2026-08-22 07:00:00', '2026-08-24 09:00:00'),
  (8,  4,  2, 7, '2026-08-25 10:00:00', '2026-08-25 13:30:00'),
  (9,  12, 3, 3, '2026-09-01 08:00:00', '2026-09-02 04:00:00'),
  (10, 1,  1, 8, '2026-09-03 06:00:00', '2026-09-04 07:00:00'),
  (11, 7,  4, 4, '2026-09-05 05:00:00', '2026-09-06 20:00:00'),
  (11, 11, 7, 5, '2026-09-07 06:00:00', '2026-09-07 14:00:00'),
  (12, 10, 6, 6, '2026-09-08 08:00:00', '2026-09-08 17:00:00'),
  (13, 4,  2, 7, '2026-09-10 08:00:00', '2026-09-10 11:30:00'),
  (14, 6,  3, 2, '2026-09-12 09:00:00', '2026-09-12 10:00:00'),
  (15, 3,  2, 3, '2026-09-15 06:00:00', '2026-09-16 02:00:00'),
  (15, 9,  6, 6, '2026-09-17 07:00:00', '2026-09-18 20:00:00'),
  (16, 11, 7, 9, '2026-09-18 06:00:00', '2026-09-18 15:00:00'),
  (17, 8,  5, 5, '2026-09-20 06:00:00', NULL),
  (18, 2,  1, 2, '2026-09-22 07:00:00', NULL),
  (19, 12, 3, 3, '2026-09-25 08:00:00', NULL),
  (20, 10, 6, 6, '2026-10-01 08:00:00', '2026-10-01 17:00:00'),
  (21, 7,  4, 4, '2026-10-03 05:00:00', '2026-10-04 20:00:00'),
  (22, 3,  8, 8, '2026-10-05 07:00:00', '2026-10-06 03:00:00'),
  (23, 4,  2, 7, '2026-10-08 09:00:00', '2026-10-08 12:30:00'),
  (24, 5,  3, 2, '2026-10-10 06:00:00', NULL),
  (25, 1,  8, 1, '2026-10-12 08:00:00', '2026-10-13 06:00:00'),
  (26, 9,  6, 6, '2026-10-15 07:00:00', NULL),
  (28, 11, 7, 9, '2026-10-18 06:00:00', NULL);

-- Conferencia rapida
SELECT 'cidade' AS tabela, COUNT(*) AS total FROM cidade
UNION ALL SELECT 'cliente', COUNT(*) FROM cliente
UNION ALL SELECT 'telefone_cliente', COUNT(*) FROM telefone_cliente
UNION ALL SELECT 'motorista', COUNT(*) FROM motorista
UNION ALL SELECT 'habilitacao', COUNT(*) FROM habilitacao
UNION ALL SELECT 'veiculo', COUNT(*) FROM veiculo
UNION ALL SELECT 'armazem', COUNT(*) FROM armazem
UNION ALL SELECT 'rota', COUNT(*) FROM rota
UNION ALL SELECT 'encomenda', COUNT(*) FROM encomenda
UNION ALL SELECT 'encomenda_rota', COUNT(*) FROM encomenda_rota;
