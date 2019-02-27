USE employees;
DESCRIBE employees;

-- Find your query for employees born on Christmas and hired in the 90s from order_by_exercises.sql. Update it to find just the first 5 employees.
SELECT * FROM employees WHERE (hire_date > '1989-12-31') AND (birth_date LIKE '%12-25%')
ORDER BY birth_date, hire_date DESC
LIMIT 5;

-- Update the query to find the tenth page of results. 
SELECT * FROM employees WHERE (hire_date > '1989-12-31') AND (birth_date LIKE '%12-25%')
ORDER BY birth_date, hire_date DESC
LIMIT 5 OFFSET 45;

-- LIMIT and OFFSET can be used to create multiple pages of data. What is the relationship between OFFSET (number of results to skip), LIMIT (number of results per page), and the page number?

-- page number = (limit # + offset #)/limit #