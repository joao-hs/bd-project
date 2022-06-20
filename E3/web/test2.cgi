#!/usr/bin/python3

from wsgiref.handlers import CGIHandler

from flask import Flask

import psycopg2
import psycopg2.extras

DB_HOST = "db.tecnico.ulisboa.pt"
DB_USER = "ist199249"
DB_DATABASE=DB_USER
DB_PASSWORD="khgm6034"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)

app = Flask(__name__)

@app.route('/list_accounts')
def list_accounts():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT * FROM borrower;"
        cursor.execute(query)
        rowcount=cursor.rowcount

        # Python 3.6 introduced f-strings
        # We will use them here to build the HTML string
        html = f'''
        <!DOCTYPE html>
        <html>
            <head>
                <meta charset="utf-8">
                <title> List accounts - Python</title>
            </he/list_accountsad>
            <body style="padding:20px">
                <table border="3">
                    <thead>
                        <tr>
                            <th>account_number</th>
                            <th>branch_name</th>
                        </tr>
                    </thead>
                    <tbody>
        '''

        for record in cursor:
            html += f'''
                        <tr>
                            <td>{record[0]}</td>
                            <td>{record[1]}</td>
                        </tr
            '''
        html += '''
                    </tbody>
                </table>
            </body>
        </html>
        '''

        return html
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()
CGIHandler().run(app)