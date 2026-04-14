SET SERVEROUTPUT ON;

DECLARE
    v_count NUMBER;
BEGIN
    -- ================================
    --  Remover pagamentos gerados
    -- ================================
    SELECT COUNT(*) INTO v_count FROM pagamentos WHERE id_sinistro IN (301, 302, 303);
    DELETE FROM pagamentos WHERE id_sinistro IN (301, 302, 303);
    DBMS_OUTPUT.PUT_LINE('Pagamentos removidos: ' || v_count);

    -- ================================
    --  Remover sinistros
    -- ================================
    SELECT COUNT(*) INTO v_count FROM sinistros WHERE id_sinistro IN (301, 302, 303);
    DELETE FROM sinistros WHERE id_sinistro IN (301, 302, 303);
    DBMS_OUTPUT.PUT_LINE('Sinistros removidos: ' || v_count);

    -- ================================
    --  Remover histórico de sinistros
    -- ================================
    SELECT COUNT(*) INTO v_count FROM historico_sinistros WHERE id_cliente IN (301, 302, 303);
    DELETE FROM historico_sinistros WHERE id_cliente IN (301, 302, 303);
    DBMS_OUTPUT.PUT_LINE('Registros de histórico removidos: ' || v_count);

    -- ================================
    --  Remover apólices
    -- ================================
    SELECT COUNT(*) INTO v_count FROM apolices WHERE id_apolice IN (301, 302, 303);
    DELETE FROM apolices WHERE id_apolice IN (301, 302, 303);
    DBMS_OUTPUT.PUT_LINE('Apólices removidas: ' || v_count);

    -- ================================
    --  Remover clientes
    -- ================================
    SELECT COUNT(*) INTO v_count FROM clientes WHERE id_cliente IN (301, 302, 303);
    DELETE FROM clientes WHERE id_cliente IN (301, 302, 303);
    DBMS_OUTPUT.PUT_LINE('Clientes removidos: ' || v_count);


    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Banco revertido para o estado anterior aos testes.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro durante a reversão: ' || SQLERRM);
END;
/
