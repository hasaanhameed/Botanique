from pydantic import BaseModel
from typing import Optional

class Identification(BaseModel):
    id: Optional[str] = None
    user_id: Optional[str] = None
    plant_name: str
    scientific_name: Optional[str] = None
    description: Optional[str] = None
    water: Optional[str] = None
    light: Optional[str] = None
    temperature: Optional[str] = None
    season: Optional[str] = None
    created_at: Optional[str] = None

