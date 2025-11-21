USE Vaction;
DROP PROCEDURE IF EXISTS sp_analise_ferias_por_mes_empresa;
DELIMITER $$

CREATE PROCEDURE sp_analise_ferias_por_mes_empresa(IN p_id_empresa INT)
BEGIN
    SELECT 
        e.nome AS empresa,
        SUM(MONTH(p.data_inicio) = 1) AS jan,
        SUM(MONTH(p.data_inicio) = 2) AS fev,
        SUM(MONTH(p.data_inicio) = 3) AS mar,
        SUM(MONTH(p.data_inicio) = 4) AS abr,
        SUM(MONTH(p.data_inicio) = 5) AS mai,
        SUM(MONTH(p.data_inicio) = 6) AS jun,
        SUM(MONTH(p.data_inicio) = 7) AS jul,
        SUM(MONTH(p.data_inicio) = 8) AS ago,
        SUM(MONTH(p.data_inicio) = 9) AS sept,
        SUM(MONTH(p.data_inicio) = 10) AS oct,
        SUM(MONTH(p.data_inicio) = 11) AS nov,
        SUM(MONTH(p.data_inicio) = 12) AS dez
    FROM usuario u
    JOIN empresa e ON u.fk_empresa = e.id_empresa
    JOIN pedido p ON p.fk_usuario = u.id_usuario
    JOIN status s ON s.id_status = p.fk_status
    WHERE s.nome = 'APROVADO'
      AND e.id_empresa = p_id_empresa
    GROUP BY e.nome;
END $$

DELIMITER ;

call sp_analise_ferias_por_mes_empresa(1);

-- Quantidade de férias por mes do gestor/equipe
DROP PROCEDURE IF EXISTS sp_analise_ferias_por_mes_gestor;
DELIMITER $$

CREATE PROCEDURE sp_analise_ferias_por_mes_gestor(IN gestorId INT)
BEGIN
    SELECT 
        g.nome AS gestor,
        SUM(MONTH(p.data_inicio) = 1) AS jan,
        SUM(MONTH(p.data_inicio) = 2) AS fev,
        SUM(MONTH(p.data_inicio) = 3) AS mar,
        SUM(MONTH(p.data_inicio) = 4) AS abr,
        SUM(MONTH(p.data_inicio) = 5) AS mai,
        SUM(MONTH(p.data_inicio) = 6) AS jun,
        SUM(MONTH(p.data_inicio) = 7) AS jul,
        SUM(MONTH(p.data_inicio) = 8) AS ago,
        SUM(MONTH(p.data_inicio) = 9) AS sept,
        SUM(MONTH(p.data_inicio) = 10) AS oct,
        SUM(MONTH(p.data_inicio) = 11) AS nov,
        SUM(MONTH(p.data_inicio) = 12) AS dez
    FROM usuario u
    JOIN usuario g ON u.fk_aprovador = g.id_usuario
    JOIN pedido p ON p.fk_usuario = u.id_usuario
    JOIN status s ON s.id_status = p.fk_status
    WHERE s.nome = 'APROVADO'
      AND g.id_usuario = gestorId
    GROUP BY g.nome;
END $$

DELIMITER ;

call sp_analise_ferias_por_mes_gestor(1);

DROP PROCEDURE IF EXISTS sp_saldo_ferias_usuario;
-- Procedure saldo de ferias
DELIMITER $$

CREATE PROCEDURE sp_saldo_ferias_usuario (IN p_id_usuario INT)
BEGIN
    SELECT 
        u.id_usuario,
        u.nome AS nome_usuario,
        u.data_admissao,
        TIMESTAMPDIFF(MONTH, u.data_admissao, CURDATE()) AS meses_trabalhados,
        (TIMESTAMPDIFF(MONTH, u.data_admissao, CURDATE()) / 12.0) * 30 AS dias_direito,
        COALESCE(SUM(CASE WHEN s.nome = 'APROVADO' THEN p.dias_usufruidos ELSE 0 END), 0) AS dias_usufruidos,
        GREATEST(
            ((TIMESTAMPDIFF(MONTH, u.data_admissao, CURDATE()) / 12.0) * 30) -
            COALESCE(SUM(CASE WHEN s.nome = 'APROVADO' THEN p.dias_usufruidos ELSE 0 END), 0),
            0
        ) AS saldo_ferias
    FROM usuario u
    LEFT JOIN pedido p ON p.fk_usuario = u.id_usuario
    LEFT JOIN status s ON s.id_status = p.fk_status
    WHERE u.id_usuario = p_id_usuario
    GROUP BY u.id_usuario, u.nome, u.data_admissao;
END $$

DELIMITER ;

CALL sp_saldo_ferias_usuario(10);

-- Saldo de férias Gestor
CREATE OR REPLACE VIEW vw_saldo_ferias_por_gestor AS
SELECT 
    g.id_usuario AS id_gestor,
    g.nome AS nome_gestor,
    u.id_usuario AS id_funcionario,
    u.nome AS nome_funcionario,
    GREATEST(
        ((TIMESTAMPDIFF(MONTH, u.data_admissao, CURDATE()) / 12.0) * 30) -
        COALESCE(SUM(CASE WHEN s.nome = 'APROVADO' THEN p.dias_usufruidos ELSE 0 END), 0),
        0
    ) AS saldo_ferias
FROM usuario u
JOIN usuario g ON u.fk_aprovador = g.id_usuario
LEFT JOIN pedido p ON p.fk_usuario = u.id_usuario
LEFT JOIN status s ON s.id_status = p.fk_status
GROUP BY g.id_usuario, g.nome, u.id_usuario, u.nome, u.data_admissao; 

SELECT * FROM vw_saldo_ferias_por_gestor;

-- Calcular proximos dias de ferias
DROP PROCEDURE IF EXISTS sp_tempo_proximas_ferias;
DELIMITER $$

CREATE PROCEDURE sp_tempo_proximas_ferias (IN p_id_usuario INT)
BEGIN
    SELECT 
        u.id_usuario,
        u.nome AS nome_usuario,
        u.data_admissao,
        TIMESTAMPDIFF(MONTH, u.data_admissao, CURDATE()) AS meses_trabalhados,
        (TIMESTAMPDIFF(MONTH, u.data_admissao, CURDATE()) / 12.0) * 30 AS dias_direito,
        COALESCE(SUM(CASE WHEN s.nome = 'APROVADO' THEN p.dias_usufruidos ELSE 0 END), 0) AS dias_usufruidos,
        GREATEST(
            ((TIMESTAMPDIFF(MONTH, u.data_admissao, CURDATE()) / 12.0) * 30) -
            COALESCE(SUM(CASE WHEN s.nome = 'APROVADO' THEN p.dias_usufruidos ELSE 0 END), 0),
            0
        ) AS saldo_ferias,

        CASE 
            WHEN GREATEST(
                    ((TIMESTAMPDIFF(MONTH, u.data_admissao, CURDATE()) / 12.0) * 30) -
                    COALESCE(SUM(CASE WHEN s.nome = 'APROVADO' THEN p.dias_usufruidos ELSE 0 END), 0),
                    0
                ) >= 15 THEN 0
            ELSE CEIL(
                (15 - GREATEST(
                    ((TIMESTAMPDIFF(MONTH, u.data_admissao, CURDATE()) / 12.0) * 30) -
                    COALESCE(SUM(CASE WHEN s.nome = 'APROVADO' THEN p.dias_usufruidos ELSE 0 END), 0),
                    0
                )) * (12.0/30) * 30
            )
        END AS dias_trabalho_para_atingir_15
    FROM usuario u
    LEFT JOIN pedido p ON p.fk_usuario = u.id_usuario
    LEFT JOIN status s ON s.id_status = p.fk_status
    WHERE u.id_usuario = p_id_usuario
    GROUP BY u.id_usuario, u.nome, u.data_admissao;
END $$

DELIMITER ;

call sp_tempo_proximas_ferias(10);

-- Pedidos de ferias pendentes de aprovacao do gestor

DROP PROCEDURE IF EXISTS sp_chamados_pendentes_gestor_rh;
DELIMITER $$

CREATE PROCEDURE sp_chamados_pendentes_gestor_rh(IN p_id_usuario INT)
BEGIN
    -- Declarando a variável no topo do BEGIN
    DECLARE v_nivel INT;

    -- Pegando o nível de acesso do usuário passado
    SELECT fk_nivel INTO v_nivel
    FROM usuario
    WHERE id_usuario = p_id_usuario;

    -- Consulta dos pedidos pendentes
    SELECT 
        u.id_usuario AS id_funcionario,
        u.nome AS nome_funcionario,
        p.id_pedido,
        p.data_inicio,
        p.data_fim,
        p.data_solicitacao,
        s.nome AS status_pedido
    FROM usuario u
    JOIN pedido p ON p.fk_usuario = u.id_usuario
    JOIN status s ON s.id_status = p.fk_status
    WHERE u.fk_aprovador = p_id_usuario
      AND (
            (v_nivel = 2 AND s.nome = 'PENDENTE_GESTOR') 
         OR (v_nivel = 3 AND s.nome = 'PENDENTE_RH')
      )
    ORDER BY p.data_solicitacao;

END $$

DELIMITER ;

call sp_chamados_pendentes_gestor_rh(1);


-- Disponibilidade da equipe por gestor
DROP PROCEDURE IF EXISTS sp_disponibilidade_equipe_por_gestor;
DELIMITER $$

CREATE PROCEDURE sp_disponibilidade_equipe_por_gestor(IN gestorId INT)
BEGIN
    SELECT 
        g.nome AS gestor,
        COUNT(DISTINCT u.id_usuario) AS total_colaboradores,

        -- Colaboradores atualmente de férias
        COUNT(DISTINCT CASE 
            WHEN s.nome = 'APROVADO'
             AND CURDATE() BETWEEN p.data_inicio AND p.data_fim
            THEN u.id_usuario
        END) AS em_ferias,

        -- Colaboradores disponíveis (não estão de férias)
        COUNT(DISTINCT CASE 
            WHEN u.id_usuario NOT IN (
                SELECT p2.fk_usuario
                FROM pedido p2
                JOIN status s2 ON s2.id_status = p2.fk_status
                WHERE s2.nome = 'APROVADO'
                AND CURDATE() BETWEEN p2.data_inicio AND p2.data_fim
            )
            THEN u.id_usuario
        END) AS disponiveis

    FROM usuario u
    JOIN usuario g ON u.fk_aprovador = g.id_usuario
    LEFT JOIN pedido p ON p.fk_usuario = u.id_usuario
    LEFT JOIN status s ON s.id_status = p.fk_status
    WHERE g.id_usuario = gestorId
    GROUP BY g.nome;
END $$

DELIMITER ;

-- Exemplo de execução:
CALL sp_disponibilidade_equipe_por_gestor(1);

DROP PROCEDURE IF EXISTS sp_sla_medio_por_empresa;
DELIMITER $$

CREATE PROCEDURE sp_sla_medio_por_empresa(
    IN p_id_empresa INT
)
BEGIN
    SELECT 
        AVG(DATEDIFF(h.data_alteracao, p.data_solicitacao)) AS sla_medio_dias
    FROM pedido p
    JOIN usuario u ON u.id_usuario = p.fk_usuario
    JOIN historico h ON h.fk_pedido = p.id_pedido
    JOIN decisao d ON h.fk_decisao = d.id_decisao
    WHERE d.nome = 'APROVADO'
      AND u.fk_empresa = p_id_empresa;
END $$

DELIMITER ;

call sp_sla_medio_por_empresa(1);

CREATE PROCEDURE grafico_ferias_por_mes()
BEGIN
    SELECT 
        CASE 
            WHEN mes = 1 THEN 'Janeiro'
            WHEN mes = 2 THEN 'Fevereiro'
            WHEN mes = 3 THEN 'Março'
            WHEN mes = 4 THEN 'Abril'
            WHEN mes = 5 THEN 'Maio'
            WHEN mes = 6 THEN 'Junho'
            WHEN mes = 7 THEN 'Julho'
            WHEN mes = 8 THEN 'Agosto'
            WHEN mes = 9 THEN 'Setembro'
            WHEN mes = 10 THEN 'Outubro'
            WHEN mes = 11 THEN 'Novembro'
            WHEN mes = 12 THEN 'Dezembro'
        END AS nome_mes,
        COUNT(*) AS total
    FROM ferias
    WHERE mes IS NOT NULL
    GROUP BY mes
    ORDER BY mes
END $$

DELIMITER ;