CREATE OR REPLACE TRIGGER TRG_LOG_VALOR_PAGO AFTER
    UPDATE OF VALOR_PAGO ON PAGAMENTOS
    FOR EACH ROW
    WHEN (OLD.VALOR_PAGO <> NEW.VALOR_PAGO)
BEGIN
    INSERT INTO LOGS ( ALTERACAO ) 
    VALUES ( 'Usuario ' || USER || 
             ' alterou pagamento ID ' || :OLD.ID_PAGAMENTO || 
             ' de ' || NVL(TO_CHAR(:OLD.VALOR_PAGO),'NULL') || 
             ' para ' || NVL(TO_CHAR(:NEW.VALOR_PAGO),'NULL') || 
             ' em ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS') 
            );
END;
/
