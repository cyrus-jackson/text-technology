import logging
from newsapi import NewsApiClient
from utils.config import NEWS_KEY, DATE_TO_FETCH

# Init
logging.basicConfig(level=logging.INFO)
newsapi = NewsApiClient(api_key=NEWS_KEY)


def get_today_news_urls():
    urls = []
    news_urls = newsapi.get_everything(q='Germany', 
                                       sort_by='publishedAt', 
                                       from_param=str(DATE_TO_FETCH))
    
    urls_articles = news_urls['articles']
    if urls_articles is None:
        logging.error(f"urls_articles is None.")
    else:
        logging.info(f"Received {len(urls_articles)} news articles.")
        
    for news in urls_articles:
        urls.append(news['url'])
    return urls
