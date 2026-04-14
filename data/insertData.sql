-- ===========================
-- INSERTS CLIENTES
-- ===========================
INSERT INTO CLIENTES (nome, data_nascimento, status) VALUES ('Alice Silva', TO_DATE('1980-05-12','YYYY-MM-DD'), 'ativo');
INSERT INTO CLIENTES (nome, data_nascimento, status) VALUES ('Bruno Souza', TO_DATE('1975-11-03','YYYY-MM-DD'), 'ativo');
INSERT INTO CLIENTES (nome, data_nascimento, status) VALUES ('Carla Pereira', TO_DATE('1990-07-20','YYYY-MM-DD'), 'inativo');
INSERT INTO CLIENTES (nome, data_nascimento, status) VALUES ('Marco Cardoso', TO_DATE('1996-11-03','YYYY-MM-DD'), 'inativo');


-- ===========================
-- INSERTS APOLICES
-- ===========================
INSERT INTO APOLICES (id_cliente, status, valor_segurado, franquia) VALUES (1, 'ativa', 100000, 5000);
INSERT INTO APOLICES (id_cliente, status, valor_segurado, franquia) VALUES (1, 'ativa', 50000, 2000);
INSERT INTO APOLICES (id_cliente, status, valor_segurado, franquia) VALUES (2, 'suspensa', 75000, 3000);
INSERT INTO APOLICES (id_cliente, status, valor_segurado, franquia) VALUES (3, 'cancelada', 60000, 4000);


-- ===========================
-- INSERTS SINISTROS
-- ===========================
INSERT INTO SINISTROS (id_apolice, tipo_sinistro, valor_estimado, status) VALUES (1, 'Acidente', 15000, 'em análise');
INSERT INTO SINISTROS (id_apolice, tipo_sinistro, valor_estimado, status) VALUES (2, 'Roubo', 10000, 'aprovado');
INSERT INTO SINISTROS (id_apolice, tipo_sinistro, valor_estimado, status) VALUES (3, 'Incêndio', 5000, 'recusado');
INSERT INTO SINISTROS (id_apolice, tipo_sinistro, valor_estimado, status) VALUES (1, 'Danos elétricos', 2000, 'em análise');


-- ===========================
-- INSERTS PAGAMENTOS
-- ===========================
INSERT INTO PAGAMENTOS (id_sinistro, valor_pago, data_pagamento) VALUES (2, 9500, TO_DATE('2024-01-10','YYYY-MM-DD'));
INSERT INTO PAGAMENTOS (id_sinistro, valor_pago, data_pagamento) VALUES (1, 0, NULL); -- ainda não aprovado
INSERT INTO PAGAMENTOS (id_sinistro, valor_pago, data_pagamento) VALUES (4, 0, NULL); -- ainda não aprovado


-- ===========================
-- INSERTS HISTORICO_SINISTROS
-- ===========================
INSERT INTO HISTORICO_SINISTROS (id_cliente, quantidade_sinistros) VALUES (1, 2); 
INSERT INTO HISTORICO_SINISTROS (id_cliente, quantidade_sinistros) VALUES (2, 1); 
INSERT INTO HISTORICO_SINISTROS (id_cliente, quantidade_sinistros) VALUES (3, 1);