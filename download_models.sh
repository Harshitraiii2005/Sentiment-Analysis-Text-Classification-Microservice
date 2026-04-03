#!/bin/bash
echo "========================================"
echo "Starting model download for Indic NLP API"
echo "========================================"

echo "Downloading Sentiment Model (nlptown multilingual)..."
python -c '
from transformers import pipeline
pipeline("text-classification", model="nlptown/bert-base-multilingual-uncased-sentiment")
print("✅ Sentiment model downloaded successfully!")
'

echo "Downloading Topic Model (mDeBERTa multilingual)..."
python -c '
from transformers import pipeline
pipeline("zero-shot-classification", model="MoritzLaurer/mDeBERTa-v3-base-mnli-xnli")
print("✅ Topic model downloaded successfully!")
'

echo "========================================"
echo "✅ All models downloaded successfully!"
echo "========================================"