-- 03_consultas.sql : consultas de validacao (Transportadora)
-- Rodar DEPOIS do 01_criacao.sql e do 02_dados.sql.
-- Dica: no Workbench, selecione UMA consulta e aperte Ctrl+Enter para ver o resultado dela.
-- As consultas 02 e 10 usam CURDATE(); os resultados descritos valem para a data 24/10/2026.

USE transportadora;

-- Consulta 01
-- Pergunta de negocio: quais encomendas postadas em setembro/2026 ja foram entregues ou estao em transito?
-- Conceitos: WHERE + AND + BETWEEN + IN
SELECT id_encomenda, peso_kg, valor_frete, data_postagem, status
FROM encomenda
WHERE data_postagem BETWEEN '2026-09-01' AND '2026-09-30'
  AND status IN ('entregue', 'em_transito')
ORDER BY data_postagem;

-- Consulta 02
-- Pergunta de negocio: quais motoristas tem CNH vencendo nos proximos 30 dias?
-- Conceitos: WHERE + BETWEEN com funcoes de data (CURDATE, DATE_ADD) + INNER JOIN
-- Esperado (24/10/2026): Paulo Sergio Nunes e Tiago Barbosa
SELECT m.nome AS motorista, h.numero_cnh, h.validade
FROM habilitacao h
INNER JOIN motorista m ON m.id_motorista = h.id_motorista
WHERE h.validade BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
ORDER BY h.validade;

-- Consulta 03
-- Pergunta de negocio: quais clientes sao pessoa juridica (documento no formato de CNPJ)?
-- Conceitos: LIKE
SELECT nome, cpf_cnpj, email
FROM cliente
WHERE cpf_cnpj LIKE '%/0001-%'
ORDER BY nome;

-- Consulta 04
-- Pergunta de negocio: quais trechos ainda estao em andamento (sem data de chegada)?
-- Conceitos: IS NULL
-- Esperado: 6 trechos (encomendas 17, 18, 19, 24, 26 e 28)
SELECT id_encomenda, id_rota, id_motorista, id_veiculo, data_saida
FROM encomenda_rota
WHERE data_chegada IS NULL
ORDER BY data_saida;

-- Consulta 05
-- Pergunta de negocio: quais sao as 5 encomendas com maior valor de frete?
-- Conceitos: ORDER BY + LIMIT (ranking)
SELECT id_encomenda, id_cliente, peso_kg, valor_frete
FROM encomenda
ORDER BY valor_frete DESC
LIMIT 5;

-- Consulta 06
-- Pergunta de negocio: quantas encomendas, qual o frete total e o peso medio por status?
-- Conceitos: COUNT, SUM, AVG + GROUP BY
SELECT status,
       COUNT(*)                  AS total_encomendas,
       SUM(valor_frete)          AS frete_total,
       ROUND(AVG(peso_kg), 2)    AS peso_medio_kg
FROM encomenda
GROUP BY status
ORDER BY total_encomendas DESC;

-- Consulta 07
-- Pergunta de negocio: quantas encomendas cada armazem recebeu (inclusive os que nao receberam nenhuma)?
-- Conceitos: LEFT JOIN + COUNT + GROUP BY
-- Esperado: o armazem "Terminal Nordeste" aparece com 0
SELECT a.nome AS armazem,
       COUNT(e.id_encomenda) AS total_encomendas
FROM armazem a
LEFT JOIN encomenda e ON e.id_armazem_origem = a.id_armazem
GROUP BY a.id_armazem, a.nome
ORDER BY total_encomendas DESC, a.nome;

-- Consulta 08
-- Pergunta de negocio: qual o faturamento de frete por cliente, mostrando so quem passou de R$ 500?
-- Conceitos: INNER JOIN + SUM + GROUP BY + HAVING
SELECT c.nome AS cliente,
       COUNT(e.id_encomenda) AS total_encomendas,
       SUM(e.valor_frete)    AS frete_total
FROM cliente c
INNER JOIN encomenda e ON e.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
HAVING SUM(e.valor_frete) > 500
ORDER BY frete_total DESC;

-- Consulta 09
-- Pergunta de negocio: quais trechos estao em andamento, com cliente, motorista e veiculo?
-- Conceitos: INNER JOIN com 5 tabelas + IS NULL
SELECT e.id_encomenda,
       c.nome   AS cliente,
       m.nome   AS motorista,
       v.placa  AS placa,
       er.data_saida
FROM encomenda_rota er
INNER JOIN encomenda e ON e.id_encomenda = er.id_encomenda
INNER JOIN cliente   c ON c.id_cliente   = e.id_cliente
INNER JOIN motorista m ON m.id_motorista = er.id_motorista
INNER JOIN veiculo   v ON v.id_veiculo   = er.id_veiculo
WHERE er.data_chegada IS NULL
ORDER BY er.data_saida;

-- Consulta 10
-- Pergunta de negocio: quais encomendas estao atrasadas (prazo vencido e ainda nao entregues)?
-- Conceitos: INNER JOIN com 3 tabelas + WHERE com data + DATEDIFF
-- Esperado (24/10/2026): encomendas 17, 18, 19 e 24
SELECT e.id_encomenda,
       c.nome  AS cliente,
       d.nome  AS cidade_destino,
       e.prazo_entrega,
       DATEDIFF(CURDATE(), e.prazo_entrega) AS dias_de_atraso
FROM encomenda e
INNER JOIN cliente c ON c.id_cliente = e.id_cliente
INNER JOIN cidade  d ON d.id_cidade  = e.id_cidade_destino
WHERE e.status NOT IN ('entregue', 'cancelada')
  AND e.prazo_entrega < CURDATE()
ORDER BY dias_de_atraso DESC;

-- Consulta 11
-- Pergunta de negocio: quais veiculos nunca realizaram nenhum trecho?
-- Conceitos: LEFT JOIN + IS NULL
-- Esperado: JKL0M12 (Mercedes-Benz Atego)
SELECT v.placa, v.modelo, v.status
FROM veiculo v
LEFT JOIN encomenda_rota er ON er.id_veiculo = v.id_veiculo
WHERE er.id_encomenda IS NULL;

-- Consulta 12
-- Pergunta de negocio: quais encomendas tem frete acima da media geral?
-- Conceitos: subconsulta (SELECT dentro do WHERE) + INNER JOIN
SELECT e.id_encomenda, c.nome AS cliente, e.valor_frete
FROM encomenda e
INNER JOIN cliente c ON c.id_cliente = e.id_cliente
WHERE e.valor_frete > (SELECT AVG(valor_frete) FROM encomenda)
ORDER BY e.valor_frete DESC;

-- Consulta 13
-- Pergunta de negocio: qual o total de frete de cada cliente (incluindo quem nunca enviou nada)?
-- Conceitos: consulta sobre uma VIEW (vw_frete_cliente)
-- Esperado: "Cliente Sem Encomendas" com 0 encomendas e frete 0
SELECT *
FROM vw_frete_cliente
ORDER BY total_frete DESC;

-- Consulta 14 (extra)
-- Pergunta de negocio: quais sao as rotas mais utilizadas?
-- Conceitos: INNER JOIN com 4 tabelas (cidade usada duas vezes) + COUNT + GROUP BY + LIMIT
SELECT r.id_rota,
       co.nome AS origem,
       cd.nome AS destino,
       COUNT(*) AS total_trechos
FROM rota r
INNER JOIN encomenda_rota er ON er.id_rota = r.id_rota
INNER JOIN cidade co ON co.id_cidade = r.id_cidade_origem
INNER JOIN cidade cd ON cd.id_cidade = r.id_cidade_destino
GROUP BY r.id_rota, co.nome, cd.nome
ORDER BY total_trechos DESC, origem
LIMIT 5;
