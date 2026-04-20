
# Indic NLP • Sentiment & Topic Classifier

![License](https://img.shields.io/badge/License-MIT-yellow.svg)
![Python](https://img.shields.io/badge/Python-3.10%2B-blue.svg?logo=python&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-0.115-009485.svg?logo=fastapi&logoColor=white)
![Hugging Face](https://img.shields.io/badge/Hugging%20Face-FFD21E.svg?logo=huggingface&logoColor=black)
![Docker](https://img.shields.io/badge/Docker-2496ED.svg?logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5.svg?logo=kubernetes&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E.svg?logo=amazon-aws&logoColor=white)

**Production-grade Multilingual NLP Microservice** for **English + Hindi + Hinglish** text.

Analyze **sentiment** and perform **zero-shot topic classification** instantly with state-of-the-art Hugging Face models.

---

### 🌐 Live Demo

**Try it now →** [http://98.91.209.242/](http://98.91.209.242/)

Beautiful, responsive web UI with real-time analysis.

<img width="1600" height="1000" alt="image" src="https://github.com/user-attachments/assets/fad8e4ff-6352-4a77-b39d-2efeca0a3fb1" />
 <!-- Replace with actual screenshot later -->

---

### ✨ Key Features

- **Multilingual Support** — Excellent performance on English, Hindi, and Hinglish (code-mixed) text
- **Sentiment Analysis** — 5-star multilingual BERT model (`nlptown/bert-base-multilingual-uncased-sentiment`)
- **Zero-shot Topic Classification** — Powerful mDeBERTa model for flexible topic detection
- **Beautiful Web UI** — Premium, responsive interface built with Bootstrap + modern design
- **Production REST API** — FastAPI with Pydantic validation, Swagger docs, and rate limiting
- **Batch Processing** — Analyze up to 20 texts in a single request
- **Kubernetes Ready** — Full manifests (Deployment, HPA, Service, Ingress) included
- **Dockerized** — Optimized multi-layer Docker image with proper caching
- **Background Logging** — Async Redis-based prediction logging
- **Health Checks** — `/health` and `/ready` endpoints for production monitoring
- **Rate Limiting** — Protection against abuse using SlowAPI

---

### 🛠️ Tech Stack

- **Backend**: FastAPI + Uvicorn
- **ML Models**: Hugging Face Transformers (PyTorch)
- **Frontend**: Jinja2 + Bootstrap 5 + Font Awesome
- **Containerization**: Docker
- **Orchestration**: Kubernetes (Deployment + HPA)
- **Caching & Logging**: Redis (async)
- **API Documentation**: Swagger UI (OpenAPI)
- **Cloud**: AWS EC2 / EKS ready

---

### 🚀 Quick Start

#### Using Docker (Recommended)

```bash
docker pull harshitrai20/indie-nlp:latest

docker run -d -p 8000:8000 \
  --name indic-nlp \
  harshitrai20/indie-nlp:latest
```

Then open: `http://localhost:8000`

#### Local Development

```bash
git clone https://github.com/harshitrai20/indic-nlp.git
cd indic-nlp

# Install dependencies
pip install -r requirements.txt

# Run the app
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

---

### 📡 API Endpoints

| Method | Endpoint              | Description                          |
|--------|-----------------------|--------------------------------------|
| `POST` | `/predict`            | Single text prediction               |
| `POST` | `/batch-predict`      | Batch prediction (max 20 texts)      |
| `GET`  | `/health`             | Health check                         |
| `GET`  | `/ready`              | Readiness probe                      |
| `GET`  | `/docs`               | Swagger UI Documentation             |



---

### 📊 Model Performance

- **Sentiment Model**: `nlptown/bert-base-multilingual-uncased-sentiment` (Strong cross-lingual transfer for Hindi/Hinglish)
- **Topic Model**: `MoritzLaurer/mDeBERTa-v3-base-mnli-xnli` (Excellent zero-shot performance across 100+ languages)

Both models run on CPU/GPU automatically.

---

### 📁 Project Structure

```
indic-nlp/
├── app/
│   ├── main.py
│   ├── models.py          # NLPModels singleton
│   ├── schemas.py
│   ├── utils.py           # Rate limiter
│   ├── background.py      # Redis logging
│   └── templates/
├── kubernetes/            # Deployment, HPA, Service, Ingress
├── Dockerfile
├── requirements.txt
└── README.md
```

---

### 🔮 Future Scope & Roadmap

- [ ] **Fine-tuned Hindi Sentiment Model** for better accuracy on Indian social media text
- [ ] **Named Entity Recognition (NER)** for Indian names, locations, and organizations
- [ ] **Multimodal Support** — Image + Text sentiment (Memes, Posts)
- [ ] **Advanced Hinglish Handling** with custom tokenizer
- [ ] **User Dashboard** with history and analytics
- [ ] **A/B Testing** framework for model versions
- [ ] **Monitoring** with Prometheus + Grafana
- [ ] **CI/CD Pipeline** using GitHub Actions
- [ ] **Support for more Indic languages** (Tamil, Telugu, Bengali, etc.)
- [ ] **SaaS Version** with API key authentication and usage quotas

---

### 🧪 Demo Texts

**English**:
> "The new iPhone is absolutely amazing but too expensive!"

**Hindi**:
> "यह सरकार की नीतियां बहुत अच्छी हैं, देश तरक्की कर रहा है।"

**Hinglish**:
> "Bhai yeh movie mast thi but ending thodi weak thi yaar."

---

### 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

### ⭐ Show Your Support

If you like this project, please give it a star! ⭐

Made with ❤️ for the Indian developer community.

**Live App**: [http://98.91.209.242/](http://98.91.209.242/)

---

**Built with FastAPI • Hugging Face • Docker • Kubernetes**
