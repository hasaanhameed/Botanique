from schemas.user import UserSignUp, UserSignIn, UserUpdatePassword
from database.database import supabase, supabase_admin
from supabase_auth.errors import AuthApiError
from auth_token.current_user import get_current_user_id
from fastapi import APIRouter, status, HTTPException, Depends, Header
from typing import Optional

router = APIRouter(prefix="/user", tags=["User"])

@router.post("/signup", status_code=status.HTTP_201_CREATED)
def signup(user: UserSignUp):
    try:
        response = supabase.auth.sign_up({
            "email": user.email,
            "password": user.password,
            "options": {"data": {"name": user.name}}
        })
    except AuthApiError as e:
        raise HTTPException(status_code=400, detail=str(e))

    if response.user is None:
        raise HTTPException(status_code=400, detail="Signup failed")

    return {"message": "User created successfully", "user_id": response.user.id}

@router.post("/signin", status_code=status.HTTP_200_OK)
def signin(user: UserSignIn):
    try:
        response = supabase.auth.sign_in_with_password({
            "email": user.email,
            "password": user.password,
        })
        if response.user is None:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")
        
        return {
            "message": "Login successful",
            "access_token": response.session.access_token,
            "user_id": response.user.id
        }
    except AuthApiError as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")
    except Exception as e:
        print(f"Login error: {e}")
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Internal server error")

@router.get("/profile")
async def get_profile(authorization: Optional[str] = Header(None)):
    if not authorization:
        raise HTTPException(status_code=401, detail="Authentication required")
    
    try:
        token = authorization.replace("Bearer ", "")
        user_resp = supabase.auth.get_user(token)
        if not user_resp or not user_resp.user:
            raise HTTPException(status_code=401, detail="Invalid session")
        
        user = user_resp.user
        user_id = user.id
        
        # Get identification count
        ident_resp = supabase.table("identifications") \
            .select("id", count="exact") \
            .eq("user_id", user_id) \
            .execute()
        
        # Use .count if available, otherwise len(.data)
        count = getattr(ident_resp, 'count', 0)
        if count is None:
            count = len(ident_resp.data) if hasattr(ident_resp, 'data') else 0
        
        # Fix datetime issue: check if it's a string or datetime object
        member_since = "Unknown"
        if user.created_at:
            if isinstance(user.created_at, str):
                member_since = user.created_at.split("T")[0]
            else:
                # Assuming it's a datetime object
                member_since = user.created_at.strftime("%Y-%m-%d")

        return {
            "name": user.user_metadata.get("name", "User"),
            "email": user.email,
            "identification_count": count,
            "member_since": member_since
        }
    except HTTPException:
        raise
    except Exception as e:
        print(f"Profile error: {e}")
        # Return 500 for unexpected errors instead of 401
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/update-password", status_code=status.HTTP_200_OK)
async def update_password(update_data: UserUpdatePassword, authorization: Optional[str] = Header(None)):
    if not authorization:
        raise HTTPException(status_code=401, detail="Authentication required")
    
    try:
        token = authorization.replace("Bearer ", "")
        user_resp = supabase.auth.get_user(token)
        if not user_resp or not user_resp.user:
            raise HTTPException(status_code=401, detail="Invalid session")
        
        email = user_resp.user.email
        
        # Validate current password
        try:
            supabase.auth.sign_in_with_password({
                "email": email,
                "password": update_data.current_password
            })
        except AuthApiError:
            raise HTTPException(status_code=401, detail="Incorrect current password")
        except Exception as e:
            print(f"Password re-auth error: {e}")
            raise HTTPException(status_code=401, detail="Authentication failed")

        # Update to new password
        response = supabase.auth.update_user({
            "password": update_data.new_password
        })
        if response.user is None:
            raise HTTPException(status_code=400, detail="Password update failed")
        
        return {"message": "Password updated successfully"}
    except HTTPException:
        raise
    except Exception as e:
        print(f"Update password error: {e}")
        raise HTTPException(status_code=400, detail=str(e))

@router.delete("/delete", status_code=status.HTTP_200_OK)
async def delete_account(authorization: Optional[str] = Header(None)):
    if not authorization:
        raise HTTPException(status_code=401, detail="Authentication required")
    
    try:
        token = authorization.replace("Bearer ", "")
        user_resp = supabase.auth.get_user(token)
        if not user_resp or not user_resp.user:
            raise HTTPException(status_code=401, detail="Invalid session")
        
        user_id = user_resp.user.id
        
        # Delete user via admin API
        supabase_admin.auth.admin.delete_user(user_id)
        
        return {"message": "Account deleted successfully"}
    except Exception as e:
        print(f"Delete account error: {e}")
        raise HTTPException(status_code=400, detail=str(e))