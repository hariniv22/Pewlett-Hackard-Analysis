CREATE TABLE departments(
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(40) NOT NULL,
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
);

CREATE TABLE employees(
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	PRIMARY KEY(emp_no, dept_no)

);

CREATE TABLE salaries(
	emp_no INT NOT NULL,
	salary VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no),
	PRIMARY KEY(emp_no)

);

CREATE TABLE managers(
	dept_no VARCHAR NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	PRIMARY KEY(dept_no,emp_no)
);

CREATE TABLE titles(
	emp_no int NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	PRIMARY KEY(emp_no, title, from_date)
);

SELECT e.emp_no,
	   e.first_name,
	   e.last_name,
	   ti.title,
	   ti.from_date,
	   ti.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as ti
ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1952-1-1' AND '1955-12-31') 
ORDER BY emp_no;

SELECT * FROM retirement_titles;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) rt.emp_no,
				rt.first_name,
				rt.last_name,
				rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY emp_no, to_date DESC;

SELECT * FROM unique_titles;

-- number of employees by most recent title
SELECT COUNT(ut.emp_no), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT(ut.emp_no) DESC;

-- Deliverable2

SELECT DISTINCT ON(emp_no) e.emp_no,
	   e.first_name,
	   e.last_name,
	   e.birth_date,
	   de.from_date,
	   de.to_date,
	   ti.title
INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_emp as de
ON e.emp_no = de.emp_no
INNER JOIN titles as ti
ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1965-1-1' AND '1965-12-31') AND (de.to_date='9999-01-01')
ORDER BY e.emp_no;

-- Total count of employees eligible for mentorship
SELECT COUNT(me.emp_no)
FROM mentorship_eligibility as me

--- Additional queries for Summary(Deliverable 3)

--- Query1(Get all current retiring employees whose salary is over 50k)

SELECT * FROM unique_titles;

SELECT ut.emp_no,
	   ut.title,
	   ut.first_name,
	   ut.last_name,
	   s.salary
INTO salary_over_50k
FROM unique_titles as ut
INNER JOIN salaries as s
ON ut.emp_no = s.emp_no
WHERE (s.salary >= '50000');

-- number of current employees with salary over 50k
SELECT COUNT(sok.emp_no), sok.title
FROM salary_over_50k as sok
GROUP BY sok.title
ORDER BY COUNT(sok.emp_no) DESC;

-- Query 2
-- Get the gender of all current employees retiring
SELECT ut.emp_no,
	   ut.title,
	   ut.first_name,
	   ut.last_name,
	   e.gender
INTO gender_info
FROM unique_titles as ut
INNER JOIN employees as e
ON ut.emp_no = e.emp_no;

-- Get a count of Male employees retiring
SELECT COUNT(gi.gender), gi.title
FROM gender_info as gi
WHERE (gi.gender = 'M')
GROUP BY gi.title
ORDER BY COUNT(gi.gender) DESC;


