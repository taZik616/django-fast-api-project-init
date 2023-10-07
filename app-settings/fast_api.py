from api.v1.app import app
from fastapi.middleware.wsgi import WSGIMiddleware

from .wsgi import application as DjangoApp

app.mount("/", WSGIMiddleware(DjangoApp))
