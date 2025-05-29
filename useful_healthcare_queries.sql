
-- USE your working database
USE healthcare_db;

-- 1. View all patients with Cancer sorted by highest billing
SELECT Name, Age, Medical_Condition, Billing_Amount
FROM healthcare_dataset
WHERE Medical_Condition = 'Cancer'
ORDER BY Billing_Amount DESC;

-- 2. Average billing by medical condition
SELECT Medical_Condition, COUNT(*) AS patient_count, AVG(Billing_Amount) AS avg_billing
FROM healthcare_dataset
GROUP BY Medical_Condition;

-- 3. Total revenue and average billing per hospital
SELECT Hospital, COUNT(*) AS patient_count, SUM(Billing_Amount) AS total_revenue, AVG(Billing_Amount) AS avg_billing
FROM healthcare_dataset
GROUP BY Hospital
ORDER BY total_revenue DESC;

-- 4. Patients and their doctor specialties
SELECT h.Name, h.Medical_Condition, h.Doctor, d.Specialty
FROM healthcare_dataset h
JOIN doctors d ON h.Doctor = d.Doctor_Name;

-- 5. Patients treated by the most experienced doctor
SELECT Name, Medical_Condition, Doctor, Billing_Amount
FROM healthcare_dataset
WHERE Doctor = (
    SELECT Doctor_Name FROM doctors ORDER BY Years_Experience DESC LIMIT 1
);

-- 6. Top performing doctors by total billing
SELECT h.Doctor, d.Specialty, COUNT(*) AS patient_count, SUM(h.Billing_Amount) AS total_billing
FROM healthcare_dataset h
JOIN doctors d ON h.Doctor = d.Doctor_Name
GROUP BY h.Doctor, d.Specialty
ORDER BY total_billing DESC;

-- 7. Monthly admission trends
SELECT YEAR(Date_of_Admission) AS year, MONTH(Date_of_Admission) AS month, COUNT(*) AS admissions, AVG(Billing_Amount) AS avg_billing
FROM healthcare_dataset
GROUP BY year, month
ORDER BY year, month;

-- 8. Insurance provider performance
SELECT Insurance_Provider, COUNT(*) AS policy_holders, SUM(Billing_Amount) AS total_claims
FROM healthcare_dataset
GROUP BY Insurance_Provider
ORDER BY total_claims DESC;

-- 9. Highest billing patient in each condition
SELECT h1.Name, h1.Medical_Condition, h1.Billing_Amount
FROM healthcare_dataset h1
WHERE h1.Billing_Amount = (
    SELECT MAX(h2.Billing_Amount)
    FROM healthcare_dataset h2
    WHERE h2.Medical_Condition = h1.Medical_Condition
);

-- 10. Create view for hospital summary
CREATE OR REPLACE VIEW hospital_summary AS
SELECT Hospital, COUNT(*) AS total_patients, AVG(Billing_Amount) AS avg_billing, SUM(Billing_Amount) AS total_revenue
FROM healthcare_dataset
GROUP BY Hospital;

-- 11. Query the hospital summary view
SELECT * FROM hospital_summary ORDER BY total_revenue DESC;
