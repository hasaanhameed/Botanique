from fastapi import Header, HTTPException
from database.database import supabase
from typing import Optional

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