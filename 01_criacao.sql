-- 01_criacao.sql : banco, tabelas, indices e view (Transportadora)
-- Ordem: independentes -> dependentes -> associativa

CREATE DATABASE IF NOT EXISTS transportadora
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE transportadora;

-- 1. CIDADE
CREATE TABLE cidade (
  id_cidade INT AUTO_INCREMENT PRIMARY KEY,
  nome      VARCHAR(60) NOT NULL,
  estado    CHAR(2)     NOT NULL,
  CONSTRAINT uq_cidade UNIQUE (nome, estado)
);

-- 2. CLIENTE (RN1: cpf_cnpj e email unicos)
CREATE TABLE cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome       VARCHAR(100) NOT NULL,
  cpf_cnpj   VARCHAR(18)  NOT NULL UNIQUE,
  email      VARCHAR(120) NOT NULL UNIQUE,
  id_cidade  INT,
  CONSTRAINT fk_cliente_cidade FOREIGN KEY (id_cidade) REFERENCES cidade (id_cidade)
);

-- 3. TELEFONE_CLIENTE (atributo multivalorado)
CREATE TABLE telefone_cliente (
  id_telefone INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente  INT         NOT NULL,
  numero      VARCHAR(20) NOT NULL,
  CONSTRAINT fk_tel_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
    ON DELETE CASCADE
);

-- 4. MOTORISTA
CREATE TABLE motorista (
  id_motorista  INT AUTO_INCREMENT PRIMARY KEY,
  nome          VARCHAR(100) NOT NULL,
  data_admissao DATE         NOT NULL
);

-- 5. HABILITACAO (relacionamento 1:1: FK com UNIQUE) - RN5 e RN7
CREATE TABLE habilitacao (
  id_habilitacao INT AUTO_INCREMENT PRIMARY KEY,
  id_motorista   INT         NOT NULL UNIQUE,
  numero_cnh     VARCHAR(15) NOT NULL UNIQUE,
  categoria      CHAR(2)     NOT NULL,
  validade       DATE        NOT NULL,
  CONSTRAINT fk_hab_motorista FOREIGN KEY (id_motorista) REFERENCES motorista (id_motorista),
  CONSTRAINT ck_hab_categoria CHECK (categoria IN ('B','C','D','E','AB','AC','AD','AE'))
);

-- 6. VEICULO (RN2 e RN5)
CREATE TABLE veiculo (
  id_veiculo    INT AUTO_INCREMENT PRIMARY KEY,
  placa         VARCHAR(8)    NOT NULL UNIQUE,
  modelo        VARCHAR(60)   NOT NULL,
  capacidade_kg DECIMAL(10,2) NOT NULL,
  status        VARCHAR(15)   NOT NULL DEFAULT 'disponivel',
  CONSTRAINT ck_veiculo_cap    CHECK (capacidade_kg > 0),
  CONSTRAINT ck_veiculo_status CHECK (status IN ('disponivel','em_viagem','manutencao'))
);

-- 7. ARMAZEM
CREATE TABLE armazem (
  id_armazem INT AUTO_INCREMENT PRIMARY KEY,
  nome       VARCHAR(80) NOT NULL,
  id_cidade  INT         NOT NULL,
  CONSTRAINT fk_armazem_cidade FOREIGN KEY (id_cidade) REFERENCES cidade (id_cidade)
);

-- 8. ENCOMENDA (RN2, RN3, RN4, RN8)
CREATE TABLE encomenda (
  id_encomenda      INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente        INT           NOT NULL,
  id_armazem_origem INT           NOT NULL,
  id_cidade_destino INT           NOT NULL,
  peso_kg           DECIMAL(10,2) NOT NULL,
  valor_frete       DECIMAL(10,2) NOT NULL,
  data_postagem     DATE          NOT NULL,
  prazo_entrega     DATE          NOT NULL,
  status            VARCHAR(15)   NOT NULL DEFAULT 'postada',
  CONSTRAINT fk_enc_cliente FOREIGN KEY (id_cliente)        REFERENCES cliente (id_cliente),
  CONSTRAINT fk_enc_armazem FOREIGN KEY (id_armazem_origem) REFERENCES armazem (id_armazem),
  CONSTRAINT fk_enc_destino FOREIGN KEY (id_cidade_destino) REFERENCES cidade (id_cidade),
  CONSTRAINT ck_enc_peso    CHECK (peso_kg > 0),
  CONSTRAINT ck_enc_frete   CHECK (valor_frete >= 0),
  CONSTRAINT ck_enc_prazo   CHECK (prazo_entrega >= data_postagem),
  CONSTRAINT ck_enc_status  CHECK (status IN ('postada','em_transito','entregue','cancelada'))
);

-- 9. ROTA (RN9)
CREATE TABLE rota (
  id_rota           INT AUTO_INCREMENT PRIMARY KEY,
  id_cidade_origem  INT           NOT NULL,
  id_cidade_destino INT           NOT NULL,
  distancia_km      DECIMAL(8,2)  NOT NULL,
  CONSTRAINT fk_rota_origem  FOREIGN KEY (id_cidade_origem)  REFERENCES cidade (id_cidade),
  CONSTRAINT fk_rota_destino FOREIGN KEY (id_cidade_destino) REFERENCES cidade (id_cidade),
  CONSTRAINT uq_rota         UNIQUE (id_cidade_origem, id_cidade_destino),
  CONSTRAINT ck_rota_dist    CHECK (distancia_km > 0),
  CONSTRAINT ck_rota_cidades CHECK (id_cidade_origem <> id_cidade_destino)
);

-- 10. ENCOMENDA_ROTA (N:N, chave primaria composta) - RN6 e RN11
CREATE TABLE encomenda_rota (
  id_encomenda INT      NOT NULL,
  id_rota      INT      NOT NULL,
  id_motorista INT      NOT NULL,
  id_veiculo   INT      NOT NULL,
  data_saida   DATETIME NOT NULL,
  data_chegada DATETIME,
  PRIMARY KEY (id_encomenda, id_rota),
  CONSTRAINT fk_er_encomenda FOREIGN KEY (id_encomenda) REFERENCES encomenda (id_encomenda)
    ON DELETE CASCADE,
  CONSTRAINT fk_er_rota      FOREIGN KEY (id_rota)      REFERENCES rota (id_rota),
  CONSTRAINT fk_er_motorista FOREIGN KEY (id_motorista) REFERENCES motorista (id_motorista),
  CONSTRAINT fk_er_veiculo   FOREIGN KEY (id_veiculo)   REFERENCES veiculo (id_veiculo),
  CONSTRAINT ck_er_datas     CHECK (data_chegada IS NULL OR data_chegada >= data_saida)
);

-- Indices extras (colunas muito usadas em filtros e juncoes)
CREATE INDEX idx_cliente_nome    ON cliente (nome);
CREATE INDEX idx_enc_prazo       ON encomenda (prazo_entrega);
CREATE INDEX idx_enc_status      ON encomenda (status);
CREATE INDEX idx_hab_validade    ON habilitacao (validade);

-- View: frete total por cliente
CREATE VIEW vw_frete_cliente AS
SELECT c.id_cliente, c.nome AS cliente,
       COUNT(e.id_encomenda) AS total_encomendas,
       COALESCE(SUM(e.valor_frete), 0) AS total_frete
FROM cliente c
LEFT JOIN encomenda e ON e.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome;
