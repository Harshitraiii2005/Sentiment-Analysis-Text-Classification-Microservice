from transformers import pipeline
import torch
from typing import List, Optional

class NLPModels:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._init_models()
        return cls._instance

    def _init_models(self):
        device = 0 if torch.cuda.is_available() else -1
        
        # Sentiment: 5-star multilingual model (good for Hindi/Hinglish)
        print("Loading sentiment model (nlptown 1-5 stars)...")
        self.sentiment_pipeline = pipeline(
            "text-classification",
            model="nlptown/bert-base-multilingual-uncased-sentiment",
            device=device
        )
        
        # Topic: Faster multilingual zero-shot model
        print("Loading fast topic model (mDeBERTa)...")
        self.topic_pipeline = pipeline(
            "zero-shot-classification",
            model="MoritzLaurer/mDeBERTa-v3-base-mnli-xnli",
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