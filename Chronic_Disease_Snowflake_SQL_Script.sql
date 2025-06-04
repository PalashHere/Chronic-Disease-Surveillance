
-- ✅ Database & Schema Setup
CREATE DATABASE IF NOT EXISTS health_data;
USE DATABASE health_data;

CREATE SCHEMA IF NOT EXISTS chronic_disease;
USE SCHEMA chronic_disease;

-- 🔹 Raw Indicators Table
CREATE OR REPLACE TABLE raw_indicators (
  YearStart INT,
  YearEnd INT,
  LocationAbbr STRING,
  LocationDesc STRING,
  DataSource STRING,
  Topic STRING,
  Question STRING,
  Response STRING, 
  DataValueUnit STRING,
  DataValueType STRING,
  DataValue FLOAT,
  DataValueAlt FLOAT,
  DataValueFootnoteSymbol STRING,
  DataValueFootnote STRING,
  LowConfidenceLimit FLOAT,
  HighConfidenceLimit FLOAT,
  StratificationCategory1 STRING,
  Stratification1 STRING,
  StratificationCategory2 STRING,
  Stratification2 STRING,
  StratificationCategory3 STRING,
  Stratification3 STRING,
  Geolocation STRING,
  LocationID STRING,
  TopicID STRING,
  QuestionID STRING,
  ResponseID STRING,
  DataValueTypeID STRING,
  StratificationCategoryID1 STRING,
  StratificationID1 STRING,
  StratificationCategoryID2 STRING,
  StratificationID2 STRING,
  StratificationCategoryID3 STRING,
  StratificationID3 STRING
);

-- 📤 Stage & Data Load (from Azure)
CREATE OR REPLACE STAGE azure_cdi_stage
URL = ''
CREDENTIALS = (AZURE_SAS_TOKEN = '')
FILE_FORMAT = (
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
);

COPY INTO raw_indicators
FROM @azure_cdi_stage/U.S._Chronic_Disease_Indicators.csv
ON_ERROR = 'CONTINUE';

-- 🔍 Clean Table
CREATE OR REPLACE TABLE clean_indicators (
  year INT,
  state_code STRING,
  state STRING,
  topic STRING,
  question STRING,
  value FLOAT,
  value_type STRING,
  ci_lower FLOAT,
  ci_upper FLOAT,
  datavalueunit STRING,
  geolocation STRING,
  group_category STRING,
  group_name STRING,  
  locationid STRING,
  topicid STRING,
  questionid STRING,
  datavaluetypeid STRING,
  stratificationcategoryid1 STRING,
  stratificationid1 STRING
);

-- 🧠 Analysis Queries
-- Average value per topic by year
SELECT year, topic, AVG(value) AS avg_value
FROM clean_indicators
WHERE value IS NOT NULL
GROUP BY year, topic
ORDER BY year;

-- Obesity by state
SELECT state, AVG(value) AS avg_value
FROM clean_indicators
WHERE topic = 'Obesity' AND value IS NOT NULL
GROUP BY state
ORDER BY avg_value DESC;

-- Diabetes by demographic
SELECT group_category, group_name, AVG(value) AS avg_value
FROM clean_indicators
WHERE topic = 'Diabetes' AND value IS NOT NULL
GROUP BY group_category, group_name
ORDER BY avg_value DESC;

-- Confidence Interval range for Cancer
SELECT year, topic, AVG(ci_lower) AS avg_ci_lower, AVG(ci_upper) AS avg_ci_upper
FROM clean_indicators
WHERE topic = 'Cancer' AND value IS NOT NULL
GROUP BY year, topic
ORDER BY year;

-- Null value summary
SELECT 
  COUNT(*) AS total_rows,
  COUNTIF(value IS NULL) * 100.0 / COUNT(*) AS percent_null_value,
  COUNTIF(ci_lower IS NULL) * 100.0 / COUNT(*) AS percent_null_ci_lower,
  COUNTIF(geolocation IS NULL) * 100.0 / COUNT(*) AS percent_null_geo
FROM clean_indicators;

-- Highest Value per Topic
SELECT topic, state, year, value
FROM clean_indicators
QUALIFY ROW_NUMBER() OVER (PARTITION BY topic ORDER BY value DESC) = 1;

-- National average flag for Diabetes
WITH national_avg AS (
  SELECT AVG(value) AS avg_val
  FROM clean_indicators
  WHERE topic = 'Diabetes'
)
SELECT state, year, value,
       CASE WHEN value > (SELECT avg_val FROM national_avg)
            THEN 'Above National Avg'
            ELSE 'Below National Avg' END AS diabetes_flag
FROM clean_indicators
WHERE topic = 'Diabetes';
