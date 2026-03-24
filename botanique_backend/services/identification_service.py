from database.database import supabase

async def save_identification(user_id: str, plant_data: dict, image_base64: str = None):
    try:
        supabase.table("identifications").insert({
            "user_id": user_id,
            "plant_name": plant_data.get("name"),
            "scientific_name": plant_data.get("scientific_name"),
            "description": plant_data.get("description"),
            "water": plant_data.get("water"),
            "light": plant_data.get("light"),
            "temperature": plant_data.get("temperature"),
            "season": plant_data.get("season"),
            "image_base64": image_base64
        }).execute()
        return True
    except Exception as e:
        print(f"Error saving identification: {e}")
        return False

async def fetch_history(user_id: str):
    try:
        response = supabase.table("identifications") \
            .select("*") \
            .eq("user_id", user_id) \
            .order("created_at", desc=True) \
            .execute()
        return response.data
    except Exception as e:
        print(f"Error fetching history: {e}")
        return []
