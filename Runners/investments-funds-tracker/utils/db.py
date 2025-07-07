import logging
import psycopg2
from psycopg2.extras import RealDictCursor
from datetime import datetime

from utils.config import DATABASE_URL, DATE_TODAY

# Configure logging
logging.basicConfig(level=logging.INFO)

def get_connection():
    return psycopg2.connect(DATABASE_URL)


def insert_funding_data(link: str, date: datetime, result_json: str):
    query_insert = """
        INSERT INTO funding (link, date, result_json)
        VALUES (%s, %s, %s)
    """

    query_create_table = """
        CREATE TABLE IF NOT EXISTS funding (
            link TEXT,
            date TIMESTAMPTZ,
            result_json JSONB
        )
    """

    try:
        with get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(query_insert, (link, date, result_json))
    except psycopg2.Error as e:
        if e.pgcode == '42P01':  # Table does not exist
            logging.warning("Table does not exist. Creating table...")
            try:
                with get_connection() as connection:
                    with connection.cursor() as cursor:
                        cursor.execute(query_create_table)
                        cursor.execute(query_insert, (link, date, result_json))
            except psycopg2.Error as ex:
                logging.error(f"Retry insert failed: {ex}")
        else:
            logging.error(f"Insert error: {e}")


def insert_investment_data(inner_data: dict):
    query = """
        INSERT INTO investments (
            link, place, news_article_date, amount, jobs_count,
            funding_related, funding_status, notes, needs_verification, summary
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """

    link = inner_data.get("Link")
    place = inner_data.get("Place", "Unknown")
    news_article_date = inner_data.get("News_Article_Date")
    amount = inner_data.get("Amount", 0)
    jobs = inner_data.get("JobsCount", 0)
    funding_related = inner_data.get("funding_related", False)
    funding_status = inner_data.get("funding_status", "Undefined")
    notes = inner_data.get("notes", "No Notes")
    notes = "No Notes" if not notes else notes
    needs_verification = inner_data.get("needs_verification", True)
    summary = inner_data.get("summary", "")

    place_str = ", ".join(place) if isinstance(place, list) else place

    try:
        news_article_date = (
            datetime.strptime(news_article_date, "%Y-%m-%d")
            if news_article_date and news_article_date != "Undefined"
            else DATE_TODAY
        )
    except ValueError:
        news_article_date = DATE_TODAY

    try:
        with get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(
                    query,
                    (
                        link,
                        place_str,
                        news_article_date,
                        amount,
                        jobs,
                        funding_related,
                        funding_status,
                        notes,
                        needs_verification,
                        summary,
                    ),
                )
                logging.info("Investment data inserted successfully.")
                return True
    except psycopg2.Error as e:
        logging.error(f"Error inserting investment data: {e}")
        return False


def insert_or_update_investment(inner_data: dict):
    link = inner_data.get("Link")
    summary = inner_data.get("summary", "")

    check_query = "SELECT 1 FROM investments WHERE link = %s"
    update_query = "UPDATE investments SET summary = %s WHERE link = %s"

    try:
        with get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(check_query, (link,))
                exists = cursor.fetchone() is not None

                if exists:
                    cursor.execute(update_query, (summary, link))
                    logging.info(f"Summary updated for link: {link}")
    except psycopg2.Error as e:
        logging.error(f"Error during insert_or_update: {e}")
