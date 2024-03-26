CREATE DATABASE project;

USE project;

-- DATA CLEANING 

SELECT * FROM hr;

ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20);

DESCRIBE HR;

SELECT birthdate FROM HR;

SET SQl_safe_updates = 0;

UPDATE HR
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
    
ALTER TABLE HR
MODIFY COLUMN birthdate DATE;

UPDATE HR
SET hire_date = CASE 
	WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN HIre_date LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL 
    END;
    
ALTER TABLE HR
MODIFY COLUMN hire_date DATE;

DESCRIBE HR;

SELECT termdate FROM HR;

UPDATE HR
SET termdate = IF(termdate IS NOT NULL AND termdate != '',
				  DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC')),
                  '0000-00-00')
WHERE TRUE;

SELECT termdate FROM HR;

SET SQl_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE HR
MODIFY COLUMN termdate DATE;

SELECT * FROM HR;

ALTER TABLE HR
ADD COLUMN age INT;

UPDATE HR
SET age = TIMESTAMPDIFF(YEAR, birthdate, CURDATE());

SELECT birthdate, age FROM HR;

SELECT 
	min(AGE) AS youngest,
	Max(AGE) AS oldest
FROM HR;

SELECT COUNT(*) FROM HR WHERE age < 18;
SELECT * FROM HR;


-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?
SELECT gender, COUNT(*) 
FROM HR
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, COUNT(*) 
FROM HR
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY COUNT(*) DESC;

-- 3. What is the age distribution of employees in the company?
SELECT
min(age) AS youngest,
max(age) AS oldest
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00';

SELECT 
	CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
		WHEN age >= 25 AND age <= 34 THEN '25-34'
		WHEN age >= 35 AND age <= 44 THEN '35-44'
		WHEN age >= 45 AND age <= 54 THEN '45-54'
		WHEN age >= 55 AND age <= 64 THEN '55-64'
		ELSE '65+'
        END AS age_group, COUNT(*)
FROM hr
WHERE age >= 18 AND TErmdate = '0000-00-00'
GROUP BY age_group
ORDER BY age_group; 

-- 4. How many employees work at headquarters vs remote location?
SELECT location, COUNT(*) FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location;

-- 5. What is the average length of employment of employees who have been terminated?
SELECT
ROUND(AVG(DATEDIFF(termdate, hire_date))/365, 0) AS avg_len_emp
FROM hr
WHERE termdate <> '0000-00-00' AND termdate <= CURDATE() AND age >= 18;

-- 6. How does the gender distribution vary across departments and job titles?
SELECT department, gender, count(*)
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY department, gender
ORDER BY department;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, count(*)
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY jobtitle;

-- 8. What is the distribution of employees across locations by city and state?
SELECT location_state, count(*)
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location_state;

-- 9. What is the tenure distribution for each department?
SELECT department, ROUND(AVG(DATEDIFF(termdate, hire_date)/365), 0)
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY department;