--1. Criar uma Stored Procedure que recebe via parâmetro o nome do personagem e retorna (via select) o Nome do Personagem, Ano de Nascimento do Personagem, Nome da Raça, Nome da Classe e Nome da Habilidade 
/*
CREATE OR ALTER PROCEDURE spInfoPersonagem @nome varchar(100)
AS
BEGIN
	SELECT
		A.Nome Nome, 
		YEAR(A.DataNascimento) AnoNascimento, 
		B.Nome Raca,
		C.Nome Classe, 
		D.Nome Habilidade
	FROM Personagem A INNER JOIN Raca B
		ON A.IDRaca = B.IDRaca
			INNER JOIN Classe C
				ON A.IDClasse = C.IDClasse
					INNER JOIN Habilidade D
						ON C.IDHabilidade = D.IDHabilidade
	WHERE A.Nome = @nome
END
GO

EXEC spInfoPersonagem @nome = ''
GO
*/


--2. Criar uma Stored Procedure que recebe via parâmetro um inteiro referente ao ano de nascimento do personagem e retorna via parâmetro de OUTPUT a quantidade de personagens que nasceram no ano informado via parâmetro.
/*
CREATE OR ALTER PROCEDURE spPersonagensPorAno @ano int, @qtd int OUTPUT
AS
BEGIN
	SELECT @qtd = COUNT(DataNascimento) FROM Personagem WHERE YEAR(DataNascimento) = @ano
END
GO

DECLARE @Qtd int
EXEC spPersonagensPorAno ____, @Qtd OUTPUT
PRINT @Qtd
GO
*/


--3. Criar uma Stored Procedure para atualizar a quantidade do valor do Poder da tabela Habilidade. Devem ser informados como parâmetros o ID da Habilidade e a quantidade de pontos a adicionar ou subtrair. Deve ser utilizado o conceito de transações para evitar que a quantidade de pontos fique negativa ou acima de 100 (cem), quando isso ocorrer a operação deve ser “desfeita” e uma mensagem de erro personalizada/customizada deve ser exibida.
/*
CREATE OR ALTER PROCEDURE spAtualizaPoderHabilidade @id int, @pontos int
AS
BEGIN
	DECLARE @novoPoder int
	BEGIN TRAN MyTransaction
		UPDATE Habilidade SET Poder = Poder + @pontos WHERE IDHabilidade = @id
		SELECT @novoPoder = Poder FROM Habilidade WHERE IDHabilidade = @id
		IF @novoPoder>=0 AND @novoPoder<=100
			BEGIN
				COMMIT
				PRINT 'Atualizacao realizada com sucesso'
			END
		ELSE
			BEGIN
				ROLLBACK
				IF @novoPoder<0
					RAISERROR('Operacao desfeita: o Poder deve ser positivo',10,1)
				ELSE
					RAISERROR('Operacao desfeita: o Poder nao pode ultrapassar 100',10,1)
			END
END
GO

EXEC spAtualizaPoderHabilidade @id=_, @pontos=1000000
EXEC spAtualizaPoderHabilidade @id=_, @pontos=-1000000
EXEC spAtualizaPoderHabilidade @id=_, @pontos=30
GO
*/


--4. Criar uma Scalar Function que recebe como parâmetro o IDClasse e retorna a quantidade de Personagens associados/cadastrados. O parâmetro informado deve ser utilizado para filtrar o resultado.
/*
CREATE OR ALTER FUNCTION dbo.fnPersonagensDaClasse(@id int)
RETURNS INT
AS
BEGIN
	DECLARE @qtd int
	SELECT @qtd = COUNT(IDPersonagem) FROM Personagem WHERE IDClasse = @id
	RETURN @qtd
END
GO

SELECT dbo.fnPersonagensDaClasse(_) QtdPersonagens
*/


--5. Criar uma Table Function (Multi-Statement) que recebe como parâmetro um inteiro e conforme o valor recebido deve retornar: a. Valor informado 1: Nome da Classe e a quantidade de personagens associados b. Valor informado 2: Nome da Raça e a quantidade de personagens associados c. Valor informado 3: Nome da Habilidade e a quantidade de personagens associados
/*
CREATE OR ALTER FUNCTION dbo.fnMultiConsultas(@op int)
RETURNS @tabela TABLE (Nome varchar(100), QtdPersonagens int)
AS
BEGIN
	IF @op=1
		INSERT INTO @tabela 
		SELECT 
			A.Nome, COUNT(B.IDPersonagem)
		FROM Classe A INNER JOIN Personagem B
			ON A.IDClasse = B.IDClasse
		GROUP BY A.Nome
	ELSE
		IF @op=2
			INSERT INTO @tabela 
			SELECT 
				A.Nome, COUNT(B.IDPersonagem)
			FROM Raca A INNER JOIN Personagem B
				ON A.IDRaca = B.IDRaca
			GROUP BY A.Nome
		ELSE
			IF @op=3
				INSERT INTO @tabela
				SELECT 
					C.Nome, COUNT(B.IDPersonagem)
				FROM Classe A INNER JOIN Personagem B
					ON A.IDClasse = B.IDClasse
						INNER JOIN Habilidade C
							ON A.IDHabilidade = C.IDHabilidade
				GROUP BY C.Nome
	RETURN
END
GO

SELECT * FROM dbo.fnMultiConsultas(1)
SELECT * FROM dbo.fnMultiConsultas(2)
SELECT * FROM dbo.fnMultiConsultas(3)
GO
*/