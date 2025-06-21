from flask import Flask, jsonify
from flask_cors import CORS
from azure.cosmos import CosmosClient, PartitionKey, exceptions
import os

app = Flask(__name__)
CORS(app)

# Connessione a Cosmos DB
COSMOS_URI = os.environ.get("COSMOS_URI")
COSMOS_KEY = os.environ.get("COSMOS_KEY")
DATABASE_NAME = "azure-sql-db"
CONTAINER_NAME = "visite"
PARTITION_KEY = "/id"

client = CosmosClient(COSMOS_URI, credential=COSMOS_KEY)
db = client.create_database_if_not_exists(DATABASE_NAME)
container = db.create_container_if_not_exists(
    id=CONTAINER_NAME,
    partition_key=PartitionKey(path=PARTITION_KEY)
)

# Inizializza il documento contatore (una volta sola)
def init_counter():
    try:
        container.read_item(item="main", partition_key="main")
    except exceptions.CosmosResourceNotFoundError:
        container.create_item({"id": "main", "count": 0})

init_counter()

@app.route("/counter")
def count():
    item = container.read_item(item="main", partition_key="main")
    item["count"] += 1
    print(item["count"])
    container.replace_item(item="main", body=item)

    return jsonify(count=item["count"]), 200

@app.route("/health")
def health():
    return jsonify(status="ok"), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)