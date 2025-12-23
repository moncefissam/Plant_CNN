# Plant Detection API

A FastAPI-based REST API for plant disease detection using deep learning with the PlantVillage dataset.

## Supported Plant Classes

This model detects the following 5 plant conditions:

| Index | Class Name           | Description                    |
|-------|---------------------|--------------------------------|
| 0     | Pepper Bell Healthy | Healthy pepper bell plant      |
| 1     | Potato Early Blight | Potato with early blight       |
| 2     | Potato Healthy      | Healthy potato plant           |
| 3     | Tomato Early Blight | Tomato with early blight       |
| 4     | Tomato Healthy      | Healthy tomato plant           |

## Requirements

- Python 3.10+
- TensorFlow 2.x
- The trained model file: `plant_model.h5`

## Quick Start

### 1. Create Virtual Environment

```bash
# Windows
python -m venv venv
.\venv\Scripts\activate

# Linux/macOS
python3 -m venv venv
source venv/bin/activate
```

### 2. Install Dependencies

```bash
pip install -r requirements.txt
```

### 3. Place Your Model

Make sure `plant_model.h5` is in the same directory as `app.py`.

### 4. Run the Server

```bash
# Development (with auto-reload)
uvicorn app:app --reload --host 0.0.0.0 --port 8000

# Production
uvicorn app:app --host 0.0.0.0 --port 8000
```

## API Endpoints

| Method | Endpoint   | Description                          |
|--------|------------|--------------------------------------|
| GET    | `/`        | API info and available endpoints     |
| GET    | `/health`  | Health check (for monitoring)        |
| GET    | `/docs`    | Interactive Swagger API documentation|
| GET    | `/redoc`   | Alternative API documentation        |
| POST   | `/predict` | Upload image for plant prediction    |

## Usage Examples

### Using PowerShell (Windows)

```powershell
# Test health endpoint
Invoke-RestMethod -Uri http://localhost:8000/health

# Upload image for prediction
$form = @{ file = Get-Item -Path "plant_image.jpg" }
Invoke-RestMethod -Uri http://localhost:8000/predict -Method Post -Form $form
```

### Using curl (Linux/macOS)

```bash
# Test health endpoint
curl http://localhost:8000/health

# Upload image for prediction
curl -X POST "http://localhost:8000/predict" \
  -H "accept: application/json" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@plant_image.jpg"
```

### Using Python

```python
import requests

# Test health
response = requests.get("http://localhost:8000/health")
print(response.json())

# Predict plant
with open("plant_image.jpg", "rb") as f:
    response = requests.post(
        "http://localhost:8000/predict",
        files={"file": f}
    )
print(response.json())
```

## Response Format

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

## Configuration

| Setting | Value | Notes |
|---------|-------|-------|
| Model File | `plant_model.h5` | Must be in same directory |
| Image Size | 224x224 | Adjust in `preprocess_image()` if different |
| Port | 8000 | Change with `--port` flag |

## Deployment

For production deployment, consider:

1. **Process Manager**: Use Gunicorn with Uvicorn workers
   ```bash
   gunicorn app:app -w 4 -k uvicorn.workers.UvicornWorker
   ```

2. **HTTPS**: Set up with nginx reverse proxy

3. **CORS**: Restrict origins in `app.py` for security:
   ```python
   allow_origins=["https://yourdomain.com"]
   ```

4. **Docker**: Create a Dockerfile for containerized deployment

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Model not found | Ensure `plant_model.h5` is in the backend directory |
| Module not found | Run `pip install -r requirements.txt` in activated venv |
| Port in use | Change port: `uvicorn app:app --port 8001` |
| CORS errors | Check `allow_origins` in `app.py` |

## Dataset

This model was trained on the [PlantVillage Dataset](https://www.kaggle.com/datasets/abdallahalidev/plantvillage-dataset) from Kaggle.
