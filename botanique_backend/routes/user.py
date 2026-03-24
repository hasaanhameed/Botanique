from fastapi import APIRouter, status, HTTPException
from schemas.user import UserSignUp, UserSignIn
from database.database import supabase
from supabase_auth.errors import AuthApiError

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