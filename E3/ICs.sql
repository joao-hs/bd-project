--- ICS ---
-----------

-- IC1 --
CREATE TRIGGER category_check_trigger
BEFORE INSERT ON tem_outra
FOR EACH ROW EXECUTE PROCEDURE category_check_proc()

CREATE OR REPLACE FUNCTION category_check_proc()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.super_categoria_nome = NEW.categoria_nome THEN
        RAISE EXCEPTION '(IC-1) Uma Categoria não pode estar contida em si própria '
    END IF;

END;
$$ LANGUAGE plpgsql;

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
        FETCH cursor_planogram INTO p_ean, num_p, num_s, fab, unit;
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
EXECUTE PROCEDURE max_units_proc();

-- IC3 --
CREATE TRIGGER verifica_categorias_trigger
BEFORE INSERT ON prateleira
EXECUTE PROCEDURE verifica_planograma();

CREATE OR REPLACE FUNCTION verifica_planograma() RETURNS TRIGGER AS $$
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
        FETCH cursor_planogram INTO p_ean, num_p, num_s, fab, unit;
        EXIT WHEN NOT FOUND;
        IF NEW.num_prateleira = num_p AND NEW.num_serie = num_s AND NEW.fabricante = fab THEN
            IF NEW.categoria_nome NOT IN (SELECT categoria_nome FROM tem_categoria WHERE ean = NEW.ean) THEN
                RAISE EXCEPTION 'bla bla'
            END IF;
        END IF;
    END LOOP;
    CLOSE cursor_planogram;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;