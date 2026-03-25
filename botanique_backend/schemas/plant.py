from pydantic import BaseModel
from typing import Optional

class PlantBase(BaseModel):
    name: str
    description: str
    water: str
    light: str
    temperature: str
    season: str

class Plant(PlantBase):
    id: str
    user_id: str
    image_url: Optional[str] = None

    class Config:
        from_attributes = True
