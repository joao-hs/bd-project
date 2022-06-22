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

@app.route('/')
def menu():
    try:
        render_template("index.html")
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
        return render_template("manage_categories.html", cursor=cursor, params=request.args)
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
        query = "START TRANSACTION; INSERT INTO categoria values (%s); INSERT INTO categoria_simples values (%s); COMMIT;"
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
    pass

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

@app.route('/eventos')
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
        """
        SELECT sub_categoria
        FROM(
            WITH RECURSIVE sub_categorias AS (
                SELECT sub_categoria, super_categoria
                FROM hierarquias_cat
                WHERE sub_categoria = %s
                UNION
                    SELECT hc.sub_categoria, hc.super_categoria
                    FROM hierarquias_cat AS hc
                    JOIN sub_categorias sc ON sc.sub_categoria=hc.super_categoria
            ) SELECT *
            FROM sub_categorias
        ) AS aux
        WHERE sub_categoria <> %s;
        """
        query = "SELECT sub_categoria FROM (WITH RECURSIVE sub_categorias AS (SELECT sub_categoria, super_categoria FROM hierarquias_cat WHERE sub_categoria = %s UNION SELECT hc.sub_categoria, hc.super_categoria FROM hierarquias_cat AS hc JOIN sub_categorias sc ON sc.sub_categoria=hc.super_categoria) SELECT * FROM sub_categorias) AS aux WHERE sub_categoria <> %s;"
        data = (categoria, categoria)
        cursor.execute(query, data)
        return render_template("list_subcategories.html", cursor=cursor, params=request.args)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

#_____________________________________________________________

@app.route('/list_accounts')
def list_accounts():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT * FROM account;"
        cursor.execute(query)
        return render_template("index.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/accounts')
def list_accounts_edit():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT account_number, branch_name, balance FROM account;"
        cursor.execute(query)
        return render_template("accounts.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/balance')
def change_balance():
    try:
        return render_template("balance.html", params=request.args)
    except Exception as e:
        return str(e)

@app.route('/update', methods=["POST"])
def update_balance():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        balance=request.form["balance"]
        account_number=request.form["account_number"]
        query = "UPDATE account SET balance=%s WHERE account_number=%s"
        data=(balance,account_number)
        cursor.execute(query, data)
        return query
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


CGIHandler().run(app)