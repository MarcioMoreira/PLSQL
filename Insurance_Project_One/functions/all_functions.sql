CREATE OR REPLACE FUNCTION FN_CALCULAR_FRANQUIA (
    P_VALOR_SEGURADO IN NUMBER,
    P_TIPO_SINISTRO  IN VARCHAR2 DEFAULT 'Geral'
) RETURN NUMBER IS
    V_FRANQUIA NUMBER;
BEGIN
    -- Define a franquia base dependendo do tipo de sinistro
    IF P_TIPO_SINISTRO = 'Acidente' THEN
        V_FRANQUIA := P_VALOR_SEGURADO * 0.05; -- 5% do valor segurado
    ELSIF P_TIPO_SINISTRO = 'Roubo' THEN
        V_FRANQUIA := P_VALOR_SEGURADO * 0.10; -- 10% do valor segurado
    ELSE
        V_FRANQUIA := P_VALOR_SEGURADO * 0.02; -- 2% para outros tipos
    END IF;

    -- Retorna o valor calculado da franquia
    RETURN V_FRANQUIA;
END;
/

SET SERVEROUTPUT ON;

DECLARE
    V_RESULTADO NUMBER;
BEGIN
 -- Chamando a função diretamente
    V_RESULTADO := FN_CALCULAR_FRANQUIA(100000, 'Incêndio');
    DBMS_OUTPUT.PUT_LINE('Franquia calculada: ' || V_RESULTADO);
END;
/

CREATE OR REPLACE FUNCTION FN_CALCULAR_INDENIZACAO (
    P_VALOR_ESTIMADO IN NUMBER,
    P_FRANQUIA       IN NUMBER
) RETURN NUMBER IS
    V_INDENIZACAO NUMBER;
BEGIN
    -- Calcula a indenização subtraindo a franquia
    V_INDENIZACAO := P_VALOR_ESTIMADO - P_FRANQUIA;

    -- Garante que a indenização não seja negativa
    IF V_INDENIZACAO < 0 THEN
        V_INDENIZACAO := 0;
    END IF;

    -- Retorna o valor calculado da indenização
    RETURN V_INDENIZACAO;
END;
/

SET SERVEROUTPUT ON;

DECLARE
    V_RESULTADO NUMBER;
BEGIN
 -- Chamando a função diretamente
    V_RESULTADO := FN_CALCULAR_INDENIZACAO(
        P_VALOR_ESTIMADO => 15000,
        P_FRANQUIA       => 5000
    );
    DBMS_OUTPUT.PUT_LINE('Indenização calculada: ' || V_RESULTADO);
END;
/

CREATE OR REPLACE FUNCTION FN_LIMITE_INDENIZACAO (
    P_VALOR_INDENIZACAO IN NUMBER,
    P_VALOR_SEGURADO    IN NUMBER
) RETURN NUMBER IS
    V_LIMITE NUMBER;
BEGIN
    -- Verifica se a indenização ultrapassa o valor segurado
    IF P_VALOR_INDENIZACAO > P_VALOR_SEGURADO THEN
        V_LIMITE := P_VALOR_SEGURADO; -- Limita a indenização ao valor segurado
    ELSE
        V_LIMITE := P_VALOR_INDENIZACAO; -- Mantém o valor calculado
    END IF;

    -- Retorna o valor ajustado da indenização
    RETURN V_LIMITE;
END;
/

SET SERVEROUTPUT ON;

DECLARE
    V_RESULTADO NUMBER;
BEGIN
 -- Chamando a função diretamente
    V_RESULTADO := FN_LIMITE_INDENIZACAO(80000, 100000);
    DBMS_OUTPUT.PUT_LINE('Indenização limitada: ' || V_RESULTADO);
END;
/

CREATE OR REPLACE FUNCTION FN_VERIFICAR_APOLICE_ATIVA (
    P_ID_APOLICE IN NUMBER
) RETURN VARCHAR2 IS
    V_STATUS APOLICES.STATUS%TYPE;
BEGIN
    -- Busca o status da apólice no banco
    SELECT
        STATUS
    INTO V_STATUS
    FROM
        APOLICES
    WHERE
        ID_APOLICE = P_ID_APOLICE;

    -- Verifica se a apólice está ativa
    IF V_STATUS = 'ativa' THEN
        RETURN 'APOLICE ATIVA';
    ELSE
        RETURN 'APOLICE INATIVA';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Caso o ID da apólice não exista
        RETURN 'APOLICE NAO ENCONTRADA';
    WHEN OTHERS THEN
        -- Para qualquer outro erro inesperado
        RETURN 'ERRO AO VERIFICAR APOLICE';
END;
/

SET SERVEROUTPUT ON;

DECLARE
    V_RESULTADO VARCHAR2(50);
BEGIN
 -- Chamando a função diretamente
    V_RESULTADO := FN_VERIFICAR_APOLICE_ATIVA(2);
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || V_RESULTADO);
END;
/

CREATE OR REPLACE FUNCTION FN_VERIFICAR_HISTORICO_CLIENTE (
    P_ID_CLIENTE IN NUMBER
) RETURN NUMBER IS
    V_QTD_SINISTROS HISTORICO_SINISTROS.QUANTIDADE_SINISTROS%TYPE;
BEGIN
    -- Busca a quantidade de sinistros do cliente
    SELECT
        QUANTIDADE_SINISTROS
    INTO V_QTD_SINISTROS
    FROM
        HISTORICO_SINISTROS
    WHERE
        ID_CLIENTE = P_ID_CLIENTE;

    -- Retorna a quantidade de sinistros
    RETURN V_QTD_SINISTROS;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Se não houver histórico, retorna 0
        RETURN 0;
    WHEN OTHERS THEN
        -- Para qualquer outro erro inesperado
        RAISE_APPLICATION_ERROR(-20001, 'Erro ao consultar histórico do cliente.');
END;
/

SET SERVEROUTPUT ON;
DECLARE
 v_sinistros NUMBER;
BEGIN
 v_sinistros := fn_verificar_historico_cliente(5);
 DBMS_OUTPUT.PUT_LINE('Quantidade de sinistros do cliente: ' || v_sinistros);
END;
/

CREATE OR REPLACE FUNCTION fn_sinistro_coberto(
    p_tipo_sinistro IN VARCHAR2,
    p_franquia      IN NUMBER DEFAULT 0
) RETURN VARCHAR2 IS
BEGIN
    -- Avalia se o tipo de sinistro é coberto
    IF p_tipo_sinistro IN ('Acidente', 'Roubo', 'Incêndio') THEN
        RETURN 'COBERTO';
    ELSE
        RETURN 'NAO COBERTO';
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        -- Retorna mensagem de erro em caso de exceção inesperada
        RETURN 'ERRO AO AVALIAR COBERTURA';
END;
/

SET SERVEROUTPUT ON;

DECLARE
    V_RESULTADO VARCHAR2(20);
BEGIN
    V_RESULTADO := FN_SINISTRO_COBERTO('Acidente');
    DBMS_OUTPUT.PUT_LINE('Cobertura: ' || V_RESULTADO);
    V_RESULTADO := FN_SINISTRO_COBERTO('Danos Morais');
    DBMS_OUTPUT.PUT_LINE('Cobertura: ' || V_RESULTADO);
END;
/

CREATE OR REPLACE FUNCTION FN_AJUSTAR_VALOR_SINISTRO (
    P_VALOR_ESTIMADO IN NUMBER,
    P_FRANQUIA       IN NUMBER,
    P_QTD_SINISTROS  IN NUMBER DEFAULT 0
) RETURN NUMBER IS
    V_VALOR_AJUSTADO NUMBER;
BEGIN
    -- Subtrai a franquia do valor estimado
    V_VALOR_AJUSTADO := P_VALOR_ESTIMADO - P_FRANQUIA;

    -- Aplica desconto de 10% se o cliente tiver mais de 3 sinistros
    IF P_QTD_SINISTROS > 3 THEN
        V_VALOR_AJUSTADO := V_VALOR_AJUSTADO * 0.9;
    END IF;

    -- Garante que o valor não seja negativo
    IF V_VALOR_AJUSTADO < 0 THEN
        V_VALOR_AJUSTADO := 0;
    END IF;

    -- Retorna o valor ajustado
    RETURN V_VALOR_AJUSTADO;
EXCEPTION
    WHEN OTHERS THEN
        -- Retorna -1 em caso de erro inesperado
        RETURN -1;
END;
/

SET SERVEROUTPUT ON;

DECLARE
    V_RESULTADO NUMBER;
BEGIN
 -- Chamando a função diretamente
    V_RESULTADO := FN_AJUSTAR_VALOR_SINISTRO(10000, 12000, 1);
    DBMS_OUTPUT.PUT_LINE('Valor ajustado do sinistro: ' || V_RESULTADO);
END;
/