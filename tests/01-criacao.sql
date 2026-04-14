SET SERVEROUTPUT ON;

-- ================================
--  Criar clientes para teste
-- ================================
INSERT INTO clientes (id_cliente, nome, data_nascimento, status)
VALUES (301, 'Cliente Teste OK', DATE '1985-01-01', 'ativo');

INSERT INTO clientes (id_cliente, nome, data_nascimento, status)
VALUES (302, 'Cliente Teste NOK', DATE '1990-05-15', 'ativo');

INSERT INTO clientes (id_cliente, nome, data_nascimento, status)
VALUES (303, 'Cliente Teste Histórico', DATE '1975-08-20', 'ativo');

-- ================================
--  Criar apólices para os clientes
-- ================================
INSERT INTO apolices (id_apolice, id_cliente, status, valor_segurado, franquia)
VALUES (301, 301, 'ativa', 10000, 1000); -- OK

INSERT INTO apolices (id_apolice, id_cliente, status, valor_segurado, franquia)
VALUES (302, 302, 'cancelada', 8000, 500); -- NOK

INSERT INTO apolices (id_apolice, id_cliente, status, valor_segurado, franquia)
VALUES (303, 303, 'ativa', 5000, 500); -- Histórico para cliente sem registros anteriores

-- ================================
--  Criar sinistros para teste
-- ================================
INSERT INTO sinistros (id_sinistro, id_apolice, tipo_sinistro, valor_estimado, status)
VALUES (301, 301, 'acidente', 5000, 'em análise'); -- OK

INSERT INTO sinistros (id_sinistro, id_apolice, tipo_sinistro, valor_estimado, status)
VALUES (302, 302, 'roubo', 3000, 'em análise'); -- NOK (apólice cancelada)

INSERT INTO sinistros (id_sinistro, id_apolice, tipo_sinistro, valor_estimado, status)
VALUES (303, 303, 'acidente', 2000, 'em análise'); -- Histórico ausente

-- ================================
--  Criar historicos para teste
-- ================================
-- Histórico inicial para o cliente OK
INSERT INTO historico_sinistros (id_historico, id_cliente, quantidade_sinistros)
VALUES (301, 301, 0);

-- Histórico inicial para o cliente NOK
INSERT INTO historico_sinistros (id_historico, id_cliente, quantidade_sinistros)
VALUES (302, 302, 0);

-- Cliente sem histórico (para testar raise_application_error)
-- Não insira nada para 303


COMMIT;

