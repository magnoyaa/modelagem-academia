USE academia_logico;

INSERT INTO plano (id_plano, nome, valor, duracao_meses) VALUES (1, 'Mensal', 99.90, 1);
INSERT INTO plano (id_plano, nome, valor, duracao_meses) VALUES (2, 'Trimestral', 269.90, 3);
INSERT INTO plano (id_plano, nome, valor, duracao_meses) VALUES (3, 'Anual', 899.90, 12);

INSERT INTO aluno (id_aluno, nome, cpf, email, telefone, data_nascimento, data_matricula, id_plano)
VALUES (1, 'Lucas Ferreira', '11111111111', 'lucas@email.com', '98991110001', '2001-03-15', '2026-01-10', 1);
INSERT INTO aluno (id_aluno, nome, cpf, email, telefone, data_nascimento, data_matricula, id_plano)
VALUES (2, 'Ana Souza', '22222222222', 'ana@email.com', '98991110002', '1998-07-22', '2026-02-05', 2);
INSERT INTO aluno (id_aluno, nome, cpf, email, telefone, data_nascimento, data_matricula, id_plano)
VALUES (3, 'Pedro Lima', '33333333333', 'pedro@email.com', '98991110003', '2003-11-02', '2026-03-01', 3);
INSERT INTO aluno (id_aluno, nome, cpf, email, telefone, data_nascimento, data_matricula, id_plano)
VALUES (4, 'Marina Costa', '44444444444', 'marina@email.com', '98991110004', '1995-05-30', '2026-04-12', 1);

INSERT INTO pagamento (id_pagamento, data_pagamento, valor_pago, forma_pagamento, id_aluno)
VALUES (1, '2026-01-10', 99.90, 'Pix', 1);
INSERT INTO pagamento (id_pagamento, data_pagamento, valor_pago, forma_pagamento, id_aluno)
VALUES (2, '2026-02-10', 99.90, 'Cartao', 1);
INSERT INTO pagamento (id_pagamento, data_pagamento, valor_pago, forma_pagamento, id_aluno)
VALUES (3, '2026-02-05', 269.90, 'Pix', 2);
INSERT INTO pagamento (id_pagamento, data_pagamento, valor_pago, forma_pagamento, id_aluno)
VALUES (4, '2026-03-01', 899.90, 'Dinheiro', 3);
INSERT INTO pagamento (id_pagamento, data_pagamento, valor_pago, forma_pagamento, id_aluno)
VALUES (5, '2026-04-12', 99.90, 'Pix', 4);

INSERT INTO instrutor (id_instrutor, nome, cpf, telefone, especialidade)
VALUES (1, 'Carlos Mendes', '55555555555', '98992220001', 'Spinning');
INSERT INTO instrutor (id_instrutor, nome, cpf, telefone, especialidade)
VALUES (2, 'Juliana Rocha', '66666666666', '98992220002', 'Yoga');
INSERT INTO instrutor (id_instrutor, nome, cpf, telefone, especialidade)
VALUES (3, 'Rafael Alves', '77777777777', '98992220003', 'Danca');

INSERT INTO aula (id_aula, nome, dia_semana, horario, vagas, id_instrutor)
VALUES (1, 'Spinning', 'Segunda', '18:00:00', 15, 1);
INSERT INTO aula (id_aula, nome, dia_semana, horario, vagas, id_instrutor)
VALUES (2, 'Yoga', 'Quarta', '07:00:00', 12, 2);
INSERT INTO aula (id_aula, nome, dia_semana, horario, vagas, id_instrutor)
VALUES (3, 'Zumba', 'Sexta', '19:00:00', 25, 3);
INSERT INTO aula (id_aula, nome, dia_semana, horario, vagas, id_instrutor)
VALUES (4, 'Spinning', 'Quinta', '06:30:00', 15, 1);

INSERT INTO inscricao (id_aluno, id_aula, data_inscricao) VALUES (1, 1, '2026-01-12');
INSERT INTO inscricao (id_aluno, id_aula, data_inscricao) VALUES (1, 3, '2026-01-15');
INSERT INTO inscricao (id_aluno, id_aula, data_inscricao) VALUES (2, 2, '2026-02-07');
INSERT INTO inscricao (id_aluno, id_aula, data_inscricao) VALUES (3, 1, '2026-03-03');
INSERT INTO inscricao (id_aluno, id_aula, data_inscricao) VALUES (4, 3, '2026-04-14');

SELECT aluno.nome AS aluno, plano.nome AS plano, plano.valor
FROM aluno
JOIN plano ON aluno.id_plano = plano.id_plano;

SELECT aluno.nome AS aluno, aula.nome AS aula, aula.dia_semana, aula.horario, instrutor.nome AS instrutor
FROM inscricao
JOIN aluno ON inscricao.id_aluno = aluno.id_aluno
JOIN aula ON inscricao.id_aula = aula.id_aula
JOIN instrutor ON aula.id_instrutor = instrutor.id_instrutor
ORDER BY aluno.nome;

SELECT aluno.nome AS aluno, COUNT(pagamento.id_pagamento) AS qtd_pagamentos, SUM(pagamento.valor_pago) AS total_pago
FROM aluno
JOIN pagamento ON aluno.id_aluno = pagamento.id_aluno
GROUP BY aluno.id_aluno, aluno.nome;
