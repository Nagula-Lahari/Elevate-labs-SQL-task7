
# SQL Developer Internship - Task 7: Creating Views

## Objective

This task focuses on learning to create and effectively use SQL views. The primary goals are to understand how views simplify complex queries, provide data abstraction, and enhance security within a database.

## Tools Used
* **MySQL Workbench**

## Deliverables

This repository contains:

1.  **SQL View Definitions:** The `CREATE VIEW` statements for various scenarios, demonstrating complex `SELECT` queries.
2.  **SQL View Usage Examples:** `SELECT` statements that illustrate how to query and leverage the created views.
3.  **Interview Questions and Answers:** Comprehensive answers to common interview questions related to SQL views.
4.  **Complete Query Code:** A single `.sql` file containing all necessary SQL commands for schema setup, data insertion, view creation, and usage examples.

---

## 1. Database Setup and Sample Data

To facilitate the demonstration of views, a sample database schema (`Departments` and `Employees` tables) is set up, and sample data is inserted.

The full SQL script for setup, data, and views is available in `complete_query_code.sql`.

```sql
-- Schema Setup for demonstration purposes

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
````

-----

## 2\. View Definitions

Here are the definitions of various views, demonstrating different use cases:

### View 1: `EmployeeDetails` (Joining two tables)

This view combines employee information with their respective department names, providing a consolidated view of employee details.

```sql
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
```

### View 2: `HighSalaryEmployees` (Filtering and Abstraction)

This view isolates employees with a salary greater than $70,000, abstracting the filtering logic from subsequent queries.

```sql
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
```

### View 3: `DepartmentSalarySummary` (Aggregation)

This view provides a summarized look at total and average salaries per department, demonstrating the use of aggregate functions within a view.

```sql
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
```

### View for Security Example: `PublicEmployeeInfo` (Column-Level Security)

This view demonstrates how to restrict column access. If the `Employees` table contained sensitive columns (e.g., SSN), this view would omit them, providing only public information.

```sql
CREATE VIEW PublicEmployeeInfo AS
SELECT
    employee_id,
    first_name,
    last_name,
    email,
    phone_number
FROM
    Employees;
```

### View for `WITH CHECK OPTION` Example: `EngineeringEmployees`

This view filters employees by `department_id = 102` (Engineering). The `WITH CHECK OPTION` ensures that any `INSERT` or `UPDATE` operation performed through this view adheres to this `WHERE` clause.

```sql
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
```

-----

## 3\. Usage Examples

Views can be queried just like regular tables, offering a simplified interface to complex data.

### Querying `EmployeeDetails` View:

```sql
SELECT * FROM EmployeeDetails;
```

**Expected Output (Example):**
| employee\_id | first\_name | last\_name | email | phone\_number | hire\_date | job\_id | salary | department\_name |
|-------------|------------|-----------|-------|--------------|-----------|--------|--------|-----------------|
| 1           | Alice      | Smith     | alice.smith@example.com | 111-222-3333 | 2020-01-15 | Software Engineer | 75000.00 | Engineering |
| 2           | Bob        | Johnson   | bob.johnson@example.com | 444-555-6666 | 2019-03-20 | HR Specialist | 60000.00 | Human Resources |
| ...         | ...        | ...       | ...   | ...          | ...       | ...    | ...    | ...             |

### Querying `HighSalaryEmployees` View:

```sql
SELECT first_name, last_name, salary FROM HighSalaryEmployees ORDER BY salary DESC;
```

**Expected Output (Example):**
| first\_name | last\_name | salary |
|------------|-----------|--------|
| Eve        | Davis     | 95000.00 |
| Charlie    | Brown     | 85000.00 |
| Alice      | Smith     | 75000.00 |

### Querying `DepartmentSalarySummary` View:

```sql
SELECT department_name, total_employees, average_salary FROM DepartmentSalarySummary;
```

**Expected Output (Example):**
| department\_name | total\_employees | average\_salary |
|-----------------|-----------------|----------------|
| Human Resources | 2               | 52500.00       |
| Engineering     | 2               | 85000.00       |
| Sales           | 1               | 85000.00       |
| Marketing       | 1               | 55000.00       |

### Demonstrating `WITH CHECK OPTION`:

Attempting to `INSERT` a row into `EngineeringEmployees` that does not meet the `WHERE` clause condition (`department_id = 102`) will result in an error.

```sql
-- This INSERT will FAIL due to WITH CHECK OPTION
-- INSERT INTO EngineeringEmployees (employee_id, first_name, last_name, department_id)
-- VALUES (7, 'New', 'Employee', 101);

-- This INSERT will SUCCEED as it meets the condition
-- INSERT INTO EngineeringEmployees (employee_id, first_name, last_name, department_id)
-- VALUES (7, 'Valid', 'Engineer', 102);

-- Querying the view after a valid insert (if performed)
-- SELECT * FROM EngineeringEmployees;
```

-----

## 4\. Interview Questions

### 1\. What is a view?

A view is a virtual table based on the result-set of a SQL query. It does not store data itself but instead derives its data from one or more underlying base tables each time it is accessed. Views are stored as a `SELECT` statement within the database's metadata.

### 2\. Can we update data through a view?

It is conditionally possible. You can `UPDATE`, `INSERT`, or `DELETE` data through a view if:

  * The view is based on a **single base table**.
  * The view includes the **primary key** of the base table.
  * The view **does not** contain `DISTINCT`, aggregate functions (`SUM`, `AVG`, `COUNT`, etc.), `GROUP BY`, `HAVING`, `UNION`, or `UNION ALL`.
  * Calculated columns or expressions are **not updatable**.
  * Views involving `JOIN` operations are generally **not updatable**.

If these conditions are not met, DML operations on the view will typically result in an error.

### 3\. What is a materialized view?

A materialized view (also known as an indexed view in SQL Server or a snapshot in Oracle) is a physical copy of the data resulting from a query, stored on disk. Unlike a regular view, which is executed every time it's queried, a materialized view pre-computes and stores the result set. This significantly improves query performance for complex operations (like heavy aggregations or joins) at the cost of requiring periodic refreshing to reflect changes in the underlying base tables.

### 4\. Difference between view and table?

| Feature         | Table                                       | View                                          |
| :-------------- | :------------------------------------------ | :-------------------------------------------- |
| **Storage** | Stores actual data persistently on disk.    | Does not store data; it's a virtual representation. |
| **Existence** | A physical entity in the database schema.   | A logical entity, a stored query.             |
| **Data Source** | An independent data container.             | Derives its data from one or more base tables. |
| **Performance** | Generally faster for direct data access.    | Can incur performance overhead due to on-the-fly execution, but can simplify complex queries. |
| **Manipulation**| Directly supports DML (INSERT, UPDATE, DELETE). | DML operations are restricted and often not possible. |
| **Indexing** | Can be indexed directly to improve query speed. | Cannot be indexed directly (except for materialized/indexed views in some systems). |

### 5\. How to drop a view?

To remove a view from the database, use the `DROP VIEW` statement followed by the view's name:

```sql
DROP VIEW ViewName;
```

**Example:**

```sql
DROP VIEW EmployeeDetails;
```

### 6\. Why use views?

Views are used for several important reasons in database management:

  * **Abstraction and Simplification:** They hide the complexity of underlying table structures, joins, and calculations, presenting a simplified and user-friendly data model.
  * **Security:** Views can restrict access to specific rows (using `WHERE` clauses for row-level security) or columns (by selecting only non-sensitive columns for column-level security), preventing unauthorized users from viewing sensitive data.
  * **Data Consistency:** By encapsulating complex business logic or common queries within a view, they ensure that all applications and users retrieve data consistently using the same defined logic.
  * **Backward Compatibility:** If the underlying table schema changes, a view can be redefined to maintain the original interface for applications, minimizing disruption.
  * **Reusable SQL Logic:** Complex and frequently used `SELECT` statements can be saved as views and reused without rewriting the entire query each time.

### 7\. Can we create indexed views?

Yes, some advanced database systems like SQL Server (called "indexed views") and Oracle/PostgreSQL (called "materialized views") allow the creation of views that are physically stored and indexed. This significantly boosts performance for queries against these views, especially for complex aggregations or joins, as the data is pre-computed and indexed. Standard SQL, SQLite, and MySQL's default setup do not support true indexed views in the same manner.

### 8\. How to secure data using views?

Views are a powerful tool for implementing data security:

  * **Column-Level Security:** By omitting sensitive columns (e.g., `salary`, `SSN`) from the view definition, you can prevent users who only have `SELECT` access to the view from ever seeing that confidential data.
  * **Row-Level Security:** A `WHERE` clause in the view definition can restrict users to seeing only relevant subsets of data (e.g., `WHERE department_id = user_department_id`), implementing row-level security.
  * **Hiding Schema Complexity:** Users only need to interact with the view, without requiring direct access to or knowledge of the intricate underlying table structure, thus reducing the attack surface.

### 9\. What are limitations of views?

  * **Performance Overhead:** For complex views, the database must execute the underlying `SELECT` query every time the view is accessed, which can lead to performance degradation compared to directly querying base tables.
  * **Updatability Restrictions:** Many views are not directly updatable, especially those involving multiple tables, aggregate functions, `DISTINCT`, etc.
  * **Dependency Issues:** Views are dependent on their underlying base tables. If columns are renamed or dropped, or tables are altered in incompatible ways, the view can become invalid.
  * **Debugging Complexity:** Debugging issues that arise when querying complex views can be challenging, as the problem might lie within the view's definition or in the base tables it references.
  * **No Direct Indexing (usually):** Regular views cannot be directly indexed, which limits performance optimization strategies available for base tables (except for materialized/indexed views in specific DBMS).

### 10\. How does WITH CHECK OPTION work?

The `WITH CHECK OPTION` clause, used in a `CREATE VIEW` or `ALTER VIEW` statement, enforces that all `INSERT` and `UPDATE` operations performed through the view must conform to the conditions (the `WHERE` clause) defined in the view's query.

If an attempt is made to insert or update a row through the view such that the modified row would no longer satisfy the view's `WHERE` clause (and thus would not be visible through the view), the operation will be rejected with an error. This ensures data integrity and consistency within the view's defined scope.

**Example:** If a view `Managers` is defined with `WHERE job_title = 'Manager' WITH CHECK OPTION`, you cannot update a manager's `job_title` through this view to something other than 'Manager'. You also cannot insert a new employee through this view with a `job_title` other than 'Manager'.

-----

## Key Concepts

  * **Views:** Virtual tables that provide a logical representation of data without storing it, simplifying data access and enhancing security.
  * **Data Abstraction:** The process of hiding complex underlying details and presenting a simpler, more manageable interface. Views are a prime example of data abstraction in SQL, as they allow users to interact with a simplified data model without needing to understand the intricacies of the base tables and their relationships.

