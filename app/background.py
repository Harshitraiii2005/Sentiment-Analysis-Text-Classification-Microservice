import json
import redis.asyncio as redis
from datetime import datetime

redis_client = None

async def get_redis():
    global redis_client
    if redis_client is None:
        redis_client = redis.Redis(host='redis', port=6379, decode_responses=True)
    return redis_client

async def log_prediction(text: str, result: dict, latency: float):
    try:
        r = await get_redis()
        log_entry = {
            "timestamp": datetime.utcnow().isoformat(),
            "text": text[:200],  # truncate long text
            "sentiment": result["sentiment"],
            "topic": result["topic"],
            "latency_ms": latency * 1000
        }
        await r.lpush("prediction_logs", json.dumps(log_entry))
        await r.ltrim("prediction_logs", 0, 9999)  # keep last 10k logs
    except Exception:
        # fallback to console
        print(f"[LOG] {datetime.utcnow()} | Latency: {latency*1000:.1f}ms | {result}")