CREATE TABLE Alunos (
    ID INT PRIMARY KEY,
    nome VARCHAR(100),
    idade INT,
    email VARCHAR(100),
    telefone VARCHAR(20)
);
CREATE TABLE Instrutores (
    ID INT PRIMARY KEY,
    nome VARCHAR(100),
    especialidade VARCHAR(100),
    email VARCHAR(100),
    telefone VARCHAR(20)
);
CREATE TABLE PlanosTreinamento (
    ID INT PRIMARY KEY,
    nome VARCHAR(100),
    descricao TEXT,
    duracao_semanas INT,
    valor_mensal DECIMAL(10, 2)
);
CREATE TABLE Equipamentos (
    ID INT PRIMARY KEY,
    nome VARCHAR(100),
    descricao TEXT,
    quantidade_disponivel INT
);
CREATE TABLE RegistrosTreinos (
    ID INT PRIMARY KEY,
    ID_aluno INT,
    ID_instrutor INT,
    data_treino DATE,
    descricao TEXT,
    observacoes TEXT,
    FOREIGN KEY (ID_aluno) REFERENCES Alunos(ID),
    FOREIGN KEY (ID_instrutor) REFERENCES Instrutores(ID)
);
CREATE TABLE PagamentosMensalidades (
    ID INT PRIMARY KEY,
    ID_aluno INT,
    data_pagamento DATE,
    valor_pago DECIMAL(10, 2),
    FOREIGN KEY (ID_aluno) REFERENCES Alunos(ID)
);
INSERT INTO Alunos (ID, nome, idade, email, telefone)
VALUES
(1, 'João Silva', 25, 'joao.silva@example.com', '(11) 98765-4321'),
(2, 'Maria Santos', 30, 'maria.santos@example.com', '(21) 91234-5678'),
(3, 'Pedro Oliveira', 28, 'pedro.oliveira@example.com', '(31) 87654-1234');

INSERT INTO Instrutores (ID, nome, especialidade, email, telefone)
VALUES
(1, 'Ana Souza', 'Musculação', 'ana.souza@example.com', '(11) 99876-5432'),
(2, 'Carlos Pereira', 'Pilates', 'carlos.pereira@example.com', '(21) 92345-6789'),
(3, 'Juliana Lima', 'Yoga', 'juliana.lima@example.com', '(31) 88765-4321');

INSERT INTO PlanosTreinamento (ID, nome, descricao, duracao_semanas, valor_mensal)
VALUES
(1, 'Plano Básico', 'Treinamento para iniciantes.', 12, 150.00),
(2, 'Plano Plus', 'Programa para atletas.', 24, 250.00),
(3, 'Plano Personalizado', 'Treinamento adaptado.', 16, 200.00);

INSERT INTO Equipamentos (ID, nome, descricao, quantidade_disponivel)
VALUES
(1, 'Esteira', 'Esteira elétrica para corrida.', 5),
(2, 'Bicicleta Ergométrica', 'Bicicleta estacionária.', 8),
(3, 'Halteres', 'Maquina para membros superiores.', 20);

INSERT INTO RegistrosTreinos (ID, ID_aluno, ID_instrutor, data_treino, descricao, observacoes)
VALUES
(1, 1, 1, '2024-06-20', 'Treino de musculação focado em membros superiores.', 'João apresentou bom progresso.'),
(2, 2, 2, '2024-06-21', 'Sessão de pilates para fortalecimento do core.', 'Maria teve excelente flexibilidade.'),
(3, 3, 3, '2024-06-19', 'Treino de CrossFit com circuito de alta intensidade.', 'Pedro se destacou na resistência muscular.');

INSERT INTO PagamentosMensalidades (ID, ID_aluno, data_pagamento, valor_pago)
VALUES
(1, 1, '2024-06-10', 150.00),
(2, 2, '2024-06-15', 250.00),
(3, 3, '2024-06-05', 200.00);

SELECT * FROM Alunos;
SELECT * FROM Instrutores WHERE especialidade = 'Yoga';
SELECT * FROM PlanosTreinamento WHERE duracao_semanas > 20;
SELECT * FROM Equipamentos;
SELECT * FROM RegistrosTreinos WHERE ID_aluno = 1;
SELECT * FROM PagamentosMensalidades WHERE ID_aluno = 2;
SELECT Alunos.nome AS nome_aluno, Instrutores.nome AS nome_instrutor
FROM RegistrosTreinos
JOIN Alunos ON RegistrosTreinos.ID_aluno = Alunos.ID
JOIN Instrutores ON RegistrosTreinos.ID_instrutor = Instrutores.ID;
SELECT nome, valor_mensal FROM PlanosTreinamento;
SELECT nome, quantidade_disponivel FROM Equipamentos WHERE quantidade_disponivel > 10;
SELECT nome FROM Alunos WHERE ID NOT IN (SELECT DISTINCT ID_aluno FROM PagamentosMensalidades);



