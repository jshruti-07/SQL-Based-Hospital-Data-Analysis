CREATE TABLE hospital_data(
	Hospital_Name VARCHAR(100),
	Location VARCHAR(60),
	Department VARCHAR(50),
	Doctors_Count INT,
	Patients_Count INT,
	Admission_Date DATE,
	Discharge_Date DATE,
	Medical_Expenses NUMERIC(10,2)
);

SELECT * FROM hospital_data;

--Import data into hospital_data table
COPY
hospital_data(Hospital_Name, Location, Department, Doctors_Count, Patients_Count, Admission_Date, Discharge_Date, Medical_Expenses)
FROM 'C:\Users\SHRUTI\Downloads\Hospital_Data.csv'
DELIMITER ','
CSV HEADER;

--1. Total number of patients across all hospitals
SELECT SUM(patients_count) AS Total_patient_count FROM hospital_data;


--2. Average count of doctors available in each hospital
SELECT Hospital_Name, AVG(doctors_count) AS Average_doc_count
FROM hospital_data
GROUP BY Hospital_Name;


--3. Top 3 hospital departments that have the highest number of patients
--Solution 1: If we consider patient_count of the indivisual departments of each hospital separately
SELECT hospital_name, department, patients_count
FROM hospital_data
GROUP BY hospital_name, department, patients_count
ORDER BY patients_count DESC LIMIT 3;
--Solution 2: If we combine patient_count of similar departments of all hospitals
SELECT department, SUM(patients_count) AS departmental_patient_count
FROM hospital_data
GROUP BY department
ORDER BY departmental_patient_count DESC LIMIT 3;


--4. Hospital that recorded the highest medical expenses
SELECT hospital_name, SUM(medical_expenses)
FROM hospital_data 
GROUP BY hospital_name
ORDER BY SUM(medical_expenses) DESC LIMIT 1;


--5. Average medical expenses per day for each hospital
SELECT hospital_name, AVG(medical_expenses / (discharge_date - admission_date)) AS Avg_expense
FROM hospital_data
GROUP BY hospital_name;


--6. Find the patient with the longest stay
SELECT *, (discharge_date - admission_date) AS stay_duration
FROM hospital_data
ORDER BY stay_duration DESC LIMIT 1;


--7. Total number of patients treated in each city
SELECT location, SUM(patients_count) as city_wise_patient_count
FROM hospital_data
GROUP BY location
ORDER BY city_wise_patient_count DESC;


--8. Average number of days patients spend in each department
SELECT department, AVG(patients_count) AS avg_dept_patient_count
FROM hospital_data
GROUP BY department
ORDER BY avg_dept_patient_count DESC;


--9. The department with the least number of patients
SELECT department, SUM(patients_count) AS dept_wise_patient_count
FROM hospital_data
GROUP BY department
ORDER BY dept_wise_patient_count ASC LIMIT 1;


--10. Group the data by month and calculate the total medical expenses for each month
SELECT TO_CHAR(admission_date, 'Month-YYYY') AS month, SUM(medical_expenses) AS monthly_expense
FROM hospital_data
GROUP BY TO_CHAR(admission_date, 'Month-YYYY')
ORDER BY month ASC;