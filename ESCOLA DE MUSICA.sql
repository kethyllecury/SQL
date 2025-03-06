CREATE TABLE MUSICOS (
    Id_musico INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    nacionalidade VARCHAR(50)
);
CREATE TABLE SINFONIAS (
    id_sinfonia INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    data_sinfonia DATE NOT NULL,
    compositor VARCHAR(100) NOT NULL
);
CREATE TABLE ORQUESTRA (
    id_orquestra INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    pais VARCHAR(100) NOT NULL,
    data_criacao DATE NOT NULL
);
CREATE TABLE FUNCOES_MUSICOS (
    id_funcao INT PRIMARY KEY AUTO_INCREMENT,
    id_musico INT NOT NULL,
    data_adesao DATE NOT NULL,
    id_sinfonia INT NOT NULL,
    FOREIGN KEY (id_musico) REFERENCES MUSICOS(Id_musico),
    FOREIGN KEY (id_sinfonia) REFERENCES SINFONIAS(id_sinfonia)
);
CREATE TABLE INSTRUMENTOS (
    id_instrumentos INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(100) NOT NULL
);

INSERT INTO MUSICOS (nome, data_nascimento, nacionalidade) VALUES
('Ludwig van Beethoven', '1770-12-17', 'Alemão'),
('Wolfgang Amadeus Mozart', '1756-01-27', 'Austríaco'),
('Johann Sebastian Bach', '1685-03-31', 'Alemão'),
('Frédéric Chopin', '1810-03-01', 'Polonês'),
('Claude Debussy', '1862-08-22', 'Francês'),
('Antonio Vivaldi', '1678-03-04', 'Italiano'),
('Sergei Rachmaninoff', '1873-04-01', 'Russo'),
('Igor Stravinsky', '1882-06-17', 'Russo'),
('Johannes Brahms', '1833-05-07', 'Alemão'),
('Pyotr Ilyich Tchaikovsky', '1840-05-07', 'Russo');

INSERT INTO SINFONIAS (nome, data_sinfonia, compositor) VALUES
('Sinfonia No. 9', '1824-05-07', 'Ludwig van Beethoven'),
('Sinfonia No. 40', '1788-07-25', 'Wolfgang Amadeus Mozart'),
('Sinfonia No. 5', '1808-12-22', 'Ludwig van Beethoven'),
('Sinfonia No. 3', '1803-04-07', 'Ludwig van Beethoven'),
('Sinfonia No. 41', '1788-08-10', 'Wolfgang Amadeus Mozart'),
('Sinfonia No. 6', '1808-12-22', 'Ludwig van Beethoven'),
('Sinfonia No. 4', '1841-11-06', 'Johannes Brahms'),
('Sinfonia No. 1', '1876-11-04', 'Johannes Brahms'),
('Sinfonia Manfred', '1885-03-23', 'Pyotr Ilyich Tchaikovsky'),
('Sinfonia Maestra', '1893-10-28', 'Pyotr Ilyich Tchaikovsky');

INSERT INTO ORQUESTRA (nome, cidade, pais, data_criacao) VALUES
('Filarmônica de Berlim', 'Berlim', 'Alemanha', '1882-05-01'),
('Orquestra Sinfônica de Londres', 'Londres', 'Reino Unido', '1904-06-09'),
('Filarmônica de Viena', 'Viena', 'Áustria', '1842-03-28'),
('Orquestra de Paris', 'Paris', 'França', '1967-11-14'),
('Orquestra Sinfônica de São Paulo', 'São Paulo', 'Brasil', '1954-10-05'),
('Filarmônica de Nova Iorque', 'Nova Iorque', 'EUA', '1842-12-07'),
('Orquestra Sinfônica de Chicago', 'Chicago', 'EUA', '1891-10-16'),
('Filarmônica de Los Angeles', 'Los Angeles', 'EUA', '1919-10-24'),
('Orquestra Sinfônica de Boston', 'Boston', 'EUA', '1881-10-22'),
('Orquestra Nacional da Rússia', 'Moscou', 'Rússia', '1990-01-01');

INSERT INTO FUNCOES_MUSICOS (id_musico, data_adesao, id_sinfonia) VALUES
(1, '1824-05-07', 1),
(2, '1788-07-25', 2), 
(1, '1808-12-22', 3), 
(1, '1803-04-07', 4), 
(2, '1788-08-10', 5),
(1, '1808-12-22', 6),
(9, '1841-11-06', 7), 
(9, '1876-11-04', 8),
(10, '1885-03-23', 9), 
(10, '1893-10-28', 10); 

INSERT INTO INSTRUMENTOS (nome, tipo) VALUES
('Violino', 'Cordas'),
('Piano', 'Teclas'),
('Flauta', 'Sopro'),
('Trompete', 'Sopro'),
('Oboé', 'Sopro'),
('Clarinete', 'Sopro'),
('Tímpanos', 'Percussão'),
('Harpa', 'Cordas'),
('Trombone', 'Sopro'),
('Fagote', 'Sopro');

UPDATE MUSICOS SET nome = 'Ludwig van Beethoven filho' WHERE id_musico = 1;
UPDATE MUSICOS SET nacionalidade = 'Francês' WHERE id_musico = 3;
UPDATE SINFONIAS SET compositor = 'L. van Beethoven' WHERE id_sinfonia = 2;
UPDATE MUSICOS SET data_nascimento = '1756-01-27' WHERE id_musico = 2;
UPDATE SINFONIAS SET nome = 'Sinfonia No. 10' WHERE id_sinfonia = 1;
UPDATE INSTRUMENTOS SET tipo = 'Teclas ' WHERE nome = 'Piano';
UPDATE FUNCOES_MUSICOS SET data_adesao = '1808-12-23' WHERE id_musico = 1 AND id_sinfonia = 3;
UPDATE INSTRUMENTOS SET tipo = 'Sopro' WHERE nome = 'Trompete';
UPDATE MUSICOS SET nacionalidade = 'Austríaco' WHERE id_musico = 2;
UPDATE SINFONIAS SET compositor= 'Vivaldi' WHERE id_sinfonia = 9;    
CREATE VIEW VERMUSICOS AS SELECT nome, nacionalidade FROM MUSICOS;
CREATE VIEW VIEW_SINFONIAS AS SELECT nome, compositor FROM SINFONIAS;
CREATE VIEW VIEW_ORQUESTRA AS SELECT nome, pais FROM ORQUESTRA;
CREATE VIEW VIEW_ORQUESTRA_DATA AS SELECT nome, data_criacao FROM ORQUESTRA;
SELECT nome FROM MUSICOS WHERE id_musico IN (SELECT id_musico FROM FUNCOES_MUSICOS WHERE id_sinfonia = 1);
SELECT nome FROM SINFONIAS WHERE compositor = (SELECT compositor FROM SINFONIAS WHERE id_sinfonia = 1);
SELECT nome FROM ORQUESTRA WHERE data_criacao > (SELECT data_criacao FROM ORQUESTRA WHERE id_orquestra = 1);
SELECT nome FROM SINFONIAS WHERE data_sinfonia < (SELECT data_sinfonia FROM SINFONIAS WHERE id_sinfonia = 4);
SELECT nome FROM INSTRUMENTOS WHERE id_instrumentos NOT IN (SELECT id_musico FROM FUNCOES_MUSICOS);
SELECT compositor FROM SINFONIAS GROUP BY compositor HAVING COUNT(*) > 1;
DELETE FROM INSTRUMENTOS WHERE nome = 'Violino';
DELETE FROM ORQUESTRA WHERE id_orquestra = 3;
DELETE FROM FUNCOES_MUSICOS WHERE id_musico = 4 AND id_sinfonia = 1;
SELECT MUSICOS.nome AS musico_nome, SINFONIAS.nome AS sinfonia_nome
FROM MUSICOS INNER JOIN SINFONIAS ON MUSICOS.id_musico = SINFONIAS.id_sinfonia;
SELECT MUSICOS.nome AS musico_nome, INSTRUMENTOS.nome AS Instrumento_nome
FROM MUSICOS LEFT JOIN INSTRUMENTOS ON MUSICOS.id_musico = INSTRUMENTOS.id_instrumentos;
SELECT MUSICOS.nome AS musico_nome, FUNCOES_MUSICOS.data_adesao AS data_entrada
FROM MUSICOS LEFT JOIN FUNCOES_MUSICOS ON MUSICOS.id_musico = FUNCOES_MUSICOS.id_musico;
SELECT CONCAT(nome, ' - ', pais) AS nome_pais FROM ORQUESTRA;
SELECT nome FROM SINFONIAS ORDER BY data_sinfonia;
SELECT * FROM ORQUESTRA WHERE cidade = 'São Paulo';
SELECT DISTINCT compositor FROM SINFONIAS;
SELECT nome FROM INSTRUMENTOS WHERE tipo IS NULL;
SELECT nome FROM SINFONIAS WHERE compositor = 'Vivaldi';
SELECT COUNT(*) AS total_musicos FROM MUSICOS; 
SELECT nome, data_nascimento FROM MUSICOS ORDER BY data_nascimento DESC LIMIT 5;
SELECT compositor, COUNT(*) AS quantidade_sinfonias FROM SINFONIAS GROUP BY compositor ORDER BY quantidade_sinfonias DESC;
SELECT compositor, COUNT(*) AS num_sinfonias FROM SINFONIAS GROUP BY compositor HAVING COUNT(*) > 1;
SELECT nome, COUNT(*) AS quantidade FROM INSTRUMENTOS GROUP BY nome ORDER BY quantidade DESC;
















