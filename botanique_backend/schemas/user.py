from pydantic import BaseModel

class UserSignUp(BaseModel):
    name: str
    email: str
    password: str

class UserSignIn(BaseModel):
    email: str
    password: str

class UserUpdatePassword(BaseModel):
    current_password: str
    new_password: str