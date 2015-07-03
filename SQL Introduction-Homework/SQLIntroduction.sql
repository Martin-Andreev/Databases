USE SoftUni

--4.Write a SQL query to find all information about all departments (use "SoftUni" database).
SELECT * FROM Departments


GO
--5.Write a SQL query to find all department names.
SELECT Name
FROM Departments


GO
--6.Write a SQL query to find the salary of each employee. 
SELECT Salary
FROM Employees


GO
--7.Write a SQL to find the full name of each employee. 
SELECT FirstName + ' ' + LastName AS FullName
FROM Employees


GO
--8.Write a SQL query to find the email addresses of each employee.
SELECT e.FirstName + '.' + e.LastName + '@softuni.bg' AS [Full Email Addresses]
FROM Employees e


GO
--Problem 9.	Write a SQL query to find all different employee salaries. 
SELECT DISTINCT Salary
FROM Employees

GO
--10.Write a SQL query to find all information about the employees whose job title is “Sales Representative“.
SELECT *
FROM Employees
WHERE JobTitle = 'Sales Representative'


GO
--11.Write a SQL query to find the names of all employees whose first name starts with "SA".
SELECT e.FirstName + ' ' + e.LastName AS [Full Name]
FROM Employees e
WHERE e.FirstName LIKE 'SA%'


GO
--12.Write a SQL query to find the names of all employees whose last name contains "ei".
SELECT e.FirstName + ' ' + e.LastName AS [Full Name]
FROM Employees e
WHERE e.LastName LIKE '%ei%'


GO
--13.Write a SQL query to find the salary of all employees whose salary is in the range [20000…30000].
SELECT e.FirstName + ' ' + e.LastName AS [Full Name], e.Salary
FROM Employees e
WHERE e.Salary BETWEEN 20000 AND 30000


GO
--14.Write a SQL query to find the names of all employees whose salary is 25000, 14000, 12500 or 23600.
SELECT e.FirstName + ' ' + e.LastName AS [Full Name], e.Salary
FROM Employees e
WHERE e.Salary IN (25000, 14000, 12500, 23600)


GO
--15.Write a SQL query to find all employees that do not have manager.
SELECT e.FirstName + ' ' + e.LastName AS [Full Name], m.FirstName + ' ' + m.LastName as [Manager]
FROM Employees e
LEFT JOIN Employees m
	ON e.ManagerID = m.EmployeeID
WHERE e.ManagerID IS NULL


GO
--16.Write a SQL query to find all employees that have salary more than 50000. Order them in decreasing order by salary.
SELECT e.FirstName + ' ' + e.LastName AS [Full Name], e.Salary
FROM Employees e
WHERE e.Salary > 50000
ORDER By e.Salary DESC


GO
--17.Write a SQL query to find the top 5 best paid employees.
SELECT TOP 5 e.FirstName + ' ' + e.LastName AS [Full Name], e.Salary
FROM Employees e
ORDER BY e.Salary DESC


GO
--18.Write a SQL query to find all employees along with their address.
SELECT e.FirstName + ' ' + e.LastName AS [Full Name], a.AddressText
FROM Employees e
JOIN Addresses a
	ON e.AddressID = a.AddressID


GO
--19.Write a SQL query to find all employees along with their manager.
SELECT e.FirstName + ' ' + e.LastName AS [Full Name], a.AddressText
FROM Employees e, Addresses a
WHERE e.AddressID = a.AddressID


GO
--20.Write a SQL query to find all employees along with their manager.
SELECT e.FirstName + ' ' + e.LastName AS [Full Name], m.FirstName + ' ' + m.LastName AS [Manager]
FROM Employees e
LEFT JOIN Employees m
	ON e.ManagerID = m.EmployeeID



GO
--21.Write a SQL query to find all employees, along with their manager and their address.
SELECT e.FirstName + ' ' + e.LastName AS [Full Name], m.FirstName + ' ' + m.LastName AS [Manager], a.AddressText 
FROM Employees e
LEFT JOIN Employees m
	ON e.ManagerID = m.EmployeeID
JOIN Addresses a
	ON e.AddressID = a.AddressID


GO
--22.Write a SQL query to find all departments and all town names as a single list.
SELECT d.Name 
FROM Departments d
UNION
SELECT t.Name 
FROM Towns t


GO
--23.Write a SQL query to find all the employees and the manager for each of them along with the employees that do not have manager. 
SELECT e.FirstName + ' ' + e.LastName AS [Full Name], m.FirstName + ' ' + m.LastName AS [Manager]
FROM Employees e
RIGHT OUTER JOIN Employees m
	ON e.ManagerID = m.EmployeeID

GO
--24.Write a SQL query to find the names of all employees from the departments "Sales" and "Finance" whose hire year is between 1995 and 2005.
SELECT e.FirstName + ' ' + e.LastName AS [Employee Name],
	e.HireDate,
	d.Name
FROM Employees e
INNER JOIN Departments d
ON e.DepartmentID = d.DepartmentID
WHERE d.Name IN ('Sales', 'Finance') AND e.HireDate BETWEEN '1995-1-1' AND '2005-12-31'
ORDER BY e.HireDate ASC