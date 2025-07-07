import os
from datetime import datetime, timedelta

GEMINI_KEY = os.getenv('GEMINI_KEY')
CRON_SECRET = os.getenv('CRON_SECRET', 'zzzz')
DATABASE_URL = os.getenv('POSTGRES_URL')
REDIS_URL = os.getenv('REDIS_URL')
NEWS_KEY = os.getenv('NEWS_KEY')
MEDIASTACK_KEY = os.getenv('MEDIASTACK_KEY')


yesterday = datetime.now() - timedelta(29)
DATE_TO_FETCH = str(yesterday.strftime("%Y-%m-%d"))
print("Date to fetch: " + str(DATE_TO_FETCH))
today = datetime.now()
DATE_TODAY = str(today.strftime("%Y-%m-%d"))