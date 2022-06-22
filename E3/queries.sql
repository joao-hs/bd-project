
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
SELECT DISTINCT retalhista_nome FROM
retalhista AS r JOIN responsavel_por AS rp
ON r.tin = rp.tin JOIN prateleira AS p 
ON rp.fabricante = p.fabricante AND rp.num_serie = p.num_serie;


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

-- Auxiliary Functions --

-- Auxiliary Procedures --

CREATE OR REPLACE FUNCTION remove_category(IN category CHAR) RETURNS VOID AS
$$
DECLARE subcategory CHAR(80) DEFAULT '';
DECLARE subcategories_cursor CURSOR FOR
    (SELECT sub_categoria
        FROM(
            WITH RECURSIVE sub_categorias AS (
                SELECT sub_categoria, super_categoria
                FROM hierarquias_cat
                WHERE sub_categoria = category
                UNION
                    SELECT hc.sub_categoria, hc.super_categoria
                    FROM hierarquias_cat AS hc
                    JOIN sub_categorias sc ON sc.sub_categoria=hc.super_categoria
            ) SELECT *
            FROM sub_categorias
        ) AS aux
        WHERE sub_categoria <> category);
BEGIN
    IF category IN (SELECT * FROM super_categoria) THEN
        OPEN subcategories_cursor;
        LOOP
            FETCH subcategories_cursor INTO subcategory;
            EXIT WHEN NOT FOUND;
            IF subcategory IN (SELECT * FROM categoria_simples) 
            THEN
                PERFORM remove_simple_category(subcategory);
            END IF;
        END LOOP;
        CLOSE subcategories_cursor;
        OPEN subcategories_cursor;
        LOOP 
            FETCH subcategories_cursor INTO subcategory;
            EXIT WHEN NOT FOUND;
            -- Remover dos sitios onde uma super categoria apareceria
            DELETE FROM tem_outra WHERE categoria_nome=subcategory;
            DELETE FROM super_categoria WHERE super_categoria_nome=subcategory;
            DELETE FROM categoria WHERE categoria_nome=subcategory;
        END LOOP;
        CLOSE subcategories_cursor;
        DELETE FROM prateleira WHERE categoria_simples_nome=category;
        DELETE FROM tem_outra WHERE categoria_nome=category;
        DELETE FROM super_categoria WHERE super_categoria_nome=category;
        DELETE FROM categoria WHERE categoria_nome=category;
        DELETE FROM categoria WHERE categoria_nome=category;
    ELSE
        PERFORM remove_simple_category(category);
    END IF;
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION remove_simple_category(IN category CHAR) RETURNS VOID AS
$$
BEGIN
    -- Remover todas as relações hierárquicas de "category"
    DELETE FROM tem_outra WHERE categoria_nome=category;
    -- Remover as entradas de evento_reposição que tenham produtos de "category"
    DELETE FROM evento_reposicao WHERE ean IN (
        SELECT tc.ean 
        FROM tem_categoria tc 
        JOIN produto p ON tc.categoria_simples_nome=p.categoria_simples_nome
        WHERE p.categoria_simples_nome=category
    );
    -- Remover as entradas de planograma que tenham prateleiras de "category"
    --      e/ou produtos de "category"
    DELETE FROM planograma WHERE (ean, num_prateleira, num_serie, fabricante) IN (
        SELECT pl.ean, pl.num_prateleira, pl.num_serie, pl.fabricante
        FROM prateleira sh JOIN planograma pl 
        ON sh.num_prateleira=pl.num_prateleira AND sh.num_serie=pl.num_serie AND sh.fabricante=pl.fabricante
        JOIN produto p ON pl.ean=p.ean
        WHERE sh.categoria_simples_nome=category OR p.categoria_simples_nome=category
    );
    -- Remover as entradas de prateleira de "category"
    DELETE FROM prateleira WHERE categoria_simples_nome=category;
    -- Remover todas as linhas em que "category" apareça como categoria de um produto
    DELETE FROM tem_categoria WHERE categoria_simples_nome=category;
    -- Remover produtos que participam em tem_categoria associados a "category"
    DELETE FROM produto WHERE ean IN (
        SELECT ean
        FROM tem_categoria
        WHERE categoria_simples_nome=category
    );
    -- Remover produtos com categoria principal "category"
    DELETE FROM produto WHERE categoria_simples_nome=category;
    -- Remover "category" de categoria_simples, se existir
    DELETE FROM categoria_simples WHERE categoria_simples_nome=category;
    -- Remover "category"
    DELETE FROM categoria WHERE categoria_nome=category;
END
$$ LANGUAGE plpgsql;