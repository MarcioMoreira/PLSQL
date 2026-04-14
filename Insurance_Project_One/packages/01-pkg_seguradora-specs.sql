-- ===========================
-- PACKAGE SPECIFICATION
-- ===========================
CREATE OR REPLACE PACKAGE pkg_seguradora AS

    -- Variáveis globais de package (persistem durante a sessão)
    -- Exemplo:
    -- g_sinistros_temp t_sinistros := t_sinistros();

    -- Apenas a procedure principal precisa estar na especificacao 
    -- se as outras forem usadas apenas internamente.

    PROCEDURE pr_analisar_sinistro(
        p_id_sinistro IN NUMBER,
        p_valor_final OUT NUMBER,
        p_status      OUT VARCHAR2
    );

END pkg_seguradora;
/