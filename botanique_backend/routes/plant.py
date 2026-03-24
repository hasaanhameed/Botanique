from fastapi import APIRouter, UploadFile, File, Depends
from services.plant_service import identify_plant
from schemas.plant import Plant
import uuid

router = APIRouter(prefix="/plant", tags=["Plant"])

@router.post("/identify")
async def identify(image: UploadFile = File(...)):
    plant_data = await identify_plant(image)
    
    # We return the identification result. 
    # For now we don't save to DB yet, just return the "dummy + identified" data.
    return plant_data

@router.get("/history")
async def get_history():
    # Placeholder for history logic
    return []
