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

CGIHandler().run(app)