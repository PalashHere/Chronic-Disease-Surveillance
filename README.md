🩺 Chronic Disease Surveillance Dashboard
Tools Used: Snowflake · Python · Azure Blob Storage · Power BI

📊 Project Overview
This project presents a full-stack healthcare analytics solution that tracks chronic disease trends across the United States between 2015–2022. Using open-source CDC datasets, the solution enables public health insights across time, geography, and demographic groups.

🚀 Objective
Analyze chronic disease indicators (e.g., obesity, diabetes, cancer) across states and years

Visualize demographic disparities using gender, race, and group stratifications

Highlight public health risks with confidence interval metrics and national average flags

🧱 Tech Stack & Architecture
scss
Copy
Edit
CDC Dataset (CSV)
    ↓
Azure Blob Storage
    ↓
Snowflake (External Stage + SQL Data Warehouse)
    ↓
Python (Pandas) for data cleaning & transformation
    ↓
Snowflake (Star Schema: Fact + Dimensions)
    ↓
Power BI (Dashboard Visualizations & KPIs)
📁 Features & Functionality
ETL Pipeline:
Uploaded raw CSV to Azure → Ingested via Snowflake external stage → Cleaned using Python → Stored as star schema

Data Model:

FactIndicators (200K+ records)

Dimensions: Date, State, Topic, Group, Question, ValueType

Power BI Dashboard Includes:
✅ KPI Cards
✅ Time-Series Trends
✅ Geo Mapping by State
✅ Demographic Breakdown (Group Category / Group Name)
✅ Drilldowns & Flags for Above Avg. Analysis
✅ Raw Data Explorer with slicers

📌 Key Insights
Obesity and diabetes show increasing post-COVID prevalence in many southern states

Female and Hispanic groups showed higher prevalence rates in several indicators

Confidence intervals vary significantly by condition and group type, indicating data uncertainty

Flags identify outlier states performing above national health benchmarks

🧠 Skills Demonstrated
Cloud Data Engineering (Snowflake, Azure Blob)

Data Wrangling (Python, Pandas)

Dimensional Modeling (Star Schema)

BI Reporting & DAX (Power BI)

SQL Scripting (Snowflake SQL)

📎 Dataset Source
CDC Chronic Disease Indicators Dataset - https://data.cdc.gov/
