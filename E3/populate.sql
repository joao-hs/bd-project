drop table categoria cascade;
drop table categoria_simples cascade;
drop table super_categoria cascade;
drop table tem_outra cascade;
drop table produto cascade;
drop table tem_categoria cascade;
drop table ivm cascade;
drop table ponto_de_retalho cascade;
drop table instalada_em cascade;
drop table prateleira cascade;
drop table planograma cascade;
drop table retalhista cascade;
drop table responsavel_por cascade;
drop table evento_reposicao cascade;
--------------------

create table categoria
   (categoria_nome 	varchar(80)	not null unique,
    constraint pk_categoria primary key(categoria_nome));

create table categoria_simples
   (categoria_simples_nome  varchar(80)	not null unique,
    constraint pk_categoria_simples primary key(categoria_simples_nome),
    constraint fk_categoria_simples_categoria foreign key(categoria_simples_nome) references categoria(categoria_nome));
    
create table super_categoria
   (super_categoria_nome    varchar(80)    not null unique,
    constraint pk_super_categoria primary key(super_categoria_nome),
    constraint fk_super_categoria_categoria foreign key(super_categoria_nome) references categoria(categoria_nome));
    
create table tem_outra
    (super_categoria_nome varchar(80) not null,
    categoria_nome varchar(80) not null unique,
    constraint pk_tem_outra primary key(categoria_nome),
    constraint fk_tem_outra_super_categoria foreign key(super_categoria_nome) references super_categoria(super_categoria_nome),
    constraint fk_tem_outra_categoria foreign key(categoria_nome) references categoria(categoria_nome));

create table produto
    (ean numeric(13) not null unique,
     categoria_simples_nome varchar(80) not null,
     descr varchar(50) not null,
     constraint pk_produto primary key(ean),
     constraint fk_produto_categoria_simples foreign key(categoria_simples_nome) references categoria_simples(categoria_simples_nome));

create table tem_categoria
    (ean numeric(13) not null,
     categoria_simples_nome varchar(80) not null,
     constraint pk_tem_categoria primary key(ean),
     constraint fk_tem_categoria_produto foreign key(ean) references produto(ean),
     constraint fk_tem_categoria_categoria foreign key(categoria_simples_nome) references categoria_simples(categoria_simples_nome));

create table ivm
    (num_serie numeric(13) not null,
     fabricante varchar(80) not null,
     constraint pk_ivm primary key(num_serie, fabricante));
    
create table ponto_de_retalho
    (ponto_de_retalho_nome varchar(80) not null unique,
     concelho varchar(80) not null,
     distrito varchar(80) not null,
     constraint pk_ponto_de_retalho primary key(ponto_de_retalho_nome));

create table instalada_em
    (num_serie numeric(13) not null,
     fabricante varchar(80) not null,
     ponto_de_retalho_nome varchar(80) not null,
     constraint pk_instalada_em primary key(num_serie, fabricante),
     constraint fk_instalada_em_ivm foreign key(num_serie, fabricante) references ivm(num_serie, fabricante),
     constraint fk_instalada_em_ponto_de_retalho foreign key(ponto_de_retalho_nome) references ponto_de_retalho(ponto_de_retalho_nome));
     
create table prateleira
    (num_prateleira numeric(2) not null,
     num_serie numeric(13) not null,
     fabricante varchar(80) not null,
     altura numeric(3) not null,
     categoria_simples_nome varchar(80) not null,
     constraint pk_prateleira primary key(num_prateleira, num_serie, fabricante),
     constraint fk_instalada_em_ivm foreign key(num_serie, fabricante) references ivm(num_serie, fabricante),
     constraint fk_tem_categoria_categoria_simples foreign key(categoria_simples_nome) references categoria_simples(categoria_simples_nome));

create table planograma
    (ean numeric(13) not null,
     num_prateleira numeric(2) not null,
     num_serie numeric(13) not null,
     fabricante varchar(80) not null,
     faces numeric(2) not null,
     unidades numeric(2) not null,
     loc varchar(80) not null,
     constraint pk_planograma primary key(ean, num_prateleira, num_serie, fabricante),
     constraint fk_planograma_produto foreign key(ean) references produto(ean),
     constraint fk_planograma_prateleira foreign key(num_prateleira, num_serie, fabricante) references prateleira(num_prateleira, num_serie, fabricante));

create table retalhista
    (tin numeric(13) not null unique,
     retalhista_nome varchar(80) not null unique,
     constraint pk_retalhista primary key(tin));

create table responsavel_por
    (tin numeric(13) not null,
     num_serie numeric(13) not null,
     fabricante varchar(80) not null,
     constraint pk_responsavel_por primary key(num_serie, fabricante),
     constraint fk_responsavel_por_retalhista foreign key(tin) references retalhista(tin),
     constraint fk_responsavel_por_ivm foreign key(num_serie, fabricante) references ivm(num_serie, fabricante));

create table evento_reposicao
    (ean numeric(13) not null,
     num_prateleira numeric(2) not null,
     num_serie numeric(13) not null,
     fabricante varchar(80) not null,
     instante timestamp without time zone,
     unidades numeric(4) not null,
     tin numeric(13) not null,
     constraint pk_evento_reposicao primary key(ean, num_prateleira, num_serie, fabricante, instante),
     constraint fk_evento_reposicao_retalhista foreign key(tin) references retalhista(tin),
     constraint fk_evento_reposicao_planograma foreign key(ean, num_prateleira, num_serie, fabricante) references planograma(ean, num_prateleira, num_serie, fabricante));


---------------------------------------- 
----------------------------------------

-- insert into categoria values (categoria_nome)
insert into categoria values ('Bebidas');
insert into categoria values ('Águas');
insert into categoria values ('Laticinios');
insert into categoria values ('Bebidas Quentes');
insert into categoria values ('Bebidas Frias');
insert into categoria values ('Refrigerantes');
insert into categoria values ('Bebidas Energéticas');
insert into categoria values ('Sumos');
insert into categoria values ('Bebidas  Alcoólicas');
insert into categoria values ('Cafés');
insert into categoria values ('Chás e Chocolates');
insert into categoria values ('Comida');
insert into categoria values ('Pastelaria');
insert into categoria values ('Aperitivos');
insert into categoria values ('Enlatados');
insert into categoria values ('Aperitivos Doces');
insert into categoria values ('Aperitivos Salgados');
insert into categoria values ('Bolachas');
insert into categoria values ('Chocolates');
insert into categoria values ('Gomas');
insert into categoria values ('Batatas Fritas');
insert into categoria values ('Sandes');
insert into categoria values ('Bolos');
insert into categoria values ('Salgados');
insert into categoria values ('Frutas');
insert into categoria values ('Outros');
insert into categoria values ('Consumíveis');
insert into categoria values ('Higiene e Saude');
insert into categoria values ('Papelaria');
insert into categoria values ('Gelo');
insert into categoria values ('Pastilhas');

-- insert into categoria_simples values (categoria_simples_nome)
insert into categoria_simples values ('Águas');
insert into categoria_simples values ('Laticinios');
insert into categoria_simples values ('Refrigerantes');
insert into categoria_simples values ('Bebidas Energéticas');
insert into categoria_simples values ('Sumos');
insert into categoria_simples values ('Bebidas  Alcoólicas');
insert into categoria_simples values ('Cafés');
insert into categoria_simples values ('Chás e Chocolates');
insert into categoria_simples values ('Enlatados');
insert into categoria_simples values ('Bolachas');
insert into categoria_simples values ('Chocolates');
insert into categoria_simples values ('Gomas');
insert into categoria_simples values ('Batatas Fritas');
insert into categoria_simples values ('Sandes');
insert into categoria_simples values ('Bolos');
insert into categoria_simples values ('Salgados');
insert into categoria_simples values ('Frutas');
insert into categoria_simples values ('Higiene e Saude');
insert into categoria_simples values ('Papelaria');
insert into categoria_simples values ('Gelo');
insert into categoria_simples values ('Pastilhas');

-- insert into super_categoria values (super_categoria_nome)
insert into super_categoria values ('Bebidas');
insert into super_categoria values ('Bebidas Quentes');
insert into super_categoria values ('Bebidas Frias');
insert into super_categoria values ('Comida');
insert into super_categoria values ('Pastelaria');
insert into super_categoria values ('Aperitivos');
insert into super_categoria values ('Aperitivos Doces');
insert into super_categoria values ('Aperitivos Salgados');
insert into super_categoria values ('Outros');
insert into super_categoria values ('Consumíveis');

-- insert into tem_outra values (super_categoria_nome, categoria_nome)
insert into tem_outra values ('Bebidas', 'Laticinios');
insert into tem_outra values ('Bebidas', 'Águas');
insert into tem_outra values ('Bebidas', 'Bebidas Quentes');
insert into tem_outra values ('Bebidas', 'Bebidas Frias');
insert into tem_outra values ('Bebidas Quentes', 'Cafés');
insert into tem_outra values ('Bebidas Quentes', 'Chás e Chocolates');
insert into tem_outra values ('Bebidas Frias', 'Refrigerantes');
insert into tem_outra values ('Bebidas Frias', 'Sumos');
insert into tem_outra values ('Bebidas Frias', 'Bebidas Energéticas');
insert into tem_outra values ('Bebidas Frias', 'Bebidas Alcoólicas');
insert into tem_outra values ('Comida', 'Enlatados');
insert into tem_outra values ('Comida', 'Frutas');
insert into tem_outra values ('Comida', 'Pastelaria');
insert into tem_outra values ('Comida', 'Aperitivos');
insert into tem_outra values ('Pastelaria', 'Sandes');
insert into tem_outra values ('Pastelaria', 'Bolos');
insert into tem_outra values ('Pastelaria', 'Salgados');
insert into tem_outra values ('Aperitivos', 'Bolachas');
insert into tem_outra values ('Aperitivos', 'Aperitivos Doces');
insert into tem_outra values ('Aperitivos', 'Aperitivos Salgados');
insert into tem_outra values ('Aperitivos Doces', 'Gomas');
insert into tem_outra values ('Aperitivos Doces', 'Chocolates');
insert into tem_outra values ('Aperitivos Salgados', 'Batatas Fritas');
insert into tem_outra values ('Outros', 'Consumíveis');
insert into tem_outra values ('Outros', 'Papelaria');
insert into tem_outra values ('Outros', 'Gelo');
insert into tem_outra values ('Consumíveis', 'Pastilhas');

-- insert into produto values (ean, categoria_simples_nome, descr)
insert into produto values (8277017071665, 'Águas', 'Luso');
insert into produto values (5344744972884, 'Águas', 'Vitalis');
insert into produto values (1468742349281, 'Águas', 'Voss');
insert into produto values (6933349746483, 'Águas', 'Evian');
insert into produto values (3624127013048, 'Águas', 'Água das Pedras');
insert into produto values (7436239398082, 'Águas', 'Healsi');
insert into produto values (6695451872988, 'Águas', 'Friz');
insert into produto values (9309433720727, 'Águas', 'Monchique');
insert into produto values (4364545572541, 'Laticinios', 'Leite Gordo');
insert into produto values (8004343337244, 'Laticinios', 'Leite Meio-Gordo');
insert into produto values (1792119494879, 'Laticinios', 'Leite Magro');
insert into produto values (1786796992737, 'Laticinios', 'Ucal');
insert into produto values (4773510772361, 'Laticinios', 'Leite Morango');
insert into produto values (4507514029325, 'Laticinios', 'Leite Baunilha');
insert into produto values (2393828982064, 'Laticinios', 'Leite Banana');
insert into produto values (7990558838340, 'Laticinios', 'Leite Amendoa');
insert into produto values (4120646065829, 'Laticinios', 'Leite Soja');
insert into produto values (9148643601559, 'Laticinios', 'Leite Aveia');
insert into produto values (1970399813258, 'Refrigerantes', 'Coca-Cola');
insert into produto values (1415920407258, 'Refrigerantes', 'Pepsi');
insert into produto values (9436423843998, 'Refrigerantes', 'Ice Tea Limão');
insert into produto values (4116446086554, 'Refrigerantes', 'Sumol Laranja');
insert into produto values (4007856375212, 'Refrigerantes', 'Ice Tea Manga');
insert into produto values (1591885619623, 'Refrigerantes', 'Ice Tea Pessego');
insert into produto values (7949296596870, 'Refrigerantes', '7-up');
insert into produto values (9056373519185, 'Refrigerantes', 'Sumol Ananás');
insert into produto values (7862531865560, 'Refrigerantes', 'Fanta');
insert into produto values (5845675049179, 'Bebidas Energéticas', 'Redbull');
insert into produto values (8995534805862, 'Bebidas Energéticas', 'Redbull s/açucar');
insert into produto values (9972128589711, 'Bebidas Energéticas', 'Redbull Açaí');
insert into produto values (3433756858371, 'Bebidas Energéticas', 'Monster');
insert into produto values (5778006673339, 'Bebidas Energéticas', 'Burn');
insert into produto values (5422437870366, 'Bebidas Energéticas', 'Power+');
insert into produto values (6322066117311, 'Sumos', 'Compal Pera');
insert into produto values (4838583824881, 'Sumos', 'Compal Pessego');
insert into produto values (3004067520289, 'Sumos', 'Compal Manga');
insert into produto values (7867281547047, 'Sumos', 'Bongo');
insert into produto values (1388502170230, 'Sumos', 'Compal Laranja');
insert into produto values (2512806864646, 'Sumos', 'Sumo Laranja');
insert into produto values (8564323381223, 'Sumos', 'Limonada');
insert into produto values (3006258109754, 'Sumos', 'Sumo Frutos Vermelhos');
insert into produto values (1588368862294, 'Sumos', 'Compal Maçã');
insert into produto values (2972633052179, 'Bebidas Alcoólicas', 'Sagres');
insert into produto values (1961762608074, 'Bebidas Alcoólicas', 'Heineken');
insert into produto values (1943670441172, 'Bebidas Alcoólicas', 'Super Bock');
insert into produto values (1985742792864, 'Bebidas Alcoólicas', 'Sommersby');
insert into produto values (3410536415212, 'Bebidas Alcoólicas', 'Sommersby Frutos Vermelhos');
insert into produto values (7609421540708, 'Bebidas Alcoólicas', 'Bandida do Pomar');
insert into produto values (5603455607276, 'Bebidas Alcoólicas', 'Heineken Silver');
insert into produto values (9743550131525, 'Bebidas Alcoólicas', 'Crystal');
insert into produto values (2966486261635, 'Bebidas Alcoólicas', 'Argos');
insert into produto values (6832765095131, 'Bebidas Alcoólicas', 'Vinho Tinto');
insert into produto values (8030185700094, 'Bebidas Alcoólicas', 'Sangria');
insert into produto values (1767913590362, 'Cafés', 'Starbucks Latte');
insert into produto values (8951474757057, 'Cafés', 'Starbucks Latte Caramelo');
insert into produto values (4578369174019, 'Cafés', 'Go Chill Latte');
insert into produto values (1083824667588, 'Cafés', 'Go Chill Latte Caramelo');
insert into produto values (4363392137051, 'Cafés', 'Go Chill Latte Aveia');
insert into produto values (1625550139699, 'Chás e Chocolates', 'Chocolate Quente');
insert into produto values (4161276977659, 'Chás e Chocolates', 'Chocolate Branco Quente');
insert into produto values (4872647741072, 'Chás e Chocolates', 'Chá Verde');
insert into produto values (1071900184324, 'Chás e Chocolates', 'Matcha');
insert into produto values (2419370101677, 'Chás e Chocolates', 'Chá Preto');
insert into produto values (5311121102624, 'Enlatados', 'Atum Tenorio');
insert into produto values (7940229787025, 'Enlatados', 'Atum');
insert into produto values (2453609540508, 'Enlatados', 'Salsichas');
insert into produto values (5243209551946, 'Enlatados', 'Salsichas Aves');
insert into produto values (5775680912367, 'Enlatados', 'Salsichas Vegan');
insert into produto values (2340891527939, 'Frutas', 'Banana');
insert into produto values (6471869716982, 'Frutas', 'Maçã');
insert into produto values (5739588863582, 'Frutas', 'Ananás');
insert into produto values (5701128114035, 'Frutas', 'Pera');
insert into produto values (8394027391764, 'Frutas', 'Melancia');
insert into produto values (8165576689366, 'Frutas', 'Uvas');
insert into produto values (7813862519536, 'Frutas', 'Pessego');
insert into produto values (8940554794292, 'Bolachas', 'Oreos');
insert into produto values (3759784226315, 'Bolachas', 'Tuc');
insert into produto values (2573778806042, 'Bolachas', 'Tuc Presunto');
insert into produto values (8613107322864, 'Bolachas', 'Bolachas Agua e Sal');
insert into produto values (3345786165241, 'Bolachas', 'Philipinos');
insert into produto values (7362307416070, 'Bolachas', 'Bolachas Digestivas');
insert into produto values (1519997189837, 'Chocolates', 'M&M');
insert into produto values (7917634690250, 'Chocolates', 'M&M amendoim');
insert into produto values (5985409804091, 'Chocolates', 'M&M crispy');
insert into produto values (8377810473507, 'Chocolates', 'Kinder Bueno');
insert into produto values (5684394684188, 'Chocolates', 'Kinder Delice');
insert into produto values (8653781909919, 'Chocolates', 'Maltesers');
insert into produto values (6227218275617, 'Chocolates', 'Snickers');
insert into produto values (5788004280332, 'Chocolates', 'Twix');
insert into produto values (7883969941806, 'Chocolates', 'Mars');
insert into produto values (1052886131386, 'Chocolates', 'Smarties');
insert into produto values (2510353769360, 'Chocolates', 'Kinder');
insert into produto values (7845004830427, 'Chocolates', 'Bounty');
insert into produto values (5248846151702, 'Gomas', 'Haribo Ursos');
insert into produto values (2987948307130, 'Gomas', 'Haribo Starmix');
insert into produto values (7878616034728, 'Gomas', 'Haribo Favoritos');
insert into produto values (8450196743835, 'Gomas', 'Haribo Happy Cola');
insert into produto values (2479220216657, 'Gomas', 'Haribo Marshmallows');
insert into produto values (7403498365885, 'Gomas', 'Haribo Spaghetti');
insert into produto values (2149472099442, 'Gomas', 'Vidal Melancias');
insert into produto values (2348262137248, 'Gomas', 'Vidal Sortido');
insert into produto values (6603850730999, 'Gomas', 'Vidal Rainbow Belts');
insert into produto values (3125750693139, 'Batatas Fritas', 'Lays Gourmet');
insert into produto values (9625587832897, 'Batatas Fritas', 'Lays Light');
insert into produto values (5403360903101, 'Batatas Fritas', 'Lays Forno');
insert into produto values (6219541830862, 'Batatas Fritas', 'Ruffles Original');
insert into produto values (6514243268757, 'Batatas Fritas', 'Lays Original');
insert into produto values (8616611752094, 'Batatas Fritas', 'Pringles');
insert into produto values (2284344530635, 'Batatas Fritas', 'Pringles Paprika');
insert into produto values (8439455499278, 'Batatas Fritas', 'Pringles Sour Cream');
insert into produto values (5459415942837, 'Sandes', 'Sandes Queijo');
insert into produto values (6650262439477, 'Sandes', 'Sandes Queijo e Fiambre');
insert into produto values (4087699796587, 'Sandes', 'Sandes Presunto');
insert into produto values (8118918266130, 'Sandes', 'Hamburguer');
insert into produto values (1085234046721, 'Sandes', 'Hot Dog');
insert into produto values (1555053245786, 'Sandes', 'Hamburguer Queijo');
insert into produto values (9584833690590, 'Sandes', 'Sandes Vegan');
insert into produto values (8533636365161, 'Bolos', 'Waffle');
insert into produto values (2505292620512, 'Bolos', 'Waffle Chocolate');
insert into produto values (5947269556256, 'Bolos', 'Croissant Chocolate');
insert into produto values (1041036705095, 'Bolos', 'Croissant Creme');
insert into produto values (5932150501379, 'Bolos', 'Bolo Chocolate');
insert into produto values (6025014063287, 'Bolos', 'Bolo Cenoura');
insert into produto values (1025943703805, 'Bolos', 'Donut');
insert into produto values (5846218715704, 'Bolos', 'Donut Chocolate');
insert into produto values (3988656542326, 'Salgados', 'Folhado Misto');
insert into produto values (6075239865358, 'Salgados', 'Croquete');
insert into produto values (2360325987130, 'Salgados', 'Croquete Espinafres');
insert into produto values (9449159705966, 'Salgados', 'Folhado Espinafres');
insert into produto values (8364840225124, 'Salgados', 'Folhado Pizza');
insert into produto values (1284354657704, 'Salgados', 'Pizza Queijo');
insert into produto values (8776563521432, 'Salgados', 'Pizza Queijo e Fiambre');
insert into produto values (5493181691267, 'Salgados', 'Pão com Choriço');
insert into produto values (7154465797509, 'Higiene e Saude', 'Lenços');
insert into produto values (8519339191682, 'Higiene e Saude', 'Lenços Perfumados');
insert into produto values (1517011948532, 'Higiene e Saude', 'Máscaras Cirugicas');
insert into produto values (3892977199091, 'Higiene e Saude', 'Teste Covid-19');
insert into produto values (3418608887277, 'Higiene e Saude', 'Gel Desinfetante');
insert into produto values (1528910470243, 'Higiene e Saude', 'Repelente Mosquitos');
insert into produto values (1746191137346, 'Higiene e Saude', 'Fralda');
insert into produto values (1675328415728, 'Higiene e Saude', 'Toalhitas Humidas');
insert into produto values (3124727371836, 'Higiene e Saude', 'Algodão');
insert into produto values (5452149204981, 'Higiene e Saude', 'Álcool');
insert into produto values (5292599744895, 'Higiene e Saude', 'Betadine');
insert into produto values (0321302005519, 'Papelaria', 'Canetas Pretas');
insert into produto values (4176419843554, 'Papelaria', 'Canetas Azuis');
insert into produto values (3507797043457, 'Papelaria', 'Canetas Mix');
insert into produto values (3705347281078, 'Papelaria', 'Lapis');
insert into produto values (8870652112264, 'Papelaria', 'Borrachas');
insert into produto values (1111538823771, 'Papelaria', 'Corretor');
insert into produto values (2888818377511, 'Gelo', 'Gelo instantaneo');
insert into produto values (6347772554585, 'Pastilhas', 'Tridente Menta');
insert into produto values (1837598307905, 'Pastilhas', 'Tridente Morango');
insert into produto values (5752011825267, 'Pastilhas', 'Tridente Oral-B');
insert into produto values (8421250231352, 'Pastilhas', 'Tridente Frutos Vermelhos');

-- insert into tem_categoria values (ean, categoria_simples_nome)
insert into tem_categoria values (8277017071665, 'Águas');
insert into tem_categoria values (5344744972884, 'Águas');
insert into tem_categoria values (1468742349281, 'Águas');
insert into tem_categoria values (6933349746483, 'Águas');
insert into tem_categoria values (3624127013048, 'Águas');
insert into tem_categoria values (7436239398082, 'Águas');
insert into tem_categoria values (6695451872988, 'Águas');
insert into tem_categoria values (9309433720727, 'Águas');
insert into tem_categoria values (4364545572541, 'Laticinios');
insert into tem_categoria values (8004343337244, 'Laticinios');
insert into tem_categoria values (1792119494879, 'Laticinios');
insert into tem_categoria values (1786796992737, 'Laticinios');
insert into tem_categoria values (4773510772361, 'Laticinios');
insert into tem_categoria values (4507514029325, 'Laticinios');
insert into tem_categoria values (2393828982064, 'Laticinios');
insert into tem_categoria values (7990558838340, 'Laticinios');
insert into tem_categoria values (4120646065829, 'Laticinios');
insert into tem_categoria values (9148643601559, 'Laticinios');
insert into tem_categoria values (1970399813258, 'Refrigerantes');
insert into tem_categoria values (1415920407258, 'Refrigerantes');
insert into tem_categoria values (9436423843998, 'Refrigerantes');
insert into tem_categoria values (4116446086554, 'Refrigerantes');
insert into tem_categoria values (4007856375212, 'Refrigerantes');
insert into tem_categoria values (1591885619623, 'Refrigerantes');
insert into tem_categoria values (7949296596870, 'Refrigerantes');
insert into tem_categoria values (9056373519185, 'Refrigerantes');
insert into tem_categoria values (7862531865560, 'Refrigerantes');
insert into tem_categoria values (5845675049179, 'Bebidas Energéticas');
insert into tem_categoria values (8995534805862, 'Bebidas Energéticas');
insert into tem_categoria values (9972128589711, 'Bebidas Energéticas');
insert into tem_categoria values (3433756858371, 'Bebidas Energéticas');
insert into tem_categoria values (5778006673339, 'Bebidas Energéticas');
insert into tem_categoria values (5422437870366, 'Bebidas Energéticas');
insert into tem_categoria values (6322066117311, 'Sumos');
insert into tem_categoria values (4838583824881, 'Sumos');
insert into tem_categoria values (3004067520289, 'Sumos');
insert into tem_categoria values (7867281547047, 'Sumos');
insert into tem_categoria values (1388502170230, 'Sumos');
insert into tem_categoria values (2512806864646, 'Sumos');
insert into tem_categoria values (8564323381223, 'Sumos');
insert into tem_categoria values (3006258109754, 'Sumos');
insert into tem_categoria values (1588368862294, 'Sumos');
insert into tem_categoria values (2972633052179, 'Bebidas Alcoólicas');
insert into tem_categoria values (1961762608074, 'Bebidas Alcoólicas');
insert into tem_categoria values (1943670441172, 'Bebidas Alcoólicas');
insert into tem_categoria values (1985742792864, 'Bebidas Alcoólicas');
insert into tem_categoria values (3410536415212, 'Bebidas Alcoólicas');
insert into tem_categoria values (7609421540708, 'Bebidas Alcoólicas');
insert into tem_categoria values (5603455607276, 'Bebidas Alcoólicas');
insert into tem_categoria values (9743550131525, 'Bebidas Alcoólicas');
insert into tem_categoria values (2966486261635, 'Bebidas Alcoólicas');
insert into tem_categoria values (6832765095131, 'Bebidas Alcoólicas');
insert into tem_categoria values (8030185700094, 'Bebidas Alcoólicas');
insert into tem_categoria values (1767913590362, 'Cafés');
insert into tem_categoria values (8951474757057, 'Cafés');
insert into tem_categoria values (4578369174019, 'Cafés');
insert into tem_categoria values (1083824667588, 'Cafés');
insert into tem_categoria values (4363392137051, 'Cafés');
insert into tem_categoria values (1625550139699, 'Chás e Chocolates');
insert into tem_categoria values (4161276977659, 'Chás e Chocolates');
insert into tem_categoria values (4872647741072, 'Chás e Chocolates');
insert into tem_categoria values (1071900184324, 'Chás e Chocolates');
insert into tem_categoria values (2419370101677, 'Chás e Chocolates');
insert into tem_categoria values (5311121102624, 'Enlatados');
insert into tem_categoria values (7940229787025, 'Enlatados');
insert into tem_categoria values (2453609540508, 'Enlatados');
insert into tem_categoria values (5243209551946, 'Enlatados');
insert into tem_categoria values (5775680912367, 'Enlatados');
insert into tem_categoria values (2340891527939, 'Frutas');
insert into tem_categoria values (6471869716982, 'Frutas');
insert into tem_categoria values (5739588863582, 'Frutas');
insert into tem_categoria values (5701128114035, 'Frutas');
insert into tem_categoria values (8394027391764, 'Frutas');
insert into tem_categoria values (8165576689366, 'Frutas');
insert into tem_categoria values (7813862519536, 'Frutas');
insert into tem_categoria values (8940554794292, 'Bolachas');
insert into tem_categoria values (3759784226315, 'Bolachas');
insert into tem_categoria values (2573778806042, 'Bolachas');
insert into tem_categoria values (8613107322864, 'Bolachas');
insert into tem_categoria values (3345786165241, 'Bolachas');
insert into tem_categoria values (7362307416070, 'Bolachas');
insert into tem_categoria values (1519997189837, 'Chocolates');
insert into tem_categoria values (7917634690250, 'Chocolates');
insert into tem_categoria values (5985409804091, 'Chocolates');
insert into tem_categoria values (8377810473507, 'Chocolates');
insert into tem_categoria values (5684394684188, 'Chocolates');
insert into tem_categoria values (8653781909919, 'Chocolates');
insert into tem_categoria values (6227218275617, 'Chocolates');
insert into tem_categoria values (5788004280332, 'Chocolates');
insert into tem_categoria values (7883969941806, 'Chocolates');
insert into tem_categoria values (1052886131386, 'Chocolates');
insert into tem_categoria values (2510353769360, 'Chocolates');
insert into tem_categoria values (7845004830427, 'Chocolates');
insert into tem_categoria values (5248846151702, 'Gomas');
insert into tem_categoria values (2987948307130, 'Gomas');
insert into tem_categoria values (7878616034728, 'Gomas');
insert into tem_categoria values (8450196743835, 'Gomas');
insert into tem_categoria values (2479220216657, 'Gomas');
insert into tem_categoria values (7403498365885, 'Gomas');
insert into tem_categoria values (2149472099442, 'Gomas');
insert into tem_categoria values (2348262137248, 'Gomas');
insert into tem_categoria values (6603850730999, 'Gomas');
insert into tem_categoria values (3125750693139, 'Batatas Fritas');
insert into tem_categoria values (9625587832897, 'Batatas Fritas');
insert into tem_categoria values (5403360903101, 'Batatas Fritas');
insert into tem_categoria values (6219541830862, 'Batatas Fritas');
insert into tem_categoria values (6514243268757, 'Batatas Fritas');
insert into tem_categoria values (8616611752094, 'Batatas Fritas');
insert into tem_categoria values (2284344530635, 'Batatas Fritas');
insert into tem_categoria values (8439455499278, 'Batatas Fritas');
insert into tem_categoria values (5459415942837, 'Sandes');
insert into tem_categoria values (6650262439477, 'Sandes');
insert into tem_categoria values (4087699796587, 'Sandes');
insert into tem_categoria values (8118918266130, 'Sandes');
insert into tem_categoria values (1085234046721, 'Sandes');
insert into tem_categoria values (1555053245786, 'Sandes');
insert into tem_categoria values (9584833690590, 'Sandes');
insert into tem_categoria values (8533636365161, 'Bolos');
insert into tem_categoria values (2505292620512, 'Bolos');
insert into tem_categoria values (5947269556256, 'Bolos');
insert into tem_categoria values (1041036705095, 'Bolos');
insert into tem_categoria values (5932150501379, 'Bolos');
insert into tem_categoria values (6025014063287, 'Bolos');
insert into tem_categoria values (1025943703805, 'Bolos');
insert into tem_categoria values (5846218715704, 'Bolos');
insert into tem_categoria values (3988656542326, 'Salgados');
insert into tem_categoria values (6075239865358, 'Salgados');
insert into tem_categoria values (2360325987130, 'Salgados');
insert into tem_categoria values (9449159705966, 'Salgados');
insert into tem_categoria values (8364840225124, 'Salgados');
insert into tem_categoria values (1284354657704, 'Salgados');
insert into tem_categoria values (8776563521432, 'Salgados');
insert into tem_categoria values (5493181691267, 'Salgados');
insert into tem_categoria values (7154465797509, 'Higiene e Saude');
insert into tem_categoria values (8519339191682, 'Higiene e Saude');
insert into tem_categoria values (1517011948532, 'Higiene e Saude');
insert into tem_categoria values (3892977199091, 'Higiene e Saude');
insert into tem_categoria values (3418608887277, 'Higiene e Saude');
insert into tem_categoria values (1528910470243, 'Higiene e Saude');
insert into tem_categoria values (1746191137346, 'Higiene e Saude');
insert into tem_categoria values (1675328415728, 'Higiene e Saude');
insert into tem_categoria values (3124727371836, 'Higiene e Saude');
insert into tem_categoria values (5452149204981, 'Higiene e Saude');
insert into tem_categoria values (5292599744895, 'Higiene e Saude');
insert into tem_categoria values (0321302005519, 'Papelaria');
insert into tem_categoria values (4176419843554, 'Papelaria');
insert into tem_categoria values (3507797043457, 'Papelaria');
insert into tem_categoria values (3705347281078, 'Papelaria');
insert into tem_categoria values (8870652112264, 'Papelaria');
insert into tem_categoria values (1111538823771, 'Papelaria');
insert into tem_categoria values (2888818377511, 'Gelo');
insert into tem_categoria values (6347772554585, 'Pastilhas');
insert into tem_categoria values (1837598307905, 'Pastilhas');
insert into tem_categoria values (5752011825267, 'Pastilhas');
insert into tem_categoria values (8421250231352, 'Pastilhas');

-- insert into ivm values (num_serie, fabricante)
insert into ivm values (8888208809802, 'Vending lda');
insert into ivm values (5348430509603, 'Vending lda');
insert into ivm values (4574860484968, 'Vending lda');
insert into ivm values (7462252893192, 'Vending lda');
insert into ivm values (1994724148811, 'Vending lda');
insert into ivm values (3535073013679, 'Vending lda');
insert into ivm values (7485419189999, 'Vending lda');
insert into ivm values (9899990094627, 'Vending lda');
insert into ivm values (4961530410328, 'Vending lda');
insert into ivm values (9099724688753, 'Vending lda');
insert into ivm values (8888208809802, 'Instant Foodies inc');
insert into ivm values (5348430509603, 'Instant Foodies inc');
insert into ivm values (4574860484968, 'Instant Foodies inc');
insert into ivm values (7462252893192, 'Instant Foodies inc');
insert into ivm values (1994724148811, 'Instant Foodies inc');
insert into ivm values (3535073013679, 'Instant Foodies inc');
insert into ivm values (7485419189999, 'Instant Foodies inc');
insert into ivm values (9899990094627, 'Instant Foodies inc');
insert into ivm values (4961530410328, 'Instant Foodies inc');
insert into ivm values (9099724688753, 'Instant Foodies inc');
insert into ivm values (8888208809802, 'Azkoyen Group');
insert into ivm values (5348430509603, 'Azkoyen Group');
insert into ivm values (4574860484968, 'Azkoyen Group');
insert into ivm values (7462252893192, 'Azkoyen Group');
insert into ivm values (1994724148811, 'Azkoyen Group');
insert into ivm values (3535073013679, 'Azkoyen Group');
insert into ivm values (7485419189999, 'Azkoyen Group');
insert into ivm values (9899990094627, 'Azkoyen Group');
insert into ivm values (4961530410328, 'Azkoyen Group');
insert into ivm values (9099724688753, 'Azkoyen Group');
insert into ivm values (8888208809802, 'GLORY');
insert into ivm values (5348430509603, 'GLORY');
insert into ivm values (4574860484968, 'GLORY');
insert into ivm values (7462252893192, 'GLORY');
insert into ivm values (1994724148811, 'GLORY');
insert into ivm values (3535073013679, 'GLORY');
insert into ivm values (7485419189999, 'GLORY');
insert into ivm values (9899990094627, 'GLORY');
insert into ivm values (4961530410328, 'GLORY');
insert into ivm values (9099724688753, 'GLORY');
insert into ivm values (8888208809802, 'Fuji Electric');
insert into ivm values (5348430509603, 'Fuji Electric');
insert into ivm values (4574860484968, 'Fuji Electric');
insert into ivm values (7462252893192, 'Fuji Electric');
insert into ivm values (1994724148811, 'Fuji Electric');
insert into ivm values (3535073013679, 'Fuji Electric');
insert into ivm values (7485419189999, 'Fuji Electric');
insert into ivm values (9899990094627, 'Fuji Electric');
insert into ivm values (4961530410328, 'Fuji Electric');
insert into ivm values (9099724688753, 'Fuji Electric');

-- insert into ponto_de_retalho values (ponto_de_retalho_nome, concelho, distrito)
insert into ponto_de_retalho values ('Galp Oeiras', 'Oeiras', 'Lisboa');
insert into ponto_de_retalho values ('Galp Alvalade', 'Lisboa', 'Lisboa');
insert into ponto_de_retalho values ('BP Rua das Antas', 'Sintra', 'Lisboa');
insert into ponto_de_retalho values ('Farmácia Fontainhas', 'Vila Nova de Gaia', 'Porto');
insert into ponto_de_retalho values ('Escola Secondária de Valongo', 'Valongo', 'Porto');
insert into ponto_de_retalho values ('Galp Santo Tirso', 'Santo Tirso', 'Porto');
insert into ponto_de_retalho values ('Auchan Lagoa', 'Lagoa', 'Faro');
insert into ponto_de_retalho values ('Universidade de Faro', 'Faro', 'Faro');
insert into ponto_de_retalho values ('Oeiras Park', 'Oeiras', 'Lisboa');
insert into ponto_de_retalho values ('Aeroporto Lisboa', 'Lisboa', 'Lisboa');
insert into ponto_de_retalho values ('Galp Sintra', 'Sintra', 'Lisboa');
insert into ponto_de_retalho values ('Escola Secundaria Vila Nova de Gaia', 'Vila Nova de Gaia', 'Porto');
insert into ponto_de_retalho values ('Galp Valongo', 'Valongo', 'Porto');
insert into ponto_de_retalho values ('BP Santo Tirso', 'Santo Tirso', 'Porto');
insert into ponto_de_retalho values ('Galp Lagoa', 'Lagoa', 'Faro');
insert into ponto_de_retalho values ('Galp Faro', 'Faro', 'Faro');
insert into ponto_de_retalho values ('Auchan Oeiras', 'Oeiras', 'Lisboa');
insert into ponto_de_retalho values ('Instituto Superior Tecnico', 'Lisboa', 'Lisboa');
insert into ponto_de_retalho values ('Alegro Sintra', 'Sintra', 'Lisboa');
insert into ponto_de_retalho values ('Galp Porto', 'Vila Nova de Gaia', 'Porto');
insert into ponto_de_retalho values ('BP Valongo', 'Valongo', 'Porto');
insert into ponto_de_retalho values ('Farmacia ST', 'Santo Tirso', 'Porto');
insert into ponto_de_retalho values ('Rodoviária Lagoa', 'Lagoa', 'Faro');
insert into ponto_de_retalho values ('Aeroporto Faro', 'Faro', 'Faro');

-- insert into instalada_em values (num_serie, fabricante, ponto_de_retalho_nome)
insert into instalada_em values (8888208809802, 'Vending lda', 'Auchan Oeiras');
insert into instalada_em values (5348430509603, 'Vending lda',);
insert into instalada_em values (4574860484968, 'Vending lda', 'Aeroporto Lisboa');
insert into instalada_em values (7462252893192, 'Vending lda', 'Galp Oeiras');
insert into instalada_em values (1994724148811, 'Vending lda', 'Aeroporto Faro');
insert into instalada_em values (3535073013679, 'Vending lda', 'Instituto Superior Tecnico');
insert into instalada_em values (7485419189999, 'Vending lda', 'Rodoviária Lagoa');
insert into instalada_em values (9899990094627, 'Vending lda', 'Galp Alvalade');
insert into instalada_em values (4961530410328, 'Vending lda', 'Alegro Sintra');
insert into instalada_em values (9099724688753, 'Vending lda', 'Auchan Oeiras');
insert into instalada_em values (8888208809802, 'Instant Foodies inc', 'Rodoviária Lagoa');
insert into instalada_em values (5348430509603, 'Instant Foodies inc', 'Aeroporto Lisboa');
insert into instalada_em values (4574860484968, 'Instant Foodies inc', 'Galp Faro');
insert into instalada_em values (7462252893192, 'Instant Foodies inc', 'Aeroporto Faro');
insert into instalada_em values (1994724148811, 'Instant Foodies inc', 'Escola Secondária de Valongo');
insert into instalada_em values (3535073013679, 'Instant Foodies inc', 'Farmácia Fontainhas');
insert into instalada_em values (7485419189999, 'Instant Foodies inc', 'Galp Porto');
insert into instalada_em values (9899990094627, 'Instant Foodies inc', 'Aeroporto Faro');
insert into instalada_em values (4961530410328, 'Instant Foodies inc','Galp Santo Tirso');
insert into instalada_em values (9099724688753, 'Instant Foodies inc', 'Galp Porto');
insert into instalada_em values (8888208809802, 'Azkoyen Group', 'BP Valongo');
insert into instalada_em values (5348430509603, 'Azkoyen Group', 'Instituto Superior Tecnico');
insert into instalada_em values (4574860484968, 'Azkoyen Group', 'Alegro Sintra');
insert into instalada_em values (7462252893192, 'Azkoyen Group', 'BP Rua das Antas');
insert into instalada_em values (1994724148811, 'Azkoyen Group', 'Escola Secondária de Valongo');
insert into instalada_em values (3535073013679, 'Azkoyen Group', 'Farmacia ST');
insert into instalada_em values (7485419189999, 'Azkoyen Group', 'Aeroporto Lisboa');
insert into instalada_em values (9899990094627, 'Azkoyen Group', 'Escola Secondária de Valongo');
insert into instalada_em values (4961530410328, 'Azkoyen Group', 'Auchan Oeiras');
insert into instalada_em values (9099724688753, 'Azkoyen Group', 'Auchan Oeiras');
insert into instalada_em values (8888208809802, 'GLORY', 'Universidade de Faro');
insert into instalada_em values (5348430509603, 'GLORY', 'Oeiras Park');
insert into instalada_em values (4574860484968, 'GLORY', 'Aeroporto Faro');
insert into instalada_em values (7462252893192, 'GLORY', 'Escola Secundaria Vila Nova de Gaia');
insert into instalada_em values (1994724148811, 'GLORY', 'Aeroporto Lisboa');
insert into instalada_em values (3535073013679, 'GLORY', 'Escola Secundaria Vila Nova de Gaia');
insert into instalada_em values (7485419189999, 'GLORY', 'Rodoviária Lagoa');
insert into instalada_em values (9899990094627, 'GLORY', 'Rodoviária Lagoa');
insert into instalada_em values (4961530410328, 'GLORY', 'Galp Valongo');
insert into instalada_em values (9099724688753, 'GLORY', 'Auchan Lagoa');
insert into instalada_em values (8888208809802, 'Fuji Electric', 'Galp Faro');
insert into instalada_em values (5348430509603, 'Fuji Electric', 'Aeroporto Lisboa');
insert into instalada_em values (4574860484968, 'Fuji Electric', 'Auchan Lagoa');
insert into instalada_em values (7462252893192, 'Fuji Electric', 'Alegro Sintra');
insert into instalada_em values (1994724148811, 'Fuji Electric', 'Galp Lagoa');
insert into instalada_em values (3535073013679, 'Fuji Electric', 'BP Santo Tirso');
insert into instalada_em values (7485419189999, 'Fuji Electric', 'Auchan Lagoa');
insert into instalada_em values (9899990094627, 'Fuji Electric', 'Aeroporto Faro');
insert into instalada_em values (4961530410328, 'Fuji Electric', 'Aeroporto Lisboa');
insert into instalada_em values (9099724688753, 'Fuji Electric', 'Galp Sintra');

-- insert into prateleira values (num_prateleira, num_serie, fabricante, altura, categoria_simples_nome)

-- insert into planograma values (ean, num_prateleira, num_serie, fabricante, faces, unidades, loc)

-- insert into retalhista values (tin, retalhista_nome)
insert into retalhista values (9876543211111, 'Drinks & co');
insert into retalhista values (3417630879649, 'Healthy Vending Food');
insert into retalhista values (2378179048864, 'Unilever');
insert into retalhista values (1048025576912, 'Drinkscape');
insert into retalhista values (6787954950079, 'Quality Meal');
insert into retalhista values (2677939703594, 'Drinknest');
insert into retalhista values (2771899030136, 'Wish Snack');
insert into retalhista values (3770978070948, 'Dine Food');
insert into retalhista values (8978167380044, 'Snackzen');
insert into retalhista values (9087042596230, 'Chew Drink');
insert into retalhista values (5538346730286, 'Luxury Food');
insert into retalhista values (3915490959574, 'Violet Meal');
insert into retalhista values (5880934365457, 'Stake Drink');
insert into retalhista values (9425493289689, 'Drips Snack');
insert into retalhista values (5126790930207, 'Cream Food');
insert into retalhista values (6011158039898, 'Rumble Snack');
insert into retalhista values (2982545428332, 'Snacklance');
insert into retalhista values (3529102244786, 'Lane Snack');
insert into retalhista values (7825838411766, 'Drink Charm');
insert into retalhista values (1132877923583, 'Sweets Joy');
insert into retalhista values (1769001928832, 'Sweets Guard');
insert into retalhista values (4605211128102, 'Sweets Loop');
insert into retalhista values (8416517046952, 'Food Delight');
insert into retalhista values (7290903799810, 'Food Bites');
insert into retalhista values (4788875231357, 'Snack Wish');
insert into retalhista values (8846259194266, 'Snackiva');
insert into retalhista values (1893660950613, 'Foodaro');
insert into retalhista values (9636314992455, 'Drinkify');
insert into retalhista values (2717869371705, 'Meal Fever');
insert into retalhista values (9281061801443, 'Snack Utopia');

-- insert into responsavel_por values (tin, num_serie, fabricante)
insert into responsavel_por values (9876543211111, 8888208809802, 'Vending lda');
insert into responsavel_por values (7290903799810, 5348430509603, 'Vending lda');
insert into responsavel_por values (6011158039898, 4574860484968, 'Vending lda');
insert into responsavel_por values (6787954950079, 7462252893192, 'Vending lda');
insert into responsavel_por values (3915490959574, 1994724148811, 'Vending lda');
insert into responsavel_por values (5538346730286, 3535073013679, 'Vending lda');
insert into responsavel_por values (2677939703594, 7485419189999, 'Vending lda');
insert into responsavel_por values (2378179048864, 9899990094627, 'Vending lda');
insert into responsavel_por values (4788875231357, 4961530410328, 'Vending lda');
insert into responsavel_por values (1769001928832, 9099724688753, 'Vending lda');
insert into responsavel_por values (1132877923583, 8888208809802, 'Instant Foodies inc');
insert into responsavel_por values (4605211128102, 5348430509603, 'Instant Foodies inc');
insert into responsavel_por values (3417630879649, 4574860484968, 'Instant Foodies inc');
insert into responsavel_por values (8846259194266, 7462252893192, 'Instant Foodies inc');
insert into responsavel_por values (7825838411766, 1994724148811, 'Instant Foodies inc');
insert into responsavel_por values (2378179048864, 3535073013679, 'Instant Foodies inc');
insert into responsavel_por values (8416517046952, 7485419189999, 'Instant Foodies inc');
insert into responsavel_por values (7290903799810, 9899990094627, 'Instant Foodies inc');
insert into responsavel_por values (9281061801443, 4961530410328, 'Instant Foodies inc');
insert into responsavel_por values (1893660950613, 9099724688753, 'Instant Foodies inc');
insert into responsavel_por values (9636314992455, 8888208809802, 'Azkoyen Group');
insert into responsavel_por values (1048025576912, 5348430509603, 'Azkoyen Group');
insert into responsavel_por values (3770978070948, 4574860484968, 'Azkoyen Group');
insert into responsavel_por values (8978167380044, 7462252893192, 'Azkoyen Group');
insert into responsavel_por values (8846259194266, 1994724148811, 'Azkoyen Group');
insert into responsavel_por values (2982545428332, 3535073013679, 'Azkoyen Group');
insert into responsavel_por values (3529102244786, 7485419189999, 'Azkoyen Group');
insert into responsavel_por values (9087042596230, 9899990094627, 'Azkoyen Group');
insert into responsavel_por values (9281061801443, 4961530410328, 'Azkoyen Group');
insert into responsavel_por values (2717869371705, 9099724688753, 'Azkoyen Group');
insert into responsavel_por values (5880934365457, 8888208809802, 'GLORY');
insert into responsavel_por values (5126790930207, 5348430509603, 'GLORY');
insert into responsavel_por values (6011158039898, 4574860484968, 'GLORY');
insert into responsavel_por values (9425493289689, 7462252893192, 'GLORY');
insert into responsavel_por values (9636314992455, 1994724148811, 'GLORY');
insert into responsavel_por values (1048025576912, 3535073013679, 'GLORY');
insert into responsavel_por values (2771899030136, 7485419189999, 'GLORY');
insert into responsavel_por values (2677939703594, 9899990094627, 'GLORY');
insert into responsavel_por values (9425493289689, 4961530410328, 'GLORY');
insert into responsavel_por values (3529102244786, 9099724688753, 'GLORY');
insert into responsavel_por values (9425493289689, 8888208809802, 'Fuji Electric');
insert into responsavel_por values (5126790930207, 5348430509603, 'Fuji Electric');
insert into responsavel_por values (8416517046952, 4574860484968, 'Fuji Electric');
insert into responsavel_por values (3770978070948, 7462252893192, 'Fuji Electric');
insert into responsavel_por values (6787954950079, 1994724148811, 'Fuji Electric');
insert into responsavel_por values (1769001928832, 3535073013679, 'Fuji Electric');
insert into responsavel_por values (9636314992455, 7485419189999, 'Fuji Electric');
insert into responsavel_por values (9636314992455, 9899990094627, 'Fuji Electric');
insert into responsavel_por values (7825838411766, 4961530410328, 'Fuji Electric');
insert into responsavel_por values (1048025576912, 9099724688753, 'Fuji Electric');

-- insert into evento_reposicao values (ean, num_prateleira, num_serie, fabricante, instante, unidades, tin)
