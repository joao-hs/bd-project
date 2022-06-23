#!/usr/bin/python3
from wsgiref.handlers import CGIHandler
from flask import Flask, render_template, request
import psycopg2
import psycopg2.extras

DB_HOST = "db.tecnico.ulisboa.pt"
DB_USER = "ist199249"
DB_DATABASE=DB_USER
DB_PASSWORD="khgm6034"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)

app = Flask(__name__)

@app.route('/menu')
def menu():
    try:
        return render_template("index.html")
    except Exception as e:
        return str(e)

@app.route('/gerir-categorias')
def manage_categories():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT * FROM categoria;"
        cursor.execute(query)
        return render_template("manage_categories.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/inserir-categoria', methods=["POST"])
def insert_category():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        categoria = request.form["categoria"]
        query = "START TRANSACTION; INSERT INTO categoria VALUES (%s); INSERT INTO categoria_simples VALUES (%s); COMMIT;"
        data = (categoria, categoria)
        cursor.execute(query, data)
        return render_template("landing_manage_categories.html", params=query)
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route('/remover-categoria', methods=["GET"])
def remove_category():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        categoria = request.args["categoria"]
        query = "START TRANSACTION; DO $$ BEGIN PERFORM remove_category(%s); END $$ LANGUAGE plpgsql; COMMIT;"
        data = (categoria, )
        cursor.execute(query, data)
        return render_template("landing_manage_categories.html", params=query)
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route('/gerir-retalhistas')
def manage_retailer():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT * FROM retalhista;"
        cursor.execute(query)
        return render_template("manage_retailers.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/inserir-retalhista', methods=["POST"])
def insert_retailer():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        tin = request.form["tin"]
        nome = request.form["nome"]
        query = "START TRANSACTION; INSERT INTO retalhista VALUES (%s, %s); COMMIT;"
        data = (tin, nome)
        cursor.execute(query, data)
        return render_template("landing_manage_retailers.html", params=query)
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route('/remover-retalhista', methods=["GET"])
def remove_retailer():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        tin = request.args["tin"]
        query = "START TRANSACTION; DO $$ BEGIN PERFORM remove_retailer(%s); END $$ LANGUAGE plpgsql; COMMIT;"
        data = (tin, )
        cursor.execute(query, data)
        return render_template("landing_manage_retailers.html", params=query)
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route('/ivm')
def get_ivm():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT DISTINCT num_serie, fabricante FROM evento_reposicao;"
        cursor.execute(query)
        return render_template("ivm.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/eventos', methods=["GET"])
def list_events():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        num_serie = request.args["num_serie"]
        fabricante = request.args["fabricante"]
        query = "SELECT categoria_simples_nome, SUM(unidades) FROM evento_reposicao er JOIN produto p ON er.ean=p.ean WHERE num_serie = %s AND fabricante = %s GROUP BY categoria_simples_nome;"
        data = (num_serie, fabricante)
        cursor.execute(query, data)
        return render_template("events.html", cursor=cursor, params=request.args)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()


@app.route('/categoria')
def choose_category():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT DISTINCT super_categoria FROM hierarquias_cat WHERE super_categoria IS NOT NULL;"
        cursor.execute(query)
        return render_template("category.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()


@app.route('/listar-subcategorias', methods=["GET"])
def list_subcategories():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        categoria = request.args["categoria"]
        query = "SELECT * FROM subcategories_of(%s)"
        data = (categoria, )
        cursor.execute(query, data)
        return render_template("list_subcategories.html", cursor=cursor, params=request.args)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/sql1')
def sql1():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT retalhista_nome FROM (SELECT tin, COUNT(*) FROM responsavel_por GROUP BY tin HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM responsavel_por GROUP BY tin)) AS aux JOIN retalhista ON aux.tin=retalhista.tin;"
        cursor.execute(query)
        return render_template("sql1.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/sql2')
def sql2():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT DISTINCT retalhista_nome FROM retalhista AS r JOIN responsavel_por AS rp ON r.tin = rp.tin JOIN prateleira AS p ON rp.fabricante = p.fabricante AND rp.num_serie = p.num_serie;"
        cursor.execute(query)
        return render_template("sql2.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()
    
@app.route('/sql3')
def sql3():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "(SELECT ean FROM produto) EXCEPT (SELECT ean FROM evento_reposicao);"
        cursor.execute(query)
        return render_template("sql3.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()
    
@app.route('/sql4')
def sql4():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT ean FROM (SELECT DISTINCT ean, tin FROM evento_reposicao)AS a GROUP BY ean HAVING COUNT(*) = 1;"
        cursor.execute(query)
        return render_template("sql4.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/olap1')
def olap1():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT dia_semana, concelho, SUM ( unidades ) AS unidades_totais FROM vendas WHERE((CAST(ano AS int)*10000+CAST(mes AS int)*100+CAST(dia_mes AS int)) BETWEEN 20220201 AND 20230101) GROUP BY CUBE (dia_semana, concelho);"
        cursor.execute(query)
        return render_template("olap1.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/olap2')
def olap2():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT concelho, cat, dia_semana, SUM ( unidades ) AS unidades_totais FROM vendas WHERE distrito = 'Lisboa' GROUP BY GROUPING SETS ((cat, concelho),(cat, dia_semana), (concelho), (cat), (dia_semana), ());"
        cursor.execute(query)
        return render_template("olap2.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

CGIHandler().run(app)