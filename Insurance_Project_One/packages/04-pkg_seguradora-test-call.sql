SET SERVEROUTPUT ON;

DECLARE
    V_VALOR  NUMBER;
    V_STATUS VARCHAR2(20);
BEGIN
    PKG_SEGURADORA.PR_ANALISAR_SINISTRO(101, V_VALOR, V_STATUS); -- sinistro 101
    DBMS_OUTPUT.PUT_LINE('Sinistro analisado.');
    DBMS_OUTPUT.PUT_LINE('Status: '
                         || V_STATUS
                         || ', Valor Final: ' || V_VALOR);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END;
/

