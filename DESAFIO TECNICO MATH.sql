CREATE TABLE TbCliente (
    CD_CLIENTE INT PRIMARY KEY,
    NM_CLIENTE VARCHAR(100)
);

CREATE TABLE TbTransacoes (
    CD_CLIENTE INT,
    DT_TRANSACAO DATE,
    CD_TRANSACAO VARCHAR(3),
    VR_TRANSACAO DECIMAL(10, 2),
    PRIMARY KEY (CD_CLIENTE, DT_TRANSACAO, CD_TRANSACAO),
    FOREIGN KEY (CD_CLIENTE) REFERENCES TbCliente(CD_CLIENTE)
);

INSERT INTO TbCliente (CD_CLIENTE, NM_CLIENTE) VALUES
(1, 'João'),
(2, 'Maria'),
(3, 'José'),
(4, 'Adilson'),
(5, 'Cleber');


INSERT INTO TbTransacoes (CD_CLIENTE, DT_TRANSACAO, CD_TRANSACAO, VR_TRANSACAO) VALUES
(1, '2021-08-28', '000', 020.00),
(1, '2021-09-09', '110', 078.90),
(1, '2021-09-17', '220', 058.00),
(1, '2021-11-15', '110', 178.90),
(1, '2021-12-24', '220', 110.37),
(5, '2021-10-28', '110', 220.00),
(5, '2021-11-07', '110', 380.00),
(5, '2021-12-05', '220', 398.86),
(5, '2021-12-14', '220', 033.90),
(5, '2021-12-21', '220', 016.90),
(3, '2021-10-05', '110', 720.90),
(3, '2021-11-05', '110', 720.90),
(3, '2021-12-05', '110', 720.90),
(4, '2021-10-09', '000', 050.00);

# 1. Qual cliente teve o maior saldo médio no mês 11? 

SELECT CD_CLIENTE, AVG(VR_TRANSACAO) AS Saldo_Medio
FROM TbTransacoes
WHERE DT_TRANSACAO BETWEEN '2021-11-01' AND '2021-11-30'
GROUP BY CD_CLIENTE
ORDER BY Saldo_Medio DESC
LIMIT 1;

# 2. Qual é o saldo de cada cliente?

SELECT c.CD_CLIENTE, 
       COALESCE(SUM(CASE WHEN t.CD_TRANSACAO = '110' THEN t.VR_TRANSACAO 
                         WHEN t.CD_TRANSACAO = '220' THEN -t.VR_TRANSACAO 
                         ELSE t.VR_TRANSACAO END), 0) AS Saldo
FROM TbCliente c
LEFT JOIN TbTransacoes t ON c.CD_CLIENTE = t.CD_CLIENTE
GROUP BY c.CD_CLIENTE;

# 3. Qual é o saldo médio de clientes que receberam CashBack?

SELECT AVG(VR_TRANSACAO) AS Saldo_Medio_CashBack
FROM TbTransacoes
WHERE CD_TRANSACAO = '000';

# 4. Qual o ticket médio das quatro últimas movimentações dos usuários?
    
WITH LastTransactions AS (
    SELECT CD_CLIENTE, VR_TRANSACAO, ROW_NUMBER() OVER (PARTITION BY CD_CLIENTE ORDER BY DT_TRANSACAO DESC) AS RowNum
    FROM TbTransacoes
)
SELECT c.CD_CLIENTE, 
       COALESCE(AVG(l.VR_TRANSACAO), 0) AS Ticket_Medio
FROM TbCliente c
LEFT JOIN LastTransactions l ON c.CD_CLIENTE = l.CD_CLIENTE AND l.RowNum <= 4
GROUP BY c.CD_CLIENTE;

# 5. Qual é a proporção entre Cash In/Out mensal?

SELECT 
    EXTRACT(MONTH FROM DT_TRANSACAO) AS Mes,
    SUM(CASE WHEN CD_TRANSACAO = '110' THEN VR_TRANSACAO ELSE 0 END) AS CashIn,
    SUM(CASE WHEN CD_TRANSACAO = '220' THEN VR_TRANSACAO ELSE 0 END) AS CashOut,
    SUM(CASE WHEN CD_TRANSACAO = '110' THEN VR_TRANSACAO ELSE 0 END) / NULLIF(SUM(CASE WHEN CD_TRANSACAO = '220' THEN VR_TRANSACAO ELSE 0 END), 0) AS Proporcao_CashIn_Out
FROM TbTransacoes
GROUP BY EXTRACT(MONTH FROM DT_TRANSACAO);

# 6. Qual a última transação de cada tipo para cada usuário?

SELECT CD_CLIENTE, CD_TRANSACAO, MAX(DT_TRANSACAO) AS Ultima_Transacao
FROM TbTransacoes
GROUP BY CD_CLIENTE, CD_TRANSACAO;


# 7. Qual a última transação de cada tipo para cada usuário por mês?

SELECT CD_CLIENTE, CD_TRANSACAO, EXTRACT(MONTH FROM DT_TRANSACAO) AS Mes, MAX(DT_TRANSACAO) AS Ultima_Transacao
FROM TbTransacoes
GROUP BY CD_CLIENTE, CD_TRANSACAO, EXTRACT(MONTH FROM DT_TRANSACAO);


# 8. Qual quatidade de usuários que movimentaram a conta?

SELECT COUNT(DISTINCT CD_CLIENTE) AS Usuarios_Que_Movimentaram
FROM TbTransacoes;

# 9. Qual o balanço do final de 2021?

SELECT c.CD_CLIENTE, 
       COALESCE(SUM(CASE WHEN t.CD_TRANSACAO = '110' THEN t.VR_TRANSACAO 
                         WHEN t.CD_TRANSACAO = '220' THEN -t.VR_TRANSACAO 
                         ELSE t.VR_TRANSACAO END), 0) AS Balanco_Final
FROM TbCliente c
LEFT JOIN TbTransacoes t ON c.CD_CLIENTE = t.CD_CLIENTE
AND t.DT_TRANSACAO <= '2021-12-31'
GROUP BY c.CD_CLIENTE;

# 10. Quantos usuários que receberam CashBack continuaram interagindo com este banco?

WITH CashBackClients AS (
    SELECT DISTINCT CD_CLIENTE
    FROM TbTransacoes
    WHERE CD_TRANSACAO = '000'
)
SELECT COUNT(DISTINCT t.CD_CLIENTE) AS Usuarios_Ativos
FROM TbTransacoes t
JOIN CashBackClients c ON t.CD_CLIENTE = c.CD_CLIENTE
WHERE t.DT_TRANSACAO > '2021-08-28';

# 11. Qual a primeira e a última movimentação dos usuários com saldo maior que R$100?

WITH SaldoMaiorQue100 AS (
    SELECT CD_CLIENTE, SUM(CASE WHEN CD_TRANSACAO = '110' THEN VR_TRANSACAO 
                                WHEN CD_TRANSACAO = '220' THEN -VR_TRANSACAO 
                                ELSE VR_TRANSACAO END) AS Saldo
    FROM TbTransacoes
    GROUP BY CD_CLIENTE
    HAVING SUM(CASE WHEN CD_TRANSACAO = '110' THEN VR_TRANSACAO 
                    WHEN CD_TRANSACAO = '220' THEN -VR_TRANSACAO 
                    ELSE VR_TRANSACAO END) > 100
)
SELECT t.CD_CLIENTE, MIN(t.DT_TRANSACAO) AS Primeira_Movimentacao, MAX(t.DT_TRANSACAO) AS Ultima_Movimentacao
FROM TbTransacoes t
JOIN SaldoMaiorQue100 s ON t.CD_CLIENTE = s.CD_CLIENTE
GROUP BY t.CD_CLIENTE;

# 12. Qual o balanço das últimas quatro movimentações de cada usuário?

WITH LastTransactions AS (
    SELECT CD_CLIENTE, 
           CD_TRANSACAO, 
           VR_TRANSACAO, 
           ROW_NUMBER() OVER (PARTITION BY CD_CLIENTE ORDER BY DT_TRANSACAO DESC) AS RowNum
    FROM TbTransacoes
)
SELECT c.CD_CLIENTE, 
       COALESCE(SUM(CASE WHEN t.CD_TRANSACAO = '110' THEN t.VR_TRANSACAO 
                         WHEN t.CD_TRANSACAO = '220' THEN -t.VR_TRANSACAO 
                         ELSE t.VR_TRANSACAO END), 0) AS Balanco_Ultimas4
FROM TbCliente c
LEFT JOIN LastTransactions t ON c.CD_CLIENTE = t.CD_CLIENTE
WHERE t.RowNum <= 4 OR t.RowNum IS NULL
GROUP BY c.CD_CLIENTE;



# 13. Qual o ticket médio das últimas quatro movimentações de cada usuário?

SELECT c.CD_CLIENTE, 
       COALESCE(SUM(CASE WHEN t.CD_TRANSACAO = '110' THEN t.VR_TRANSACAO 
                         WHEN t.CD_TRANSACAO = '220' THEN -t.VR_TRANSACAO 
                         ELSE t.VR_TRANSACAO END), 0) AS `Balanço_Final_2021`
FROM TbCliente c
LEFT JOIN TbTransacoes t ON c.CD_CLIENTE = t.CD_CLIENTE
AND t.DT_TRANSACAO <= '2021-12-31'
GROUP BY c.CD_CLIENTE;





