from flask import Flask
app=Flask(__name__)
@app.route('/')
def home():
    return "Hello from devops ci/cd pipeline, docker img v1"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)