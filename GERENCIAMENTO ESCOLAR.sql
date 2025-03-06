
CREATE TABLE Aluno (
    AlunoID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100),
    DataNascimento DATE,
    Endereco VARCHAR(100) DEFAULT 'SEM ENDEREÇO'
);

CREATE TABLE Responsavel (
    ResponsavelID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100),
    Telefone VARCHAR(20),
    EnderecoContato VARCHAR(100)
);

CREATE TABLE Professor (
    ProfessorID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100),
    DisciplinaLecionada VARCHAR(100),
    Contato VARCHAR(200)
);

CREATE TABLE Disciplina (
    DisciplinaID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100),
    CargaHoraria INT,
    ProfessorResponsavel INT,
    FOREIGN KEY (ProfessorResponsavel) REFERENCES Professor(ProfessorID)
);

CREATE TABLE Matricula (
    AlunoID INT,
    DisciplinaID INT,
    DataMatricula DATE,
    PRIMARY KEY (AlunoID, DisciplinaID),
    FOREIGN KEY (AlunoID) REFERENCES Aluno(AlunoID),
    FOREIGN KEY (DisciplinaID) REFERENCES Disciplina(DisciplinaID)
);

CREATE TABLE Nota (
    AlunoID INT,
    DisciplinaID INT,
    ValorNota DECIMAL(5, 2),
    DataAvaliacao DATE,
    PRIMARY KEY (AlunoID, DisciplinaID),
    FOREIGN KEY (AlunoID) REFERENCES Aluno(AlunoID),
    FOREIGN KEY (DisciplinaID) REFERENCES Disciplina(DisciplinaID)
);

CREATE TABLE Frequencia (
    AlunoID INT,
    DisciplinaID INT,
    Data DATE,
    Presenca BOOLEAN,
    PRIMARY KEY (AlunoID, DisciplinaID, Data),
    FOREIGN KEY (AlunoID) REFERENCES Aluno(AlunoID),
    FOREIGN KEY (DisciplinaID) REFERENCES Disciplina(DisciplinaID)
);

CREATE TABLE Atividade (
    AtividadeID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100),
    Descricao TEXT,
    Data DATE
);

CREATE TABLE Participacao (
    AlunoID INT,
    AtividadeID INT,
    DataParticipacao DATE,
    PRIMARY KEY (AlunoID, AtividadeID),
    FOREIGN KEY (AlunoID) REFERENCES Aluno(AlunoID),
    FOREIGN KEY (AtividadeID) REFERENCES Atividade(AtividadeID)
);

INSERT INTO Aluno (Nome, DataNascimento, Endereco) VALUES
('João Silva', '2005-03-15', 'Rua das Flores, 123'),
('Maria Santos', '2006-07-20', 'Avenida Principal, 456'),
('Pedro Oliveira', '2004-11-10', 'Travessa das Árvores, 789');

INSERT INTO Responsavel (Nome, Telefone, EnderecoContato) VALUES
('José Silva', '987654321', 'Rua das Flores, 123'),
('Carla Santos', '987123456', 'Avenida Principal, 456'),
('Marcos Oliveira', '987789123', 'Travessa das Árvores, 789');

INSERT INTO Professor (Nome, DisciplinaLecionada, Contato) VALUES
('Ana Maria', 'Matemática', 'ana.maria@email.com'),
('Paulo Souza', 'Português', 'paulo.souza@email.com'),
('Fernanda Lima', 'História', 'fernanda.lima@email.com');
    
INSERT INTO Disciplina (Nome, CargaHoraria, ProfessorResponsavel) VALUES
('Matemática', 60, 1),
('Português', 60, 2),
('História', 100, 3);

INSERT INTO Matricula (AlunoID, DisciplinaID, DataMatricula) VALUES
(1, 1, '2024-01-10'),
(2, 2, '2024-01-12'),
(3, 3, '2024-01-15');

INSERT INTO Nota (AlunoID, DisciplinaID, ValorNota, DataAvaliacao) VALUES
(1, 1, 8.5, '2024-03-05'),
(2, 2, 7.0, '2024-03-10'),
(3, 3, 9.0, '2024-03-15');

INSERT INTO Frequencia (AlunoID, DisciplinaID, Data, Presenca) VALUES
(1, 1, '2024-03-05', true),
(2, 2, '2024-03-10', true),
(3, 3, '2024-03-15', true);

INSERT INTO Atividade (Nome, Descricao, Data) VALUES
('Feira de Ciências', 'Apresentação de projetos científicos', '2024-05-15'),
('Visita ao Museu', 'Visita guiada ao museu', '2024-06-01'),
('Campeonato de Futebol', 'Torneio entre os alunos da escola', '2024-06-10');

INSERT INTO Participacao (AlunoID, AtividadeID, DataParticipacao) VALUES
(1, 1, '2024-05-15'),
(2, 2, '2024-06-01'),
(3, 3, '2024-06-10');

SELECT AlunoID,(SELECT AVG(ValorNota) FROM Nota)AS Media_nota FROM Nota;
CREATE VIEW RESPONSAVEL AS SELECT Nome FROM Responsavel;
SELECT *FROM RESPONSAVEL;
SELECT AVG(ValorNota) AS Notas, DataAvaliacao FROM Nota GROUP BY DataAvaliacao WITH ROLLUP;
INSERT INTO Aluno (Nome, DataNascimento) VALUES('Jo', '2005-03-18');
SELECT Nome, DataNascimento, Endereco FROM Aluno;
SELECT 
    a.Nome AS Aluno,
    d.Nome AS Disciplina,
    p.Nome AS Professor
FROM 
    Aluno a
    INNER JOIN Matricula m ON a.AlunoID = m.AlunoID
    INNER JOIN Disciplina d ON m.DisciplinaID = d.DisciplinaID
    INNER JOIN Professor p ON d.ProfessorResponsavel = p.ProfessorID;








