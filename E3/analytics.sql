-- Consultas OLAP

-- 1
SELECT dia_semana, concelho, SUM ( unidades ) AS unidades_totais 
FROM vendas
WHERE((CAST(ano AS int)*10000+CAST(mes AS int)*100+CAST(dia_mes AS int)) BETWEEN 20220201 AND 20230101)
GROUP BY CUBE (dia_semana, concelho);

--2
SELECT concelho, cat, dia_semana, SUM ( unidades ) AS unidades_totais 
FROM vendas 
WHERE distrito = 'Lisboa'
GROUP BY GROUPING SETS ((cat, concelho),(cat, dia_semana), (concelho), (cat), (dia_semana), ());

