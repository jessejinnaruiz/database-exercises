USE employees;
SHOW TABLES;
-- shows the tables in the employees DB
DESCRIBE employees;
-- shows the fields in the employees tables; the data types include int, date, varchar, enum
DESCRIBE departments;
SHOW CREATE TABLE employees;

-- Which table(s) do you think contain a numeric type column? Salaries table
-- Which table(s) do you think contain a string type column? Dept, dept_emp, dept_manager, employees, titles
-- Which table(s) do you think contain a date type column? dept_emp_latest_date
-- What is the relationship between the employees and the departments tables? Deptartments is a key for which departments exist. Employees is a table of unique employees and their information. There seems to be no relationship in the tables but we can assume that employees have a particular department.
-- dept_emp table links the employees to the departments
-- Show the SQL that created the dept_manager table. ********
SHOW CREATE TABLE dept_manager;
