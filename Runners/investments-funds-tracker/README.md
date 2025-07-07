
# Investments Funds Tracker

A Python-based system for tracking, extracting, and storing information about investments and funding from news articles related to Germany. The project uses Google Gemini for AI-powered information extraction, PostgreSQL for storage, Redis for deduplication, and supports deployment on Vercel as a serverless API.

## Features

- Fetches news articles about investments in Germany using MediaStack and NewsAPI.
- Uses Google Gemini to extract structured investment data from news articles.
- Stores extracted data in a PostgreSQL database.
- Deduplicates processed links using Redis.
- Exposes an HTTP API for batch processing and data retrieval.
- Can be run locally or deployed to Vercel with scheduled cron jobs.

## Project Structure

```
.
├── api/
│   └── index.py           # Main API handler
├── utils/
│   ├── config.py          # Configuration and environment variables
│   ├── db.py              # Database operations (PostgreSQL)
│   ├── genai_module.py    # Google Gemini integration
│   ├── news_module.py     # News fetching logic
│   └── redis_db.py        # Redis deduplication logic
├── run_server.py          # Local HTTP server entrypoint
├── watch_server.py        # (Optional) Watchdog for development
├── requirements.txt       # Python dependencies
├── vercel.json            # Vercel deployment config
└── README.md
```

## Setup

### 1. Clone the Repository

```bash
git clone <repo-url>
cd investments-funds-tracker
```

### 2. Install Dependencies

```bash
pip install -r requirements.txt
```

### 3. Environment Variables

Create a `.env` file or set the following environment variables:

- `GEMINI_KEY` – Google Gemini API key
- `POSTGRES_URL` – PostgreSQL connection string
- `REDIS_URL` – Redis connection string
- `NEWS_KEY` – NewsAPI key
- `MEDIASTACK_KEY` – MediaStack API key
- `CRON_SECRET` – (Optional) Secret for cron authorization

### 4. Running Locally

Start the HTTP server:

```bash
python run_server.py
```

The API will be available at `http://localhost:8008/`.

### 5. Development Tools

For auto-reloading during development, install watchdog:

```bash
pip install watchdog
python watch_server.py
```

## Deployment

This project is ready for deployment on [Vercel](https://vercel.com/):

- The API is served from [`api/index.py`](api/index.py).
- Scheduled jobs are configured in [`vercel.json`](vercel.json).

## Usage

- The main endpoint fetches news, processes them with Gemini, and stores results in the database.
- Processed links are tracked in Redis to avoid duplication.


