
# 🏥 Healthcare SQL Analysis

This project analyzes healthcare data using SQL in MySQL Command Line Interface (CLI). It includes patient admission records, doctor information, hospital performance, and insurance analysis.

## 📁 Files Included

- `health_analysis.sql`: Creates tables, inserts sample doctor data, defines views and indexes.
- `healthcare_dataset.csv`: Sample patient dataset to be imported into MySQL.
- `useful_healthcare_queries.sql`: Powerful SQL queries to extract insights like top doctors, billing trends, hospital revenue, etc.

## ✅ How to Run This Project

1. Open your MySQL Command Line:
   ```bash
   mysql -u your_username -p
   ```

2. Create and use the database:
   ```sql
   CREATE DATABASE healthcare_db;
   USE healthcare_db;
   ```

3. Run the schema file:
   ```sql
   SOURCE /full/path/to/health_analysis.sql;
   ```

4. Import the patient dataset (after placing the CSV in MySQL's `secure_file_priv` path):
   ```sql
   LOAD DATA INFILE '/path/to/healthcare_dataset.csv'
   INTO TABLE healthcare_dataset
   FIELDS TERMINATED BY ','
   ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 ROWS;
   ```

5. Run the insights queries:
   ```sql
   SOURCE /full/path/to/useful_healthcare_queries.sql;
   ```

## 📊 Insights You'll Get

- Top conditions by billing
- Doctor revenue performance
- Hospital comparisons
- Insurance company payouts
- Monthly admission trends
- High-billing patients per condition

## 👩‍💻 Tools Used

- MySQL CLI
- CSV Data
