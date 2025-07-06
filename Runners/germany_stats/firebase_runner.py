import re
import requests
import logging
import time
from datetime import datetime

from google.oauth2 import service_account
from google.cloud import firestore

from lxml import html

logging.basicConfig(level=logging.INFO)
todays_date = str(datetime.now().strftime("%Y-%m-%d"))
now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def copy_data_to_firestore(json_data, collection_name):

    credentials = service_account.Credentials.from_service_account_file("credentials.json")

    db = firestore.Client(credentials=credentials)

    doc_ref = db.collection(collection_name).document(todays_date)

    if isinstance(json_data, list):
        firestore_data = {}
        firestore_data["response"] = json_data
        doc_ref.set(firestore_data)
    else:
        doc_ref.set(json_data)

    print(f"Successfully copied data to Firestore with document ID: {todays_date}")


def retry_logic(retries, delay, func, *args, **kwargs):
    for attempt in range(retries):
        try:
            return func(*args, **kwargs)
        except Exception as e:
            logging.error(f"Attempt {attempt + 1} failed: {e}")
            if attempt < retries - 1:
                time.sleep(delay)
            else:
                raise


def fetch_and_parse_fuel_prices():
    url = 'https://autotraveler.ru/en/germany/trend-price-fuel-germany.html'
    resp = requests.get(url, timeout=10)
    resp.raise_for_status()

    resp.encoding = resp.apparent_encoding
    doc = html.fromstring(resp.text)

    prices = {}
    # Find each <tr> in the main table body
    for tr in doc.xpath("//table[contains(@class,'table')]/tbody/tr"):
        fuel = tr.xpath("string(td[1])").strip()
        raw_now = tr.xpath("string(td[2])").strip()

        # regex to get value
        m = re.search(r"(\d+\.\d+)", raw_now)
        if not m:
            continue

        val = float(m.group(1))
        prices[fuel] = val

    return prices

if __name__ == '__main__':
    fuel_prices = retry_logic(3, 5, fetch_and_parse_fuel_prices)
    print(fuel_prices)
    copy_data_to_firestore(fuel_prices, "fuel_prices")
    # for fuel, val in prices.items():
    #     print(f"{fuel}: € {val:.3f}")
