USE employees;
-- 1 Find all the employees with the same hire date as employee 101010 using a sub-query. 69 Rows
SELECT first_name, last_name, hire_date
FROM employees.employees
WHERE hire_date = (
	SELECT hire_date
    FROM employees
    WHERE emp_no = '101010'
);

-- 2 Find all the titles held by all employees with the first name Aamod. 314 total titles, 6 unique titles
SELECT COUNT(title)
FROM titles
JOIN employees ON titles.emp_no = employees.emp_no
	WHERE employees.first_name 
    IN ( 
		SELECT first_name
		FROM employees
		WHERE first_name = 'Aamod');

SELECT COUNT(DISTINCT title)
FROM titles
JOIN employees ON titles.emp_no = employees.emp_no
	WHERE employees.first_name 
    IN ( 
		SELECT first_name
		FROM employees
		WHERE first_name = 'Aamod');

-- ? 3 How many people in the employees table are no longer working for the company?
SELECT COUNT(*)
FROM employees
WHERE emp_no NOT IN (
	SELECT emp_no
    FROM dept_emp
    WHERE to_date > NOW()
);

-- 4 Find all the current department managers that are female.
SELECT employees.first_name, employees.last_name
FROM dept_manager
JOIN employees ON dept_manager.emp_no = employees.emp_no
WHERE dept_manager.emp_no IN (
SELECT emp_no
FROM employees 
WHERE gender = 'F') AND to_date = '9999-01-01';

-- 5 Find all the employees that currently have a higher than average salary. 154543 rows in total. 
SELECT employees.first_name, employees.last_name, salaries.salary AS salary
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no
WHERE salaries.salary > (
	SELECT AVG(salary)
	FROM salaries) AND salaries.to_date = '9999-01-01';

-- 6 How many current salaries are within 1 standard deviation of the highest salary? (Hint: you can use a built in function to calculate the standard deviation.) 
SELECT COUNT(salaries.salary)
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no
WHERE salaries.to_date = '9999-01-01' AND salaries.salary BETWEEN (
	SELECT MAX(salary)-STD(salary)
	FROM salaries)
    AND 
    (SELECT MAX(salary)+STD(salary)
	FROM salaries); 

-- From Zachs example in class
SELECT MAX(salary) - STD(salary) FROM salaries;

-- 6a What percentage of all salaries is this? 78 salaries
SELECT (
SELECT COUNT(salaries.salary)
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no
WHERE salaries.to_date = '9999-01-01' AND salaries.salary BETWEEN (
	SELECT MAX(salary)-STD(salary)
	FROM salaries)
    AND 
    (SELECT MAX(salary)+STD(salary)
	FROM salaries))/COUNT(salary)*100
    FROM salaries
    ;

-- zach's answer:
SELECT (COUNT(*)/(SELECT COUNT(*) FROM salaries WHERE to_date > NOW())) * 100
FROM salaries
WHERE salary >= (
	SELECT MAX(salary) - STDDEV(salary) FROM salaries AND to_date > NOW()
    );


-- *~*!*~*!*~*!*~*!*~*!* BONUS *!*~*!*~*!*~*!*~*!*~*
-- Find all the department names that currently have female managers.
SELECT departments.dept_name
FROM dept_manager
JOIN employees ON dept_manager.emp_no = employees.emp_no
JOIN departments ON dept_manager.dept_no = departments.dept_no
WHERE dept_manager.to_date = '9999-01-01' AND dept_manager.emp_no IN (
	SELECT emp_no
    FROM employees
    WHERE gender = 'F'
);

-- Find the first and last name of the employee with the highest salary.
SELECT employees.first_name, employees.last_name, salaries.salary
FROM employees
JOIN salaries ON salaries.emp_no = employees.emp_no
WHERE salaries.salary IN (
	SELECT MAX(salary)
    FROM salaries
);

-- Find the department name that the employee with the highest salary works in.
SELECT employees.first_name, employees.last_name, salaries.salary, departments.dept_name
FROM employees
JOIN salaries ON salaries.emp_no = employees.emp_no
JOIN dept_emp ON employees.emp_no  = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE salaries.salary IN (
	SELECT MAX(salary)
    FROM salaries
);