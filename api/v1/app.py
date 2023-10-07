from fastapi import FastAPI

app = FastAPI()
app.mount("/api/v1", app)
