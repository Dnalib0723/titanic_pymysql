from flask import Flask, jsonify
import pymysql

app = Flask(__name__)

def get_db_connection():
    return pymysql.connect(
        host='db',
        user='user',
        password='password',
        database='titanic',
        cursorclass=pymysql.cursors.DictCursor
    )

@app.route('/passengers')
def get_passengers():
    connection = get_db_connection()
    with connection:
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM passengers")
            result = cursor.fetchall()
            return jsonify(result)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)