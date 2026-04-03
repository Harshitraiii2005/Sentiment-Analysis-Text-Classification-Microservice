# ==================== Stage 1: Builder ====================
FROM python:3.12-slim AS builder
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ==================== Stage 2: Runtime ====================
FROM python:3.12-slim
WORKDIR /app

# Copy Python packages and uvicorn from builder
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin/uvicorn /usr/local/bin/uvicorn

# Copy app code
COPY app/ ./app/

# Pre-download models (safer single-line style with ; separators)
RUN python -c "
    import torch
    from transformers import pipeline
    print('Downloading sentiment model...')
    pipeline('text-classification', model='nlptown/bert-base-multilingual-uncased-sentiment')
    print('Downloading topic model...')
    pipeline('zero-shot-classification', model='MoritzLaurer/mDeBERTa-v3-base-mnli-xnli')
    print('✅ All models downloaded successfully!')
    "

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "2"]