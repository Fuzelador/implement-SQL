-- Criando Tabelas - EXERCICIO SLIDE 47

CREATE TABLE Ambulatorio (
    Num_a SERIAL PRIMARY KEY,
    Andar INT,
    Capacidade INT
);

CREATE TABLE Paciente (
    Cod_p SERIAL PRIMARY KEY,
    Nome VARCHAR(255),
    Idade INT,
    Cidade VARCHAR(255)
);

CREATE TABLE Medico (
    Cod_m SERIAL PRIMARY KEY,
    Nome VARCHAR(255),
    Idade INT,
    Espec VARCHAR(255),
    Cidade VARCHAR(255),
    Num_a INT REFERENCES Ambulatorio(Num_a)
);

CREATE TABLE Consulta (
    Cod_m INT REFERENCES Medico(Cod_m),
    Cod_p INT REFERENCES Paciente(Cod_p),
    Data DATE,
    Hora TIME
);

CREATE TABLE Convenios (
	cod_conv SERIAL PRIMARY KEY,
	nome_conv VARCHAR(255),
	data_fatura DATE
);
	
CREATE TABLE associados (
    cod_assoc SERIAL PRIMARY KEY,
    nome_assoc VARCHAR(255),
    cidade VARCHAR(255),
    coordenadas VARCHAR(255),
	cod_conv INT REFERENCES convenios (cod_conv)
);

CREATE TABLE faturamento (
    data_fatura DATE CHECK (data_fatura <= CURRENT_DATE), -- Impede datas futuras
    cod_conv INT,
    cod_assoc INT,
    data_venc DATE CHECK (data_venc >= CURRENT_DATE), -- Impede datas passadas
    FOREIGN KEY (cod_conv) REFERENCES convenios (cod_conv),
    FOREIGN KEY (cod_assoc) REFERENCES associados (cod_assoc)
);

CREATE TABLE medico_convenio (
    cod_medico INT,
    cod_conv INT,
    PRIMARY KEY (cod_medico, cod_conv),
    FOREIGN KEY (cod_medico) REFERENCES Medico(Cod_m),
    FOREIGN KEY (cod_conv) REFERENCES convenios(cod_conv)
);

-- Inserir dados na tabela de convênios
INSERT INTO convenios (nome_conv, data_fatura)
VALUES
    ('Convênio A', '2023-09-01'),
    ('Convênio B', '2023-09-15');

-- Inserir dados na tabela de médicos
INSERT INTO Medico (Nome, Idade, Espec, Cidade, Num_a)
VALUES
    ('João', 40, 'Ortopedista', 'Florianópolis', 1),
    ('Maria', 42, 'Oftalmologista', 'Blumenau', 2),
    ('Pedro', 51, 'Pediatra', 'São José', 2);

-- Inserir associações de médicos com convênios na tabela medico_convenio
INSERT INTO medico_convenio (cod_medico, cod_conv)
VALUES
    (1, 1), -- João aceita Convênio A
    (2, 1), -- Maria aceita Convênio A
    (2, 2), -- Maria aceita Convênio B

-- Verifique a associação médico-convênio na tabela medico_convenio
SELECT * FROM medico_convenio;

-- Inserir registros na tabela "convenios"
INSERT INTO convenios (nome_conv, data_fatura)
VALUES
    ('Convênio A', '2023-09-01'),
    ('Convênio B', '2023-09-15');

-- Inserir registros na tabela "associados" associando-os a convênios existentes
INSERT INTO associados (nome_assoc, cidade, coordenadas, cod_conv)
VALUES
    ('Associado 1', 'Cidade A', 'Coord A', 1),
    ('Associado 2', 'Cidade B', 'Coord B', 2);

-- Inserir registros na tabela "faturamento" com datas de faturamento e vencimento válidas
INSERT INTO faturamento (data_fatura, cod_conv, cod_assoc, data_venc)
VALUES
    ('2023-09-10', 1, 1, '2023-09-20'),
    ('2023-09-05', 2, 2, '2023-09-25');
-- Adicione a nova coluna "data_pagto" à tabela "faturamento" sem aceitar valores nulos
ALTER TABLE faturamento
ADD COLUMN data_pagto DATE NOT NULL;

-- Inserir registros na tabela "faturamento" com a nova coluna "data_pagto"
INSERT INTO faturamento (data_fatura, cod_conv, cod_assoc, data_venc, data_pagto)
VALUES
    ('2023-09-10', 1, 1, '2023-09-20', '2023-09-15'),
    ('2023-09-05', 2, 2, '2023-09-25', '2023-09-18');

-- Adicione restrições de verificação para a nova coluna "data_pagto"
ALTER TABLE faturamento
ADD CONSTRAINT chk_data_pagto_valida
CHECK (
    data_pagto IS NOT NULL AND
    data_pagto >= data_fatura AND
    data_pagto >= CURRENT_DATE
);

-- Inserir datas de pagamento aleatórias em registros existentes na tabela "faturamento"
UPDATE faturamento
SET data_pagto = 
    DATE(data_fatura + (FLOOR(RANDOM() * (CURRENT_DATE - data_fatura + 1))) || ' days');

--listar o nome do associado e o nome do convênio de todas as faturas não pagas na tabela "faturamento"
SELECT
    a.nome_assoc AS "Nome do Associado",
    c.nome_conv AS "Nome do Convênio"
FROM
    faturamento AS f
JOIN
    associados AS a ON f.cod_assoc = a.cod_assoc
JOIN
    convenios AS c ON f.cod_conv = c.cod_conv
WHERE
    f.data_pagto IS NULL;


SELECT * FROM Medico
SELECT * FROM Paciente
SELECT * FROM Consulta
SELECT * FROM Ambulatorio

-- Preenchendo Tabelas - EXERCICIO SLIDE 48, 49, 50, 51

INSERT INTO Ambulatorio (Num_a, Andar, Capacidade)
VALUES
    (1, 1, 30),
    (2, 1, 50),
    (3, 2, 40),
    (4, 2, 25),
    (5, 2, 55),
    (6, 2, 10),
    (7, 2, 10);
	
SELECT * FROM Ambulatorio


INSERT INTO Medico (Cod_m, Nome, Idade, Espec, Cidade, Num_a)
VALUES
    (1, 'Joao', 40, 'ortopedista', 'Florianopolis', 1),
    (2, 'Maria', 42, 'oftalmologista', 'Blumenau', 2),
    (3, 'Pedro', 51, 'pediatra', 'Sao Jose', 2),
    (4, 'Carlos', 28, 'ortopedista', 'Florianopolis', 4),
    (5, 'Marcia', 33, 'neurologista', 'Florianopolis', 3),
    (6, 'Pedrinho', 38, 'infectologista', 'Blumenau', 1),
    (7, 'Mariana', 39, 'infectologista', 'Florianopolis', NULL),
    (8, 'Roberta', 50, 'neurologista', 'Joinville', 5),
    (9, 'Vanusa', 39, 'aa', 'Curitiba', NULL),
    (10, 'Valdo', 50, 'aa', 'Curitiba', NULL);
	
SELECT * FROM Medico

INSERT INTO Paciente (Cod_p, Nome, Idade, Cidade)
VALUES
    (1, 'Clevi', 60, 'Florianopolis'),
    (2, 'Cleusa', 25, 'Palhoca'),
    (3, 'Alberto', 45, 'Palhoca'),
    (4, 'Roberta', 44, 'Sao Jose'),
    (5, 'Fernanda', 3, 'Sao Jose'),
    (6, 'Luanda', 2, 'Florianopolis'),
    (7, 'Manuela', 69, 'Florianopolis'),
    (8, 'Caio', 45, 'Florianopolis'),
    (9, 'Andre', 83, 'Florianopolis'),
    (10, 'Andre', 21, 'Florianopolis');
	
SELECT * FROM Paciente

INSERT INTO Consulta (Cod_m, Cod_p, Data, Hora)
VALUES
    (1, 3, '2000-06-12', '14:00'),
    (4, 3, '2000-06-13', '9:00'),
    (2, 9, '2000-06-14', '14:00'),
    (7, 5, '2000-06-12', '10:00'),
    (8, 6, '2000-06-19', '13:00'),
    (5, 1, '2000-06-20', '13:00'),
    (6, 8, '2000-06-20', '20:30'),
    (6, 2, '2000-06-15', '11:00'),
    (6, 4, '2000-06-15', '14:00'),
    (7, 2, '2000-06-10', '19:30');

SELECT * FROM Consulta

-- EXERCICIO SLIDE 52
-- 1 
SELECT * FROM Medico WHERE Cidade = 'Florianopolis';

-- 2
SELECT Cod_m FROM Medico WHERE Nome = 'Roberta';

-- 3
SELECT DISTINCT Espec
FROM Medico
WHERE Cidade = 'Florianopolis';

-- 4
SELECT Consulta.Data
FROM Consulta
INNER JOIN Paciente ON Consulta.Cod_p = Paciente.Cod_p
WHERE Paciente.Nome = 'Caio';

-- 5
SELECT DISTINCT Paciente.Nome
FROM Consulta
INNER JOIN Medico ON Consulta.Cod_m = Medico.Cod_m
INNER JOIN Paciente ON Consulta.Cod_p = Paciente.Cod_p
WHERE Medico.Nome = 'Pedrinho';

-- 6
SELECT Medico.Nome AS Nome_Medico, Consulta.Data
FROM Medico
INNER JOIN Consulta ON Medico.Cod_m = Consulta.Cod_m;

-- 7
SELECT Medico.Nome AS Nome_Medico, Ambulatorio.Andar
FROM Medico
INNER JOIN Ambulatorio ON Medico.Num_a = Ambulatorio.Num_a
WHERE Medico.Espec = 'infectologista';

--8
SELECT Paciente.Nome AS Nome_Paciente
FROM Paciente
INNER JOIN Consulta ON Paciente.Cod_p = Consulta.Cod_p
INNER JOIN Medico ON Consulta.Cod_m = Medico.Cod_m
WHERE Medico.Num_a = 2;

-- 9
SELECT Medico.Nome AS Nome_Medico, COALESCE(Paciente.Nome, 'null') AS Nome_Paciente
FROM Medico
LEFT JOIN Consulta ON Medico.Cod_m = Consulta.Cod_m
LEFT JOIN Paciente ON Consulta.Cod_p = Paciente.Cod_p;

-- 10
SELECT Paciente.Nome AS Nome_Paciente, Consulta.Data, Consulta.Hora
FROM Consulta
LEFT JOIN Paciente ON Consulta.Cod_p = Paciente.Cod_p
ORDER BY Paciente.Nome ASC, Consulta.Data DESC, Consulta.Hora DESC;