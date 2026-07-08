# Imagen base liviana con Python
FROM python:3.12-slim

WORKDIR /app

# Instalar dependencias primero (mejor caché de capas)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# El monolito sirve TANTO la API como el frontend (static/)
COPY app.py .
COPY static/ static/

EXPOSE 8000

# 1 worker a propósito: con varios, cada uno tiene SUS PROPIAS métricas en
# memoria y Prometheus haría scrape a uno u otro al azar, dando números
# inconsistentes. Para el lab, 1 worker mantiene las métricas correctas.
# Forma shell (no exec) para que $PORT se expanda. Cloud Run inyecta PORT
# (por defecto 8080); el ${PORT:-8000} mantiene el arranque local en 8000.
CMD gunicorn --bind 0.0.0.0:${PORT:-8000} --workers 1 app:app
