FROM python:3.11-slim

WORKDIR /app

# Install dependencies first (better layer caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your application code
COPY app/ ./app/
COPY templates/ ./templates/
COPY main.py .

# Handle static directory safely (this is the fix)
RUN mkdir -p static
COPY static/ ./static/ || true   # <--- This prevents build failure if static/ is empty or missing

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]