
-- ===========================
-- INSERTS CLIENTES
-- ===========================
INSERT INTO clientes VALUES (1, 'João Silva', '123456789', DATE '1985-03-12', SYSDATE);
INSERT INTO clientes VALUES (2, 'Ana Martins', '987654321', DATE '1990-07-22', SYSDATE);
INSERT INTO clientes VALUES (3, 'Carlos Ferreira', '456123789', DATE '1978-11-02', SYSDATE);
INSERT INTO clientes VALUES (4, 'Marta Costa', '321654987', DATE '1982-05-18', SYSDATE);
INSERT INTO clientes VALUES (5, 'Ricardo Almeida', '741852963', DATE '1995-09-30', SYSDATE);
INSERT INTO clientes VALUES (6, 'Zacarias Anacleto', '111222333', DATE '2000-01-01', SYSDATE);


-- ===========================
-- INSERTS APOLICES
-- ===========================
INSERT INTO apolices VALUES (101, 1, 'Automóvel', 450.00, 'ATIVA', DATE '2024-01-01', DATE '2024-12-31');
INSERT INTO apolices VALUES (102, 1, 'Habitação', 320.00, 'ATIVA', DATE '2023-06-01', DATE '2024-06-01');
INSERT INTO apolices VALUES (103, 2, 'Vida', 600.00, 'CANCELADA', DATE '2022-01-01', DATE '2023-01-01');
INSERT INTO apolices VALUES (104, 3, 'Automóvel', 500.00, 'ATIVA', DATE '2024-03-01', DATE '2025-03-01');
INSERT INTO apolices VALUES (105, 4, 'Saúde', 800.00, 'ATIVA', DATE '2024-02-15', DATE '2025-02-15');
INSERT INTO apolices VALUES (106, 5, 'Habitação', 350.00, 'EXPIRADA', DATE '2022-05-01', DATE '2023-05-01');


-- ===========================
-- INSERTS SINISTROS
-- ===========================
INSERT INTO sinistros VALUES (1001, 101, DATE '2024-04-10', 1200.00, 'PENDENTE');
INSERT INTO sinistros VALUES (1002, 101, DATE '2024-06-15', 800.00, 'PAGO');
INSERT INTO sinistros VALUES (1003, 104, DATE '2024-05-20', 1500.00, 'PENDENTE');
INSERT INTO sinistros VALUES (1004, 105, DATE '2024-03-01', 500.00, 'PAGO');
INSERT INTO sinistros VALUES (1005, 102, DATE '2024-07-12', 300.00, 'PAGO');


-- ===========================
-- INSERTS PAGAMENTOS
-- ===========================
INSERT INTO pagamentos VALUES (5001, 101, 450.00, DATE '2024-01-05');
INSERT INTO pagamentos VALUES (5002, 102, 320.00, DATE '2023-06-05');
INSERT INTO pagamentos VALUES (5003, 104, 500.00, DATE '2024-03-05');
INSERT INTO pagamentos VALUES (5004, 105, 800.00, DATE '2024-02-20');
INSERT INTO pagamentos VALUES (5005, 101, 200.00, DATE '2024-07-01'); -- pagamento parcial extra