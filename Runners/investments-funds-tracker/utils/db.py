import logging
import psycopg2
from psycopg2.extras import RealDictCursor
from datetime import datetime

from utils.config import DATABASE_URL, DATE_TODAY

# Initialize database connection
logging.basicConfig(level=logging.INFO)
connection = psycopg2.connect(DATABASE_URL)

connection.autocommit = True

import psycopg2
from datetime import datetime

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
        with connection.cursor() as cursor:
            cursor.execute(query_insert, (link, date, result_json))
            connection.commit()
    except psycopg2.Error as e:
        # Check if the error is due to a missing table
        if e.pgcode == '42P01':  # PostgreSQL code for 'undefined_table'
            logging.warning("Table does not exist. Creating table...")
            with connection.cursor() as cursor:
                cursor.execute(query_create_table)
                connection.commit()
            # Retry the insert after creating the table
            with connection.cursor() as cursor:
                cursor.execute(query_insert, (link, date, result_json))
                connection.commit()
        else:
            logging.error(f"An error occurred: {e}")
            connection.rollback()



def insert_investment_data(inner_data: dict):
    print("Dictonary: ")
    query = """
        INSERT INTO investments (link, place, news_article_date, amount, jobs_count, funding_related, funding_status, notes, needs_verification, summary)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    
    # Ensure all fields exist in inner_data, assigning defaults if missing
    link = inner_data.get("Link")
    place = inner_data.get("Place", "Unknown")  # Default to ["Unknown"] if Place is missing
    news_article_date = inner_data.get("News_Article_Date")
    amount = inner_data.get("Amount", 0)
    jobs = inner_data.get("JobsCount", 0)
    funding_related = inner_data.get("funding_related", False)
    funding_status = inner_data.get("funding_status", "Undefined")
    notes = inner_data.get("notes", "No Notes")
    notes = "No Notes" if len(notes) == 0 else notes 
    needs_verification = inner_data.get("needs_verification", True)
    summary = inner_data.get("summary","")

    # Convert `Place` to a string for database insertion (assuming it's a list)
    place_str = ", ".join(place) if isinstance(place, list) else place

    try:
        news_article_date = (
            datetime.strptime(news_article_date, "%Y-%m-%d")
            if news_article_date and news_article_date != "Undefined"
            else DATE_TODAY
        )
    except ValueError:
        news_article_date = DATE_TODAY  # Default to None if date parsing fails

    try:
        print(query,(
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
            connection.commit()
            logging.info("Data inserted successfully.")
    except psycopg2.Error as e:
        logging.error(f"Error inserting data: {e}")
        connection.rollback()


def insert_or_update_investment(inner_data: dict):
    link = inner_data["Link"]
    summary = inner_data.get("summary", "") # Get summary, default to empty string

    # Check if the link already exists
    check_query = "SELECT 1 FROM investments WHERE link = %s"
    try:
        with connection.cursor() as cursor:
            cursor.execute(check_query, (link,))
            exists = cursor.fetchone() is not None

            if exists:
                # Update existing row (only summary)
                update_query = "UPDATE investments SET summary = %s WHERE link = %s"
                cursor.execute(update_query, (summary, link))
                logging.info(f"Summary updated for link: {link}")

            connection.commit()
    except psycopg2.Error as e:
        logging.error(f"Error inserting or updating data: {e}")
        connection.rollback()