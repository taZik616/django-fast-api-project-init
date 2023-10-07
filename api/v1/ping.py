from .app import app


@app.get("/ping")
def ping():
    return {"message": "pong"}
