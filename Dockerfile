# Dockerfile de l'application Flask - à compléter
#
# 1. Partir d'une image Python 3.12 légère       (FROM)
# 2. Se placer dans le dossier /app              (WORKDIR)
# 3. Copier requirements.txt puis installer les dépendances avec pip  (COPY, RUN)
# 4. Copier le code de l'application (main.py)   (COPY)
# 5. Indiquer le port utilisé par l'application : 4000  (EXPOSE)
# 6. Lancer l'application : python main.py       (CMD)


# Image de base légère : "slim" (~45 Mo) plutôt que l'image complète (~1 Go)
FROM python:3.12-slim

# Pas de .pyc, logs affichés tout de suite, pas de cache pip dans l'image
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

# Dépendances AVANT le code : elles changent rarement, donc cette couche
# reste en cache tant que requirements.txt ne bouge pas.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Utilisateur sans privilèges : l'application ne tourne pas en root
RUN useradd --create-home --uid 1000 appuser

# Le code en dernier (c'est ce qui change le plus souvent), et seulement main.py
COPY --chown=appuser:appuser main.py .

USER appuser

EXPOSE 4000

CMD ["python", "main.py"]