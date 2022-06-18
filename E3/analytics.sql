-- Vendas(ean, cat, ano, trimestre, mes, dia_mes, dia_semana, distrito, concelho, unidades)
--      ean e cat: correspondem às PK das relações produto e categoria, respetivamente
--      distrito e concelho: correspondem aos atributos com o mesmo nome de ponto_de_retalho
--      ano, trimestre, mes, dia_mes e dia_semana: atributos derivado do atributo instante
--      unidades: corresponde ao atributo com o emso nome da relação evento_reposição

CREATE VIEW Vendas(ean, cat, ano, trimestre, mes, dia_mes, dia_semana, distrito, concelho, unidades)
AS


SELECT (
    ean, 
    hasCat.categoria_nome AS cat,
    EXTRACT(YEAR FROM TIMESTAMP instant), 
    EXTRACT(QUARTER FROM TIMESTAMP instant), 
    EXTRACT(MONTH FROM TIMESTAMP instant), 
    EXTRACT(DAY FROM TIMESTAMP instant), 
    EXTRACT(DOW FROM TIMESTAMP instant), 
    pontRet.distrito AS distrito, 
    pontRet.concelho AS concelho, 
    unidades
) 
FROM eventoReposicao as repEvent
JOIN instaladaEm AS instNS 
    ON instNS.num_serie = repEvent.num_serie
JOIN instaladaEm AS instF 
    ON instF.fabricante = repEvent.fabricante
JOIN pontoDeRetalho AS pontRet 
    ON pontRet.pontoDeRetalho_nome = repEvent.pontoDeRetalho_nome
JOIN temCategoria AS hasCat 
    ON hasCat.ean = repEvent.ean;