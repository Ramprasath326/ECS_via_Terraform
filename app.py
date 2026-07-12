from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello Ram, this is running inside a Docker container!"

@app.route("/health")
def health():
    return {"status": "healthy"}, 200