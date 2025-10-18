-- ======================
-- POPULANDO AS TABELAS
-- ======================
-- EMPRESA
INSERT INTO empresa (id_empresa, nome, cnpj) VALUES
(1, 'VAction Tecnologia', '12.345.678/0001-99'),
(2, 'Banco XPTO', '98.765.432/0001-11');

-- NIVEL DE ACESSO
INSERT INTO nivel_acesso (id_nivel, descricao) VALUES
(1, 'COLABORADOR'),
(2, 'GESTOR'),
(3, 'RH');

-- STATUS (4 registros)
INSERT INTO status (id_status, nome) VALUES
(1, 'PENDENTE_GESTOR'),
(2, 'PENDENTE_RH'),
(3, 'APROVADO'),
(4, 'REPROVADO');

-- DECISAO (2 registros)
INSERT INTO decisao (id_decisao, nome) VALUES
(1, 'APROVADO'),
(2, 'REPROVADO');

-- USUARIOS
INSERT INTO usuario (id_usuario, nome, email, area, senha, cargo, data_admissao, cpf, fk_empresa, fk_nivel) VALUES
(1, 'Gabriel Duarte', 'gabriel@vaction.com', 'TI', '123456', 'Desenvolvedor', '2022-05-10', '12345678900', 1, 1),
(2, 'Ana Souza', 'ana@vaction.com', 'TI', '123456', 'Gerente de TI', '2020-03-15', '32165498700', 1, 2),
(3, 'Carlos Oliveira', 'carlos@vaction.com', 'RH', '123456', 'Analista RH', '2019-01-20', '45678912300', 1, 3),
(4, 'Mariana Lima', 'mariana@bancoxpto.com', 'Financeiro', '123456', 'Analista Financeiro', '2021-11-05', '65498732100', 2, 1),
(5, 'Fernanda Costa', 'fernanda@bancoxpto.com', 'Financeiro', '123456', 'Coordenadora Financeiro', '2018-07-22', '98732165400', 2, 2),
(6, 'Ricardo Almeida', 'ricardo@bancoxpto.com', 'RH', '123456', 'Especialista RH', '2017-09-10', '74185296300', 2, 3),
(7, 'Danilo Silvestre', 'danilo@vaction.com', 'TI', '123456', 'Analista', '2022-05-10', '37827313323', 1, 1);

UPDATE Usuario SET fk_aprovador = 2 WHERE id_usuario = 1;
UPDATE Usuario SET fk_aprovador = 3 WHERE id_usuario = 2;
UPDATE Usuario SET fk_aprovador = NULL WHERE id_usuario = 3;
UPDATE Usuario SET fk_aprovador = 5 WHERE id_usuario = 4;
UPDATE Usuario SET fk_aprovador = 6 WHERE id_usuario = 5;
UPDATE Usuario SET fk_aprovador = NULL WHERE id_usuario = 6;
UPDATE Usuario SET fk_aprovador = 2 WHERE id_usuario = 7;

update pedido set fk_status = 2 where id_pedido = 3;
select * from pedido;

-- PEDIDO DE FERIAS
INSERT INTO pedido (id_pedido, data_inicio, data_fim, data_solicitacao, ultima_atualizacao, fk_usuario, fk_status) VALUES
(1, '2025-07-01', '2025-07-15', '2025-03-01', '2025-03-02', 1, 1),
(2, '2025-08-05', '2025-08-20', '2025-03-10', '2025-03-15', 4, 2);

-- HISTORICO (rastreamento do processo)
INSERT INTO historico (id_alteracao, data_alteracao, observacao, fk_pedido, fk_usuario, fk_decisao) VALUES
(1, '2025-03-02', 'Solicitação enviada ao gestor', 1, 1, NULL),
(2, '2025-03-03', 'Gestor aprovou e enviou para RH', 1, 2, 1),
(3, '2025-03-15', 'Solicitação encaminhada ao RH', 2, 4, NULL),
(4, '2025-03-18', 'RH reprovou por conflito de agenda', 2, 6, 2);
