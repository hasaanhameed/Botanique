from database.redis_client import redis_client
import time

def is_rate_limited(user_id: str, limit: int = 5, window: int = 3600):
    """
    Check if a user has exceeded their rate limit.
    Default: 5 identifications per hour (3600 seconds).
    """
    if not user_id:
        # Fallback if user is not logged in 
        return False

    key = f"rate_limit:{user_id}"
    
    try:
        # Increment the counter
        current_count = redis_client.incr(key)
        
        # If it's the first request in the window, set expiration
        if current_count == 1:
            redis_client.expire(key, window)
            
        if current_count > limit:
            return True
            
        return False
    except Exception as e:
        print(f"Rate limiting error: {e}")
        # Fail open - don't block users if Redis is down
        return False
