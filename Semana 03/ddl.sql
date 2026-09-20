CREATE DATABASE academia_logico;
USE academia_logico;

CREATE TABLE plano (
    id_plano INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
    valor DECIMAL(8,2) NOT NULL,
    duracao_meses INT NOT NULL,
    CHECK (valor > 0),
    CHECK (duracao_meses > 0)
);

CREATE TABLE aluno (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(15),
    data_nascimento DATE NOT NULL,
    data_matricula DATE NOT NULL DEFAULT (CURRENT_DATE),
    id_plano INT NOT NULL,
    FOREIGN KEY (id_plano) REFERENCES plano(id_plano),
    CHECK (data_matricula >= data_nascimento)
);

CREATE TABLE pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    data_pagamento DATE NOT NULL,
    valor_pago DECIMAL(8,2) NOT NULL,
    forma_pagamento VARCHAR(20) NOT NULL DEFAULT 'Pix',
    id_aluno INT NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
    CHECK (valor_pago > 0),
    CHECK (forma_pagamento IN ('Pix', 'Cartao', 'Dinheiro'))
);

CREATE TABLE instrutor (
    id_instrutor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    telefone VARCHAR(15),
    especialidade VARCHAR(50)
);

CREATE TABLE aula (
    id_aula INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    dia_semana VARCHAR(15) NOT NULL,
    horario TIME NOT NULL,
    vagas INT NOT NULL DEFAULT 20,
    id_instrutor INT NOT NULL,
    FOREIGN KEY (id_instrutor) REFERENCES instrutor(id_instrutor),
    CHECK (vagas > 0),
    CHECK (dia_semana IN ('Segunda', 'Terca', 'Quarta', 'Quinta', 'Sexta', 'Sabado'))
);

CREATE TABLE inscricao (
    id_aluno INT NOT NULL,
    id_aula INT NOT NULL,
    data_inscricao DATE NOT NULL DEFAULT (CURRENT_DATE),
    PRIMARY KEY (id_aluno, id_aula),
    FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
    FOREIGN KEY (id_aula) REFERENCES aula(id_aula)
);
