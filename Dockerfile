# ==================== Stage 1: Builder (install deps) ====================
FROM python:3.12-slim AS builder
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ==================== Stage 2: Runtime ====================
FROM python:3.12-slim
WORKDIR /app

# Copy installed packages and uvicorn from builder
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin/uvicorn /usr/local/bin/uvicorn

# Copy your application code + static + templates
COPY app/ ./app/
COPY static/ ./static/
COPY templates/ ./templates/

# Copy and run model download script
COPY download_models.sh .
RUN chmod +x download_models.sh && ./download_models.sh

# Install curl for health checks (if needed)
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8000

# Run with 1 worker (good for memory-constrained environments)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "1"]