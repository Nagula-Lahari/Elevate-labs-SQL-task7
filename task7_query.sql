-- SQL Developer Internship - Task 7: Creating Views
-- Complete Query Code

-- Section 1: Schema Setup and Sample Data Insertion

-- Drop existing tables if they exist to ensure a clean run
-- This is crucial for re-running the script without errors if tables already exist.
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;

-- Create Departments Table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

-- Insert sample data into Departments
INSERT INTO Departments (department_id, department_name) VALUES
(101, 'Human Resources'),
(102, 'Engineering'),
(103, 'Sales'),
(104, 'Marketing');

-- Create Employees Table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    hire_date DATE,
    job_id VARCHAR(50),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Insert sample data into Employees
INSERT INTO Employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, department_id) VALUES
(1, 'Alice', 'Smith', 'alice.smith@example.com', '111-222-3333', '2020-01-15', 'Software Engineer', 75000.00, 102),
(2, 'Bob', 'Johnson', 'bob.johnson@example.com', '444-555-6666', '2019-03-20', 'HR Specialist', 60000.00, 101),
(3, 'Charlie', 'Brown', 'charlie.brown@example.com', '777-888-9999', '2021-06-01', 'Sales Manager', 85000.00, 103),
(4, 'Diana', 'Prince', 'diana.prince@example.com', '123-456-7890', '2022-02-10', 'Marketing Coordinator', 55000.00, 104),
(5, 'Eve', 'Davis', 'eve.davis@example.com', '987-654-3210', '2018-09-01', 'Lead Engineer', 95000.00, 102),
(6, 'Frank', 'White', 'frank.white@example.com', '111-333-5555', '2023-01-05', 'HR Assistant', 45000.00, 101);

-- Section 2: View Creation

-- Drop existing views if they exist to ensure a clean run
-- This is important if you are re-running the script and views already exist.
DROP VIEW IF EXISTS EmployeeDetails;
DROP VIEW IF EXISTS HighSalaryEmployees;
DROP VIEW IF EXISTS DepartmentSalarySummary;
DROP VIEW IF EXISTS EngineeringEmployees; -- View used for WITH CHECK OPTION example
DROP VIEW IF EXISTS PublicEmployeeInfo;   -- View used for security example

-- View 1: EmployeeDetails (Joining two tables)
-- This view combines information from the Employees and Departments tables
-- to provide a comprehensive view of employee details including their department name.
CREATE VIEW EmployeeDetails AS
SELECT
    E.employee_id,
    E.first_name,
    E.last_name,
    E.email,
    E.phone_number,
    E.hire_date,
    E.job_id,
    E.salary,
    D.department_name
FROM
    Employees AS E
JOIN
    Departments AS D ON E.department_id = D.department_id;

-- View 2: HighSalaryEmployees (Filtering and Abstraction)
-- This view shows employees earning more than a certain salary,
-- abstracting away the filtering logic from the end-user.
CREATE VIEW HighSalaryEmployees AS
SELECT
    employee_id,
    first_name,
    last_name,
    job_id,
    salary
FROM
    Employees
WHERE
    salary > 70000.00;

-- View 3: DepartmentSalarySummary (Aggregation)
-- This view provides a summary of total and average salaries per department,
-- demonstrating the use of aggregate functions.
CREATE VIEW DepartmentSalarySummary AS
SELECT
    D.department_name,
    COUNT(E.employee_id) AS total_employees,
    SUM(E.salary) AS total_salary,
    AVG(E.salary) AS average_salary
FROM
    Departments AS D
LEFT JOIN
    Employees AS E ON D.department_id = E.department_id
GROUP BY
    D.department_name;

-- View for security example (showing column-level security)
-- This view exposes only non-sensitive employee information.
-- In a real scenario, you would grant SELECT privileges on this view,
-- not directly on the 'Employees' table, to users who don't need full access.
CREATE VIEW PublicEmployeeInfo AS
SELECT
    employee_id,
    first_name,
    last_name,
    email,
    phone_number
FROM
    Employees;

-- View for WITH CHECK OPTION example
-- This view restricts access to employees in department_id 102 (Engineering).
-- The WITH CHECK OPTION ensures that any INSERT or UPDATE operation
-- through this view must satisfy the WHERE clause (department_id = 102).
CREATE VIEW EngineeringEmployees AS
SELECT
    employee_id,
    first_name,
    last_name,
    department_id
FROM
    Employees
WHERE
    department_id = 102 -- Engineering Department
WITH CHECK OPTION;


-- Section 3: View Usage Examples

-- Usage 1: Select all data from EmployeeDetails view
-- This demonstrates how to query a view just like a regular table.
SELECT * FROM EmployeeDetails;

-- Usage 2: Select specific columns from HighSalaryEmployees view, ordered by salary
-- This shows filtering and ordering on a view.
SELECT first_name, last_name, salary FROM HighSalaryEmployees ORDER BY salary DESC;

-- Usage 3: Select all data from DepartmentSalarySummary view
-- This demonstrates querying a view that performs aggregations.
SELECT department_name, total_employees, average_salary FROM DepartmentSalarySummary;

-- Usage 4: Select data from the PublicEmployeeInfo view
-- This illustrates how a view can be used to provide a subset of columns,
-- enhancing data security by hiding sensitive information.
SELECT * FROM PublicEmployeeInfo;

-- Usage 5: Demonstrate WITH CHECK OPTION (this INSERT will fail because department_id != 102)
-- Uncomment the following lines to test this. You will receive an error
-- because the inserted row would not be visible through the EngineeringEmployees view.
-- INSERT INTO EngineeringEmployees (employee_id, first_name, last_name, department_id)
-- VALUES (7, 'New', 'Employee', 101);

-- Usage 6: Demonstrate WITH CHECK OPTION (this INSERT will succeed because department_id = 102)
-- Uncomment the following lines to test this. This insert will work as it conforms
-- to the view's WHERE clause.
-- INSERT INTO EngineeringEmployees (employee_id, first_name, last_name, department_id)
-- VALUES (7, 'Valid', 'Engineer', 102);

-- Usage 7: Query the EngineeringEmployees view after a valid insert (if performed)
-- This will show the newly inserted employee if the previous INSERT (Usage 6) was successful.
-- SELECT * FROM EngineeringEmployees;