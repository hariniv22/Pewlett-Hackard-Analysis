SELECT * FROM employees;

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-1-1' AND '1955-12-31';


SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-1-1' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-1-1' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-1-1' AND '1954-12-31'

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-1-1' AND '1955-12-31'

SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-1-1' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-1-1' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-1-1' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

DROP TABLE retirement_info;

-- Re-create retirement_info table
SELECT first_name, last_name, emp_no
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-1-1' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * from retirement_info

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
       managers.emp_no,
       managers.from_date,
       managers.to_date
FROM departments
INNER JOIN managers
ON departments.dept_no = managers.dept_no;
       
-- Joining retirement_info and dept_emp tables
SELECT retirement_info.first_name,
     retirement_info.last_name,
     retirement_info.emp_no,
     dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Aliases 
SELECT ri.emp_no,
    ri.first_name,
  ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

SELECT dep.dept_name,
       man.emp_no,
       man.from_date,
       man.to_date
FROM departments as dep
INNER JOIN managers as man
ON dep.dept_no = man.dept_no;

-- create new table for current_emp
SELECT ri.emp_no,
    ri.first_name,
  ri.last_name,
    de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

SELECT * FROM current_emp;

SELECT COUNT(first_name)
FROM current_emp;

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Create a table for count_by department
SELECT COUNT(ce.emp_no), de.dept_no
INTO retired_count_by_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM retired_count_by_dept;

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT * FROM dept_emp
ORDER BY to_date DESC;

SELECT first_name,
     last_name,
     emp_no,
     gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND
    (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
    
SELECT * FROM emp_info;

DROP TABLE emp_info;

-- join employees and salaries tables
SELECT e.first_name,
     e.last_name,
     e.emp_no,
     e.gender,
     s.salary,
     de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON e.emp_no = s.emp_no
INNER JOIN dept_emp as de
ON e.emp_no = de.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
   AND (de.to_date = '9999-01-01');
     
SELECT * FROM emp_info;

-- List of managers per department
SELECT ce.first_name,
     ce.last_name,
     man.from_date,
     man.to_date,
     man.dept_no,
     man.emp_no,
     d.dept_name
INTO manager_info
FROM managers as man
INNER JOIN current_emp as ce
ON ce.emp_no = man.emp_no
INNER JOIN departments as d
ON man.dept_no = d.dept_no;


SELECT ce.emp_no,
     ce.first_name,
     ce.last_name,
     d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

SELECT * FROM current_emp;

SELECT ce.first_name,
     ce.last_name,
     ce.emp_no,
     d.dept_name
INTO sales_info
FROM current_emp as ce
INNER JOIN dept_emp as de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE (d.dept_name = 'Sales');

SELECT ce.first_name,
     ce.last_name,
     ce.emp_no,
     d.dept_name
INTO dev_sales_info
FROM current_emp as ce
INNER JOIN dept_emp as de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales', 'Development');
