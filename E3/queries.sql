
-- 1 --

SELECT retalhista_nome
FROM (
    SELECT tin
    FROM (
            SELECT COUNT(*)
            FROM responsavelPor
            GROUP BY tin
    ) AS AUX
    WHERE count = (
        SELECT MAX(count)
        FROM AUX
    )
)AS A JOIN retalhista AS R ON A.tid = R.tid;


-- 2 --



-- 3 --

(SELECT ean FROM produto)
EXCEPT
(SELECT ean FROM eventoReposicao);


-- 4 --

SELECT ean
FROM (
        SELECT ean, COUNT(*)
        FROM (
                SELECT  ean, tid
                FROM eventoReposicao
        ) AS A
        GROUP BY ean
) AS B
WHERE count = 1;
