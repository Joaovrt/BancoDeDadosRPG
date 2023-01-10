--1. Criar a tabela do Log chamada LogFull conforme detalhes descritos.
/*
CREATE TABLE LogFull
(
	IDLogFull int identity not null,
	Tabela varchar(255) not null,
	Operacao varchar(255) not null,
	Detalhes varchar(1000) not null,
	DataEvento datetime not null,
	CONSTRAINT PKIDLogFull PRIMARY KEY (IDLogFull)
)
*/


--2. Criar uma Trigger que no momento da inserção do Personagem verifique se a idade é maior ou igual a 18 anos (verificar através do campo DataNascimento). Caso não seja a operação deve ser cancelada (rollback).
/*
CREATE OR ALTER TRIGGER tgrVerificaMaioridade
ON Personagem
AFTER INSERT
AS
BEGIN
	DECLARE @idade int
	SET @idade = YEAR(Getdate())
	-(SELECT YEAR(DataNascimento) FROM INSERTED)
	IF @idade<18
		BEGIN
			RAISERROR('Cadastro apenas de maiores de idade!',10,1)
			ROLLBACK
		END
END

--Validacao
SET DATEFORMAT DMY
INSERT INTO Personagem VALUES ('Torbin','Cresceu nas ruas de Mahakam, e lá aprendeu o quão cruel o mundo pode ser.','01-03-2021',4,2)
INSERT INTO Personagem VALUES ('Aladdin','Estudou as artes do arcano em Ban Ard, e as moldou de acordo com sua vontade.','01-03-2000',3,1)
SELECT * FROM Personagem
--DISABLE TRIGGER tgrVerificaMaioridade ON Personagem
--ENABLE TRIGGER tgrVerificaMaioridade ON Personagem
*/


--3. Criar um Trigger para gravar na tabela LogFull as informações referentes a inserção realizada na tabela Personagem. O campo detalhes deve conter o Nome do Personagem, Nome da Raça, Nome da Classe e Nome da Habilidade.
/*
CREATE OR ALTER TRIGGER tgrGravaInsercoes
ON Personagem
AFTER INSERT
AS
BEGIN
	INSERT INTO LogFull SELECT
	'Personagem','Insert',
	'Personagem: '+A.Nome
	+' / Raca: '+B.Nome
	+' / Classe: '+C.Nome
	+' / Habilidade: '+D.Nome,
	GETDATE()
	FROM INSERTED A INNER JOIN Raca B
		ON A.IDRaca=B.IDRaca
			INNER JOIN Classe C
				ON A.IDClasse=C.IDClasse
					INNER JOIN Habilidade D
						ON C.IDHabilidade = D.IDHabilidade
END

--Validacao
SET DATEFORMAT DMY
INSERT INTO Personagem VALUES ('Jasmine','Apesar de sentir saudades de seu mundo decidiu lutar contra as injustiças que encontrou em nosso, roubando dos ricos para distribuir aos pobres.','04-04-2008',2,2),
('Bonhart','Treinado nas mais variadas formas de esgrima foi o mais jovem cavaleiro a ingressar na guarda real.','10-10-2000',3,3)
SELECT * FROM Personagem
SELECT * FROM Raca
SELECT * FROM Classe
SELECT * FROM Habilidade
SELECT * FROM LogFull
--DISABLE TRIGGER tgrGravaInsercoes ON Personagem
--ENABLE TRIGGER tgrGravaInsercoes ON Personagem
*/


--4. Existe a possibilidade de criar o item 2 e 3 em uma única Trigger. Se sim, como ela ficaria?
/*
CREATE OR ALTER TRIGGER tgrVerificaMaioridadeEGravaInsercoes
ON Personagem
AFTER INSERT
AS
BEGIN
	DECLARE @idade int
	SET @idade = YEAR(Getdate())
	-(SELECT YEAR(DataNascimento) FROM INSERTED)
	IF @idade<18
		BEGIN
			RAISERROR('Cadastro apenas de maiores de idade!',10,1)
			ROLLBACK
		END
	ELSE
		BEGIN
			INSERT INTO LogFull SELECT
			'Personagem','Insert',
			'Personagem: '+A.Nome
			+' / Raca: '+B.Nome
			+' / Classe: '+C.Nome
			+' / Habilidade: '+D.Nome,
			GETDATE()
			FROM INSERTED A INNER JOIN Raca B
				ON A.IDRaca=B.IDRaca
					INNER JOIN Classe C
						ON A.IDClasse=C.IDClasse
							INNER JOIN Habilidade D
								ON C.IDHabilidade = D.IDHabilidade
		END
END

--Validacao
SET DATEFORMAT DMY
INSERT INTO Personagem VALUES ('Simba','Não lembra de seu passado, mas se lembra de como disparar uma flecha como ninguém.','05-05-2007',5,2)
INSERT INTO Personagem VALUES ('Scar','Perdeu aqueles que lhe eram queridos, assim voltou-se ao oculto em busca de traze-los de volta.','06-06-1980',1,2)
SELECT * FROM Personagem
SELECT * FROM Raca
SELECT * FROM Classe
SELECT * FROM Habilidade
SELECT * FROM LogFull
--DISABLE TRIGGER tgrVerificaMaioridadeEGravaInsercoes ON Personagem
--ENABLE TRIGGER tgrVerificaMaioridadeEGravaInsercoes ON Personagem
*/


--5. Criar uma Trigger para gravar na tabela LogFull todas as alterações realizadas na tabela Raça. No campo Detalhes dever conter o valor antigo e atual do Nome e Origem.
/*
CREATE OR ALTER TRIGGER tgrGravaAlteracoes
ON Raca
AFTER UPDATE
AS
BEGIN
	INSERT INTO LogFull SELECT	
			'Raca','Update',
			'Antigo Nome: '+A.Nome
			+' / Novo Nome: '+B.Nome
			+' / Antiga Origem: '+A.Origem
			+' / Nova Origem: '+B.Origem,
			GETDATE()
			FROM DELETED A INNER JOIN INSERTED B
				ON A.IDRaca=B.IDRaca
END

--Validacao
UPDATE Raca SET Nome = 'Troll', Origem = 'Cavernas' WHERE IDRaca = 1
SELECT * FROM Raca
SELECT * FROM LogFull
--DISABLE TRIGGER tgrGravaAlteracoes ON Raca
--ENABLE TRIGGER tgrGravaAlteracoes ON Raca
*/


--6. Criar uma Trigger para gravar na tabela LogFull todas as exclusões realizadas na tabela Habilidade. No campo Detalhes deve conter o ID, Nome e o valor do Poder que está sendo excluído.
/*
CREATE OR ALTER TRIGGER tgrGravaExclusoes
ON Habilidade
AFTER DELETE
AS
BEGIN
	INSERT INTO LogFull SELECT
			'Habilidade','Delete',
			'ID: '+CAST(IDHabilidade as varchar)
			+' / Nome: '+Nome
			+' / Poder: '+CAST(Poder as varchar),
			GETDATE()
			FROM DELETED
END

--Validacao
DELETE FROM Personagem WHERE IDClasse = 3
DELETE FROM Classe WHERE IDClasse = 3
DELETE FROM Habilidade WHERE IDHabilidade =3
SELECT * FROM Personagem
SELECT * FROM Classe
SELECT * FROM Habilidade
SELECT * FROM LogFull
--DISABLE TRIGGER tgrGravaExclusoes ON Habilidade
--ENABLE TRIGGER tgrGravaExclusoes ON Habilidade
*/