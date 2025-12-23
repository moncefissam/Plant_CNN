# 🌱 Plant Disease Detection App

A cross-platform mobile/web application for detecting plant diseases using deep learning. Built with **Flutter** (frontend) and **FastAPI** (backend).

![Python](https://img.shields.io/badge/Python-3.10+-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue)
![TensorFlow](https://img.shields.io/badge/TensorFlow-2.x-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## 📋 Supported Plant Classes

| Class | Description |
|-------|-------------|
| Pepper Bell Healthy | Healthy pepper bell plant |
| Potato Early Blight | Potato with early blight disease |
| Potato Healthy | Healthy potato plant |
| Tomato Early Blight | Tomato with early blight disease |
| Tomato Healthy | Healthy tomato plant |

Trained on the [PlantVillage Dataset](https://www.kaggle.com/datasets/abdallahalidev/plantvillage-dataset) from Kaggle.

## 📁 Project Structure

```
Plant_CNN/
├── backend/                 # FastAPI Backend
│   ├── app.py              # Main API server
│   ├── requirements.txt    # Python dependencies
│   ├── README.md           # Backend-specific docs
│   └── plant_model.h5      # Trained model (download separately)
│
├── lib/                     # Flutter Frontend
│   ├── main.dart           # App entry point
│   ├── config/             # Configuration
│   ├── models/             # Data models
│   ├── screens/            # UI screens
│   └── services/           # API services
│
├── android/                 # Android platform
├── ios/                     # iOS platform
├── web/                     # Web platform
├── windows/                 # Windows platform
├── macos/                   # macOS platform
└── linux/                   # Linux platform
```

---

## 🚀 Complete Setup Guide

### Prerequisites

- **Python 3.10+** - [Download](https://www.python.org/downloads/)
- **Flutter 3.10+** - [Install Guide](https://docs.flutter.dev/get-started/install)
- **Git** - [Download](https://git-scm.com/downloads)

### Step 1: Clone the Repository

```bash
git clone https://github.com/moncefissam/Plant_CNN.git
cd Plant_CNN
```

### Step 2: Download the Model

Download `plant_model.h5` and place it in the `backend/` folder:
```
Plant_CNN/
└── backend/
    └── plant_model.h5  ← Place here
```

> ⚠️ The model file is not included in the repository due to size limits.

---

## 🔧 Backend Setup (FastAPI)

### Step 1: Navigate to Backend Directory

```bash
cd backend
```

### Step 2: Create Virtual Environment

**Windows:**
```bash
python -m venv venv
.\venv\Scripts\activate
```

**Linux/macOS:**
```bash
python3 -m venv venv
source venv/bin/activate
```

> ✅ You should see `(venv)` in your terminal prompt when activated.

### Step 3: Install Dependencies

```bash
pip install -r requirements.txt
```

### Step 4: Run the Server

```bash
uvicorn app:app --reload --host 0.0.0.0 --port 8000
```

### Step 5: Verify It's Working

Open in browser: http://localhost:8000/docs

Or test with PowerShell:
```powershell
Invoke-RestMethod -Uri http://localhost:8000/health
```

Expected response:
```json
{"status": "healthy", "model_loaded": true, "classes_available": 5}
```

---

## 📱 Frontend Setup (Flutter)

### Step 1: Navigate to Project Root

```bash
cd ..  # Go back to Plant_CNN root (if you're in backend/)
# OR
cd Plant_CNN
```

### Step 2: Install Flutter Dependencies

```bash
flutter pub get
```

### Step 3: Configure API URL (if needed)

Edit `lib/config/app_config.dart`:
```dart
static const String apiBaseUrl = 'http://localhost:8000';  // Change for production
```

> **For Android Emulator**: Use `http://10.0.2.2:8000` instead of `localhost`

### Step 4: Run the App

**Web (Chrome):**
```bash
flutter run -d chrome
```

**Android:**
```bash
flutter run -d android
```

**iOS:**
```bash
flutter run -d ios
```

**Windows:**
```bash
flutter run -d windows
```

---

## 🧪 Testing

### Test Backend API

```bash
# Health check
curl http://localhost:8000/health

# Predict (with image)
curl -X POST http://localhost:8000/predict -F "file=@test_image.jpg"
```

### Test Flutter App

```bash
flutter test
```

---

## 🌐 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | API info |
| GET | `/health` | Health check |
| GET | `/docs` | Swagger documentation |
| POST | `/predict` | Upload image for prediction |

### Prediction Response

```json
{
  "prediction": "Tomato Early Blight",
  "confidence": 0.95,
  "all_predictions": {
    "Pepper Bell Healthy": 0.01,
    "Potato Early Blight": 0.02,
    "Potato Healthy": 0.01,
    "Tomato Early Blight": 0.95,
    "Tomato Healthy": 0.01
  }
}
```

---

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| `venv` not recognized | Use `python -m venv venv` instead of `python3` on Windows |
| Model not found | Ensure `plant_model.h5` is in `backend/` directory |
| CORS errors | Backend must be running on port 8000 |
| Flutter web camera not working | Camera only works on HTTPS in production |
| Android can't connect | Use `10.0.2.2` instead of `localhost` |

---

## 📄 License

MIT License - feel free to use this project for learning and development.

---

## 🙏 Acknowledgments

- [PlantVillage Dataset](https://www.kaggle.com/datasets/abdallahalidev/plantvillage-dataset) - Training data
- [FastAPI](https://fastapi.tiangolo.com/) - Backend framework
- [Flutter](https://flutter.dev/) - Frontend framework
- [TensorFlow](https://www.tensorflow.org/) - Deep learning
