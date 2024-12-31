from flask import Flask
import os

app = Flask(__name__)

container_id = os.getenv("HOSTNAME", "Unknown Container")
client_id = os.getenv("CLIENT_ID", "Unknown Client ID")

@app.route("/")
def home():
    return (
        f"Hello, Community! This is a Python container app served by container ID: {container_id}. "
        f"The CLIENT_ID is: {client_id}"
    )

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
