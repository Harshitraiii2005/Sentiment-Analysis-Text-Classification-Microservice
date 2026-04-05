FROM python:3.11-slim

WORKDIR /app

# Update system packages and install CA certificates (critical for SSL)
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates openssl && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip with trusted hosts
RUN pip install --no-cache-dir --upgrade pip \
    --trusted-host pypi.org \
    --trusted-host pypi.python.org \
    --trusted-host files.pythonhosted.org

# Copy and install requirements with maximum tolerance for SSL issues
COPY requirements.txt .
RUN pip install --no-cache-dir \
    --trusted-host pypi.org \
    --trusted-host pypi.python.org \
    --trusted-host files.pythonhosted.org \
    -r requirements.txt

# Copy application code
COPY app/ ./app/
COPY templates/ ./templates/
COPY main.py .
COPY static/ ./static/ 

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]