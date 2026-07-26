FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app

# Model tidak dibundel di image ini (233 MB) — diunduh otomatis dari Hugging Face
# Hub saat startup pertama kali (lihat app/services/inference.py::get_model_path).
ENV MODEL_HF_REPO_ID=eranusadata/rice-growth-hybrid-fusion-model

EXPOSE 8000

# Render & Railway menyuntikkan env var $PORT sendiri; fallback ke 8000 untuk
# `docker run` lokal biasa.
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}"]
