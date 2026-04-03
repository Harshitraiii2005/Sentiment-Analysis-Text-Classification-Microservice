FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.12-slim
WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin/uvicorn /usr/local/bin/uvicorn

COPY app/ ./app/

# Pre-download models during build (reduces cold start)
RUN python -c '
from transformers import pipeline
print("Downloading sentiment model...")
pipeline("text-classification", model="tabularisai/multilingual-sentiment-analysis")
print("Downloading topic model...")
pipeline("zero-shot-classification", model="facebook/bart-large-mnli")
print("Models ready!")
'

EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "2"]