from fastapi import APIRouter, UploadFile, File, Depends, Header
from services.plant_service import identify_plant
from services.identification_service import save_identification
from database.database import supabase
from typing import Optional
import base64


router = APIRouter(prefix="/plant", tags=["Plant"])

async def get_current_user_id(authorization: Optional[str] = Header(None)):
    if not authorization:
        return None
    try:
        token = authorization.replace("Bearer ", "")
        user_resp = supabase.auth.get_user(token)
        if user_resp and user_resp.user:
            return user_resp.user.id
    except Exception as e:
        print(f"Auth error: {e}")
    return None

@router.post("/identify")
async def identify(
    image: UploadFile = File(...),
    user_id: Optional[str] = Depends(get_current_user_id)
):
    # Read image content for identification
    content = await image.read()
    await image.seek(0) # Reset pointer for identify_plant service
    
    plant_data = await identify_plant(image)
    
    if plant_data and user_id:
        # Encode image to base64 for storage
        image_base64 = base64.b64encode(content).decode('utf-8')
        await save_identification(user_id, plant_data, image_base64)

    return plant_data
