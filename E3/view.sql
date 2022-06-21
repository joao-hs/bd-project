-- Vendas(ean, cat, ano, trimestre, mes, dia_mes, dia_semana, distrito, concelho, unidades)
--      ean e cat: correspondem às PK das relações produto e categoria, respetivamente
--      distrito e concelho: correspondem aos atributos com o mesmo nome de ponto_de_retalho
--      ano, trimestre, mes, dia_mes e dia_semana: atributos derivado do atributo instante
--      unidades: corresponde ao atributo com o emso nome da relação evento_reposição
DROP VIEW vendas;
DROP VIEW hierarquias_cat;

CREATE VIEW Vendas(ean, cat, ano, trimestre, mes, dia_mes, dia_semana, distrito, concelho, unidades)
AS
SELECT
    rep_event.ean, 
    has_cat.categoria_nome,
    to_char(instante, 'YYYY'),
    to_char(instante, 'Q'),
    to_char(instante, 'MM'),
    to_char(instante, 'DD'),
    to_char(instante, 'D'),
    pont_ret.distrito, 
    pont_ret.concelho,
    unidades
    FROM evento_reposicao AS rep_event JOIN instalada_em AS inst
    ON rep_event.num_serie = inst.num_serie AND rep_event.fabricante = inst.fabricante
    JOIN ponto_de_retalho as pont_ret ON inst.ponto_de_retalho_nome = pont_ret.ponto_de_retalho_nome
    JOIN tem_categoria as has_cat ON rep_event.ean = has_cat.ean
    ORDER BY rep_event.instante;
    
CREATE VIEW hierarquias_cat(sub_categoria, super_categoria)
AS
SELECT c.categoria_nome, "to".super_categoria_nome
FROM tem_outra "to" 
RIGHT OUTER JOIN categoria c 
ON "to".categoria_nome=c.categoria_nome;