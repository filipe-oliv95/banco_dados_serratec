-- TRABALHO GRUPO 7 : PROJETO 2

-- INTEGRANTES:
-- PAULO CEZAR SILVA VICENTE
-- FILIPE CARDOSO OLIVEIRA
-- CRYSTIAN KATSUO KELMER TAKEUCHI
-- RONALDO DE OLIVEIRA AGLIO
-- LUIS FELIPE HAMMES DE MELLO CAMPOS

--------------------------------------
--- DDL - Data Definition Language ---
--------------------------------------

-- Criação das tabelas

-- 1. contato
DROP TABLE IF EXISTS contato;
create table contato (
	id integer primary key autoincrement,
	telefone_fixo integer,
	telefone_movel integer NOT NULL,
	email text NOT NULL UNIQUE
);

-- 2. endereco
DROP TABLE IF EXISTS endereco;
create table endereco (
	id integer primary key autoincrement,
	pais text NOT NULL,
	estado text NOT NULL,
	cep varchar(8) NOT NULL,
	cidade text NOT NULL,
	bairro text NOT NULL,
	rua text NOT NULL,
	numero integer NOT NULL,
	complemento text
);

-- 3. categoria
DROP TABLE IF EXISTS categoria;
create table categoria (
	id integer primary key autoincrement,
	nome varchar(50) NOT NULL UNIQUE,
	descricao text
);

-- 4. usuario
DROP TABLE IF EXISTS usuario;
create table usuario (
	id integer primary key autoincrement,
	nome varchar(50) NOT NULL,
	username varchar(20) NOT NULL UNIQUE,
	cpf varchar(11) NOT NULL UNIQUE,
	data_nascimento date NOT NULL,
	id_endereco integer,
	id_contato integer,
	foreign key(id_endereco) references endereco(id),
	foreign key(id_contato) references contato(id)
);

-- 5. produto
DROP TABLE IF EXISTS produto;
create table produto (
	id integer primary key autoincrement,
	nome text NOT NULL,
	descricao text,
	quantidade integer NOT NULL,
	valor_unit double NOT NULL,
	data_fab date,
	id_vendedor integer,
	id_categoria integer,
	foreign key(id_vendedor) references usuario(id),
	foreign key(id_categoria) references categoria(id)
);

-- 6. usuario_produto_compra
DROP TABLE IF EXISTS usuario_produto_compra;
create table usuario_produto_compra (
	id integer primary key autoincrement,
	data_pedido date NOT NULL,
	quantidade integer NOT NULL,
	id_produto integer,
	id_comprador integer,
	foreign key(id_produto) references produto(id),
	foreign key(id_comprador) references usuario(id)
);

--------------------------------------
-- DML - Data Manipulation Language --
--------------------------------------

-- não permite associar um dado a uma FK que não existe
PRAGMA foreign_keys = ON;

-- Inserção de dados nas tabelas (começando pelas pontas) --

-- 1. contato
insert into contato (telefone_fixo, telefone_movel, email) values 
('2422315876', '24980198806', 'joao@gmail.com'),
('2422497876', '24981947565', 'maria@gmail.com'),
('1122319867', '11998870942', 'guilherme@gmail.com'),
('2422489875', '24957689012', 'pedro@gmail.com'),
('3222256748', '32980978542', 'antonia@gmail.com');

-- 2. endereco 
-- 2.1 sem complemento
insert into endereco (pais, estado, cep, cidade, bairro, rua, numero) values 
('Brasil', 'Amapá', '68909788', 'Macapá', 'Lagoa Azul', 'Rodovia BR-210', 150),
('Brasil', 'Bahia', '44067102', 'Feira de Santana', 'Conceição', 'Rua Carnópolis de Minas', 345),
('Brasil', 'Goiás', '73807820', 'Formosa', 'Jardim Califórnia', 'Rua Turquesa', 7);
-- 2.2 com complemento
insert into endereco (pais, estado, cep, cidade, bairro, rua, numero, complemento) values 
('Brasil', 'Paraná', '83304020', 'Piraquara', 'Vila Rosa', 'Rua José Leal Júnior', 47, 'Rua sem saída'),
('Brasil', 'Pará', '68553254', 'Redenção', 'Núcleo Urbano', 'Rua Três', 158, 'Próximo ao mercado');

-- 3. categoria 
insert into categoria (nome, descricao) values 
('Blusas', 'Camisetas femininas e masculinas'), 
('Calçados', 'Cores neutras e super coloridas'),
('Brinquedos', 'Para crianças e adultos'), 
('Eletrônicos', 'De ultima geração'), 
('Maquiagem', 'Base e afins');

-- 4. usuario 
insert into usuario (nome, username, cpf, data_nascimento, id_endereco, id_contato) values 
('João', 'joao_1', '83367971065', '2000-03-27', 2, 1),
('Maria', 'maria_1', '30109840062', '1995-02-15', 5, 2),
('Guilherme', 'guilherme_1', '15730317042', '1954-09-30', 3, 3),
('Pedro', 'pedro_1', '72380768021', '2004-01-31', 1, 4),
('Antonia', 'antonia_1', '82268575039', '1965-12-25', 4, 5);

-- 5. produto
insert into produto (nome, descricao, quantidade, valor_unit, data_fab, id_vendedor, id_categoria) values 
('Blusa Hello Kit', 'blusa rosa tamanho M', 15, 95, '2023-01-27', 3, 1),
('Tenis Nike', 'revolution preto tamanho 41', 10, 225, '2023-02-17', 4, 2),
('Lousa Mágica', 'lousa branca 30cm', 25, 35, '2023-03-12', 2, 3),
('Iphone 14s', 'super plus branco', 50, 15000, '2023-01-15', 1, 4),
('Pincel de maquiagem', 'tamanho grande', 60, 15, '2023-02-01', 5, 5);

-- 6. usuario_produto_compra (pedido de compra)
insert into usuario_produto_compra (data_pedido, quantidade, id_produto, id_comprador) values 
('2023-03-15', 3, 3, 3),
('2023-03-15', 5, 4, 1),
('2023-03-15', 10, 1, 3),
('2023-03-15', 7, 5, 2),
('2023-03-15', 1, 3, 5),
('2023-03-15', 2, 1, 5),
('2023-03-15', 9, 2, 1);

-- UPDATE
update produto set nome = 'Hot Wheels' where id = 3;
update produto set descricao  = 'Fiat Uno com escada' where id = 3;

-- Atualizando para 30 a quantidade de Tenis Nike no estoque
update produto set quantidade = 30 where id = 2;

-- DELETE
delete from usuario_produto_compra where quantidade > 8;

--------------------------------------
----- DQL - Data Query Language ------
--------------------------------------

-- 1. Quantas compras a Antonia realizou?
select count(*) 
from usuario_produto_compra 
where id_comprador = (select id from usuario where nome = 'Antonia')

-- 2.1 Lista de comprador, produto e quantidade (SEM INNER JOIN)
-- comprador (tabela usuario) | produto (tabela produto) | qntd (tabela usuario_produto_compra)
select u.nome as 'Comprador', p.nome as 'Produto', upc.quantidade as 'Qntd'
from usuario u, produto p, usuario_produto_compra upc 
where u.id = upc.id_comprador and p.id = upc.id_produto 

-- 2.2 Lista de comprador, produto e quantidade (COM INNER JOIN)
select u.nome as 'Comprador', p.nome as 'Produto', upc.quantidade as 'Qntd'
from usuario u, produto p
inner join usuario_produto_compra upc
on u.id = upc.id_comprador and p.id = upc.id_produto 

-- 2.3 Lista dos maiores compradores da plataforma!
select u.nome, sum(upc.quantidade * p.valor_unit)
from usuario u, produto p
inner join usuario_produto_compra upc
on u.id = upc.id_comprador and p.id = upc.id_produto 
group by u.nome order by 2 desc

-- 2.4 O maior comprador da plataforma!
select u.nome, sum(upc.quantidade * p.valor_unit) as 'Total em compras'
from usuario u, produto p
inner join usuario_produto_compra upc
on u.id = upc.id_comprador and p.id = upc.id_produto 
group by u.nome order by 2 desc limit 1

-- 2.5 Lista do valor total em cada produto
select nome as 'Produto', (quantidade * valor_unit) as 'total'
from produto

-- 2.6 Lista do valor total de cada vendedor
select u.nome as 'Vendedor', (p.quantidade * p.valor_unit) as 'total'
from produto p, usuario u
where u.id = p.id_vendedor 

-- 3. Quantidade de vendas por usuario, ordenado por quem vendeu mais
select u.nome as 'Vendedor', sum(upc.quantidade) as 'Vendas'
from usuario u, usuario_produto_compra upc, produto p  
where u.id = p.id_vendedor and p.id = upc.id_produto 
group by u.nome order by 2 desc

-- 4. NOTA FISCAL - ID 1 = João
-- comprador | produto | quantidade | valor unit | valor total | 
select u.nome  as 'comprador', p.nome as 'produto', upc.quantidade as 'qntd',
p.valor_unit as 'valor unit', (p.valor_unit * upc.quantidade) as 'valor total'
from usuario u, produto p, usuario_produto_compra upc
where u.id = upc.id_comprador and p.id = upc.id_produto and u.id = 1
