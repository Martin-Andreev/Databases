-- Problem 1.	Create a database with two tables.
--				Persons (id (PK), first name, last name, SSN) and Accounts (id (PK), person id (FK), 
--				balance). Insert few records for testing. Write a stored procedure that selects 
--				the full names of all persons.

CREATE TABLE Persons(
	Id int IDENTITY,
	FirstName nvarchar(50) NOT NULL,
	LastName nvarchar(50) NOT NULL,
	SSN nvarchar(10) NOT NULL
	CONSTRAINT PK_Persons 
		PRIMARY KEY(Id)
)

CREATE TABLE Accounts(
	Id int IDENTITY,
	PersonId int NOT NULL,
	Balance int
	CONSTRAINT PK_Accounts 
		PRIMARY KEY(Id),
	CONSTRAINT FK_Accounts 
		FOREIGN KEY(PersonId)
		REFERENCES Persons(Id)
)

INSERT INTO Persons
VALUES 
	('Susan', 'Kaneva', '192191231'),
	('Kim', 'Kardashian', '123456789'),
	('Jimmy', 'Coners', '9876543221')

INSERT INTO Accounts
VALUES
	(1, 100),
	(2, 2000),
	(3, 10500)

USE [Bank Accounts]
GO

CREATE PROC dbo.usp_SelectPersonsFullName
AS
	SELECT FirstName + ' ' + LastName AS [FullName]
	FROM Persons
GO

EXEC usp_SelectPersonsFullName


-- Problem 2.	Create a stored procedure
--				Your task is to create a stored procedure that accepts a number as a parameter and 
--				returns all persons who have more money in their accounts than the supplied number.

USE [Bank Accounts]
GO

CREATE PROC dbo.usp_SelectPersonsByAccountBalance(@minBalance int)
AS
	SELECT p.FirstName + ' ' + p.LastName AS [FullName], a.Balance AS Balance
	FROM Accounts a
	JOIN Persons p ON a.PersonId = p.Id
	WHERE a.Balance > @minBalance 
GO

EXEC dbo.usp_SelectPersonsByAccountBalance 50


--Problem 3.	Create a function with parameters
--				Your task is to create a function that accepts as parameters – sum, yearly interest rate 
--				and number of months. It should calculate and return the new sum. Write a SELECT to test
--				whether the function works as expected.

USE [Bank Accounts]
GO

CREATE FUNCTION ufn_CalculateInterest(@sum money, @yearlyInteresRate float, @numberOfMonths int) RETURNS money
AS
BEGIN
	DECLARE @newSum money
	SELECT @newSum = @sum * (1 + ((@yearlyInteresRate * @numberOfMonths) / 100))
	RETURN @newSum
END
GO


DECLARE @sum money 

SELECT @sum = a.Balance
FROM Accounts a
JOIN Persons p ON A.PersonId = p.Id
WHERE p.FirstName = 'Susan'

DECLARE @newSum money
EXEC @newSum = ufn_CalculateInterest @sum, 5, 12
SELECT @newSum


--Problem 4.	Create a stored procedure that uses the function from the previous example
--				Your task is to create a stored procedure that uses the function from the previous 
--				example to give an interest to a person's account for one month. It should take the 
--				AccountId and the interest rate as parameters.

USE [Bank Accounts]
GO

CREATE PROC dbo.usp_PersonsInterestForMonth(@accountId int, @interestRate float)
AS
	DECLARE @currentBalance money
	DECLARE @newSum money
	DECLARE @numberOfMonths int = 1

	SELECT @currentBalance = a.Balance
	FROM Accounts a
	WHERE a.Id = @accountId

	EXEC @newSum = ufn_CalculateInterest @currentBalance, @interestRate, @numberOfMonths
	RETURN @newSum
GO

DECLARE @sum money
EXEC @sum = usp_PersonsInterestForMonth 2, 5
SELECT @sum


--Problem 5.	Add two more stored procedures WithdrawMoney and DepositMoney.
--				Add two more stored procedures WithdrawMoney (AccountId, money) and DepositMoney 
--				(AccountId, money) that operate in transactions.

USE [Bank Accounts]
GO

CREATE PROC dbo.usp_WithdrawMoney(@accountId int, @money money)
AS
BEGIN TRAN
	DECLARE @oldAmount MONEY =
		(SELECT Balance FROM Accounts WHERE Id = @accountId)
	IF (@oldAmount < @Money)
		BEGIN
			ROLLBACK TRANSACTION;
			RAISERROR('Not enough money', 16, 1);
		END
	ELSE IF (@money <= 0)
		BEGIN
			ROLLBACK TRANSACTION;
			RAISERROR('Value must be positive', 16, 1);
		END
	ELSE
		BEGIN
			UPDATE Accounts
			SET Balance -= @money
			WHERE Id = @accountId
			COMMIT TRAN
		END
GO


CREATE PROC dbo.usp_DepositMoney(@accountId int, @money money)
AS
BEGIN TRAN
	DECLARE @oldAmount MONEY =
		(SELECT Balance FROM Accounts WHERE Id = @accountId)
	IF (@money <= 0)
		BEGIN
			ROLLBACK TRANSACTION;
			RAISERROR('Value must be positive', 16, 1);
		END
	ELSE
		BEGIN
			UPDATE Accounts
			SET Balance += @money
			WHERE Id = @accountId
			COMMIT TRAN
		END
GO


--Problem 6.	Create table Logs.
--				Create another table – Logs (LogID, AccountID, OldSum, NewSum). Add a trigger to 
--				the Accounts table that enters a new entry into the Logs table every time the sum 
--				on an account changes.

CREATE TABLE Logs(
	Id int IDENTITY PRIMARY KEY,
	AccountId int NOT NULL,
	OldSum money NOT NULL DEFAULT 0,
	NewSum money NOT NULL DEFAULT 0
	CONSTRAINT FK_Logs 
		FOREIGN KEY(AccountId)
		REFERENCES Accounts(Id)
)
GO

CREATE TRIGGER tr_AccountBalanceChange ON Accounts FOR UPDATE
AS
	INSERT INTO Logs(AccountId, OldSum, NewSum)
	SELECT d.Id, d.Balance, i.Balance
	FROM inserted i JOIN deleted d ON d.Id = i.Id
GO


--Problem 7.	Define function in the SoftUni database.
--				Define a function in the database SoftUni that returns all Employee's names (first or 
--				middle or last name) and all town's names that are comprised of given set of letters. 

--				Example: 'oistmiahf' will return 'Sofia', 'Smith', but not 'Rob' and 'Guy'.

CREATE FUNCTION ufn_CheckIfWordIsComprisedOfGivenLetters
(
	@inputWord nvarchar(MAX),
	@setOfletters nvarchar(MAX)
) 
RETURNS bit
AS
BEGIN
	DECLARE @wordLenght int = LEN(@inputWord);
	DECLARE @currentLetterIndex int = 1;
	DECLARE @lengthOfSubstringLetter int = 1;
	DECLARE @currentLetter nvarchar(1)
	
	WHILE @currentLetterIndex <= @wordLenght
	BEGIN
		SET @currentLetter = SUBSTRING(@inputWord, @currentLetterIndex, @lengthOfSubstringLetter)
		IF (@setOfletters NOT LIKE '%' + @currentLetter + '%')
		BEGIN
			RETURN 0
		END
		SET @currentLetterIndex += 1;
	END

	RETURN 1
END
GO

DECLARE @setOfLetters nvarchar(MAX) = 'oistmiahf' 

SELECT e.FirstName, e.MiddleName, e.LastName, t.Name
FROM Employees e
	JOIN Addresses a ON e.AddressID = a.AddressID
	JOIN Towns t ON a.TownID = t.TownID
WHERE ( 
	dbo.ufn_CheckIfWordIsComprisedOfGivenLetters(t.Name, @setOfLetters) = 1 OR
	dbo.ufn_CheckIfWordIsComprisedOfGivenLetters(e.FirstName, @setOfLetters) = 1 OR
	dbo.ufn_CheckIfWordIsComprisedOfGivenLetters(e.MiddleName, @setOfLetters) = 1 OR
	dbo.ufn_CheckIfWordIsComprisedOfGivenLetters(e.LastName, @setOfLetters) = 1)


--Problem 8.	Using database cursor write a T-SQL
--				Using database cursor write a T-SQL script that scans all employees and their addresses 
--				and prints all pairs of employees that live in the same town.

DECLARE employeePairs CURSOR READ_ONLY FOR
	SELECT e.FirstName + ' ' + e.LastName AS [FirstEmployeName], t.Name AS [TownName], e2.FirstName + ' ' + e2.LastName AS [SecondEmployeeName]
	FROM Employees e
		CROSS JOIN Employees e2
		JOIN Addresses a
			ON a.AddressID = e.AddressID
		JOIN Addresses a2
			ON a2.AddressID = e2.AddressID
		JOIN Towns t
			ON a.TownID = t.TownID
		JOIN Towns t2
			ON a2.TownID = t2.TownID
	WHERE t.TownID = t2.TownID AND e2.EmployeeID != e.EmployeeID

OPEN employeePairs
DECLARE @firstEmployee nvarchar(100), @town nvarchar(50), @secondEmployee nvarchar(100)
FETCH NEXT FROM employeePairs 
INTO @firstEmployee, @town, @secondEmployee

WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT @firstEmployee + ' ' + @town + ' ' + @secondEmployee
		FETCH NEXT FROM employeePairs
		INTO @firstEmployee, @town, @secondEmployee
	END

CLOSE employeePairs
DEALLOCATE employeePairs

--Problem 9.	Define a .NET aggregate function
--				Define a .NET aggregate function StrConcat that takes as input a sequence of strings 
--				and return a single string that consists of the input strings separated by ','

DECLARE @name nvarchar(MAX);

SELECT @name = CONCAT(@name, e.FirstName + ' ' + e.LastName, ', ')
FROM Employees e
SELECT LEFT(@name, LEN(@name) - 1);