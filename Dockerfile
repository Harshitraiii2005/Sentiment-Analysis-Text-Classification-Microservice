FROM python:3.11-slim

WORKDIR /app

# Install system dependencies for SSL
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates openssl && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip \
    --trusted-host pypi.org \
    --trusted-host pypi.python.org \
    --trusted-host files.pythonhosted.org

# Install Python packages with SSL verification disabled (this is the key for your environment)
COPY requirements.txt .
RUN PIP_DISABLE_PIP_VERSION_CHECK=1 \
    pip install --no-cache-dir \
    --trusted-host pypi.org \
    --trusted-host pypi.python.org \
    --trusted-host files.pythonhosted.org \
    --disable-pip-version-check \
    --no-deps \
    -r requirements.txt

# Copy your app code
COPY app/ ./app/
COPY templates/ ./templates/
COPY main.py .
COPY static/ ./static/ || true

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]