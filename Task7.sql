mysql> create database task7;
Query OK, 1 row affected (0.09 sec)

mysql> use task7;
Database changed
mysql> -- SQL Developer Internship - Task 7: Creating Views
mysql> -- Complete Query Code
mysql>
mysql> -- Section 1: Schema Setup and Sample Data Insertion
mysql>
mysql> -- Drop existing tables if they exist to ensure a clean run
mysql> DROP TABLE IF EXISTS Employees;
Query OK, 0 rows affected, 1 warning (0.03 sec)

mysql> DROP TABLE IF EXISTS Departments;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql>
mysql> -- Create Departments Table
mysql> CREATE TABLE Departments (
    ->     department_id INT PRIMARY KEY,
    ->     department_name VARCHAR(100) NOT NULL
    -> );
Query OK, 0 rows affected (0.09 sec)

mysql>
mysql> -- Insert sample data into Departments
mysql> INSERT INTO Departments (department_id, department_name) VALUES
    -> (101, 'Human Resources'),
    -> (102, 'Engineering'),
    -> (103, 'Sales'),
    -> (104, 'Marketing');
Query OK, 4 rows affected (0.02 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql>
mysql> -- Create Employees Table
mysql> CREATE TABLE Employees (
    ->     employee_id INT PRIMARY KEY,
    ->     first_name VARCHAR(50) NOT NULL,
    ->     last_name VARCHAR(50) NOT NULL,
    ->     email VARCHAR(100) UNIQUE,
    ->     phone_number VARCHAR(20),
    ->     hire_date DATE,
    ->     job_id VARCHAR(50),
    ->     salary DECIMAL(10, 2),
    ->     department_id INT,
    ->     FOREIGN KEY (department_id) REFERENCES Departments(department_id)
    -> );
Query OK, 0 rows affected (0.03 sec)

mysql>
mysql> -- Insert sample data into Employees
mysql> INSERT INTO Employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, department_id) VALUES
    -> (1, 'Alice', 'Smith', 'alice.smith@example.com', '111-222-3333', '2020-01-15', 'Software Engineer', 75000.00, 102),
    -> (2, 'Bob', 'Johnson', 'bob.johnson@example.com', '444-555-6666', '2019-03-20', 'HR Specialist', 60000.00, 101),
    -> (3, 'Charlie', 'Brown', 'charlie.brown@example.com', '777-888-9999', '2021-06-01', 'Sales Manager', 85000.00, 103),
    -> (4, 'Diana', 'Prince', 'diana.prince@example.com', '123-456-7890', '2022-02-10', 'Marketing Coordinator', 55000.00, 104),
    -> (5, 'Eve', 'Davis', 'eve.davis@example.com', '987-654-3210', '2018-09-01', 'Lead Engineer', 95000.00, 102),
    -> (6, 'Frank', 'White', 'frank.white@example.com', '111-333-5555', '2023-01-05', 'HR Assistant', 45000.00, 101);
Query OK, 6 rows affected (0.01 sec)
Records: 6  Duplicates: 0  Warnings: 0

mysql>
mysql> -- Section 2: View Creation
mysql>
mysql> -- Drop existing views if they exist to ensure a clean run
mysql> DROP VIEW IF EXISTS EmployeeDetails;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> DROP VIEW IF EXISTS HighSalaryEmployees;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> DROP VIEW IF EXISTS DepartmentSalarySummary;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> DROP VIEW IF EXISTS EngineeringEmployees; -- For WITH CHECK OPTION example
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> DROP VIEW IF EXISTS PublicEmployeeInfo;   -- For security example
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql>
mysql> -- View 1: EmployeeDetails (Joining two tables)
mysql> -- This view combines information from the Employees and Departments tables to provide a comprehensive view of employee details including their department name.
mysql> CREATE VIEW EmployeeDetails AS
    -> SELECT
    ->     E.employee_id,
    ->     E.first_name,
    ->     E.last_name,
    ->     E.email,
    ->     E.phone_number,
    ->     E.hire_date,
    ->     E.job_id,
    ->     E.salary,
    ->     D.department_name
    -> FROM
    ->     Employees AS E
    -> JOIN
    ->     Departments AS D ON E.department_id = D.department_id;
Query OK, 0 rows affected (0.01 sec)

mysql>
mysql> -- View 2: HighSalaryEmployees (Filtering and Abstraction)
mysql> -- This view shows employees earning more than a certain salary, abstracting away the filtering logic from the end-user.
mysql> CREATE VIEW HighSalaryEmployees AS
    -> SELECT
    ->     employee_id,
    ->     first_name,
    ->     last_name,
    ->     job_id,
    ->     salary
    -> FROM
    ->     Employees
    -> WHERE
    ->     salary > 70000.00;
Query OK, 0 rows affected (0.01 sec)

mysql>
mysql> -- View 3: DepartmentSalarySummary (Aggregation)
mysql> -- This view provides a summary of total and average salaries per department, demonstrating the use of aggregate functions.
mysql> CREATE VIEW DepartmentSalarySummary AS
    -> SELECT
    ->     D.department_name,
    ->     COUNT(E.employee_id) AS total_employees,
    ->     SUM(E.salary) AS total_salary,
    ->     AVG(E.salary) AS average_salary
    -> FROM
    ->     Departments AS D
    -> LEFT JOIN
    ->     Employees AS E ON D.department_id = E.department_id
    -> GROUP BY
    ->     D.department_name;
Query OK, 0 rows affected (0.01 sec)

mysql>
mysql> -- View for security example (showing column-level security)
mysql> -- Assumes 'SSN' might exist in a real Employees table for demonstration
mysql> CREATE VIEW PublicEmployeeInfo AS
    -> SELECT
    ->     employee_id,
    ->     first_name,
    ->     last_name,
    ->     email,
    ->     phone_number
    -> FROM
    ->     Employees;
Query OK, 0 rows affected (0.00 sec)

mysql>
mysql> -- View for WITH CHECK OPTION example
mysql> CREATE VIEW EngineeringEmployees AS
    -> SELECT
    ->     employee_id,
    ->     first_name,
    ->     last_name,
    ->     department_id
    -> FROM
    ->     Employees
    -> WHERE
    ->     department_id = 102 -- Engineering Department
    -> WITH CHECK OPTION;
Query OK, 0 rows affected (0.00 sec)

mysql>
mysql>
mysql> -- Section 3: View Usage Examples
mysql>
mysql> -- Usage 1: Select all data from EmployeeDetails view
mysql> SELECT * FROM EmployeeDetails;
+-------------+------------+-----------+---------------------------+--------------+------------+-----------------------+----------+-----------------+
| employee_id | first_name | last_name | email                     | phone_number | hire_date  | job_id                | salary   | department_name |
+-------------+------------+-----------+---------------------------+--------------+------------+-----------------------+----------+-----------------+
|           2 | Bob        | Johnson   | bob.johnson@example.com   | 444-555-6666 | 2019-03-20 | HR Specialist         | 60000.00 | Human Resources |
|           6 | Frank      | White     | frank.white@example.com   | 111-333-5555 | 2023-01-05 | HR Assistant          | 45000.00 | Human Resources |
|           1 | Alice      | Smith     | alice.smith@example.com   | 111-222-3333 | 2020-01-15 | Software Engineer     | 75000.00 | Engineering     |
|           5 | Eve        | Davis     | eve.davis@example.com     | 987-654-3210 | 2018-09-01 | Lead Engineer         | 95000.00 | Engineering     |
|           3 | Charlie    | Brown     | charlie.brown@example.com | 777-888-9999 | 2021-06-01 | Sales Manager         | 85000.00 | Sales           |
|           4 | Diana      | Prince    | diana.prince@example.com  | 123-456-7890 | 2022-02-10 | Marketing Coordinator | 55000.00 | Marketing       |
+-------------+------------+-----------+---------------------------+--------------+------------+-----------------------+----------+-----------------+
6 rows in set (0.01 sec)

mysql>
mysql> -- Usage 2: Select specific columns from HighSalaryEmployees view, ordered by salary
mysql> SELECT first_name, last_name, salary FROM HighSalaryEmployees ORDER BY salary DESC;
+------------+-----------+----------+
| first_name | last_name | salary   |
+------------+-----------+----------+
| Eve        | Davis     | 95000.00 |
| Charlie    | Brown     | 85000.00 |
| Alice      | Smith     | 75000.00 |
+------------+-----------+----------+
3 rows in set (0.00 sec)

mysql>
mysql> -- Usage 3: Select all data from DepartmentSalarySummary view
mysql> SELECT department_name, total_employees, average_salary FROM DepartmentSalarySummary;
+-----------------+-----------------+----------------+
| department_name | total_employees | average_salary |
+-----------------+-----------------+----------------+
| Human Resources |               2 |   52500.000000 |
| Engineering     |               2 |   85000.000000 |
| Sales           |               1 |   85000.000000 |
| Marketing       |               1 |   55000.000000 |
+-----------------+-----------------+----------------+
4 rows in set (0.00 sec)

mysql>
mysql> -- Usage 4: Select data from the PublicEmployeeInfo view (demonstrating column-level security)
mysql> SELECT * FROM PublicEmployeeInfo;
+-------------+------------+-----------+---------------------------+--------------+
| employee_id | first_name | last_name | email                     | phone_number |
+-------------+------------+-----------+---------------------------+--------------+
|           1 | Alice      | Smith     | alice.smith@example.com   | 111-222-3333 |
|           2 | Bob        | Johnson   | bob.johnson@example.com   | 444-555-6666 |
|           3 | Charlie    | Brown     | charlie.brown@example.com | 777-888-9999 |
|           4 | Diana      | Prince    | diana.prince@example.com  | 123-456-7890 |
|           5 | Eve        | Davis     | eve.davis@example.com     | 987-654-3210 |
|           6 | Frank      | White     | frank.white@example.com   | 111-333-5555 |
+-------------+------------+-----------+---------------------------+--------------+
6 rows in set (0.00 sec)

mysql>
mysql> -- Usage 5: Demonstrate WITH CHECK OPTION (this INSERT will fail because department_id != 102)
mysql> -- Uncomment the following lines to test this. You will see an error.
mysql> -- INSERT INTO EngineeringEmployees (employee_id, first_name, last_name, department_id)
mysql> -- VALUES (7, 'New', 'Employee', 101);
mysql>
mysql> -- Usage 6: Demonstrate WITH CHECK OPTION (this INSERT will succeed because department_id = 102)
mysql> -- INSERT INTO EngineeringEmployees (employee_id, first_name, last_name, department_id)
mysql> -- VALUES (7, 'Valid', 'Engineer', 102);
mysql>
mysql> -- Usage 7: Query the EngineeringEmployees view after a valid insert (if performed)
mysql> -- SELECT * FROM EngineeringEmployees;
mysql>