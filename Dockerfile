FROM python:3.10-slim

# System dependencies
RUN apt-get update -qqy && \
    apt-get install -y --no-install-recommends \
        git \
        gcc \
        g++ \
        poppler-utils \
        libpoppler-dev \
        unzip \
        curl \
        && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Copy project
COPY . /app
COPY .env.example /app/.env

# Download pdfjs for PDF viewer
RUN chmod +x /app/scripts/download_pdfjs.sh && \
    bash /app/scripts/download_pdfjs.sh /app/libs/ktem/ktem/assets/prebuilt/pdfjs-dist

# Install Python dependencies with pip
RUN pip install --no-cache-dir -e "libs/kotaemon[all]" && \
    pip install --no-cache-dir -e "libs/ktem"

# Pre-download multilingual embedding model
RUN python -c "from fastembed import TextEmbedding; TextEmbedding(model_name='BAAI/bge-m3')" || true

# Railway compatibility
ENV GRADIO_SERVER_NAME=0.0.0.0
ENV GRADIO_SERVER_PORT=7860
EXPOSE 7860

CMD ["python", "app.py"]
