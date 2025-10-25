-- ======================
-- EMPRESAS
-- ======================
INSERT INTO empresa (nome, cnpj) VALUES
('VAction Tecnologia', '12.345.678/0001-99'),
('Banco XPTO', '98.765.432/0001-11');

-- ======================
-- NÍVEL DE ACESSO
-- ======================
INSERT INTO nivel_acesso (descricao) VALUES
('COLABORADOR'), -- 1
('GESTOR'),      -- 2
('RH');          -- 3

-- ======================
-- STATUS
-- ======================
INSERT INTO status (nome) VALUES
('PENDENTE_GESTOR'), -- 1
('PENDENTE_RH'),     -- 2
('APROVADO'),        -- 3
('REPROVADO');       -- 4

-- ======================
-- DECISÃO
-- ======================
INSERT INTO decisao (nome) VALUES
('APROVADO'), -- 1
('REPROVADO'); -- 2

-- ======================
-- USUÁRIOS - Empresa 1
-- ======================

-- RHs
INSERT INTO usuario (nome, email, area, senha, cargo, data_admissao, cpf, fk_empresa, fk_nivel) VALUES
('Carlos RH', 'carlos.rh@vaction.com', 'RH', '123456', 'RH Manager', '2024-03-15', '11111111111', 1, 3),
('Marina RH', 'marina.rh@vaction.com', 'RH', '123456', 'RH Manager', '2024-05-20', '22222222222', 1, 3);

-- Gestores
INSERT INTO usuario (nome, email, area, senha, cargo, data_admissao, cpf, fk_empresa, fk_nivel, fk_aprovador) VALUES
('Ana Gestor TI', 'ana.gestor@vaction.com', 'TI', '123456', 'Gerente TI', '2024-07-10', '33333333333', 1, 2, 1),
('Pedro Gestor Fin', 'pedro.gestor@vaction.com', 'Financeiro', '123456', 'Gerente Financeiro', '2025-01-15', '44444444444', 1, 2, 2),
('Luisa Gestor Marketing', 'luisa.gestor@vaction.com', 'Marketing', '123456', 'Gerente Marketing', '2025-03-05', '55555555555', 1, 2, 1);

-- Colaboradores
INSERT INTO usuario (nome, email, area, senha, cargo, data_admissao, cpf, fk_empresa, fk_nivel, fk_aprovador) VALUES
('Joao Colab', 'joao@vaction.com', 'TI', '123456', 'Dev', '2025-02-01', '66666666666', 1, 1, 3),
('Maria Colab', 'maria@vaction.com', 'TI', '123456', 'Dev', '2025-03-05', '77777777777', 1, 1, 3),
('Lucas Colab', 'lucas@vaction.com', 'Financeiro', '123456', 'Analista', '2025-04-10', '88888888888', 1, 1, 4),
('Sofia Colab', 'sofia@vaction.com', 'Financeiro', '123456', 'Analista', '2025-05-15', '99999999999', 1, 1, 4),
('Rafael Colab', 'rafael@vaction.com', 'Marketing', '123456', 'Analista', '2025-06-20', '10101010101', 1, 1, 5);

-- ======================
-- PEDIDOS DE FÉRIAS
-- ======================

-- Colaboradores
INSERT INTO pedido (data_inicio, data_fim, data_solicitacao, ultima_atualizacao, dias_usufruidos, fk_usuario, fk_status) VALUES
('2024-07-01','2024-07-16','2024-06-01','2024-06-05',16,1,3),
('2024-08-15','2024-08-31','2024-07-20','2024-07-22',17,2,3),
('2025-01-10','2025-01-25','2024-12-01','2024-12-05',16,3,3),
('2025-03-05','2025-03-20','2025-02-01','2025-02-04',16,4,3),
('2025-05-10','2025-05-25','2025-04-01','2025-04-05',16,5,3);

-- Gestores
INSERT INTO pedido (data_inicio, data_fim, data_solicitacao, ultima_atualizacao, dias_usufruidos, fk_usuario, fk_status) VALUES
('2024-12-01','2024-12-16','2024-11-01','2024-11-05',16,3,3),
('2025-06-01','2025-06-16','2025-05-01','2025-05-05',16,4,3);

-- ======================
-- PEDIDOS DE FÉRIAS PENDENTES
-- ======================

-- Colaboradores - pendente gestor
INSERT INTO pedido (data_inicio, data_fim, data_solicitacao, ultima_atualizacao, dias_usufruidos, fk_usuario, fk_status) VALUES
('2025-07-15','2025-07-31','2025-06-20','2025-06-22',17,1,1),
('2025-08-01','2025-08-16','2025-07-05','2025-07-06',15,2,1),
('2025-09-10','2025-09-25','2025-08-01','2025-08-05',15,3,1);

-- Gestores - pendente RH
INSERT INTO pedido (data_inicio, data_fim, data_solicitacao, ultima_atualizacao, dias_usufruidos, fk_usuario, fk_status) VALUES
('2025-10-01','2025-10-16','2025-09-01','2025-09-05',16,3,2),
('2025-11-05','2025-11-20','2025-10-01','2025-10-05',16,4,2);
-- ======================
-- HISTÓRICO
-- ======================

-- Colaboradores
INSERT INTO historico (data_alteracao, observacao, fk_pedido, fk_usuario, fk_decisao) VALUES
('2024-06-05','Aprovado pelo gestor',1,3,1),
('2024-07-22','Aprovado pelo gestor',2,4,1),
('2024-12-05','Aprovado pelo gestor',3,5,1),
('2025-02-04','Reprovado pelo RH',4,6,2),
('2025-04-05','Aprovado pelo gestor',5,7,1),

-- Gestores
('2024-11-05','Aprovado pelo RH',6,3,1),
('2025-05-05','Aprovado pelo RH',7,4,1);

