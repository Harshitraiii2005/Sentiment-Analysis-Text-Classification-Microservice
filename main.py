from fastapi import FastAPI, BackgroundTasks, Request, Form
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
import uvicorn

from app.schemas import PredictRequest, BatchRequest
from app.models import NLPModels
from app.background import log_prediction
from app.utils import setup_limiter
import time

app = FastAPI(
    title="Indic Sentiment & Topic Classifier API",
    description="Production-grade multilingual NLP service",
    version="1.0.0"
)

# Mount static files and templates
app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")

setup_limiter(app)
models = NLPModels()

# ====================== API Endpoints (unchanged) ======================
@app.post("/predict")
async def predict_api(request: Request, data: PredictRequest, background: BackgroundTasks):
    start = time.time()
    result = await models.predict(data.text, data.candidate_topics)
    latency = time.time() - start
    background.add_task(log_prediction, data.text, result, latency)
    return {**result, "latency_ms": round(latency * 1000, 2)}

@app.post("/batch-predict")
async def batch_predict(data: BatchRequest, background: BackgroundTasks):
    results = []
    for text in data.texts[:20]:
        result = await models.predict(text, data.candidate_topics)
        results.append(result)
        background.add_task(log_prediction, text, result, 0)
    return {"predictions": results, "batch_size": len(results)}

@app.get("/health")
async def health():
    return {"status": "healthy"}

@app.get("/ready")
async def ready():
    return {"status": "ready"}

# ====================== WEB UI Routes ======================
@app.get("/", response_class=HTMLResponse)
async def home(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})

@app.post("/ui-predict", response_class=HTMLResponse)
async def ui_predict(
    request: Request,
    text: str = Form(...),
    topics: str = Form("politics,sports,technology,entertainment,business,health,education")
):
    start = time.time()
    candidate_topics = [t.strip() for t in topics.split(",") if t.strip()]
    
    result = await models.predict(text, candidate_topics)
    latency = round((time.time() - start) * 1000, 2)

    # Log in background
    background = BackgroundTasks()
    background.add_task(log_prediction, text, result, latency/1000)

    return templates.TemplateResponse(
        "index.html",
        {
            "request": request,
            "text": text,
            "result": result,
            "latency": latency,
            "topics": topics
        }
    )

if __name__ == "__main__":
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000)