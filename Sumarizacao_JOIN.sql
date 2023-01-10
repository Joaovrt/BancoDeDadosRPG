--Grupo Banco de Dados LAB
--João Victor Rosa Tagliarini 210124
--José Antônio Soares Pinto 210430
--Matheus Aparecido de Oliveira Ramos 210388

--1--
SELECT COUNT(IDHabilidade) QtdHabilidades FROM Habilidade

--2--
SELECT MAX(DataNascimento) PersonagemMaisNovo,  
	   MIN(DataNascimento) PersonagemMaisVelho
FROM Personagem

--3--
SELECT
	A.Nome Classe, COUNT(B.IDPersonagem) QtdPersonagens
FROM Classe A LEFT JOIN Personagem B
	ON A.IDClasse = B.IDClasse
GROUP BY A.Nome

--4--
SELECT
	A.Nome Raca, COUNT(B.IDPersonagem) QtdPersonagens
FROM Raca A LEFT JOIN Personagem B
	ON A.IDRaca = B.IDRaca
GROUP BY A.Nome

--5--
SELECT
	A.Nome Classe, AVG(B.Poder) MediaPoderes
FROM Classe A INNER JOIN Habilidade B
	ON A.IDHabilidade = B.IDHabilidade
GROUP BY A.Nome 
HAVING AVG(B.Poder)>=100

--6--
SELECT
	A.Nome Classe, SUM(B.Poder) SomaPoderes
FROM
	Classe A INNER JOIN Habilidade B
	ON A.IDHabilidade = B.IDHabilidade
GROUP BY A.Nome 
HAVING SUM(B.Poder) BETWEEN 150 AND 250

--7--
SELECT
	A.Nome Nome, A.DataNascimento, B.Nome Raca,
	C.Nome Classe, D.Nome Habilidade
FROM Personagem A INNER JOIN Raca B
	ON A.IDRaca = B.IDRaca
		INNER JOIN Classe C
			ON A.IDClasse = C.IDClasse
				INNER JOIN Habilidade D
					ON C.IDHabilidade = D.IDHabilidade