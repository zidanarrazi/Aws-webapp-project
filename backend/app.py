# backend/app.py
from flask import Flask, request, jsonify
import mysql.connector
import os

app = Flask(__name__)

db_config = {
    'host': os.environ.get('DB_HOST'),
    'user': os.environ.get('DB_USER'),
    'password': os.environ.get('DB_PASSWORD'),
    'database': os.environ.get('DB_NAME')
}

@app.route('/', methods=['GET'])
def health_check():
    return "Web App is Running"

@app.route('/submit', methods=['POST'])
def submit():
    data = request.get_json()
    idea = data.get('idea')

    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        cursor.execute("CREATE TABLE IF NOT EXISTS ideas (id INT AUTO_INCREMENT PRIMARY KEY, idea TEXT)")
        cursor.execute("INSERT INTO ideas (idea) VALUES (%s)", (idea,))
        conn.commit()
        return jsonify({'message': 'Idea submitted successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
