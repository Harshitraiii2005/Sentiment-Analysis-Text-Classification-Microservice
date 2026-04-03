from transformers import pipeline
import torch
from typing import List, Optional
from functools import lru_cache

class NLPModels:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._init_models()
        return cls._instance

    def _init_models(self):
        device = 0 if torch.cuda.is_available() else -1
        
        # Multilingual Sentiment Model (supports Hindi, Telugu, Bengali, etc.)
        print("Loading sentiment model... (first time will download ~500MB)")
        self.sentiment_pipeline = pipeline(
            "text-classification",
            model="tabularisai/multilingual-sentiment-analysis",
            device=device
        )
        
        # Zero-shot Topic Classification (works well with Indian languages)
        print("Loading topic model... (first time will download ~1.6GB)")
        self.topic_pipeline = pipeline(
            "zero-shot-classification",
            model="facebook/bart-large-mnli",
            device=device
        )

    async def predict(self, text: str, candidate_topics: Optional[List[str]] = None):
        if not candidate_topics:
            candidate_topics = ["politics", "sports", "technology", "entertainment", 
                              "business", "health", "education", "science", "travel"]

        # Sentiment prediction
        sent_result = self.sentiment_pipeline(text)[0]
        
        # Topic prediction
        topic_result = self.topic_pipeline(
            text, 
            candidate_labels=candidate_topics, 
            multi_label=False
        )

        return {
            "sentiment": {
                "label": sent_result["label"],
                "score": round(float(sent_result["score"]), 4)
            },
            "topic": {
                "label": topic_result["labels"][0],
                "score": round(float(topic_result["scores"][0]), 4)
            },
            "full_topic_scores": dict(zip(
                topic_result["labels"], 
                [round(float(s), 4) for s in topic_result["scores"]]
            ))
        }