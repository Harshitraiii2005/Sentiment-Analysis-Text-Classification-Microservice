from pydantic import BaseModel
from typing import List, Optional, Dict

class PredictRequest(BaseModel):
    text: str
    candidate_topics: Optional[List[str]] = None

class BatchRequest(BaseModel):
    texts: List[str]
    candidate_topics: Optional[List[str]] = None

class PredictionResponse(BaseModel):
    sentiment: Dict[str, float]
    topic: Dict[str, float]
    full_topic_scores: Dict[str, float]
    latency_ms: float