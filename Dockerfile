FROM python:3.11-slim

WORKDIR /app

# Install system CA certificates + update them (fixes most SSL issues in slim images)
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip first (helps with newer SSL handling)
RUN pip install --no-cache-dir --upgrade pip

# Install dependencies with trusted hosts as fallback
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