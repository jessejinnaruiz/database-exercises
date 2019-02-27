USE employees;


-- shows each department along with the name of the current manager for that department.
SHOW tables;
SELECT CONCAT(employees.first_name, ' ', employees.last_name) AS manager_name, departments.dept_name
FROM employees 
JOIN dept_emp ON dept_emp.emp_no = employees.emp_no
JOIN dept_manager ON dept_manager.emp_no = dept_emp.emp_no
JOIN departments ON dept_manager.dept_no = departments.dept_no
WHERE dept_manager.to_date = '9999-01-01'
ORDER BY departments.dept_name;


-- Find the name of all departments currently managed by women.
SELECT CONCAT(employees.first_name, ' ', employees.last_name) AS manager_name, departments.dept_name
FROM employees 
JOIN dept_manager ON employees.emp_no = dept_manager.emp_no 
JOIN departments ON departments.dept_no = dept_manager.dept_no
WHERE to_date LIKE '9999-01-01' AND gender = 'F';


-- Find the current titles of employees currently working in the Customer Service department.
SELECT CONCAT(employees.first_name, ' ', employees.last_name) as employee_name, departments.dept_name, titles.title FROM employees
JOIN dept_emp ON employees.emp_no  = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
JOIN titles ON employees.emp_no  = titles. emp_no
WHERE dept_name LIKE 'Customer Service' AND titles.to_date = '9999-01-01';

-- to count up the totals of each title of the employees currently working in the Customer Service department.
SELECT titles.title, COUNT(titles.title) FROM employees
JOIN dept_emp ON employees.emp_no  = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
JOIN titles ON employees.emp_no  = titles. emp_no
WHERE dept_name LIKE 'Customer Service' AND titles.to_date = '9999-01-01'
GROUP BY titles.title;


-- Find the current salary of all current managers.
SELECT departments.dept_name, CONCAT(employees.first_name, ' ', employees.last_name) as employee_name, MAX(salaries.salary) as salary
FROM employees 
JOIN dept_manager ON dept_manager.emp_no = employees.emp_no
LEFT JOIN salaries ON dept_manager.emp_no = salaries.emp_no
JOIN departments ON dept_manager.dept_no = departments.dept_no
WHERE dept_manager.to_date = '9999-01-01'
GROUP BY departments.dept_name, employees.first_name, employees.last_name;


-- 6. Find the number of employees in each department.
SELECT departments.dept_no, departments.dept_name, COUNT( DISTINCT (employees.emp_no)) as number_of_employees 
FROM employees
JOIN dept_emp ON employees.emp_no  = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
JOIN titles ON employees.emp_no  = titles. emp_no
WHERE dept_emp.to_date = '9999-01-01'
GROUP BY departments.dept_no
ORDER BY departments.dept_no;


-- 7. Which department currently has the highest average salary?
SELECT AVG(salaries.salary) AS average_salary, departments.dept_name
FROM dept_emp
JOIN salaries ON dept_emp.emp_no = salaries.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE salaries.to_date = '9999-01-01'
GROUP BY departments.dept_name
ORDER BY AVG(salaries.salary) DESC;


-- 8. Who is the highest paid employee in the Marketing department?
SELECT CONCAT(employees.first_name, ' ', employees.last_name) AS employee_name, MAX(salaries.salary) AS salary
FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN salaries ON salaries.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Marketing'
GROUP BY employees.first_name, employees.last_name
ORDER BY MAX(salaries.salary) DESC
LIMIT 1;


-- 9.  Which current department manager has the highest salary?
SELECT departments.dept_name, CONCAT(employees.first_name, ' ', employees.last_name) as employee_name, MAX(salaries.salary) as salary
FROM employees 
JOIN dept_manager ON dept_manager.emp_no = employees.emp_no
LEFT JOIN salaries ON dept_manager.emp_no = salaries.emp_no
JOIN departments ON dept_manager.dept_no = departments.dept_no
WHERE dept_manager.to_date = '9999-01-01'
GROUP BY departments.dept_name, employees.first_name, employees.last_name, salaries.salary
ORDER BY salaries.salary DESC
LIMIT 1;


-- Bonus Find the names of all current employees, their department name, and their current manager's name.  240,124 Rows
SELECT CONCAT(employees.first_name, ' ', employees.last_name) AS employee_name, departments.dept_name, CONCAT(emp2.first_name, ' ', emp2.Last_name) AS managers_name
FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON departments.dept_no = dept_emp.dept_no
JOIN dept_manager ON dept_emp.dept_no = dept_manager.dept_no
JOIN employees emp2 ON dept_manager.emp_no = emp2.emp_no
WHERE dept_manager.to_date = '9999-01-01' AND dept_emp.to_date = '9999-01-01';

	
-- Bonus Find the highest paid employee in each department.
SELECT departments.dept_name, CONCAT(employees.first_name, ' ', employees.last_name) as employee_name, MAX(salaries.salary) as salary
FROM employees 
JOIN dept_manager ON dept_manager.emp_no = employees.emp_no
LEFT JOIN salaries ON dept_manager.emp_no = salaries.emp_no
JOIN departments ON dept_manager.dept_no = departments.dept_no
WHERE dept_manager.to_date = '9999-01-01'
GROUP BY departments.dept_name, employees.first_name, employees.last_name, MAX(salary)
ORDER BY salaries.salary DESC;