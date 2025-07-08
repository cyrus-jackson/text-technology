import os
import redis
import logging
from datetime import timedelta, datetime

from utils.config import REDIS_URL, DATE_TODAY

EXPIRATION_TIME = timedelta(days=1)
KEY = "germany_investments" + DATE_TODAY
logging.info(EXPIRATION_TIME)
# Connect to Redis
redis_client = redis.from_url(REDIS_URL, decode_responses=True)

def has_data() -> bool:
    if redis_client.exists(KEY):
        logging.info("Fetching from Cache for the date: " + DATE_TODAY)
        return True
    else:
        return False




# Set data according to key with an expiry of 1 day
def set_data(data):

    redis_client.set(KEY, data, ex=EXPIRATION_TIME)

# Fetch data according to key set
def get_data():
    return redis_client.get(KEY)
