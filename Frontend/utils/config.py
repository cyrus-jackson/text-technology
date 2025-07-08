import os
from datetime import datetime

DATABASE_URL = os.getenv('POSTGRES_URL')
REDIS_URL = os.getenv('REDIS_URL')

today = datetime.now()
DATE_TODAY = str(today.strftime("%Y-%m-%d"))


FIREBASE_CRED = os.getenv("FIREBASE_CREDENTIALS_BASE64")
