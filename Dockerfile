# ==================== Stage 1: Builder ====================
FROM python:3.12-slim AS builder
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ==================== Stage 2: Runtime ====================
FROM python:3.12-slim
WORKDIR /app

# Copy installed packages from builder stage
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin/uvicorn /usr/local/bin/uvicorn

# Copy application code
COPY app/ ./app/

# Pre-download models during build (reduces cold start dramatically)
RUN python -c "
from transformers import pipeline
import torch
print('Downloading sentiment model (nlptown multilingual 1-5 stars)...')
pipeline('text-classification', model='nlptown/bert-base-multilingual-uncased-sentiment')
print('Downloading topic model (mDeBERTa multilingual zero-shot)...')
pipeline('zero-shot-classification', model='MoritzLaurer/mDeBERTa-v3-base-mnli-xnli')
print('All models downloaded successfully!')
"

EXPOSE 8000

# Run uvicorn (2 workers is good balance for CPU + transformer inference)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "2"]