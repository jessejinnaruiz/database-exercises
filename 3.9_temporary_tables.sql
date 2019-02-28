USE ada_664;

CREATE TEMPORARY TABLE temp_table (n INT UNSIGNED NOT NULL);
INSERT INTO temp_table (n) VALUES (1), (2), (3), (4), (5);
SELECT * FROM temp_table;

UPDATE temp_table SET n = n + 1;
SELECT * FROM temp_table;

-- Using the example from the lesson, re-create the employees_with_departments table.
CREATE TEMPORARY TABLE employees_with_departments AS
SELECT emp_no, first_name, last_name, dept_no, dept_name
FROM employees.employees
JOIN employees.dept_emp USING(emp_no)
JOIN employees.departments USING(dept_no)
LIMIT 100;

SELECT * 
FROM employees_with_departments;

-- Add a column named full_name to this table. It should be a VARCHAR whose length is the sum of the lengths of the first name and last name columns
ALTER TABLE employees_with_departments ADD full_name VARCHAR (50) NOT NULL;

SELECT * 
FROM employees_with_departments;

-- Update the table so that full name column contains the correct data
UPDATE employees_with_departments SET full_name = (
	CONCAT(first_name, ' ', last_name)
);

SELECT * 
FROM employees_with_departments;

-- Remove the first_name and last_name columns from the table.
ALTER TABLE employees_with_departments DROP COLUMN first_name;
ALTER TABLE employees_with_departments DROP COLUMN last_name;

SELECT * 
FROM employees_with_departments;


-- What is another way you could have ended up with this same table?
CREATE TEMPORARY TABLE employees_with_departments_3 AS
SELECT CONCAT(first_name, ' ', last_name) AS full_name, emp_no, dept_no, dept_name 
FROM employees.employees
JOIN employees.dept_emp USING(emp_no)
JOIN employees.departments USING(dept_no)
LIMIT 100;

SELECT * 
FROM employees_with_departments_3;

-- Create a temporary table based on the payments table from the sakila database. 
-- Write the SQL necessary to transform the amount column such that it is stored 
-- as an integer representing the number of cents of the payment. For example, 1.99 should become 199.
CREATE TEMPORARY TABLE sakila_amounts_transformed AS
SELECT amount, CAST(amount * 100 AS SIGNED) AS amt_2
FROM sakila.payment
LIMIT 100;

SELECT *
FROM sakila_amounts_transformed;

ALTER TABLE sakila_amounts_transformed DROP COLUMN amount;

DROP TABLE sakila_amounts_transformed;


-- Find out how the average pay in each department compares to the overall average pay. In order to make the comparison easier, you should use the Z-score for salaries. In terms of salary, what is the best department to work for? The worst?
CREATE TEMPORARY TABLE avg_by_department AS
SELECT AVG(salaries.salary) AS average_salary, departments.dept_name
FROM employees.dept_emp
JOIN employees.salaries ON dept_emp.emp_no = salaries.emp_no
JOIN employees.departments ON dept_emp.dept_no = departments.dept_no
WHERE salaries.to_date = '9999-01-01'
GROUP BY departments.dept_name
ORDER BY AVG(salaries.salary) DESC;

SELECT * 
FROM avg_by_department;

CREATE TEMPORARY TABLE employees_pay AS
SELECT emp_no, salary
FROM employees.salaries;

SELECT * 
FROM employees_pay;

-- 1. get aggregates
SELECT AVG(salary), STDDEV(salary)
FROM employees.salaries
WHERE to_date > NOW();

-- 2. get z score
SELECT emp_no, salary, ((salary-72012)/17310) AS z_salary
FROM employees.salaries
WHERE to_date > NOW();

-- 3. get department
SELECT d.dept_name, salaries.emp_no, salaries.salary, ((salary-72012)/17310) AS z_salary
FROM employees.salaries
JOIN employees.dept_emp de ON salaries.emp_no = de.emp_no
JOIN employees.departments d ON de.dept_no = d.dept_no
WHERE salaries.to_date > NOW();


-- 4. get avg z by department
SELECT a.dept_name, AVG(a.z_salary) AS avg_z_salary 
FROM
(
	SELECT d.dept_name, salaries.emp_no, salaries.salary, ((salary-72012)/17310) AS z_salary
	FROM employees.salaries
	JOIN employees.dept_emp de ON salaries.emp_no = de.emp_no
	JOIN employees.departments d ON de.dept_no = d.dept_no
	WHERE salaries.to_date > NOW()
) a
GROUP BY a.dept_name
ORDER BY avg_z_salary DESC;

 -- OPTION 1 - make a temp table
CREATE TEMPORARY TABLE agg AS
SELECT AVG(salary) AS avg_salary, STDDEV(salary) AS steddev_salary
FROM employees.salaries
WHERE to_date > NOW();

-- SELECT * FROM agg;

SELECT a.dept_name, AVG(a.z_salary) AS avg_z_salary 
FROM
(
	SELECT d.dept_name, salaries.emp_no, salaries.salary, ((salary-agg.avg_salary)/agg.steddev_salary) AS z_salary
	FROM employees.salaries
    JOIN agg
	JOIN employees.dept_emp de ON salaries.emp_no = de.emp_no
	JOIN employees.departments d ON de.dept_no = d.dept_no
	WHERE salaries.to_date > NOW()
) a
GROUP BY a.dept_name
ORDER BY avg_z_salary DESC;

-- What is the average salary for an employee based on the number of years they have been with the company? Express your answer in terms of the Z-score of salary. Since this data is a little older, scale the years of experience by subtracting the minumum from every row.
-- CREATE TEMPORARY TABLE averages_of_employees AS
-- SELECT AVG(salaries.salary) AS average_salary
-- FROM employees.dept_emp
-- JOIN employees.salaries ON dept_emp.emp_no = salaries.emp_no
-- ORDER BY AVG(salaries.salary) DESC;

-- SELECT * 
-- FROM averages_of_employees;

-- DROP TABLE averages_of_employees;

-- 1. get aggregates
SELECT AVG(salary), STDDEV(salary)
FROM employees.salaries
WHERE to_date > NOW();

-- 2. get z score & years that an employee worked
CREATE TEMPORARY TABLE z_salary_table AS
SELECT ((salaries.salary-72012)/17310) AS z_salary, salaries.salary, employees.hire_date, ROUND(DATEDIFF(NOW(), (employees.hire_date))/365.25)-19 AS years_worked
FROM employees.salaries
JOIN employees.employees USING (emp_no);

-- SELECT *
-- FROM z_salary_table;

-- DROP TABLE z_salary_table;

-- -- 3. get years that an employee worked
-- ALTER TABLE z_salary_table ADD years_worked INT UNSIGNED;

-- SELECT *
-- FROM z_salary_table;

-- UPDATE z_salary_table
-- SET years_worked = ROUND(DATEDIFF(NOW(), (hire_date))/365.25)-19;

-- SELECT *
-- FROM z_salary_table;


-- SELECT (ROUND(DATEDIFF(NOW(), MIN(employees.hire_date))/365.25)-19) as years_worked, emp_no
-- FROM employees.employees
-- JOIN z_salary_table USING (emp_no)
-- GROUP BY emp_no;

-- 4. get avg z by years
SELECT years_worked, AVG(z_salary)
FROM z_salary_table
GROUP BY years_worked;


-- SELECT DISTINCT ROUND(DATEDIFF(NOW(), MIN(employees.hire_date))/365)-19 AS years_worked, AVG(salary-72012)/17310)
-- FROM employees.salaries
-- JOIN employees.employees USING (emp_no)
-- JOIN z_salary_table USING (emp_no)
-- GROUP BY emp_no
-- ORDER BY years_worked DESC;

-- SELECT a.years_worked, a.z_salary
-- FROM
-- (
--     SELECT DISTINCT ROUND(DATEDIFF(NOW(), MIN(employees.hire_date))/365) AS years_worked, employees.emp_no, salaries.salary, ((salary-72012)/17310) AS z_salary
-- 	FROM employees.salaries
-- 	JOIN employees.employees USING (emp_no)
-- 	GROUP BY salaries.salary, z_salary, employees.emp_no
-- 	ORDER BY years_worked DESC;
-- ) 
--     a
--     GROUP BY a.years_worked;
--  
-- SELECT AVG((salary-72012)/17310) AS avg_z_salary
-- FROM z_salary_table;
--     
-- SELECT ROUND(DATEDIFF(NOW(), MIN(employees.hire_date))/365) AS years_worked, employees.emp_no, salaries.salary, 
-- 	(SELECT AVG((salary-72012)/17310) AS avg_z_salary
-- 	FROM z_salary_table)
-- FROM employees.salaries
-- JOIN employees.employees USING (emp_no)
-- GROUP BY salaries.salary, z_salary_table.avg_z_salary, employees.emp_no
-- ORDER BY years_worked DESC;