-- =========================== 
-- TABELA CLIENTES
-- =========================== 
CREATE TABLE clientes (
    id_cliente NUMBER PRIMARY KEY,
    nome VARCHAR2(100),
    nif VARCHAR2(9) UNIQUE,
    data_nascimento DATE,
    data_criacao DATE DEFAULT SYSDATE
);


-- =========================== 
-- TABELA APOLICES
-- =========================== 
CREATE TABLE apolices (
    id_apolice NUMBER PRIMARY KEY,
    id_cliente NUMBER,
    tipo VARCHAR2(50),
    premio_anual NUMBER(10,2),
    estado VARCHAR2(20),
    data_inicio DATE,
    data_fim DATE,
    CONSTRAINT fk_cliente FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente)
);


-- =========================== 
-- TABELA SINISTROS
-- =========================== 
CREATE TABLE sinistros (
    id_sinistro NUMBER PRIMARY KEY,
    id_apolice NUMBER,
    data_sinistro DATE,
    valor_reclamado NUMBER(10,2),
    estado VARCHAR2(20),
    CONSTRAINT fk_apolice FOREIGN KEY (id_apolice)
        REFERENCES apolices(id_apolice)
);


-- =========================== 
-- TABELA PAGAMENTOS
-- =========================== 
CREATE TABLE pagamentos (
    id_pagamento NUMBER PRIMARY KEY,
    id_apolice NUMBER,
    valor_pago NUMBER(10,2),
    data_pagamento DATE,
    CONSTRAINT fk_apolice_pag FOREIGN KEY (id_apolice)
        REFERENCES apolices(id_apolice)
);