-- "Dá-me os nomes dos clientes cujo ID 
-- não aparece na lista de IDs de clientes que têm apólices com sinistros."

SELECT nome 
FROM clientes 
WHERE id_cliente NOT IN (
    -- Esta subquery vai buscar todos os donos de apólices com sinistros
    SELECT a.id_cliente  -- Aqui usas o atalho
    FROM apolices a      -- Aqui defines que "apolices" passa a chamar-se "a"
    JOIN sinistros s     -- Aqui defines que "sinistros" passa a chamar-se "s"
    ON a.id_apolice = s.id_apolice
);

-- Queres saber quais as apólices que já geraram dinheiro (pagamentos), 
-- mas que ainda não deram despesa (sinistros).

SELECT id_apolice FROM pagamentos
MINUS
SELECT id_apolice FROM sinistros; -- dá vazio

-- Somar os valores por cliente, filtrar os que pagam 
-- muito e mostrar só os 2 primeiros.
SELECT id_cliente, SUM(premio_anual) as total_premios
FROM apolices
GROUP BY id_cliente
HAVING SUM(premio_anual) > 500
ORDER BY total_premios DESC
FETCH FIRST 2 ROWS ONLY;

-- O gestor quer saber quais são as apólices que 
-- têm um prémio acima da média de todas as apólices da empresa.
SELECT  id_cliente, id_apolice, premio_anual
FROM apolices
WHERE premio_anual > (
    SELECT AVG(premio_anual)
    FROM APOLICES
    )
ORDER BY premio_anual;

-- Queremos os nomes dos clientes que têm pelo menos um pagamento 
-- registado na tabela pagamentos.
SELECT nome ,id_cliente
FROM CLIENTES
WHERE ID_CLIENTE IN (
    SELECT id_cliente -- O que sai daqui tem de ser igual ao que o WHERE lá de cima pede
    FROM APOLICES
    INNER JOIN PAGAMENTOS
    ON APOLICES.ID_APOLICE = PAGAMENTOS.ID_APOLICE -- Usa o ON para ligar
);

-- Listar o id_apolice, o tipo e o premio_anual de todas as apólices cujo 
-- valor total reclamado em sinistros seja maior do que o seu próprio premio_anual.
SELECT ID_APOLICE, TIPO, PREMIO_ANUAL,
    -- Repetimos a lógica aqui para ela aparecer como uma coluna
    (SELECT SUM(valor_reclamado) 
     FROM sinistros s 
     WHERE s.ID_APOLICE = a.ID_APOLICE) AS TOTAL_SINISTROS
FROM APOLICES a
WHERE PREMIO_ANUAL < (
    SELECT SUM(valor_reclamado)
    FROM sinistros s
    WHERE s.ID_APOLICE = a.ID_APOLICE
);

-- Listar o nome e o nif da tabela clientes apenas para aqueles que 
-- aparecem mais de uma vez na tabela apolices.
SELECT c.nome, c.nif
FROM CLIENTES c
WHERE c.id_cliente IN 
    (SELECT a.id_cliente 
    FROM APOLICES a
    GROUP BY a.id_cliente -- 1º Agrupo por cliente
    HAVING COUNT(*) > 1 -- 2º Filtro quem tem mais de uma linha
    )
;

-- Listar o nome do cliente e, numa segunda coluna, mostrar a data do 
-- sinistro mais recente que esse cliente teve.
SELECT c.nome, c.id_cliente,
(
    SELECT MAX(s.data_sinistro)
    FROM sinistros s
    JOIN apolices a ON s.id_apolice = a.id_apolice
    WHERE a.id_cliente = c.id_cliente
) AS ultima_ocorrencia
FROM clientes c;


-- criar um Ranking de Sinistralidade por Cliente. Mostrar Nome do Cliente, 
-- Total Reclamado (Soma de todos os sinistros dele), Número de Sinistros (Contagem)
SELECT -- passo 1
    a.id_cliente, 
    SUM(s.valor_reclamado) as total_valor,
    COUNT(s.id_sinistro) as qtd_sinistros
FROM apolices a
JOIN sinistros s ON a.id_apolice = s.id_apolice
GROUP BY a.id_cliente;


SELECT c.nome, resumo.total_valor, resumo.qtd_sinistros
FROM clientes c
JOIN (
    -- Apenas UM Select aqui dentro (a nossa "tabela virtual")
    SELECT 
        a.id_cliente, 
        SUM(s.valor_reclamado) as total_valor,
        COUNT(s.id_sinistro) as qtd_sinistros
    FROM apolices a
    JOIN sinistros s ON a.id_apolice = s.id_apolice
    GROUP BY a.id_cliente
) resumo ON c.id_cliente = resumo.id_cliente;

-- ver o Nome do Cliente, apolices.tipo, sinistros.valor_reclamado
SELECT c.nome, a.tipo, s.valor_reclamado, a.id_apolice
FROM clientes c
JOIN apolices a ON c.id_cliente = a.id_cliente
JOIN sinistros s ON a.id_apolice = s.id_apolice;


SELECT c.nome, a.tipo, NVL(s.valor_reclamado, 0) as valor
FROM clientes c
LEFT JOIN apolices a ON c.id_cliente = a.id_cliente
LEFT JOIN sinistros s ON a.id_apolice = s.id_apolice;

-- Lista o Nome do Cliente e o Valor Pago (da tabela pagamentos).
SELECT c.nome, a.tipo, NVL(p.valor_pago, 0) as valor_pago
FROM clientes c
LEFT JOIN apolices a ON c.id_cliente = a.id_cliente
LEFT JOIN pagamentos p ON a.id_apolice = p.id_apolice;

-- ver os pagamentos de apólices que estão 'ATIVA'
SELECT  a.tipo, a.estado, SUM(NVL(p.valor_pago, 0)) as total_pago
FROM apolices a
LEFT JOIN pagamentos p ON a.id_apolice = p.id_apolice
WHERE a.estado = 'ATIVA'
GROUP BY a.tipo, a.estado;

SELECT c.nome, a.tipo, SUM(NVL(p.valor_pago,0)) as total_pago
FROM clientes c
LEFT JOIN apolices a ON c.id_cliente = a.id_cliente
LEFT JOIN pagamentos p ON a.id_apolice = p.id_apolice
WHERE a.estado = 'ATIVA'
GROUP BY c.nome, a.tipo;

SELECT c.nome, SUM(NVL(p.valor_pago,0)) as total_pago
FROM clientes c
LEFT JOIN apolices a ON c.id_cliente = a.id_cliente
LEFT JOIN pagamentos p ON a.id_apolice = p.id_apolice
WHERE a.estado = 'ATIVA'
GROUP BY c.nome;

-- Exercicios novos
-- Exercício 1: Listar todos os clientes que nasceram antes de 1990.
SELECT * 
FROM clientes c
WHERE c.data_nascimento < DATE'1990-01-01'; -- ou  TO_DATE('01/01/1990', 'DD/MM/YYYY'). 
                                            -- ou EXTRACT(YEAR FROM data_nascimento) < 1990

-- Exercício 2: Contar quantas apólices estão no estado 'ATIVA'.
SELECT * 
FROM apolices a
WHERE estado = 'ATIVA';

-- Exercício 3: Somar o número total de sinistros que já foram 'PAGO'.
SELECT COUNT(*)
FROM sinistros s
WHERE s.estado = 'PAGO';

-- Exercício 4: Somar o valor total de sinistros que já foram 'PAGO'.
SELECT SUM(valor_reclamado) AS total_pago
FROM sinistros s
WHERE s.estado = 'PAGO';

-- Exercício 5: Listar o nome do cliente e o tipo de todas as suas apólices 
-- (Dica: JOIN clientes com apolices).
SELECT DISTINCT c.id_cliente, c.nome, a.tipo
FROM clientes c
JOIN apolices a ON c.id_cliente = a.id_cliente
ORDER BY c.nome;

-- Exercício 6: Listar o id_apolice e a data_sinistro de todas as apólices do tipo 'Automóvel'.
SELECT DISTINCT a.id_apolice, s.data_sinistro, a.tipo
FROM apolices a
JOIN sinistros s ON a.id_apolice = s.id_apolice
WHERE UPPER(a.tipo) = 'AUTOMÓVEL'
ORDER BY a.id_apolice;

-- Exercício 7 (Left Join): Listar todos os nomes de clientes e os IDs das suas apólices, 
-- incluindo aqueles que não têm nenhuma apólice (Dica: LEFT JOIN).
SELECT DISTINCT c.nome, a.id_apolice
FROM clientes c
LEFT JOIN apolices a ON c.id_cliente = a.id_cliente
ORDER BY c.nome;

-- Exercício 8 (Triple Join): Listar o Nome do Cliente, o Tipo da Apólice e a Data 
-- do Sinistro para todos os sinistros 'PENDENTE'.
SELECT DISTINCT c.nome, a.tipo, s.data_sinistro, s.estado
FROM clientes c
JOIN apolices a ON c.id_cliente = a.id_cliente
JOIN sinistros s ON s.id_apolice = a.id_apolice
WHERE UPPER(s.estado) = 'PENDENTE'
ORDER BY c.nome;

-- Exercício 9 (Agregação + Join): Mostrar o nome de cada cliente e o total de valor 
-- pago em prémios (tabela pagamentos).
SELECT c.nome, a.ID_APOLICE AS apolice , SUM(p.valor_pago) AS total_acumulado
FROM clientes c
JOIN apolices a ON c.id_cliente = a.id_cliente
JOIN pagamentos p ON p.id_apolice = a.id_apolice
GROUP BY c.nome, a.id_apolice
ORDER BY total_acumulado DESC;

-- Exercício 10 (O Desafio Final): Identificar o nome do cliente que teve o sinistro 
-- de maior valor (MAX) e qual era o tipo de apólice desse sinistro.
SELECT c.nome, MAX(s.VALOR_RECLAMADO)
FROM clientes c
JOIN apolices a ON c.id_cliente = a.id_cliente
JOIN sinistros s ON s.id_apolice = a.id_apolice
ORDER BY s.valor_reclamado
GROUP BY c.nome;

