DROP DATABASE IF EXISTS transparencia;
CREATE DATABASE transparencia
 CHARACTER SET utf8mb4
 COLLATE utf8mb4_general_ci;
USE transparencia;


#====================================
#Camada Bronze (Raw)

DROP TABLE IF EXISTS raw_viagem;
CREATE TABLE raw_viagem (
    id_viagem				VARCHAR(20),
	num_proposta			VARCHAR(20),
	situacao				VARCHAR(50),
	viagem_urgente			VARCHAR(5),
    justificativa			VARCHAR(4000),
	cod_orgao_superior		VARCHAR(20),
	nome_orgao_superior		VARCHAR(255),
    cod_orgao_solicitante	VARCHAR(20),
    nome_orgao_solicitante	VARCHAR(255),
    cfp_viajante			VARCHAR(20),
	nome_viajante			VARCHAR(255),
	cargo					VARCHAR(255),
    funcao					VARCHAR(100),
    descricao				VARCHAR(255),
	data_inicio				VARCHAR(20),
	data_fim				VARCHAR(20),
	destinos				VARCHAR(4000),
	motivo					VARCHAR(4000),
	valor_diarias			VARCHAR(20),
	valor_passagens			VARCHAR(20),
	valor_devolucao			VARCHAR(20),
	valor_outros_gastos		VARCHAR(20)
);


DROP TABLE IF EXISTS raw_passagem;
CREATE TABLE raw_passagem (
    id_viagem					VARCHAR(20), -- 1ª coluna do CSV (Receberá o ID numérico correto 20286869)
    num_proposta				VARCHAR(20), -- 2ª coluna do CSV (Receberá o 000002/25)
	meio_transporte				VARCHAR(50), -- 3ª coluna do CSV
	pais_origem_ida				VARCHAR(60),
    uf_origem_ida				VARCHAR(40),
    cidade_origem_ida			VARCHAR(80),
    pais_destino_ida			VARCHAR(60),
    uf_destino_ida				VARCHAR(40),
    cidade_destino_ida			VARCHAR(80),
    pais_origem_volta			VARCHAR(60),
    uf_origem_volta				VARCHAR(40),
    cidade_origem_volta			VARCHAR(80),
    pais_destino_volta			VARCHAR(60),
    uf_destino_volta			VARCHAR(40),
    cidade_destino_volta		VARCHAR(80),
    valor_passagem				VARCHAR(20),
    taxa_servico				VARCHAR(20),
    data_emissao				VARCHAR(20),
    hora_emissao				VARCHAR(20)
);


DROP TABLE IF EXISTS raw_pagamento;
CREATE TABLE raw_pagamento (
    id_viagem                   VARCHAR(20), 
	num_proposta				VARCHAR(20),
    cod_orgao_superior			VARCHAR(20),
	nome_orgao_superior 		VARCHAR(255),
    cod_orgao_pagador			VARCHAR(20),
    nome_orgao_pagador			VARCHAR(255),
    cod_ug_pagadora				VARCHAR(20),
	nome_ug_pagadora 			VARCHAR(255),
	tipo_pagamento 				VARCHAR(50),
	valor 						VARCHAR(20)
);


DROP TABLE IF EXISTS raw_trecho;
CREATE TABLE raw_trecho (
    id_viagem        VARCHAR(20),
    num_proposta     VARCHAR(20),
    sequencia_trecho VARCHAR(10),
    origem_data      VARCHAR(10),
    origem_pais      VARCHAR(60),
    origem_uf        VARCHAR(40),
    origem_cidade    VARCHAR(80),
    destino_data     VARCHAR(10),
    destino_pais     VARCHAR(60),
    destino_uf       VARCHAR(40),
    destino_cidade   VARCHAR(80),
    meio_transporte  VARCHAR(50),
    numero_diarias   VARCHAR(30),
    missao           VARCHAR(5)
) ENGINE=InnoDB;



#======================================
#Camada Silver

DROP TABLE IF EXISTS silver_viagem;
CREATE TABLE silver_viagem (
    id_viagem               VARCHAR(20) NOT NULL PRIMARY KEY,
    num_proposta            VARCHAR(20),
    situacao                VARCHAR(50),
    viagem_urgente          VARCHAR(5),
    cod_orgao_superior      VARCHAR(20),
    nome_orgao_superior     VARCHAR(255) NOT NULL, 
    cod_orgao_solicitante   VARCHAR(20),          
    nome_orgao_solicitante  VARCHAR(255),         
    nome_viajante           VARCHAR(255),
    cargo                   VARCHAR(255),
    data_inicio             DATE,
    data_fim                DATE,
    destinos                VARCHAR(4000),
    motivo                  VARCHAR(4000),
    valor_diarias           DECIMAL(10,2) CHECK (valor_diarias >= 0), 
    valor_passagens         DECIMAL(10,2),
    valor_devolucao         DECIMAL(10,2),
    valor_outros_gastos     DECIMAL(10,2),
    valor_total             DECIMAL(12,2), 
    duracao_dias            INT            
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS silver_pagamento;
CREATE TABLE silver_pagamento (
    id_pagamento            INT AUTO_INCREMENT PRIMARY KEY, 
    id_viagem               VARCHAR(20) NOT NULL,           
    num_proposta            VARCHAR(20),
    nome_orgao_pagador      VARCHAR(255),
    nome_ug_pagadora        VARCHAR(255),
    tipo_pagamento          VARCHAR(50) NOT NULL,           
    valor                   DECIMAL(10,2) CHECK (valor >= 0), 
    FOREIGN KEY (id_viagem) REFERENCES silver_viagem(id_viagem)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS silver_passagem;
CREATE TABLE silver_passagem (
    id_passagem        INT NOT NULL AUTO_INCREMENT,
    id_viagem          VARCHAR(20) NOT NULL,
    meio_transporte    VARCHAR(50),
    pais_origem_ida    VARCHAR(60),
    uf_origem_ida      VARCHAR(40),
    cidade_origem_ida  VARCHAR(80),
    pais_destino_ida   VARCHAR(60),
    uf_destino_ida     VARCHAR(40),
    cidade_destino_ida VARCHAR(80),
    valor_passagem     DECIMAL(10,2),
    taxa_servico       DECIMAL(10,2),
    data_emissao       DATE,
    PRIMARY KEY (id_passagem),
    FOREIGN KEY (id_viagem) REFERENCES silver_viagem(id_viagem),
    CONSTRAINT chk_passagem_valor CHECK (valor_passagem >= 0),
    CONSTRAINT chk_passagem_taxa  CHECK (taxa_servico >= 0)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS silver_trecho;
CREATE TABLE silver_trecho (
    id_trecho               INT AUTO_INCREMENT PRIMARY KEY,
    id_viagem               VARCHAR(20) NOT NULL,
    sequencia_trecho        INT,
    origem_data             DATE,
    origem_uf               VARCHAR(40),
    origem_cidade           VARCHAR(80),
    destino_data            DATE,
    destino_uf              VARCHAR(40),
    destino_cidade          VARCHAR(80),
    meio_transporte         VARCHAR(50),
    numero_diarias          DECIMAL(10,2) CHECK (numero_diarias >= 0), 
    FOREIGN KEY (id_viagem) REFERENCES silver_viagem(id_viagem)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC;
