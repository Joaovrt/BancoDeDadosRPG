--DDL--

--1--
create table Raca
(
	IDRaca int not null identity,
	constraint PKIDRaca primary key (IDRaca),
	Nome varchar(100) not null,
	Descricao varchar(500),
	Origem varchar(150) not null,
	Perdido datetime not null,
)

create table Habilidade
(
	IDHabilidade int not null identity,
	constraint PKIDHabilidade primary key (IDHabilidade),
	Nome varchar(200) not null,
)

create table Classe
(
	IDClasse int not null identity,
	constraint PKIDClasse primary key (IDClasse),
	Nome varchar(100) not null,
	Caracteristicas varchar(1000),
	IDHabilidade int not null,
	constraint FKHabilidade foreign key (IDHabilidade) references Habilidade(IDHabilidade),
)

create table Personagem
(
	IDPersonagem int not null identity,
	constraint PKIDPersonagem primary key (IDPersonagem),
	Nome varchar(100) not null,
	Descricao varchar(500) not null,
	DataNascimento datetime not null,
	IDRaca int not null,
	constraint FKRaca foreign key (IDRaca) references Raca(IDRaca),
	IDClasse int not null,
	constraint FKClasse foreign key (IDClasse) references Classe(IDClasse),
)
--2--
alter table Habilidade add Poder int not null

--3--
alter table Classe alter column Caracteristicas varchar(500)

--4--
alter table Raca drop column Perdido

--DML--

--5--
set dateformat dmy

insert into Raca (Nome, Descricao, Origem) values
('Elfo','Vivem na floresta, exímeis arqueiros.', 'Floresta'),
('Vampiro','Vindos de um mundo onde a noite reina, foram jogados no nosso mundo durante a conjuração das esferas. São rápidos e possuem grande regeneração','Noitosfera'),
('Humano', 'A raça mais abundante e abrangente, são teimosos e obstinados.', 'Continente'),
('Anão','Resilientes e leais, possuem grandes habilidades na forja','Montanhas'),
('Ósteon','Uma raça de esqueletos sencientes antiga e apagada da história.','Desconhecida')

insert into Habilidade (Nome, Poder) values
('Deflagração de mana', 150),
('Conjurar esqueleto', 50),
('Provocar', 30),
('Dilacerar', 110),
('Tiro Preciso', 60)

insert into Classe (Nome, Caracteristicas, IDHabilidade) values
('Arcanista', 'Através do estudo tornou-se capaz de usar sua mana para criar poderosos feitiços.', 1),
('Gatuno', 'Se esgueira em meio as sombras para pegar seus inimigos desprevinidos.', 4),
('Cavaleiro', 'Equipado com uma armadura pesada capaz de resistir a grandes danos.', 3),
('Necromante', 'Usa de sua mana para reanimar os caídos e utiliza-los em batalha.', 2),
('Atirador', null, 5)

insert into Personagem(Nome, Descricao, DataNascimento, IDRaca, IDClasse) values
('Sírius', 'Despertado de seu sono em sua tumba, pretende trazer as sombras uma vez mais a este mundo.', '16-08-1975', 5, 4),
('Zirael', 'Determinada a atingir o ranking mais alto da ordem dos cavaleiros reais, dará tudo de si para proteger os mais fracos.', '24-02-1950', 4, 3),
('Kriton Bigaveron', 'Nascido na grande floresta, treinou suas habilidades com o arco durante séculos até chegar a perfeição.', '10-09-1995', 1, 5),
('Triss', 'Determinada a encontrar um meio de retornar ao seu mundo voltou-se para o estudo das artes arcanas.', '06-06-2002', 2, 1),
('Jenbig Vaslor', 'Cresceu na cidade Meteoro e determinado a sair de lá trilhou o seu caminho até se tornar um dos mais renomados assassinos do submndo.', '30-10-2001', 3, 2)

--6--
update Classe set Caracteristicas = 'Características Gerais' where Caracteristicas is null

--7--
delete from Personagem where year(DataNascimento) between 1970 and 1990

--Select--

--8--
select * from Personagem

--9--
select Nome, Poder from Habilidade where Poder between 0 and 100

--10--
select Nome, Descricao, DataNascimento from Personagem where Nome like '%Big%' and year(DataNascimento) between 1990 and 2000
