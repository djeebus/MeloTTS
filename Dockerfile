FROM python:3.9-slim
WORKDIR /app

RUN apt-get update && apt-get install curl -y \
    build-essential libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

ARG POETRY_VERSION=""
ENV POETRY_VERSION=$POETRY_VERSION
ENV POETRY_HOME="/usr/local"

RUN curl -sSL https://install.python-poetry.org | python -

COPY pyproject.toml .
COPY poetry.lock .
RUN poetry install --no-root

COPY . /app
RUN poetry install
RUN poetry run python -m unidic download
RUN poetry run python melo/init_downloads.py

EXPOSE 8888
CMD ["poetry", "run", "python", "./melo/app.py", "--host", "0.0.0.0", "--port", "8888"]
