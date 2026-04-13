import json
from database.redis_client import redis_client

async def get_cached_plant_details(plant_name: str):
    try:
        data = await redis_client.get(f"plant_details:{plant_name}")
        if data:
            return json.loads(data)
    except Exception as e:
        print(f"Redis get error: {e}")
    return None

async def set_cached_plant_details(plant_name: str, details: dict, expire: int = 86400 * 7):
    """Store plant details in Redis cache (7 days)."""
    try:
        await redis_client.setex(
            f"plant_details:{plant_name}",
            expire,
            json.dumps(details)
        )
    except Exception as e:
        print(f"Redis set error: {e}")
