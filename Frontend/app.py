# app.py
from flask import Flask, request, Response
import psycopg2
import os
import logging
from lxml import etree

from utils.config import DATABASE_URL
app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

# Use DATABASE_URL from environment
if not DATABASE_URL:
    logging.error("DATABASE_URL environment variable not set")

def get_connection():
    return psycopg2.connect(DATABASE_URL)

# Fetch investments
def fetch_investments(place=None):
    base_query = (
        "SELECT link, place, news_article_date, amount, jobs_count,\n"
        "       funding_related, funding_status, notes,\n"
        "       needs_verification, summary, inserted_date, verified\n"
        "FROM investments"
    )
    params = []
    if place:
        base_query += " WHERE place = %s"
        params.append(place)
    base_query += " ORDER BY inserted_date DESC"

    try:
        with get_connection() as conn:
            with conn.cursor() as cur:
                cur.execute(base_query, params)
                rows = cur.fetchall()
                logging.info(f"Fetched %d investments%s.", len(rows), f" for place='{place}'" if place else "")
                return rows
    except psycopg2.Error as e:
        logging.error(f"Error fetching investments: {e}")
        return []

# Build XML document from data rows
def build_xml(rows):
    root = etree.Element('investments')
    fields = ['link','place','news_article_date','amount','jobs_count',
              'funding_related','funding_status','notes',
              'needs_verification','summary','inserted_date','verified']
    for r in rows:
        inv = etree.SubElement(root, 'investment')
        for tag, val in zip(fields, r):
            child = etree.SubElement(inv, tag)
            child.text = '' if val is None else str(val)
    return etree.tostring(root, xml_declaration=True, encoding='UTF-8')

# XSLT transformation
def transform(xml_data, xslt_path):
    xml = etree.fromstring(xml_data)
    xslt = etree.parse(xslt_path)
    transformer = etree.XSLT(xslt)
    html = transformer(xml)
    return etree.tostring(html, pretty_print=True, method='html')

@app.route('/')
def index():
    rows = fetch_investments()
    xml = build_xml(rows)
    html = transform(xml, 'xslt/index.xslt')
    return Response(html, mimetype='text/html')

@app.route('/report')
def report():
    place = request.args.get('place')
    rows = fetch_investments(place)
    xml = build_xml(rows)
    html = transform(xml, 'xslt/report.xslt')
    return Response(html, mimetype='text/html')

@app.route('/places')
def places():
    # Return distinct places as simple XML for client side filter
    # Returns <?xml version='1.0' encoding='UTF-8'?>\n<places><place></place><place>Aschaffenburg</place></places>
    query = "SELECT DISTINCT place FROM investments ORDER BY place"
    try:
        with get_connection() as conn:
            with conn.cursor() as cur:
                cur.execute(query)
                rows = cur.fetchall()
    except psycopg2.Error as e:
        logging.error(f"Error fetching places: {e}")
        rows = []

    root = etree.Element('places')
    for (pl,) in rows:
        e = etree.SubElement(root, 'place')
        e.text = pl
    xml = etree.tostring(root, xml_declaration=True, encoding='UTF-8')
    print(xml)
    return Response(xml, mimetype='application/xml')

if __name__ == '__main__':
    # Read host and port from environment or default to 0.0.0.0:5000
    host = os.getenv('HOST', '0.0.0.0')
    port = int(os.getenv('PORT', 5001))
    logging.info(f"Starting server at {host}:{port}")
    app.run(host=host, port=port, debug=True)
