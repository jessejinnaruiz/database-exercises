-- Create a new file named 3.7_group_by_exercises.sql

USE employees;
DESCRIBE titles;

-- In your script, use DISTINCT to find the unique titles in the titles table. 
SELECT DISTINCT title FROM employees.titles;

-- Find your query for employees whose last names start and end with 'E'. 
-- Update the query find just the unique last names that start and end with 'E' using GROUP BY.
SELECT last_name FROM employees WHERE (last_name LIKE 'e%') AND (last_name LIKE '%e')
GROUP BY last_name;

-- Update your previous query to now find unique combinations of first and last name where the last name starts and ends with 'E'. You should get 846 rows.
SELECT first_name, last_name FROM employees WHERE (last_name LIKE 'e%') AND (last_name LIKE '%e')
GROUP BY first_name, last_name;

-- Find the unique last names with a 'q' but not 'qu'. 
SELECT last_name FROM employees WHERE NOT (last_name LIKE '%qu%') AND (last_name LIKE '%q%')
GROUP BY last_name;

-- Find employees with least common name and most common name FOR first name, last name and both together. 
SELECT last_name, COUNT(last_name) FROM employees
GROUP BY last_name
ORDER BY COUNT(last_name) DESC;
-- Sadowsky 145 COUNT
-- Baba COUNT 226

SELECT first_name, COUNT(first_name) FROM employees
GROUP BY first_name;
-- Lech & Renny 185 COUNT
-- Shahab 295 COUNT

SELECT COUNT(*), CONCAT(first_name, " ", last_name) AS full_name FROM employees
GROUP BY full_name
ORDER BY COUNT(*) DESC;
-- LEAST COMMON too many to list
-- Most Common full_name: 
-- '5','Rosalyn Baalen'
-- '5','Laurentiu Cesareni'



-- Update your query for 'Irena', 'Vidya', or 'Maya'. Use COUNT(*) and GROUP BY to find the number of employees for each gender with those names.
SELECT COUNT(*), gender FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya')
GROUP BY gender;


-- ??? Recall the query the generated usernames for the employees from the last lesson. Are there any duplicate usernames?
-- YES THERE ARE DUPLICATES

SELECT 
    DISTINCT LOWER(CONCAT((SUBSTR(first_name, 1, 1)),
            (SUBSTR(last_name, 1, 4)),
            '_',
            SUBSTR(birth_date, 6, 2),
            SUBSTR(birth_date, 3, 2))) AS user_names,
	COUNT(*) AS count
FROM employees
GROUP BY user_names
HAVING COUNT(*)>1;

-- Bonus: how many duplicate usernames are there? 

SELECT
	SUM(count)
    -- outer query to sum the results of the subquery
FROM (
-- subquery to find the usernames
SELECT
	CONCAT(LOWER(SUBSTR(first_name, 1, 1)),
            LOWER(SUBSTR(last_name, 1, 4)),
            '_',
            SUBSTR(birth_date, 6, 2),
            SUBSTR(birth_date, 3, 2)) AS user_names,
	COUNT(*) AS count
    FROM employees
    GROUP BY user_names DESC
	HAVING COUNT(*)>1
)
employees;
-- ANSWER #1 the number of people with duplicate user_names: 13,251
 -- ANSWER #2 sums the number of user_names: 27,403

