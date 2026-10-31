-- Instituto Semear · schema.sql
-- Banco da ONG Instituto Semear: famílias atendidas, beneficiários,
-- voluntários, atividades/oficinas, turmas, matrículas e frequência.
-- O arquivo recria o banco do zero, então pode ser executado várias vezes.

SET NAMES utf8mb4;

DROP DATABASE IF EXISTS instituto_semear;
CREATE DATABASE instituto_semear CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE instituto_semear;

-- Famílias atendidas pela ONG (responsável legal pelo beneficiário).
-- LGPD: não guardamos CPF nem endereço completo, apenas o bairro.
CREATE TABLE familia (
  id_familia       INT AUTO_INCREMENT PRIMARY KEY,
  nome_responsavel VARCHAR(150) NOT NULL,
  email            VARCHAR(100) UNIQUE,
  telefone         VARCHAR(20),
  bairro           VARCHAR(80) NOT NULL,
  renda_familiar   DECIMAL(10,2) CHECK (renda_familiar >= 0),
  data_cadastro    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Crianças e adolescentes atendidos; cada um pertence a uma família.
CREATE TABLE beneficiario (
  id_beneficiario  INT AUTO_INCREMENT PRIMARY KEY,
  id_familia       INT NOT NULL,
  nome             VARCHAR(150) NOT NULL,
  data_nascimento  DATE NOT NULL,
  escola           VARCHAR(120),
  serie            VARCHAR(30),
  data_entrada     DATE NOT NULL,
  ativo            BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT fk_beneficiario_familia
    FOREIGN KEY (id_familia) REFERENCES familia (id_familia)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT ck_beneficiario_nascimento
    CHECK (data_nascimento > '1990-01-01'),
  CONSTRAINT ck_beneficiario_entrada
    CHECK (data_entrada >= data_nascimento)
);

-- Voluntários que conduzem as turmas.
CREATE TABLE voluntario (
  id_voluntario INT AUTO_INCREMENT PRIMARY KEY,
  nome          VARCHAR(150) NOT NULL,
  email         VARCHAR(100) NOT NULL UNIQUE,
  telefone      VARCHAR(20),
  area_atuacao  ENUM('pedagogia','cultura','esporte','apoio_social','administracao') NOT NULL,
  data_inicio   DATE NOT NULL,
  ativo         BOOLEAN NOT NULL DEFAULT TRUE
);

-- Atividades/oficinas oferecidas pela ONG.
CREATE TABLE atividade (
  id_atividade INT AUTO_INCREMENT PRIMARY KEY,
  nome         VARCHAR(120) NOT NULL UNIQUE,
  tipo         ENUM('reforco_escolar','cultura','esporte','apoio_familiar') NOT NULL,
  descricao    TEXT,
  capacidade   SMALLINT NOT NULL CHECK (capacidade > 0),
  ativa        BOOLEAN NOT NULL DEFAULT TRUE
);

-- Turmas: uma atividade em um dia/horário, conduzida por um voluntário.
CREATE TABLE turma (
  id_turma      INT AUTO_INCREMENT PRIMARY KEY,
  id_atividade  INT NOT NULL,
  id_voluntario INT NOT NULL,
  dia_semana    ENUM('segunda','terca','quarta','quinta','sexta','sabado') NOT NULL,
  hora_inicio   TIME NOT NULL,
  hora_fim      TIME NOT NULL,
  sala          VARCHAR(30),
  CONSTRAINT fk_turma_atividade
    FOREIGN KEY (id_atividade) REFERENCES atividade (id_atividade)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_turma_voluntario
    FOREIGN KEY (id_voluntario) REFERENCES voluntario (id_voluntario)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT ck_turma_horario CHECK (hora_fim > hora_inicio),
  CONSTRAINT uq_turma_horario UNIQUE (id_atividade, dia_semana, hora_inicio)
);

-- Relacionamento N:N entre beneficiário e turma.
CREATE TABLE matricula (
  id_beneficiario INT NOT NULL,
  id_turma        INT NOT NULL,
  data_matricula  DATE NOT NULL,
  status          ENUM('ativa','cancelada','concluida') NOT NULL DEFAULT 'ativa',
  PRIMARY KEY (id_beneficiario, id_turma),
  CONSTRAINT fk_matricula_beneficiario
    FOREIGN KEY (id_beneficiario) REFERENCES beneficiario (id_beneficiario)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_matricula_turma
    FOREIGN KEY (id_turma) REFERENCES turma (id_turma)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Presença por aula: só existe para quem está matriculado na turma.
CREATE TABLE frequencia (
  id_frequencia   INT AUTO_INCREMENT PRIMARY KEY,
  id_beneficiario INT NOT NULL,
  id_turma        INT NOT NULL,
  data_aula       DATE NOT NULL,
  presente        BOOLEAN NOT NULL DEFAULT TRUE,
  justificativa   VARCHAR(255),
  CONSTRAINT fk_frequencia_matricula
    FOREIGN KEY (id_beneficiario, id_turma)
    REFERENCES matricula (id_beneficiario, id_turma)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT uq_frequencia UNIQUE (id_beneficiario, id_turma, data_aula),
  CONSTRAINT ck_frequencia_justificativa
    CHECK (presente = TRUE OR justificativa IS NOT NULL)
);
