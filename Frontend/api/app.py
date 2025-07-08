import logging
# Setup logging
logging.basicConfig(level=logging.DEBUG)

from flask import Flask, request, Response
import psycopg2
import os
import json
import base64
from lxml import etree
import api.cache_db as cache
from utils.config import DATABASE_URL, FIREBASE_CRED
import re
import xml.etree.ElementTree as ET
from google.oauth2 import service_account
from google.cloud import firestore

# Flask app
app = Flask(__name__)

# Database URL
if not DATABASE_URL:
    logging.error("DATABASE_URL environment variable not set")

def get_connection():
    return psycopg2.connect(DATABASE_URL)

creds_dict = json.loads(base64.b64decode(FIREBASE_CRED))

# Fetch investments
def fetch_investments(place=None):
    base_query = (
        "SELECT link, place, news_article_date, amount, jobs_count, "
        "funding_related, funding_status, notes, "
        "needs_verification, summary, inserted_date, verified "
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
                logging.info(f"Fetched {len(rows)} investments" + (f" for place='{place}'" if place else ""))
                return rows
    except psycopg2.Error as e:
        logging.error(f"Error fetching investments: {e}")
        return []

# Build XML document from data rows
def build_xml(rows):
    root = etree.Element('investments')
    fields = [
        'link','place','news_article_date','amount','jobs_count',
        'funding_related','funding_status','notes',
        'needs_verification','summary','inserted_date','verified'
    ]
    for r in rows:
        inv = etree.SubElement(root, 'investment')
        for tag, val in zip(fields, r):
            child = etree.SubElement(inv, tag)
            child.text = '' if val is None else str(val)
    return etree.tostring(root, xml_declaration=True, encoding='UTF-8')

# XSLT transformation
def transform(xml_data, xslt_path):
    try:
        xml = etree.fromstring(xml_data)
        xslt = etree.parse(xslt_path)
        transformer = etree.XSLT(xslt)
        html = transformer(xml)
        return etree.tostring(html, pretty_print=True, method='html')
    except (etree.XSLTParseError, FileNotFoundError, etree.XMLSyntaxError) as e:
        logging.error(f"XSLT transformation failed: {e}")
        return None

def sanitize_field_name(name):
    name = re.sub(r"[^\w]", "_", name)
    if re.match(r"^\d", name):
        name = "_" + name
    return name

def build_firestore_xml():
    credentials = service_account.Credentials.from_service_account_info(creds_dict)
    db = firestore.Client(credentials=credentials)

    root = ET.Element("germany_stats")

    electricity_elem = ET.SubElement(root, "electricity")
    for doc in db.collection("electricity").stream():
        rec = ET.SubElement(electricity_elem, "document", id=doc.id)
        for key, value in doc.to_dict().items():
            tag = sanitize_field_name(key)
            ET.SubElement(rec, tag).text = str(value)

    fuel_elem = ET.SubElement(root, "fuel_prices")
    for doc in db.collection("fuel_prices").stream():
        rec = ET.SubElement(fuel_elem, "document", id=doc.id)
        for key, value in doc.to_dict().items():
            tag = sanitize_field_name(key)
            ET.SubElement(rec, tag).text = str(value)

    return ET.tostring(root, encoding="utf-8", xml_declaration=True)

@app.route('/')
def index():
    logging.info("Received request for index")

    # combined = cache.get_data()
    combined = None
    if combined:
        logging.info("Using cached HTML")
    else:
        rows = fetch_investments()
        xml = build_xml(rows)
        html = transform(xml, 'xslt/index.xslt')
        firestore_xml = build_firestore_xml()
        firestore_html = transform(firestore_xml, 'xslt/stats.xsl')
        if (html is None) or (firestore_html is None):
            return Response("Internal Server Error (XSLT failure)", status=500)

        if isinstance(html, bytes):
            html = html.decode('utf-8')
        if isinstance(firestore_html, bytes):
            firestore_html = firestore_html.decode('utf-8')

        combined = firestore_html + "<hr/>" + html
        cache.set_data(combined)

    # Ensure it's a UTF-8 string
    if isinstance(combined, bytes):
        combined = combined.decode('utf-8')

    return Response(combined, mimetype='text/html')

@app.route('/report')
def report():
    place = request.args.get('place')
    rows = fetch_investments(place)
    xml = build_xml(rows)
    html = transform(xml, 'xslt/report.xslt')
    if html is None:
        return Response("Internal Server Error (XSLT failure)", status=500)

    if isinstance(html, bytes):
        html = html.decode('utf-8')
    return Response(html, mimetype='text/html')

@app.route('/places')
def places():
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
    return Response(xml, mimetype='application/xml')

if __name__ == '__main__':
    host = os.getenv('HOST', '0.0.0.0')
    port = int(os.getenv('PORT', 5001))
    logging.info(f"Starting server at {host}:{port}")
    app.run(host=host, port=port, debug=True)
