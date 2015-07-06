-- Problem 1.	Write a SQL query to find the names and salaries of the employees that take 
--				the minimal salary in the company.

SELECT e.FirstName + ' ' + e.LastName AS [Full Name], e.Salary
FROM Employees e
Where e.Salary = (SELECT MIN(Salary) FROM Employees)


-- Problem 2.	Write a SQL query to find the names and salaries of the employees that have a salary 
--				that is up to 10% higher than the minimal salary for the company.

SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary <= (SELECT min(Salary) * 1.1 FROM Employees)
AND Salary > (SELECT min(Salary) FROM Employees)


-- Problem 3.	Write a SQL query to find the full name, salary and department of the employees 
--				that take the minimal salary in their department.

SELECT e.FirstName + ' ' + e.LastName AS [Full Name], e.Salary, d.Name
FROM Employees e JOIN Departments d 
	ON e.DepartmentID = d.DepartmentID
Where e.Salary = 
	(SELECT MIN(Salary) FROM Employees
	Where DepartmentID = e.DepartmentID)


-- Problem 4.	Write a SQL query to find the average salary in the department #1.

SELECT AVG(e.Salary) AS [Average Salary]
FROM Employees e
WHERE e.DepartmentID = 1


-- Problem 5.	Write a SQL query to find the average salary in the "Sales" department.

SELECT AVG(e.Salary) AS [Average Salary]
FROM Employees e JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'


-- Problem 6.	Write a SQL query to find the number of employees in the "Sales" department.

SELECT COUNT(*) AS [Number of employees in with manager]
FROM Employees e JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'


-- Problem 7.	Write a SQL query to find the number of all employees that have manager.

SELECT COUNT(ManagerID) AS [Number of Employees with manager]
FROM Employees


-- Problem 8.	Write a SQL query to find the number of all employees that have no manager.

SELECT COUNT(*) AS [Number of Employees without manager]
FROM Employees e
WHERE e.ManagerID IS NULL


-- Problem 9.	Write a SQL query to find all departments and the average salary for each of them.

SELECT d.Name AS [Department], AVG(e.Salary) as [Average Salary]
FROM Employees e 
	JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name


-- Problem 10.	Write a SQL query to find the count of all employees in each department and for each town.

SELECT t.Name AS [Town], d.Name AS [Department], COUNT(e.EmployeeID) AS [Employees Count]
FROM Employees e 
	JOIN Departments d ON e.DepartmentID = d.DepartmentID
	JOIN Addresses a ON e.AddressID = a.AddressID
	JOIN Towns t ON a.TownID = t.TownID
GROUP BY t.Name, d.Name


-- Problem 11.	Write a SQL query to find all managers that have exactly 5 employees.

SELECT e.FirstName, e.LastName, COUNT(e.ManagerID) AS [Employees Count]
FROM Employees e 
	JOIN Employees m ON m.ManagerID = e.EmployeeID
GROUP BY e.FirstName, e.LastName
HAVING COUNT(e.ManagerID) = 5


-- Problem 12.	Write a SQL query to find all employees along with their managers.

SELECT 
	e.FirstName + ' ' + e.LastName AS [First Name],
	ISNULL(m.FirstName + ' ' + m.LastName, '(no manager)') AS [Manager]
FROM Employees e LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID
ORDER BY e.ManagerID


-- Problem 13.	Write a SQL query to find the names of all employees whose last name is exactly 
--				5 characters long. 

SELECT e.FirstName, e.LastName
FROM Employees e
WHERE LEN(e.LastName) = 5


-- Problem 14.	Write a SQL query to display the current date and time in the following format 
--				"day.month.year hour:minutes:seconds:milliseconds". 

SELECT CONVERT(varchar, GETDATE(), 113) AS [Current date and time]


-- Problem 15.	Write a SQL statement to create a table Users.
CREATE TABLE Users (
	Id int IDENTITY,
	Username nvarchar(20) NOT NULL,
	UserPassword nvarchar(30) NOT NULL,
	FullName nvarchar(50) NOT NULL,
	LastLogin dateTime
	CONSTRAINT PK_Users PRIMARY KEY(Id),
	CONSTRAINT AK_Username UNIQUE(Username),
	CONSTRAINT CHK_UserPassword CHECK (LEN(UserPassword) > 4)
)
GO


-- Problem 16.	Write a SQL statement to create a view that displays the users from the Users table 
--				that have been in the system today.

CREATE VIEW [Users from today] AS
SELECT *
FROM Users u
WHERE u.LastLogin = GETDATE();

GO


-- Problem 17.	Write a SQL statement to create a table Groups. 

CREATE TABLE Groups (
  Id int IDENTITY,
  Name nvarchar(50) NOT NULL,
  CONSTRAINT PK_Id PRIMARY KEY(Id),
  CONSTRAINT UK_Name UNIQUE(Name))

GO


-- Problem 18.	Write a SQL statement to add a column GroupID to the table Users.

ALTER TABLE Users ADD GroupId int

ALTER TABLE Users
ADD CONSTRAINT FK_UsersId FOREIGN KEY (GroupId)
    REFERENCES Groups(id);


-- Problem 19.	Write SQL statements to insert several records in the Users and Groups tables.

INSERT INTO Groups(Name)
	VALUES ('Administrators'), ('Users'), ('Moder')

INSERT INTO Users(Username, UserPassword, FullName, GroupId)
VALUES 
	('Kokicha', '12345', 'Konstantin', 2),
	('TheBlackMamba', '123456', 'Mango', 3),
	('Tsoketo', '4444444', 'Kostadin Dimitorv', 3),
	('Micha', '22211', 'Maria Marinova', 3),
	('Remcho', '12321', 'Remi Bobev', 3),
	('Ochite', '1234567', 'Mitio Ochite', 2),
	('Nafarforii', '11111', 'Navri', 3)


-- Problem 20.	Write SQL statements to update some of the records in the Users and Groups tables.

UPDATE Users
SET  Username = 'Kondio', FullName = 'Kondio Storaro'
WHERE Username = 'Nafarforii';

UPDATE Groups
SET  Name = 'Moderators'
WHERE Name = 'Moder';


-- Problem 21.	Write SQL statements to delete some of the records from the Users and Groups tables.

DELETE FROM Users
WHERE Username = 'Kondio'

DELETE FROM Groups
WHERE Name = 'Moderators'


-- Problem 22.	Write SQL statements to insert in the Users table the names of all employees from 
--				the Employees table.

INSERT INTO Users(Username, UserPassword ,FullName)
SELECT 
	LOWER(SUBSTRING(e.FirstName, 1, 3) + e.LastName), 
	LOWER(SUBSTRING(e.FirstName, 1, 3) + e.LastName),
	e.FirstName + ' ' + e.LastName 
FROM Employees e


-- Problem 23.	Write a SQL statement that changes the password to NULL for all users that have not 
--				been in the system since 10.03.2010.

UPDATE Users
SET LastLogin = NULL
WHERE LastLogin < '10-03-2010'


-- Problem 24.	Write a SQL statement that deletes all users without passwords (NULL password).

DELETE Users
WHERE UserPassword IS NULL


-- Problem 25.	Write a SQL query to display the average employee salary by department and job title.

SELECT d.Name, e.JobTitle, AVG(e.Salary) AS [Average Salary]
FROM Employees e 
	JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name, e.JobTitle


-- Problem 26.	Write a SQL query to display the minimal employee salary by department and job title 
--				along with the name of some of the employees that take it.

SELECT d.Name, e.JobTitle, MIN(e.FirstName), MIN(e.Salary) AS [Min Salary]
FROM Employees e 
	JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name, e.JobTitle
ORDER BY d.Name


-- Problem 27.	Write a SQL query to display the town where maximal number of employees work.

SELECT TOP 1 t.Name, COUNT(t.TownID) AS [Number of employees]
FROM Employees e
	JOIN Addresses a ON e.AddressID = a.AddressID
	JOIN Towns t ON a.TownID = t.TownID
GROUP BY t.TownID, t.Name
ORDER BY [Number of employees] DESC


-- Problem 28.	Write a SQL query to display the number of managers from each town.

SELECT t.Name AS [Town], COUNT(t.TownID) AS [Number of managers]
FROM Employees e
	JOIN Addresses a ON e.AddressID = a.AddressID
	JOIN Towns t ON a.TownID = t.TownID
WHERE e.EmployeeID IN (
	SELECT ManagerID FROM Employees
)
GROUP BY t.TownID, t.Name
ORDER BY t.Name


--Problem 29.	Write a SQL to create table WorkHours to store work reports for each employee.
--				Each employee should have id, date, task, hours and comments. Don't forget to define 
--				identity, primary key and appropriate foreign key.

CREATE TABLE WorkHours (
	Id int IDENTITY,
	EmployeeID int NOT NULL,
	[Date] dateTime NULL,
	Task nvarchar(200) NOT NULL,
	[Hours] int NOT NULL,
	Comments nvarchar(200) NULL,
	CONSTRAINT PK_WorkHours
		PRIMARY KEY(Id),
	CONSTRAINT FK_Employees_WorkHours 
		FOREIGN KEY(EmployeeID)
		REFERENCES Employees(EmployeeID)
)


--Problem 30.	Issue few SQL statements to insert, update and delete of some data in the table.

INSERT INTO WorkHours
VALUES 
	(10, '12-5-2015', 'Do your homework', 2, 'I promise!'),
	(55, '10-2-2015', 'Fix your computer', 10, 'I dont know how.'),
	(7, '5-4-2014', 'Bring to beers to my office', 1, 'What brand?'),
	(13, '11-1-2013', 'Help me', 24, 'How?'),
	(122, '4-10-2015', 'Go to Berlin', 108, 'I am on my way.')

UPDATE WorkHours
SET Comments = 'Your time is ticking away'
WHERE Task = 'Do your homework' AND [Hours] = 2

DELETE FROM WorkHours
WHERE Task = 'Help me' AND [Hours] = 24


--Problem 31.	Define a table WorkHoursLogs to track all changes in the WorkHours table with triggers.
--				For each change keep the old record data, the new record data and the command 
--				(insert / update / delete).

CREATE TABLE WorkHoursLogs (
	Id int IDENTITY PRIMARY KEY,
	OldEmployeeId int,
	NewEmployeeId int,
	OldDate datetime,
	NewDate datetime,
	OldTask nvarchar(50),
	NewTask nvarchar(50),
	OldHours int,
	NewHours int,
	OldComments nvarchar(50),
	NewComments nvarchar(50),
	Command nvarchar(10) NOT NULL
)
GO


CREATE TRIGGER tr_WorkHoursChange ON WorkHours FOR INSERT, UPDATE, DELETE
AS
	DECLARE 
		@oldEmployeeId int = (SELECT Id FROM deleted),
		@newEmployeeId int = (SELECT Id FROM inserted),
		@oldDate datetime = (SELECT Date FROM deleted),
		@newDate datetime = (SELECT Date FROM inserted),
		@oldTask nvarchar(200) = (SELECT Task FROM deleted),
		@newTask nvarchar(200) = (SELECT Task FROM inserted),
		@oldHours int = (SELECT Hours FROM deleted),
		@newHours int = (SELECT Hours FROM inserted),
		@oldComments nvarchar(200) = (SELECT Comments FROM deleted),
		@newComments nvarchar(200) = (SELECT Comments FROM inserted),
		@command nvarchar(10),
		@deletedCount int,
		@insertedCount int;

	SELECT @deletedCount = COUNT(*) FROM deleted
	SELECT @insertedCount = COUNT(*) FROM inserted
	IF(@deletedCount & @insertedCount > 0)
		SET @command = 'UPDATE'
	ELSE IF(@insertedCount > 0)
		SET @command = 'INSERT'
	ELSE IF(@deletedCount > 0)
		SET @command = 'DELETE'

	INSERT INTO WorkHoursLogs(
		OldEmployeeId,
		NewEmployeeId,
		OldDate,
		NewDate,
		OldTask,
		NewTask,
		OldHours,
		NewHours,
		OldComments,
		NewComments,
		Command)
	VALUES 
		(@oldEmployeeId,
		@newEmployeeId,
		@oldDate,
		@newDate,
		@oldTask,
		@newTask,
		@oldHours,
		@newHours,
		@oldComments,
		@newComments,
		@command)
GO


--Problem 32.	Start a database transaction, delete all employees from the 'Sales' department along 
--				with all dependent records from the pother tables. At the end rollback the transaction.

BEGIN TRAN
DELETE Employees
FROM Employees e 
	JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'
ROLLBACK TRAN


--Problem 33.	Start a database transaction and drop the table EmployeesProjects.

BEGIN TRAN
DROP TABLE EmployeesProjects
ROLLBACK TRAN

--Problem 34.	Find how to use temporary tables in SQL Server.
--				Using temporary tables backup all records from EmployeesProjects and restore them back 
--				after dropping and re-creating the table.

USE SoftUni
GO

CREATE TABLE #EmployeesProjects (
	EmployeeID INT NOT NULL,
	ProjectID INT NOT NULL,
	CONSTRAINT PK_EmployeesProjects
		PRIMARY KEY CLUSTERED (EmployeeID, ProjectID),
	CONSTRAINT FK_EmployeesProjects_Employees
		FOREIGN KEY(EmployeeID) REFERENCES Employees(EmployeeID),
	CONSTRAINT FK_EmployeesProjects_Projects
		FOREIGN KEY(ProjectID) REFERENCES Projects(ProjectID)
)
GO

INSERT INTO #EmployeesProjects(EmployeeID, ProjectID) SELECT * FROM EmployeesProjects

TRUNCATE TABLE EmployeesProjects
GO

INSERT INTO EmployeesProjects(EmployeeID, ProjectID) SELECT * FROM #EmployeesProjects
GO