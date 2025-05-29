-- Healthcare Data Analysis SQL Queries
-- This file contains comprehensive SQL queries for healthcare dataset analysis
-- Covers: SELECT, WHERE, ORDER BY, GROUP BY, JOINs, Subqueries, Views, and Indexes

-- 1. Create the main healthcare table
CREATE TABLE healthcare_dataset (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(10),
    Blood_Type VARCHAR(5),
    Medical_Condition VARCHAR(100),
    Date_of_Admission DATE,
    Doctor VARCHAR(100),
    Hospital VARCHAR(100),
    Insurance_Provider VARCHAR(100),
    Billing_Amount DECIMAL(15,2),
    Room_Number INT,
    Admission_Type VARCHAR(50),
    Discharge_Date DATE,
    Medication VARCHAR(100),
    Test_Results VARCHAR(50)
);

-- 2. Create a sample doctors table for JOIN examples
CREATE TABLE doctors (
    Doctor_Name VARCHAR(100) PRIMARY KEY,
    Specialty VARCHAR(100),
    Years_Experience INT
);

-- 3. Insert sample doctor data
INSERT INTO doctors (Doctor_Name, Specialty, Years_Experience) VALUES
('Dr. Smith', 'Cardiology', 15),
('Dr. Johnson', 'Oncology', 12),
('Dr. Williams', 'Neurology', 8),
('Dr. Brown', 'Orthopedics', 20),
('Dr. Davis', 'Emergency Medicine', 10);

-- 4. Basic SELECT with WHERE and ORDER BY
-- Select all patients with specific medical condition, ordered by billing amount
SELECT Name, Age, Medical_Condition, Billing_Amount
FROM healthcare_dataset
WHERE Medical_Condition = 'Cancer'
ORDER BY Billing_Amount DESC;

-- 5. SELECT with multiple conditions
SELECT Name, Age, Gender, Hospital, Billing_Amount
FROM healthcare_dataset
WHERE Age > 50 AND Gender = 'Male'
ORDER BY Age ASC;

-- 6. GROUP BY with aggregate functions
-- Average billing amount by medical condition
SELECT Medical_Condition, 
       COUNT(*) as patient_count,
       AVG(Billing_Amount) as avg_billing,
       SUM(Billing_Amount) as total_billing
FROM healthcare_dataset
GROUP BY Medical_Condition
ORDER BY avg_billing DESC;

-- 7. GROUP BY with HAVING clause
-- Hospitals with more than 5 patients
SELECT Hospital, 
       COUNT(*) as patient_count,
       AVG(Billing_Amount) as avg_billing
FROM healthcare_dataset
GROUP BY Hospital
HAVING COUNT(*) > 5
ORDER BY patient_count DESC;

-- 8. Age group analysis
SELECT 
    CASE 
        WHEN Age < 18 THEN 'Child'
        WHEN Age BETWEEN 18 AND 65 THEN 'Adult'
        ELSE 'Senior'
    END as age_group,
    COUNT(*) as patient_count,
    AVG(Billing_Amount) as avg_billing
FROM healthcare_dataset
GROUP BY age_group;

-- 9. INNER JOIN: Patients with their doctor specialties
SELECT h.Name, h.Medical_Condition, h.Doctor, d.Specialty, d.Years_Experience
FROM healthcare_dataset h
INNER JOIN doctors d ON h.Doctor = d.Doctor_Name;

-- 10. LEFT JOIN: All patients, with doctor info if available
SELECT h.Name, h.Medical_Condition, h.Doctor, d.Specialty
FROM healthcare_dataset h
LEFT JOIN doctors d ON h.Doctor = d.Doctor_Name;

-- 11. RIGHT JOIN: All doctors, with patient info if available
SELECT h.Name, h.Medical_Condition, d.Doctor_Name, d.Specialty
FROM healthcare_dataset h
RIGHT JOIN doctors d ON h.Doctor = d.Doctor_Name;

-- 12. Subquery: Patients with above-average billing
SELECT Name, Medical_Condition, Billing_Amount
FROM healthcare_dataset
WHERE Billing_Amount > (
    SELECT AVG(Billing_Amount) FROM healthcare_dataset
)
ORDER BY Billing_Amount DESC;

-- 13. Subquery: Find patients treated by the most experienced doctor
SELECT Name, Medical_Condition, Doctor, Billing_Amount
FROM healthcare_dataset
WHERE Doctor = (
    SELECT Doctor_Name 
    FROM doctors 
    ORDER BY Years_Experience DESC 
    LIMIT 1
);

-- 14. Correlated subquery: Patients with highest billing in their medical condition
SELECT h1.Name, h1.Medical_Condition, h1.Billing_Amount
FROM healthcare_dataset h1
WHERE h1.Billing_Amount = (
    SELECT MAX(h2.Billing_Amount)
    FROM healthcare_dataset h2
    WHERE h2.Medical_Condition = h1.Medical_Condition
);

-- 15. Create views for analysis
-- View for hospital summary
CREATE VIEW hospital_summary AS
SELECT Hospital, 
       COUNT(*) as total_patients,
       AVG(Billing_Amount) as avg_billing,
       SUM(Billing_Amount) as total_revenue,
       AVG(Age) as avg_patient_age
FROM healthcare_dataset
GROUP BY Hospital;

-- View for medical condition analysis
CREATE VIEW condition_analysis AS
SELECT Medical_Condition,
       COUNT(*) as patient_count,
       AVG(Billing_Amount) as avg_cost,
       MIN(Billing_Amount) as min_cost,
       MAX(Billing_Amount) as max_cost
FROM healthcare_dataset
GROUP BY Medical_Condition;

-- View for doctor performance
CREATE VIEW doctor_performance AS
SELECT h.Doctor, 
       d.Specialty,
       COUNT(*) as patients_treated,
       AVG(h.Billing_Amount) as avg_billing_per_patient,
       SUM(h.Billing_Amount) as total_revenue
FROM healthcare_dataset h
LEFT JOIN doctors d ON h.Doctor = d.Doctor_Name
GROUP BY h.Doctor, d.Specialty;

-- 16. Query the views
SELECT * FROM hospital_summary ORDER BY total_revenue DESC;
SELECT * FROM condition_analysis ORDER BY patient_count DESC;
SELECT * FROM doctor_performance ORDER BY total_revenue DESC;

-- 17. Advanced analysis queries
-- Monthly admission trends (if you have date data)
SELECT YEAR(Date_of_Admission) as admission_year,
       MONTH(Date_of_Admission) as admission_month,
       COUNT(*) as admissions,
       AVG(Billing_Amount) as avg_billing
FROM healthcare_dataset
WHERE Date_of_Admission IS NOT NULL
GROUP BY YEAR(Date_of_Admission), MONTH(Date_of_Admission)
ORDER BY admission_year, admission_month;

-- Insurance provider analysis
SELECT Insurance_Provider,
       COUNT(*) as policy_holders,
       AVG(Billing_Amount) as avg_claim_amount,
       SUM(Billing_Amount) as total_claims
FROM healthcare_dataset
GROUP BY Insurance_Provider
ORDER BY total_claims DESC;

-- 18. Create indexes for optimization
CREATE INDEX idx_medical_condition ON healthcare_dataset (Medical_Condition);
CREATE INDEX idx_doctor ON healthcare_dataset (Doctor);
CREATE INDEX idx_hospital ON healthcare_dataset (Hospital);
CREATE INDEX idx_admission_date ON healthcare_dataset (Date_of_Admission);
CREATE INDEX idx_billing_amount ON healthcare_dataset (Billing_Amount);
CREATE INDEX idx_age ON healthcare_dataset (Age);

-- 19. Query optimization examples
-- Use EXPLAIN to see query execution plan
EXPLAIN SELECT * FROM healthcare_dataset WHERE Medical_Condition = 'Cancer';
EXPLAIN SELECT h.Name, d.Specialty FROM healthcare_dataset h JOIN doctors d ON h.Doctor = d.Doctor_Name;

-- 20. Data validation queries
-- Check for missing values
SELECT 
    COUNT(*) as total_records,
    COUNT(Name) as name_count,
    COUNT(Medical_Condition) as condition_count,
    COUNT(Doctor) as doctor_count,
    COUNT(Billing_Amount) as billing_count
FROM healthcare_dataset;

-- Find duplicate records
SELECT Name, COUNT(*) as duplicate_count
FROM healthcare_dataset
GROUP BY Name
HAVING COUNT(*) > 1;

-- 21. Statistical analysis
-- Billing amount statistics by gender
SELECT Gender,
       COUNT(*) as patient_count,
       AVG(Billing_Amount) as avg_billing,
       STDDEV(Billing_Amount) as std_deviation,
       MIN(Billing_Amount) as min_billing,
       MAX(Billing_Amount) as max_billing
FROM healthcare_dataset
GROUP BY Gender;

-- 22. Complex query with multiple JOINs and subqueries
SELECT h.Name, 
       h.Medical_Condition,
       h.Billing_Amount,
       d.Specialty,
       hs.avg_billing as hospital_avg_billing,
       (h.Billing_Amount - hs.avg_billing) as billing_difference
FROM healthcare_dataset h
LEFT JOIN doctors d ON h.Doctor = d.Doctor_Name
LEFT JOIN hospital_summary hs ON h.Hospital = hs.Hospital
WHERE h.Billing_Amount > (SELECT AVG(Billing_Amount) FROM healthcare_dataset)
ORDER BY billing_difference DESC;

-- End of SQL queries
-- Remember to import your CSV data into the healthcare_dataset table before running analysis queries
