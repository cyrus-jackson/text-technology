import logging
import requests
import time

from urllib.parse import urlencode

from newsapi import NewsApiClient
from utils.config import NEWS_KEY, MEDIASTACK_KEY, DATE_TO_FETCH

# Init
logging.basicConfig(level=logging.INFO)
newsapi = NewsApiClient(api_key=NEWS_KEY)

def get_today_news_urls():
    urls = get_mediastack_urls()
    print(urls)
    return urls



def get_news_org_urls():
    urls = []
    page = 1
    while True:
        try:
            news_response = newsapi.get_everything(
                q='(deutschland OR germany)+investment',
                sort_by='publishedAt',
                from_param=DATE_TO_FETCH,
                page=page,
                page_size=100
            )
        except Exception as e:
            logging.error(f"Error fetching news: {e}")
            break

        articles = news_response.get('articles')
        if not articles:
            logging.info(f"No more articles found on page {page}.")
            break

        for article in articles:
            urls.append(article['url'])

        logging.info(f"Page {page}: Retrieved {len(articles)} articles.")
        page += 1

    return urls

def get_mediastack_urls(keywords='', countries='de', sort='published_asc', limit=100):
    base_url = "http://api.mediastack.com/v1/news"
    offset = 8900
    max = 9400
    urls = []

    while True:
        params = {
            'access_key': MEDIASTACK_KEY,
            'keywords': keywords,
            'countries': countries,
            'limit': limit,
            'offset': offset,
            'sort': sort
        }
        try:
            response = requests.get(f"{base_url}?{urlencode(params)}")
            response.raise_for_status()
            data = response.json()
        except Exception as e:
            logging.error(f"Request failed: {e}")
            break

        articles = data.get('data', [])
        if not articles:
            logging.info("No more articles found.")
            break

        for article in articles:
            url = article.get('url')
            if url:
                urls.append(url)

        pagination = data.get('pagination', {})
        total = pagination.get('total', 0)
        offset += limit

        logging.info(f"Fetched {len(articles)} articles (offset {offset}/{total})")

        if offset >= total or offset >= max:
            break
        time.sleep(2)

    return urls