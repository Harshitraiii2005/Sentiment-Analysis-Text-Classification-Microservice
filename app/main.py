from fastapi import FastAPI, BackgroundTasks, Request
from app.schemas import PredictRequest, BatchRequest, PredictionResponse
from app.models import NLPModels
from app.background import log_prediction
from app.utils import setup_limiter
import time

app = FastAPI(
    title="Indic Sentiment & Topic Classifier API",
    description="Production-grade multilingual NLP service with FastAPI + Transformers + K8s",
    version="1.0.0"
)

setup_limiter(app)
models = NLPModels()

@app.post("/predict", response_model=PredictionResponse)
async def predict(request: Request, data: PredictRequest, background: BackgroundTasks):
    start = time.time()
    result = await models.predict(data.text, data.candidate_topics)
    latency = time.time() - start

    background.add_task(log_prediction, data.text, result, latency)

    return {**result, "latency_ms": round(latency * 1000, 2)}

@app.post("/batch-predict")
async def batch_predict(data: BatchRequest, background: BackgroundTasks):
    results = []
    for text in data.texts[:20]:  # limit batch size for safety
        result = await models.predict(text, data.candidate_topics)
        results.append(result)
        background.add_task(log_prediction, text, result, 0)  # latency not measured per item
    return {"predictions": results, "batch_size": len(results)}

@app.get("/health")
async def health():
    return {"status": "healthy"}

@app.get("/ready")
async def ready():
    # Simple check - can add model warm-up if needed
    return {"status": "ready"}