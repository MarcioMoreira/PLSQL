-- ================================
--  Teste 1: Cliente OK 
-- ================================
DECLARE
    v_valor NUMBER;
    v_status VARCHAR2(20);
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Teste 1: Cliente OK ---');
    pr_analisar_sinistro(301, v_valor, v_status);
    DBMS_OUTPUT.PUT_LINE('Status: ' || v_status || ', Valor Final: ' || v_valor);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro geral: ' || SQLERRM);
END;
/

-- ================================
--  Teste 2: Cliente NOK 
-- ================================
DECLARE
    v_valor NUMBER;
    v_status VARCHAR2(20);
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Teste 2: Cliente NOK ---');
    pr_analisar_sinistro(302, v_valor, v_status);
    DBMS_OUTPUT.PUT_LINE('Status: ' || v_status || ', Valor Final: ' || v_valor);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro geral: ' || SQLERRM);
END;
/

-- ================================
--  Teste 3: Cliente sem histórico 
-- ================================
DECLARE
    v_valor NUMBER;
    v_status VARCHAR2(20);
BEGIN
    BEGIN
        pr_analisar_sinistro(303, v_valor, v_status);
        DBMS_OUTPUT.PUT_LINE('Status: ' || v_status || ', Valor Final: ' || v_valor);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro no Cliente 303: ' || SQLERRM);
    END;
END;
/

