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

insert into categoria values ('Bebida');
insert into categoria values ('Refrigerante');
insert into categoria values ('Bebida sem Gás');

insert into categoria values ('Comida');
insert into categoria values ('Pastelaria');
insert into categoria values ('Doces');
insert into categoria values ('Bolachas');

insert into categoria values ('Outros');
insert into categoria values ('Consumíveis');
insert into categoria values ('Higiene');
insert into categoria values ('Gelo');


insert into categoria_simples values ('Refrigerante');
insert into categoria_simples values ('Bebida sem Gás');
insert into categoria_simples values ('Pastelaria');
insert into categoria_simples values ('Doces');
insert into categoria_simples values ('Bolachas');
insert into categoria_simples values ('Higiene');
insert into categoria_simples values ('Gelo');


insert into super_categoria values ('Bebida');
insert into super_categoria values ('Comida');
insert into super_categoria values ('Outros');
insert into super_categoria values ('Consumíveis');


insert into tem_outra values ('Bebida', 'Refrigerante');
insert into tem_outra values ('Bebida', 'Bebida sem Gás');
insert into tem_outra values ('Comida', 'Pastelaria');
insert into tem_outra values ('Comida', 'Doces');
insert into tem_outra values ('Comida', 'Bolachas');
insert into tem_outra values ('Outros', 'Consumíveis');
insert into tem_outra values ('Consumíveis', 'Higiene');
insert into tem_outra values ('Consumíveis', 'Gelo');


insert into produto values (1111111111111, 'Bebida sem Gás', 'Powerade');
insert into produto values (2222222222222, 'Bebida sem Gás', 'Vitalis 500ml');
insert into produto values (3333333333333, 'Bebida sem Gás', 'Compal Pêra');
insert into produto values (4444444444444, 'Refrigerante', 'Iced Tea');
insert into produto values (5555555555555, 'Pastelaria', 'Croassaint Misto');
insert into produto values (6666666666666, 'Doces', 'Kinder Bueno');
insert into produto values (7777777777777, 'Bolachas', 'Tuc');
insert into produto values (8888888888888, 'Doces', 'Trident');
insert into produto values (9999999999999, 'Gelo', 'Pacote de Gelo Instantâneo');
insert into produto values (1222222222222, 'Higiene', 'Máscara COVID-19');
insert into produto values (1333333333333, 'Higiene', 'Lenços de Papel Renova');


insert into tem_categoria values (1111111111111, 'Bebida sem Gás');
insert into tem_categoria values (2222222222222, 'Bebida sem Gás');
insert into tem_categoria values (3333333333333, 'Bebida sem Gás');
insert into tem_categoria values (4444444444444, 'Refrigerante');
insert into tem_categoria values (5555555555555, 'Pastelaria');
insert into tem_categoria values (6666666666666, 'Doces');
insert into tem_categoria values (7777777777777, 'Bolachas');
insert into tem_categoria values (8888888888888, 'Doces');
insert into tem_categoria values (9999999999999, 'Gelo');
insert into tem_categoria values (1222222222222, 'Higiene');
insert into tem_categoria values (1333333333333, 'Higiene');


insert into ivm values (1111111111000, 'Vending lda');
insert into ivm values (1222222222000, 'Vending lda');
insert into ivm values (1133333333000, 'Vending lda');
insert into ivm values (1114444444000, 'Vending lda');
insert into ivm values (1111111111111, 'Instant Foodies inc');
insert into ivm values (1111111111110, 'Instant Foodies inc');
insert into ivm values (1111111111100, 'Instant Foodies inc');
insert into ivm values (1111111111000, 'Instant Foodies inc');


insert into ponto_de_retalho values ('Galp Oeiras', 'Oeiras', 'Lisboa');
insert into ponto_de_retalho values ('Galp Alvalade', 'Lisboa', 'Lisboa');
insert into ponto_de_retalho values ('BP Rua das Antas', 'Sintra', 'Lisboa');
insert into ponto_de_retalho values ('Farmácia Fontainhas', 'Vila Nova de Gaia', 'Porto');
insert into ponto_de_retalho values ('Escola Secondária de Valongo', 'Valongo', 'Porto');
insert into ponto_de_retalho values ('Galp Santo Tirso', 'Santo Tirso', 'Porto');
insert into ponto_de_retalho values ('Rodoviária Lagoa', 'Lagoa', 'Faro');
insert into ponto_de_retalho values ('Universidade de Faro', 'Faro', 'Faro');


insert into instalada_em values (1111111111000, 'Vending lda', 'Galp Oeiras');
insert into instalada_em values (1222222222000, 'Vending lda', 'Galp Alvalade');
insert into instalada_em values (1133333333000, 'Vending lda', 'Universidade de Faro');
insert into instalada_em values (1114444444000, 'Vending lda', 'Galp Santo Tirso');
insert into instalada_em values (1111111111111, 'Instant Foodies inc', 'Farmácia Fontainhas');
insert into instalada_em values (1111111111000, 'Instant Foodies inc', 'BP Rua das Antas');


insert into prateleira values (1, 1111111111000, 'Vending lda', 30, 'Bebida sem Gás');
insert into prateleira values (2, 1111111111000, 'Vending lda', 30, 'Doces');
insert into prateleira values (3, 1111111111000, 'Vending lda', 30, 'Gelo');
insert into prateleira values (1, 1222222222000, 'Vending lda', 30, 'Refrigerante');
insert into prateleira values (2, 1222222222000, 'Vending lda', 30, 'Doces');
insert into prateleira values (3, 1222222222000, 'Vending lda', 30, 'Gelo');
insert into prateleira values (1, 1133333333000, 'Vending lda', 30, 'Bebida sem Gás');
insert into prateleira values (2, 1133333333000, 'Vending lda', 30, 'Bolachas');
insert into prateleira values (3, 1133333333000, 'Vending lda', 30, 'Higiene');
insert into prateleira values (1, 1114444444000, 'Vending lda', 30, 'Bebida sem Gás');
insert into prateleira values (2, 1114444444000, 'Vending lda', 30, 'Bolachas');
insert into prateleira values (3, 1114444444000, 'Vending lda', 30, 'Higiene');
insert into prateleira values (1, 1111111111111, 'Instant Foodies inc', 25, 'Refrigerante');
insert into prateleira values (2, 1111111111111, 'Instant Foodies inc', 25, 'Doces');
insert into prateleira values (1, 1111111111000, 'Instant Foodies inc', 25, 'Bebida sem Gás');
insert into prateleira values (2, 1111111111000, 'Instant Foodies inc', 25, 'Bolachas');


-- insert into planograma values (ean, num_prateleira, num_serie, fabricante, faces, unidades, loc)
insert into planograma values (1111111111111, 1, 1111111111000, 'Vending lda', 1, 5, 'Fila A');
insert into planograma values (2222222222222, 1, 1111111111000, 'Vending lda', 2, 10, 'Fila B e C');
insert into planograma values (3333333333333, 1, 1111111111000, 'Vending lda', 1, 5, 'Fila D');
insert into planograma values (4444444444444, 1, 1111111111000, 'Vending lda', 2, 15, 'Fila D e E');
insert into planograma values (5555555555555, 1, 1111111111000, 'Vending lda', 2, 15, 'Fila D e E');

insert into planograma values (1111111111111, 1, 1222222222000, 'Vending lda', 1, 5, 'Fila A');
insert into planograma values (2222222222222, 1, 1222222222000, 'Vending lda', 2, 10, 'Fila B e C');
insert into planograma values (3333333333333, 1, 1222222222000, 'Vending lda', 1, 5, 'Fila D');
insert into planograma values (1111111111111, 1, 1133333333000, 'Vending lda', 1, 5, 'Fila A');
insert into planograma values (2222222222222, 1, 1133333333000, 'Vending lda', 2, 10, 'Fila B e C');
insert into planograma values (3333333333333, 1, 1133333333000, 'Vending lda', 1, 5, 'Fila D');
insert into planograma values (4444444444444, 1, 1133333333000, 'Vending lda', 2, 15, 'Fila D e E');
insert into planograma values (2222222222222, 1, 1114444444000, 'Vending lda', 2, 10, 'Fila B e C');
insert into planograma values (3333333333333, 1, 1114444444000, 'Vending lda', 1, 5, 'Fila D');
insert into planograma values (2222222222222, 1, 1111111111111, 'Instant Foodies inc', 2, 12, 'Fila B e C');
insert into planograma values (3333333333333, 1, 1111111111111, 'Instant Foodies inc', 1, 6, 'Fila D');
insert into planograma values (1111111111111, 1, 1111111111000, 'Instant Foodies inc', 1, 6, 'Fila A');
insert into planograma values (2222222222222, 1, 1111111111000, 'Instant Foodies inc', 2, 12, 'Fila B e C');
insert into planograma values (3333333333333, 1, 1111111111000, 'Instant Foodies inc', 1, 6, 'Fila D');
insert into planograma values (4444444444444, 1, 1111111111000, 'Instant Foodies inc', 2, 20, 'Fila E e F');

-- se for preciso inserir comida e outros

-- insert into retalhista values (tin, retalhista_nome)
insert into retalhista values (9876543211111, 'Drinks & co');
insert into retalhista values (9876543212222, 'Healthy Vending Food');
insert into retalhista values (9876543213333, 'Unilever');

-- insert into responsavel_por values (tin, num_serie, fabricante)
insert into responsavel_por values (9876543211111, 1111111111000, 'Vending lda');
insert into responsavel_por values (9876543213333, 1111111111110, 'Instant Foodies inc');

-- se for preciso inserir mais entradas

-- insert into evento_reposicao values (ean, num_prateleira, num_serie, fabricante, instante, unidades, tin)
insert into evento_reposicao values (1111111111111, 1, 1111111111000, 'Vending lda', '2022-01-01 12:00:00', 5, 9876543211111);
insert into evento_reposicao values (2222222222222, 1, 1111111111000, 'Vending lda', '2022-02-01 12:00:00', 1, 9876543211111);
insert into evento_reposicao values (1111111111111, 1, 1111111111000, 'Vending lda', '2023-01-01 12:00:00', 5, 9876543211111);
insert into evento_reposicao values (2222222222222, 1, 1111111111000, 'Vending lda', '2023-02-01 12:00:00', 1, 9876543213333);

-- é preciso ter muito cuidado com o que inserir aqui portanto vou deixar para mais tarde