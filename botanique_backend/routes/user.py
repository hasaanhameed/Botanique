from fastapi import APIRouter, status, HTTPException
from schemas.user import UserResponse, UserSignUp, UserSignIn
from database.database import supabase
from hashing.hashing import hash_password

router = APIRouter(prefix="/user", tags=["User"])

@router.post("/signup", response_model=UserResponse, status_code = status.HTTP_201_CREATED)
def signup(user: UserSignUp):
    
    isExisting = supabase.table("users").select("*").eq("email", user.email).execute()
    if isExisting.data:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Email already exists")
    
    hashed_pw = hash_password(user.password)
    new_user = supabase.table("users").insert({
        "name": user.name,
        "email": user.email,
        "password": hashed_pw
    }).execute()

    return {"message": "User created successfully"}
    
