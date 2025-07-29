# Germany Stats and Investments from News Articles
**Text Technology Coursework Project**

> A comprehensive system for extracting, processing, and visualizing investment data and economic statistics from news articles using advanced text technologies including AI, XML processing, and XSLT transformations.

## 🎯 Project Motivation

This project was developed as part of a Text Technology course to demonstrate practical applications of various text processing technologies in solving real world information extraction challenges.

### Academic Goals
- **XML Processing Mastery**: Demonstrate proficiency in XML data structures, parsing, and manipulation
- **XSLT Transformation Skills**: Showcase advanced XSLT capabilities for transforming structured data into rich, interactive web presentations
- **Modern Text Technologies Integration**: Combine traditional XML/XSLT with contemporary AI technologies for intelligent text processing
- **Data Pipeline Architecture**: Build a complete pipeline from raw text extraction to visual presentation

### Real-World Problem Solving
- **Information Overload**: Address the challenge of manually tracking investment news across multiple sources
- **Data Standardization**: Convert unstructured news articles into structured, queryable data
- **Economic Monitoring**: Create an automated system for monitoring Germany's economic landscape through investment tracking
- **Market Intelligence**: Provide accessible insights into funding trends, regional development, and economic indicators

### Technical Innovation
- **AI Powered Information Extraction**: Leverage Google Gemini AI to intelligently extract structured investment data from news articles
- **Multi-Source Data Integration**: Combine investment news with real-time economic indicators (electricity prices, fuel costs)
- **Scalable Architecture**: Design a system that can process thousands of articles while maintaining performance
- **Modern Web Technologies**: Create responsive, interactive dashboards using contemporary web standards

## 🏗️ System Architecture

### Core Components

#### 1. **Investment Tracker (`Runners/investments-funds-tracker/`)**
**Purpose**: Automated extraction and analysis of investment news articles
- **AI Integration**: Uses Google Gemini to extract structured data from unstructured news text
- **Multi-Source News Fetching**: Integrates with NewsAPI and MediaStack for comprehensive coverage
- **Intelligent Deduplication**: Redis based system prevents processing duplicate articles
- **Structured Data Storage**: PostgreSQL database for reliable, queryable investment data

#### 2. **Germany Statistics Collector (`Runners/germany_stats/`)**
**Purpose**: Automated collection of real time German economic indicators
- **Web Scraping**: Extracts fuel prices from automotive websites
- **API Integration**: Fetches electricity market data from official German sources
- **Cloud Storage**: Firestore integration for scalable, real time data access
- **Automated Scheduling**: GitHub Actions for daily data collection

#### 3. **Frontend Dashboard (`Frontend/`)**
**Purpose**: Web based visualization and interaction layer
- **XML Data Processing**: Converts database records to XML for XSLT processing
- **XSLT Transformations**: Generates responsive HTML from XML data
- **Interactive Filtering**: Dynamic filtering by location and funding status
- **Real-time Charts**: Integration with Chart.js for trend visualization
- **Caching Layer**: Redis caching for improved performance

### Data Flow Architecture

```
News Sources (NewsAPI, MediaStack)
         ↓
AI Processing (Google Gemini)
         ↓
Structured Extraction (PostgreSQL)
         ↓
XML Generation (Python/lxml)
         ↓
XSLT Transformation (XSL Stylesheets)
         ↓
Interactive Dashboard (HTML/CSS/JS)
```

## 🛠️ Technology Stack

### Text Processing Technologies
- **XML Processing**: lxml library for robust XML parsing and generation
- **XSLT Transformations**: Advanced stylesheets for data-to-presentation conversion
- **AI Text Analysis**: Google Gemini for intelligent information extraction
- **Web Scraping**: Beautiful Soup and requests for data collection

### Backend Infrastructure
- **Python Flask**: RESTful API development
- **PostgreSQL**: Relational database for investment data
- **Redis**: Caching and deduplication
- **Google Firestore**: NoSQL storage for real time statistics

### Frontend Technologies
- **Bootstrap 5**: Responsive web design
- **Chart.js**: Interactive data visualization
- **Vanilla JavaScript**: Dynamic user interactions
- **CSS3**: Modern styling and animations

### DevOps & Deployment
- **GitHub Actions**: Automated CI/CD pipelines
- **Vercel**: Serverless deployment platform
- **Docker**: Containerization (optional)
- **Environment Management**: Secure configuration handling

## 📊 Key Features

### 1. **Intelligent News Processing**
- Automated fetching from multiple news sources
- AI powered extraction of investment details (amount, location, job impact, funding status)
- Intelligent categorization (Allocated, Planned, Potential)
- Automatic duplicate detection and prevention

### 2. **Real-time Economic Monitoring**
- Daily electricity price tracking from German energy markets
- Fuel price monitoring across multiple fuel types
- Historical trend analysis and visualization
- Forecast integration for predictive insights

### 3. **Interactive Web Dashboard**
- Responsive design for desktop and mobile access
- Dynamic filtering by location and funding status
- Real time chart updates
- Detailed investment reports with source linking

### 4. **Data Quality & Validation**
- AI powered data verification flags
- Source attribution and linking
- Data consistency checks
- Error handling and logging

## 🎓 Educational Outcomes

This project demonstrates mastery of several key text technology concepts:

### XML Technologies
- **Document Structure**: Proper XML schema design for investment data
- **Namespace Management**: Handling multiple data sources with XML namespaces
- **Validation**: XSD schema validation for data integrity

### XSLT Processing
- **Template Matching**: Complex template rules for different data types
- **Conditional Logic**: XSL choose/when statements for dynamic content
- **Function Usage**: Advanced XPath expressions and XSLT functions
- **Output Methods**: HTML generation with proper formatting

### Modern Integration
- **API Design**: RESTful endpoints following best practices
- **Data Serialization**: JSON to XML conversion strategies
- **Performance Optimization**: Caching and efficient data processing
- **User Experience**: Responsive design principles

## 🚀 Getting Started

### Prerequisites
- Python 3.9+
- PostgreSQL database
- Redis instance
- API keys for news sources and Google Gemini

### Quick Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/cyrus-jackson/text-technology.git
   cd text-technology
   ```

2. **Set up environment variables**
   ```bash
   # Create environment file
   cp env/development.env.local.example env/development.env.local
   # Edit with your API keys and database URLs
   ```

3. **Install dependencies**
   ```bash
   # Investment tracker
   cd Runners/investments-funds-tracker
   pip install -r requirements.txt
   
   # Frontend
   cd ../../Frontend
   pip install -r requirements.txt
   ```

4. **Run the system**
   ```bash
   # Start investment data collection
   python Runners/investments-funds-tracker/run_server.py
   
   # Start web dashboard
   python Frontend/api/app.py
   ```