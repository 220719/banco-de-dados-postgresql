-- =====================================================================
-- Apostila Banco de Dados com PostgreSQL - Parte 1
-- Script 02: Criacao das tabelas (DDL)
-- Execute este script JA CONECTADO ao banco 'ecommerce'.
-- Prof. Dr. Anuar Jose Mincache | github.com/220719
-- =====================================================================

-- Ordem de criacao respeita as dependencias de chave estrangeira:
-- tabelas sem dependencia primeiro, depois as que as referenciam.

-- ---------------------------------------------------------------------
-- 1) cliente  - quem compra
-- ---------------------------------------------------------------------
CREATE TABLE cliente (
    id            INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome          VARCHAR(120) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,          -- RN1: e-mail unico
    cpf           CHAR(11)     NOT NULL UNIQUE,
    telefone      VARCHAR(20),
    data_cadastro TIMESTAMP    NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------
-- 2) endereco  - 1:N com cliente (um cliente, varios enderecos)
-- ---------------------------------------------------------------------
CREATE TABLE endereco (
    id           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cliente_id   INTEGER NOT NULL REFERENCES cliente(id) ON DELETE CASCADE,
    logradouro   VARCHAR(150) NOT NULL,
    numero       VARCHAR(10),
    complemento  VARCHAR(60),
    bairro       VARCHAR(80),
    cidade       VARCHAR(80) NOT NULL,
    uf           CHAR(2)     NOT NULL,
    cep          CHAR(8)     NOT NULL,
    principal    BOOLEAN     NOT NULL DEFAULT FALSE
);

-- ---------------------------------------------------------------------
-- 3) categoria  - AUTO-RELACIONAMENTO (categoria_pai_id -> categoria.id)
-- ---------------------------------------------------------------------
CREATE TABLE categoria (
    id               INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome             VARCHAR(80) NOT NULL,
    categoria_pai_id INTEGER,
    CONSTRAINT fk_categoria_pai
        FOREIGN KEY (categoria_pai_id) REFERENCES categoria(id)
);

-- ---------------------------------------------------------------------
-- 4) fornecedor  - quem fornece os produtos
-- ---------------------------------------------------------------------
CREATE TABLE fornecedor (
    id           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    razao_social VARCHAR(150) NOT NULL,
    cnpj         CHAR(14)     NOT NULL UNIQUE,
    email        VARCHAR(150),
    telefone     VARCHAR(20)
);

-- ---------------------------------------------------------------------
-- 5) produto  - itens a venda (RN2: uma categoria e um fornecedor)
-- ---------------------------------------------------------------------
CREATE TABLE produto (
    id            INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome          VARCHAR(150)  NOT NULL,
    descricao     TEXT,
    preco         NUMERIC(10,2) NOT NULL CHECK (preco >= 0),   -- RN3
    ativo         BOOLEAN       NOT NULL DEFAULT TRUE,
    data_cadastro TIMESTAMP     NOT NULL DEFAULT now(),
    categoria_id  INTEGER NOT NULL REFERENCES categoria(id),   -- RN2
    fornecedor_id INTEGER NOT NULL REFERENCES fornecedor(id)   -- RN2
);

-- ---------------------------------------------------------------------
-- 6) estoque  - 1:1 com produto (produto_id e PK e FK ao mesmo tempo)
-- ---------------------------------------------------------------------
CREATE TABLE estoque (
    produto_id        INTEGER PRIMARY KEY REFERENCES produto(id) ON DELETE CASCADE,
    quantidade        INTEGER NOT NULL DEFAULT 0 CHECK (quantidade >= 0),
    quantidade_minima INTEGER NOT NULL DEFAULT 0,
    localizacao       VARCHAR(40)
);

-- ---------------------------------------------------------------------
-- 7) cupom  - descontos aplicaveis a um pedido
-- ---------------------------------------------------------------------
CREATE TABLE cupom (
    id            INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo        VARCHAR(30)   NOT NULL UNIQUE,
    tipo_desconto VARCHAR(10)   NOT NULL CHECK (tipo_desconto IN ('percentual','fixo')),
    valor         NUMERIC(10,2) NOT NULL CHECK (valor >= 0),
    validade      DATE          NOT NULL,
    ativo         BOOLEAN       NOT NULL DEFAULT TRUE
);

-- ---------------------------------------------------------------------
-- 8) pedido  - compras (RN6: status validos via CHECK)
-- ---------------------------------------------------------------------
CREATE TABLE pedido (
    id                  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cliente_id          INTEGER NOT NULL REFERENCES cliente(id),
    endereco_entrega_id INTEGER NOT NULL REFERENCES endereco(id),
    cupom_id            INTEGER REFERENCES cupom(id) ON DELETE SET NULL,  -- opcional
    data_pedido         TIMESTAMP NOT NULL DEFAULT now(),
    status              VARCHAR(15) NOT NULL DEFAULT 'pendente'
        CHECK (status IN ('pendente','pago','enviado','entregue','cancelado')),  -- RN6
    valor_total         NUMERIC(10,2) NOT NULL DEFAULT 0
);

-- ---------------------------------------------------------------------
-- 9) item_pedido  - ASSOCIATIVA N:M (pedido x produto), PK COMPOSTA
--    RN7: ON DELETE CASCADE (item nao existe sem o pedido)
-- ---------------------------------------------------------------------
CREATE TABLE item_pedido (
    pedido_id      INTEGER NOT NULL REFERENCES pedido(id)  ON DELETE CASCADE,    -- RN7
    produto_id     INTEGER NOT NULL REFERENCES produto(id) ON DELETE RESTRICT,
    quantidade     INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMERIC(10,2) NOT NULL CHECK (preco_unitario >= 0),  -- RN5
    PRIMARY KEY (pedido_id, produto_id)
);

-- ---------------------------------------------------------------------
-- 10) pagamento  - 1:N com pedido (um pedido pode ter mais de um pgto)
-- ---------------------------------------------------------------------
CREATE TABLE pagamento (
    id             INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pedido_id      INTEGER NOT NULL REFERENCES pedido(id) ON DELETE CASCADE,
    metodo         VARCHAR(20) NOT NULL
        CHECK (metodo IN ('pix','cartao_credito','cartao_debito','boleto')),
    valor          NUMERIC(10,2) NOT NULL CHECK (valor >= 0),
    status         VARCHAR(15) NOT NULL DEFAULT 'pendente'
        CHECK (status IN ('pendente','aprovado','recusado','estornado')),
    data_pagamento TIMESTAMP NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------
-- 11) avaliacao  - N:M cliente x produto, com atributos (RN4: nota 1..5)
-- ---------------------------------------------------------------------
CREATE TABLE avaliacao (
    id         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES cliente(id),
    produto_id INTEGER NOT NULL REFERENCES produto(id),
    nota       SMALLINT NOT NULL CHECK (nota BETWEEN 1 AND 5),  -- RN4
    comentario TEXT,
    data       TIMESTAMP NOT NULL DEFAULT now(),
    -- um cliente avalia um produto no maximo uma vez:
    CONSTRAINT uq_avaliacao_cliente_produto UNIQUE (cliente_id, produto_id)
);
