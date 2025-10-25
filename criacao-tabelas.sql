DROP DATABASE IF EXISTS Vaction;
CREATE DATABASE  Vaction;
USE Vaction;

-- EMPRESA
CREATE TABLE empresa (
    id_empresa INT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    cnpj VARCHAR(45) UNIQUE NOT NULL
);

-- NIVEL DE ACESSO
CREATE TABLE nivel_acesso (
    id_nivel INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(45) NOT NULL
    CHECK (descricao IN ('COLABORADOR', 'GESTOR', 'RH'))
);

-- STATUS
CREATE TABLE status (
    id_status INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL
    CHECK (nome IN ('PENDENTE_GESTOR', 'PENDENTE_RH', 'APROVADO', 'REPROVADO'))
);

-- DECISAO
CREATE TABLE decisao (
    id_decisao INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL
    CHECK (nome IN ('APROVADO', 'REPROVADO'))
);

-- USUARIO
CREATE TABLE usuario (
    id_usuario INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    email VARCHAR(45) UNIQUE NOT NULL,
    area VARCHAR(45),
    senha VARCHAR(45) NOT NULL,
    cargo VARCHAR(45),
    data_admissao DATE NOT NULL,
    cpf VARCHAR(45) UNIQUE NOT NULL,
    autenticado BOOLEAN,
    fk_empresa INT NOT NULL,
    fk_aprovador INT NULL,
    fk_nivel INT NOT NULL,
    FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa),
    FOREIGN KEY (fk_aprovador) REFERENCES usuario(id_usuario),
    FOREIGN KEY (fk_nivel) REFERENCES nivel_acesso(id_nivel)
);

-- PEDIDO DE FERIAS
CREATE TABLE pedido (
    id_pedido INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    data_solicitacao DATE NOT NULL,
    dias_usufruidos INT,
    ultima_atualizacao DATE,
    fk_usuario INT NOT NULL,
    fk_status INT NOT NULL,
    FOREIGN KEY (fk_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (fk_status) REFERENCES status(id_status)
);

-- HISTORICO
CREATE TABLE historico (
    id_alteracao INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    data_alteracao DATE NOT NULL,
    observacao VARCHAR(45),
    fk_pedido INT NOT NULL,
    fk_usuario INT NOT NULL,
    fk_decisao INT NULL,
    FOREIGN KEY (fk_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (fk_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (fk_decisao) REFERENCES decisao(id_decisao)
);
