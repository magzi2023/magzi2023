CREATE OR REPLACE VIEW contracts_between_2000_and_2002 AS

SELECT 
    tb1.emp_no, tb1.dept_no, d.dept_name, t3.salary, tb1.from_date, tb1.to_date,
    AVG(salary) OVER w AS average_salary
FROM
    (SELECT
        de1.emp_no, de1.dept_no, de1.from_date, de1.to_date
    FROM
        dept_emp de1
    JOIN (SELECT 
        de.emp_no, MAX(de.from_date) AS from_date
    FROM
        dept_emp de
    WHERE
        de.from_date > '2000-01-01'
            AND de.to_date < '2002-01-01'
    GROUP BY de.emp_no) AS t1
    WHERE
        de1.from_date = t1.from_date
            AND de1.emp_no = t1.emp_no) AS tb1
        JOIN
departments d USING (dept_no)
    
 JOIN   
(SELECT s1.emp_no, s1.salary, s1.from_date, s1.to_date
	FROM salaries s1
	JOIN
	(SELECT s.emp_no, MAX(s.from_date) AS from_date
		FROM salaries s
		WHERE s.from_date > '2000-01-01' AND s.to_date < '2002-01-01'
		GROUP BY s.emp_no)AS t2
	USING(emp_no) 
	WHERE s1.emp_no = t2.emp_no AND 
		s1.from_date = t2.from_date) AS t3
USING(emp_no)

WINDOW w AS (PARTITION BY tb1.dept_no)
ORDER BY tb1.emp_no, salary
;

