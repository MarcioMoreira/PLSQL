-- ===========================
-- PACKAGE BODY
-- ===========================
CREATE OR REPLACE PACKAGE BODY pkg_seguradora AS

    -- ---------------------------------------------
    -- ---------------------------------------------
    -- Functions
    -- ---------------------------------------------
    -- ---------------------------------------------
    -- fn_calcular_franquia
    FUNCTION fn_calcular_franquia(
        p_valor_segurado IN NUMBER,
        p_tipo_sinistro  IN VARCHAR2 DEFAULT 'geral'
    ) RETURN NUMBER IS
        v_franquia NUMBER;
    BEGIN
        -- Define a franquia base dependendo do tipo de sinistro
        IF p_tipo_sinistro = 'Acidente' THEN
            v_franquia := p_valor_segurado * 0.05; -- 5% do valor segurado
        ELSIF p_tipo_sinistro = 'Roubo' THEN
            v_franquia := p_valor_segurado * 0.10; -- 10% do valor segurado
        ELSE
            v_franquia := p_valor_segurado * 0.02; -- 2% para outros tipos
        END IF;
        -- Retorna o valor calculado da franquia
        RETURN v_franquia;
    END fn_calcular_franquia;
    -- ---------------------------------------------
    -- fn_calcular_indenizacao 
    FUNCTION fn_calcular_indenizacao(
        p_valor_estimado IN NUMBER,
        p_franquia       IN NUMBER
    ) RETURN NUMBER IS
        v_indenizacao NUMBER;
    BEGIN
        -- Calcula a indenização subtraindo a franquia
        v_indenizacao := p_valor_estimado - p_franquia;
        -- Garante que a indenização não seja negativa
        IF v_indenizacao < 0 THEN
            v_indenizacao := 0;
        END IF;
        -- Retorna o valor calculado da indenização
        RETURN v_indenizacao;
    END fn_calcular_indenizacao;
    -- ---------------------------------------------
    -- fn_limite_indenizacao
    FUNCTION fn_limite_indenizacao(
        p_valor_indenizacao IN NUMBER,
        p_valor_segurado    IN NUMBER
    ) RETURN NUMBER IS
        v_limite NUMBER;
    BEGIN
        -- Verifica se a indenização ultrapassa o valor segurado
        IF p_valor_indenizacao > p_valor_segurado THEN
            v_limite := p_valor_segurado; -- Limita a indenização ao valor segurado
        ELSE
            v_limite := p_valor_indenizacao; -- Mantém o valor calculado
        END IF;
        -- Retorna o valor ajustado da indenização
        RETURN v_limite;
    END fn_limite_indenizacao;
    -- ---------------------------------------------
    -- fn_verificar_apolice_ativa
    FUNCTION fn_verificar_apolice_ativa(
        p_id_apolice IN NUMBER
    ) RETURN VARCHAR2 IS
        v_status APOLICES.status%TYPE;
    BEGIN
        -- Busca o status da apólice no banco
        SELECT status
        INTO v_status
        FROM APOLICES
        WHERE id_apolice = p_id_apolice;
        -- Verifica se a apólice está ativa
        IF v_status = 'ativa' THEN
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
    END fn_verificar_apolice_ativa;
    -- ---------------------------------------------
    -- fn_verificar_historico_cliente
    FUNCTION fn_verificar_historico_cliente(
        p_id_cliente IN NUMBER
    ) RETURN NUMBER IS
        v_qtd_sinistros HISTORICO_SINISTROS.quantidade_sinistros%TYPE;
    BEGIN
        -- Busca a quantidade de sinistros do cliente
        SELECT quantidade_sinistros
        INTO v_qtd_sinistros
        FROM HISTORICO_SINISTROS
        WHERE id_cliente = p_id_cliente;
        -- Retorna a quantidade de sinistros
        RETURN v_qtd_sinistros;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Se não houver histórico, retorna 0
            RETURN 0;
        WHEN OTHERS THEN
            -- Para qualquer outro erro inesperado
            RAISE_APPLICATION_ERROR(-20001, 'Erro ao consultar histórico do cliente.');
    END fn_verificar_historico_cliente;
    -- ---------------------------------------------
    -- fn_sinistro_coberto
    FUNCTION fn_sinistro_coberto(
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
    END fn_sinistro_coberto;
    -- ---------------------------------------------
    -- fn_ajustar_valor_sinistro
    FUNCTION fn_ajustar_valor_sinistro(
        p_valor_estimado IN NUMBER,
        p_franquia       IN NUMBER,
        p_qtd_sinistros  IN NUMBER DEFAULT 0
    ) RETURN NUMBER IS
        v_valor_ajustado NUMBER;
    BEGIN
        -- Subtrai a franquia do valor estimado
        v_valor_ajustado := p_valor_estimado - p_franquia;
        -- Aplica desconto de 10% se o cliente tiver mais de 3 sinistros
        IF p_qtd_sinistros > 3 THEN
            v_valor_ajustado := v_valor_ajustado * 0.9;
        END IF;
        -- Garante que o valor não seja negativo
        IF v_valor_ajustado < 0 THEN
            v_valor_ajustado := 0;
        END IF;
        -- Retorna o valor ajustado
        RETURN v_valor_ajustado;
    EXCEPTION
        WHEN OTHERS THEN
            -- Retorna -1 em caso de erro inesperado
            RETURN -1;
    END fn_ajustar_valor_sinistro;
    -- ---------------------------------------------

    -- ---------------------------------------------
    -- ---------------------------------------------
    -- Procedures
    -- ---------------------------------------------
    -- ---------------------------------------------
    -- pr_gerar_mensagem_erro
    PROCEDURE pr_gerar_mensagem_erro(
        p_codigo_erro   IN NUMBER,
        p_mensagem_erro IN VARCHAR2 DEFAULT 'Erro desconhecido'
    ) IS
    BEGIN
        RAISE_APPLICATION_ERROR(p_codigo_erro, p_mensagem_erro);
    END pr_gerar_mensagem_erro;
    -- ---------------------------------------------
    -- pr_validar_apolice
    PROCEDURE pr_validar_apolice(
        p_id_apolice IN NUMBER
    ) IS
        v_status VARCHAR2(50);
    BEGIN
        -- Chama a função que verifica o status da apólice
        v_status := fn_verificar_apolice_ativa(p_id_apolice);

        -- Validação da regra de negócio
        IF v_status <> 'APOLICE ATIVA' THEN
            pr_gerar_mensagem_erro(-20001, 'Apólice inválida ou inativa');
        END IF;
    END pr_validar_apolice;
    -- ---------------------------------------------
    -- pr_validar_sinistro
    PROCEDURE pr_validar_sinistro(
        p_tipo_sinistro IN VARCHAR2
    ) IS
        v_resultado VARCHAR2(20);
    BEGIN
        -- Verifica se o sinistro é coberto
        v_resultado := fn_sinistro_coberto(p_tipo_sinistro);
        -- Aplica regra de negócio
        IF v_resultado <> 'COBERTO' THEN
            pr_gerar_mensagem_erro(-20002, 'Tipo de sinistro não coberto');
        END IF;
    END pr_validar_sinistro;
    -- ---------------------------------------------
    -- pr_obter_dados_apolice
    PROCEDURE pr_obter_dados_apolice(
        p_id_apolice     IN  NUMBER,
        p_valor_segurado OUT NUMBER,
        p_franquia       OUT NUMBER
    ) IS
    BEGIN
        SELECT valor_segurado, franquia
        INTO p_valor_segurado, p_franquia
        FROM apolices
        WHERE id_apolice = p_id_apolice;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            pr_gerar_mensagem_erro(-20003, 'Apólice não encontrada');
    END pr_obter_dados_apolice;
    -- ---------------------------------------------
    -- pr_obter_historico_cliente
    PROCEDURE pr_obter_historico_cliente(
        p_id_cliente           IN  NUMBER,
        p_quantidade_sinistros OUT NUMBER
    ) IS
    BEGIN
        SELECT quantidade_sinistros
        INTO p_quantidade_sinistros
        FROM historico_sinistros
        WHERE id_historico = p_id_cliente;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            pr_gerar_mensagem_erro(-20004, 'Histórico do cliente não encontrado');
    END pr_obter_historico_cliente;
    -- ---------------------------------------------
    -- pr_calcular_valor_final
    PROCEDURE pr_calcular_valor_final(
        p_id_sinistro  IN  NUMBER,
        p_valor_final  OUT NUMBER
    ) IS
        v_id_apolice        NUMBER;
        v_valor_estimado    NUMBER;
        v_valor_segurado    NUMBER;
        v_franquia          NUMBER;
        v_qtd_sinistros     NUMBER;
        v_id_cliente        NUMBER;
    BEGIN
        -- Obtém dados do sinistro
        BEGIN
            SELECT id_apolice, valor_estimado
            INTO v_id_apolice, v_valor_estimado
            FROM sinistros
            WHERE id_sinistro = p_id_sinistro;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                pr_gerar_mensagem_erro(-20005, 'Sinistro não encontrado');
        END;
        -- Valida apólice
        pr_validar_apolice(v_id_apolice);
        -- Obtém dados da apólice
        pr_obter_dados_apolice(v_id_apolice, v_valor_segurado, v_franquia);
        -- Obtém id do cliente da apólice
        SELECT id_cliente
        INTO v_id_cliente
        FROM apolices
        WHERE id_apolice = v_id_apolice;
        -- Obtém histórico do cliente
        pr_obter_historico_cliente(v_id_cliente, v_qtd_sinistros);
        -- Calcula valor final
        p_valor_final := fn_calcular_indenizacao(v_valor_estimado, v_franquia);
    END pr_calcular_valor_final;
    -- ---------------------------------------------
    -- pr_atualizar_status_sinistro
    PROCEDURE pr_atualizar_status_sinistro(
        p_id_sinistro IN NUMBER,
        p_novo_status IN VARCHAR2
    ) IS
    BEGIN
        -- Atualiza o status do sinistro
        UPDATE sinistros
        SET status = p_novo_status
        WHERE id_sinistro = p_id_sinistro;
        -- Se nenhum registro foi atualizado, significa que o sinistro não existe
        IF SQL%ROWCOUNT = 0 THEN
            pr_gerar_mensagem_erro(-20006, 'Sinistro não encontrado para atualização');
        END IF;
    END pr_atualizar_status_sinistro;
    -- ---------------------------------------------
    -- pr_registrar_pagamento
    PROCEDURE pr_registrar_pagamento(
        p_id_sinistro     IN NUMBER,
        p_valor_pago      IN NUMBER,
        p_data_pagamento  IN DATE DEFAULT SYSDATE
    ) IS
        v_id_sinistro_tmp NUMBER;
        v_novo_id         NUMBER;
    BEGIN
        -- Verifica se o sinistro existe
        BEGIN
            SELECT id_sinistro
            INTO v_id_sinistro_tmp
            FROM sinistros
            WHERE id_sinistro = p_id_sinistro;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                pr_gerar_mensagem_erro(-20005, 'Sinistro não encontrado');
        END;
        -- Gera o próximo id_pagamento manualmente
        SELECT NVL(MAX(id_pagamento), 0) + 1
        INTO v_novo_id
        FROM pagamentos;
        -- Insere o pagamento
        INSERT INTO pagamentos(id_pagamento, id_sinistro, valor_pago, data_pagamento)
        VALUES (v_novo_id, p_id_sinistro, p_valor_pago, p_data_pagamento);
        -- Atualiza o status do sinistro para 'pago'
        pr_atualizar_status_sinistro(p_id_sinistro, 'pago');
    END pr_registrar_pagamento;
    -- ---------------------------------------------
    -- pr_atualizar_historico_cliente
    PROCEDURE pr_atualizar_historico_cliente(
        p_id_cliente IN NUMBER
    ) IS
        v_qtde NUMBER;
    BEGIN
        -- Verifica se já existe registro no histórico
        BEGIN
            SELECT quantidade_sinistros
            INTO v_qtde
            FROM historico_sinistros
            WHERE id_cliente = p_id_cliente;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- Se não houver registro, insere novo
                INSERT INTO historico_sinistros(id_cliente, quantidade_sinistros)
                VALUES (p_id_cliente, 1);
                DBMS_OUTPUT.PUT_LINE('Histórico criado para o cliente.');
                RETURN;
        END;
        -- Se já existir registro, incrementa a quantidade
        UPDATE historico_sinistros
        SET quantidade_sinistros = quantidade_sinistros + 1
        WHERE id_cliente = p_id_cliente;
        DBMS_OUTPUT.PUT_LINE('Histórico atualizado com sucesso.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
    END pr_atualizar_historico_cliente;
    -- ---------------------------------------------
    -- pr_analisar_sinistro
    PROCEDURE pr_analisar_sinistro(
        p_id_sinistro IN NUMBER,
        p_valor_final OUT NUMBER,
        p_status OUT VARCHAR2
    ) IS
        v_id_apolice NUMBER;
        v_id_cliente NUMBER;
        v_valor_segurado NUMBER;
        v_franquia NUMBER;
        v_qtde_sinistros NUMBER;
    BEGIN
        -- Obtém id_apolice do sinistro
        SELECT id_apolice
        INTO v_id_apolice
        FROM sinistros
        WHERE id_sinistro = p_id_sinistro;
        -- Obtém id_cliente da apólice
        SELECT id_cliente
        INTO v_id_cliente
        FROM apolices
        WHERE id_apolice = v_id_apolice;
        -- Valida apólice
        pr_validar_apolice(v_id_apolice);
        -- Obtém dados da apólice (valor_segurado e franquia)
        pr_obter_dados_apolice(v_id_apolice, v_valor_segurado, v_franquia);
        -- Obtém histórico do cliente
        pr_obter_historico_cliente(v_id_cliente, v_qtde_sinistros);
        -- Calcula valor final do sinistro
        pr_calcular_valor_final(p_id_sinistro, p_valor_final);
        -- Define status do sinistro
        IF p_valor_final > 0 THEN
            p_status := 'aprovado';
        ELSE
            p_status := 'recusado';
        END IF;
        -- Atualiza status do sinistro
        pr_atualizar_status_sinistro(p_id_sinistro, p_status);
        -- Se aprovado, registra pagamento (ajustado para 3 parâmetros)
        IF p_status = 'aprovado' THEN
            pr_registrar_pagamento(
                p_id_sinistro   => p_id_sinistro,
                p_valor_pago    => p_valor_final,
                p_data_pagamento => SYSDATE
            );
        END IF;
        -- Atualiza histórico do cliente
        pr_atualizar_historico_cliente(v_id_cliente);
    EXCEPTION
        WHEN OTHERS THEN
            pr_gerar_mensagem_erro(-20010, 'Erro ao analisar sinistro: ' || SQLERRM);
    END pr_analisar_sinistro;
    -- ---------------------------------------------

END pkg_seguradora;
/
