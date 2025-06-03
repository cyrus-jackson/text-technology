import redis
from datetime import timedelta
from utils.config import REDIS_URL

# Connect to Redis
redis_client = redis.from_url(REDIS_URL, decode_responses=True)

EXPIRATION_TIME = timedelta(days=30)

# Define a function to check if a link has been processed
def has_processed_link(link: str) -> bool:
    if redis_client.exists("processed_link:" + link):
        redis_client.expire("processed_link:" + link, EXPIRATION_TIME)
        return True
    return redis_client.sismember("processed_links", link)

# Define a function to mark a link as processed
def mark_link_as_processed(link: str):
    redis_client.set("processed_link:" + link, 1, ex=EXPIRATION_TIME)
