drop table categoria
drop table categoriaSimples
drop table superCategoria
drop table temOutra
drop table produto
drop table temCategoria
drop table IVM
drop table pontoDeRetalho
drop table instaladaEm
drop table prateleira
drop table planograma
drop table retalhista
drop table responsavelPor
drop table eventoReposicao
--------------------

create table categoria
   (categoria_nome 	varchar(80)	not null unique,
    constraint pk_categoria primary key(categoria_nome));

create table categoriaSimples
   (categoriaSimples_nome 	varchar(80)	not null unique,
    constraint pk_categoriaSimples primary key(categoriaSimples_nome),
    constraint fk_categoriaSimples_categoria foreign key(categoriaSimples_nome) references categoria(categoria_nome));
    
create table superCategoria
   (superCategoria_nome 	varchar(80)	not null unique,
    constraint pk_superCategoria primary key(superCategoria_nome),
    constraint fk_superCategoria_categoria foreign key(superCategoria_nome) references categoria(categoria_nome));
    
create table temOutra
    (superCategoria_nome varchar(80) not null,
    categoria_nome varchar(80) not null unique
    constraint pk_temOutra primary key (categoria_nome)
    constraint fk_temOutra_superCategoria foreign key(superCategoria_nome) references categoria(superCategoria_nome),
    constraint fk_temOutra_categoria foreign key(categoria_nome) references categoria(categoria_nome));

create table produto
    (ean numeric(13) not null unique,
     categoria_nome varchar(80) not null,
     descr varchar(50) not null,
     constraint pk_produto primary key(ean)
     constraint fk_produto_categoria foreign key(categoria_nome) references categoria(categoria_nome);)

create table temCategoria
    (ean numeric(13) not null,
     categoria_nome varchar(80) not null,
     constraint fk_temCategoria_produto foreign key(ean) references produto(ean),
     constraint fk_temCategoria_categoria foreign key(categoria_nome) references categoria(categoria_nome);)

create table IVM
    (num_serie numeric(13) not null,
     fabricante varchar(80) not null,
     constraint pk_IVM primary key(num_serie, fabricante);)
    
create table pontoDeRetalho
    (pontoDeRetalho_nome varchar(80) not null unique,
     concelho varchar(80) not null,
     distrito varchar(80) not null,
     constraint pk_pontoDeRetalho primary key(pontoDeRetalho_nome);)

create table instaladaEm
    (num_serie numeric(13) not null,
     fabricante varchar(80) not null,
     pontoDeRetalho_nome varchar(80) not null,
     constraint fk_instaladaEm_IVM foreign key(num_serie, fabricante) references IVM(num_serie, fabricante),
     constraint fk_instaladaEm_pontoDeRetalho foreign key(pontoDeRetalho_nome) references pontoDeRetalho(pontoDeRetalho_nome);)
     
create table prateleira
    (num_prateleira numeric(2) not null,
     num_serie numeric(13) not null,
     fabricante varchar(80) not null,
     altura numeric(3) not null,
     categoria_nome varchar(80) not null,
     constraint pk_prateleira primary key(num_prateleira, num_serie, fabricante),
     constraint fk_instaladaEm_IVM foreign key(num_serie, fabricante) references IVM(num_serie, fabricante),
     constraint fk_temCategoria_categoria foreign key(categoria_nome) references categoria(categoria_nome);)

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
     constraint fk_planograma_prateleira foreign key(num_prateleira, num_serie, fabricante) prateleira(num_prateleira, num_serie, fabricante);)

create table retalhista
    (tin numeric(13) not null unique,
     retalhista_nome varchar(80) not null unique,
     constraint pk_retalhista primary key(tin);)

create table responsavelPor
    (categoria_nome varchar(80) not null,
     tin numeric(13) not null,
     num_serie numeric(13) not null,
     fabricante varchar(80) not null,
     constraint pk_responsavelPor primary key(num_serie, fabricante),
     constraint fk_responsavelPor_categoria foreign key(categoria_nome) references categoria(categoria_nome),
     constraint fk_responsavelPor_retalhista foreign key(tin),
     constraint fk_responsavelPor_prateleira foreign key(num_serie, fabricante) prateleira(num_serie, fabricante);)

create table eventoReposicao
    (ean numeric(13) not null,
     num_prateleira numeric(2) not null,
     num_serie numeric(13) not null,
     fabricante varchar(80) not null,
     instante numeric(14) not null
     unidades numeric(4) not null,
     tin numeric(13) not null,
     constraint pk_eventoReposicao primary key(ean, num_prateleira, num_serie, fabricante, instante),
     constraint fk_eventoReposicao_retalhista foreign key(tin),
     constraint fk_eventoReposicao_planograma foreign key(ean, num_prateleira, num_serie, fabricante) planograma(ean, num_prateleira, num_serie, fabricante)


        
)
---------------------------------------- 
----------------------------------------




-- insert into table values (col1val, col2val, col3val, ...);
-- char = ''
insert into categoria values ('Bebida')
insert into categoria values ('Refrigerante')
insert into categoria values ('Bebida sem Gás')

insert into categoria values ('Comida')
insert into categoria values ('Pastelaria')
insert into categoria values ('Doces')
insert into categoria values ('Bolachas')

insert into categoria values ('Outros')
insert into categoria values ('Consumíveis')
insert into categoria values ('Higiene')


insert into categoriaSimples values ('Refrigerante')
insert into categoriaSimples values ('Bebida sem Gás')
insert into categoriaSimples values ('Pastelaria')
insert into categoriaSimples values ('Doces')
insert into categoriaSimples values ('Bolachas')
insert into categoriaSimples values ('Outros')


insert into superCategoria values ('Bebida')
insert into superCategoria values ('Comida')
insert into superCategoria values ('Outros')
insert into superCategoria values ('Consumíveis')


insert into temOutra values ('Bebida', 'Refrigerante')
insert into temOutra values ('Bebida', 'Bebida sem Gás')
insert into temOutra values ('Comida', 'Pastelaria')
insert into temOutra values ('Comida', 'Doces')
insert into temOutra values ('Comida', 'Bolachas')
insert into temOutra values ('Outros', 'Consumíveis')
insert into temOutra values ('Consumíveis', 'Higiene')


insert into produto values (1111111111111, 'Bebida', 'Powerade');
insert into produto values (2222222222222, 'Bebida sem Gás', 'Vitalis 500ml');
insert into produto values (3333333333333, 'Bebida sem Gás', 'Compal Pêra');
insert into produto values (4444444444444, 'Refrigerante', 'Iced Tea');
insert into produto values (5555555555555, 'Pastelaria', 'Croassaint Misto');
insert into produto values (6666666666666, 'Doces', 'Kinder Bueno');
insert into produto values (7777777777777, 'Bolachas', 'Tuc');
insert into produto values (8888888888888, 'Outros', 'Trident');
insert into produto values (9999999999999, 'Consumíveis', 'Pacote de Gelo Instantâneo');
insert into produto values (1222222222222, 'Higiene', 'Máscara COVID-19');
insert into produto values (1333333333333, 'Higiene', 'Lenços de Papel Renova');


insert into temCategoria values (1111111111111, 'Bebida')
insert into temCategoria values (2222222222222, 'Bebida sem Gás')
insert into temCategoria values (3333333333333, 'Bebida sem Gás')
insert into temCategoria values (4444444444444, 'Refrigerante')
insert into temCategoria values (5555555555555, 'Pastelaria')
insert into temCategoria values (6666666666666, 'Doces')
insert into temCategoria values (7777777777777, 'Bolachas')
insert into temCategoria values (8888888888888, 'Consumíveis')
insert into temCategoria values (9999999999999, 'Consumíveis')
insert into temCategoria values (1222222222222, 'Higiene')
insert into temCategoria values (1333333333333, 'Higiene')


insert into IVM values (0001111111111, 'Vending lda');
insert into IVM values (0001222222222, 'Vending lda');
insert into IVM values (0001133333333, 'Vending lda');
insert into IVM values (0001114444444, 'Vending lda');
insert into IVM values (1111111111111, 'Instant Foodies inc');
insert into IVM values (0111111111111, 'Instant Foodies inc');
insert into IVM values (0011111111111, 'Instant Foodies inc');
insert into IVM values (0001111111111, 'Instant Foodies inc');


insert into pontoDeRetalho values ('Galp Oeiras', 'Oeiras', 'Lisboa');
insert into pontoDeRetalho values ('Galp Alvalade', 'Lisboa', 'Lisboa');
insert into pontoDeRetalho values ('BP Rua das Antas', 'Sintra', 'Lisboa');
insert into pontoDeRetalho values ('Farmácia Fontainhas', 'Vila Nova de Gaia', 'Porto');
insert into pontoDeRetalho values ('Escola Secondária de Valongo', 'Valongo', 'Porto');
insert into pontoDeRetalho values ('Galp Santo Tirso', 'Santo Tirso', 'Porto');
insert into pontoDeRetalho values ('Rodoviária Lagoa', 'Lagoa', 'Faro');
insert into pontoDeRetalho values ('Universidade de Faro', 'Faro', 'Faro');


insert into instaladaEm values (0001111111111, 'Vending lda', 'Galp Oeiras');
insert into instaladaEm values (0001222222222, 'Vending lda', 'Galp Alvalade');
insert into instaladaEm values (0001133333333, 'Vending lda', 'Universidade de Faro');
insert into instaladaEm values (0001114444444, 'Vending lda', 'Galp Santo Tirso');
insert into instaladaEm values (1111111111111, 'Instant Foodies inc', 'Farmácia Fontainhas');
insert into instaladaEm values (0001111111111, 'Instant Foodies inc', 'BP Rua das Antas');


insert into prateleira values (1, 0001111111111, 'Vending lda', 30, 'Bebida');
