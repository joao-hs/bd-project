
-- 1 --

SELECT retalhista_nome
FROM (
    SELECT tin, COUNT(*)
    FROM responsavel_por
    GROUP BY tin
    HAVING COUNT(*) >= ALL (
        SELECT COUNT(*)
        FROM responsavel_por
        GROUP BY tin
    )
) AS aux JOIN retalhista ON aux.tin=retalhista.tin;



-- 2 --
SELECT retalhista_nome
FROM(
    SELECT tin, COUNT(*)
    FROM responsavel_por as R RIGHT OUTER JOIN categoria_simples AS cs
    ON r.categoria_nome=cs.categoria_simples_nome
    GROUP BY tin
    HAVING COUNT(*) = (
        SELECT COUNT(*)
        FROM categoria_simples
    ) 
)AS aux JOIN retalhista ON aux.tin=retalhista.tin;


SELECT retalhista_nome, categoria_simples_nome 
FROM
retalhista AS r JOIN responsavel_por AS rp 
ON r.tin=rp.tin
RIGHT OUTER JOIN categoria_simples AS cs 
ON rp.categoria_nome=cs.categoria_simples_nome;


-- 3 --

(SELECT ean FROM produto)
EXCEPT
(SELECT ean FROM evento_reposicao);


-- 4 --

SELECT ean
FROM (
    SELECT DISTINCT ean, tin
    FROM evento_reposicao
)AS a
GROUP BY ean
HAVING COUNT(*) = 1;