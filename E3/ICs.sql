--- ICS ---
-----------

-- IC1 --

CREATE OR REPLACE FUNCTION category_check_proc()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.super_categoria_nome = NEW.categoria_nome THEN
        RAISE EXCEPTION '(IC-1) Uma Categoria não pode estar contida em si própria';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER category_check_trigger
BEFORE INSERT ON tem_outra
FOR EACH ROW EXECUTE PROCEDURE category_check_proc();

-- IC2 --
CREATE OR REPLACE FUNCTION max_units_proc()
RETURNS TRIGGER AS
$$
DECLARE p_ean numeric(13);
DECLARE num_p numeric(2);
DECLARE num_s numeric(13);
DECLARE fab varchar(80);
DECLARE unit numeric(4);
DECLARE cursor_planogram CURSOR FOR
    SELECT ean, num_prateleira, num_serie, fabricante,unidades FROM planograma;
BEGIN
    OPEN cursor_planogram;     
    LOOP
        FETCH FROM cursor_planogram INTO p_ean, num_p, num_s, fab, unit;
        EXIT WHEN NOT FOUND;
        IF NEW.ean = p_ean AND NEW.num_prateleira = num_p AND NEW.num_serie = num_s
        AND NEW.fabricante = fab THEN
            IF NEW.unidades > unit THEN
              RAISE EXCEPTION '(IC-2) O número de unidades repostas num Evento de Reposição não pode exceder o número de unidades especificado no Planograma';
            END IF;
        END IF;
    END LOOP; 
    CLOSE cursor_planogram;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER max_units_trigger
BEFORE INSERT ON evento_reposicao
FOR EACH ROW EXECUTE PROCEDURE max_units_proc();

-- IC3 --
CREATE TRIGGER verifica_categorias_trigger
BEFORE INSERT ON evento_reposicao
FOR EACH ROW EXECUTE PROCEDURE verifica_categoria_prateleira();

CREATE OR REPLACE FUNCTION verifica_categoria_prateleira() 
RETURNS TRIGGER AS 
$$
DECLARE num_p numeric(2);
DECLARE num_s numeric(13);
DECLARE fab varchar(80);
DECLARE nome_c varchar(80);
DECLARE cursor_prateleira CURSOR FOR
    SELECT num_prateleira, num_serie, fabricante, categoria_simples_nome FROM prateleira ;
BEGIN
    OPEN cursor_prateleira;
    LOOP
        FETCH cursor_prateleira INTO num_p, num_s, fab, nome_c;
        EXIT WHEN NOT FOUND;
        IF NEW.num_prateleira = num_p AND NEW.num_serie = num_s AND NEW.fabricante = fab THEN
            IF nome_c NOT IN (SELECT categoria_simples_nome FROM tem_categoria WHERE ean = NEW.ean) THEN
                RAISE EXCEPTION '(IC-5) Um Produto só pode ser reposto numa Prateleira que apresente (pelo menos) uma das Categorias desse produto';
            END IF;
        END IF;
    END LOOP;
    CLOSE cursor_prateleira;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;