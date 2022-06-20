-- Vendas(ean, cat, ano, trimestre, mes, dia_mes, dia_semana, distrito, concelho, unidades)
--      ean e cat: correspondem às PK das relações produto e categoria, respetivamente
--      distrito e concelho: correspondem aos atributos com o mesmo nome de ponto_de_retalho
--      ano, trimestre, mes, dia_mes e dia_semana: atributos derivado do atributo instante
--      unidades: corresponde ao atributo com o emso nome da relação evento_reposição

CREATE VIEW Vendas(ean, cat, ano, trimestre, mes, dia_mes, dia_semana, distrito, concelho, unidades)
AS
SELECT
    rep_event.ean, 
    has_cat.categoria_nome,
    to_char(instante, 'YYYY'),
    to_char(instante, 'Q'),
    to_char(instante, 'Mon'),
    to_char(instante, 'DD'),
    to_char(instante, 'D'),
    --EXTRACT(YEAR FROM TIMESTAMP instante), 
    --EXTRACT(QUARTER FROM TIMESTAMP instante), 
    --EXTRACT(MONTH FROM TIMESTAMP instante), 
    --EXTRACT(DAY FROM TIMESTAMP instante), 
    --EXTRACT(DOW FROM TIMESTAMP instante), 
    pont_ret.distrito, 
    pont_ret.concelho,
    unidades
FROM evento_reposicao as rep_event
JOIN instalada_em AS instNS 
    ON instNS.num_serie = rep_event.num_serie
JOIN instalada_em AS instF 
    ON instF.fabricante = instNS.fabricante
JOIN ponto_de_retalho AS pont_ret 
    ON pont_ret.ponto_de_retalho_nome = instF.ponto_de_retalho_nome
JOIN tem_categoria AS has_cat 
    ON has_cat.ean = rep_event.ean;