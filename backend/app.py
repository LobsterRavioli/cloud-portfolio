from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)


CORS(app)  # per permettere richieste da un dominio frontend diverso

counter = 0

@app.route("/counter")
def count():
    global counter
    counter += 1
    return jsonify(count=counter), 200

@app.route("/health")
def health():
    return jsonify(status="ok"), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)