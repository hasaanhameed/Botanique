from fastapi import APIRouter, Depends, Header, HTTPException
from database.database import supabase
from services.identification_service import fetch_history
from auth_token.current_user import get_current_user_id
from typing import Optional

router = APIRouter(prefix="/identification", tags=["Identification"])

@router.get("/history")
async def get_history(user_id: str = Depends(get_current_user_id)):
    if not user_id:
        raise HTTPException(status_code=401, detail="Authentication required")
    
    history = await fetch_history(user_id)
    return history
