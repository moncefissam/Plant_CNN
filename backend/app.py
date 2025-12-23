from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import tensorflow as tf
import numpy as np
from PIL import Image
import io

app = FastAPI(
    title="Plant Detection API",
    description="API for detecting plant species from images using deep learning",
    version="1.0.0"
)

# CORS configuration for cross-platform support (web, mobile, desktop)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins - adjust for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load model once at startup
model = tf.keras.models.load_model("plant_model.h5")

# PlantVillage dataset classes (must match training label order)
CLASS_NAMES = [
    "Pepper Bell Healthy",
    "Potato Early Blight",
    "Potato Healthy",
    "Tomato Early Blight",
    "Tomato Healthy"
]


def preprocess_image(image_bytes: bytes) -> np.ndarray:
    """Preprocess image for model prediction."""
    try:
        image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
        image = image.resize((224, 224))  # Adjust if your model uses different size
        image = np.array(image) / 255.0
        image = np.expand_dims(image, axis=0)
        return image
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Invalid image format: {str(e)}")


@app.get("/")
async def root():
    """Root endpoint with API information."""
    return {
        "message": "Plant Detection API",
        "docs": "/docs",
        "health": "/health"
    }


@app.get("/health")
async def health_check():
    """Health check endpoint for monitoring and deployment."""
    return {
        "status": "healthy",
        "model_loaded": model is not None,
        "classes_available": len(CLASS_NAMES)
    }


@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    """
    Predict plant species from an uploaded image.
    
    - **file**: Image file (JPEG, PNG, etc.)
    
    Returns prediction with class name and confidence score.
    """
    # Validate file type
    if not file.content_type or not file.content_type.startswith("image/"):
        raise HTTPException(
            status_code=400,
            detail="Invalid file type. Please upload an image file."
        )
    
    try:
        image_bytes = await file.read()
        image = preprocess_image(image_bytes)
        
        predictions = model.predict(image)
        class_index = np.argmax(predictions[0])
        confidence = float(predictions[0][class_index])
        
        return {
            "prediction": CLASS_NAMES[class_index],
            "confidence": confidence,
            "all_predictions": {
                name: float(predictions[0][i]) 
                for i, name in enumerate(CLASS_NAMES)
            }
        }
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Prediction failed: {str(e)}"
        )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
