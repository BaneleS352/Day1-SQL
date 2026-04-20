/* ==========================================================
   Day 1 Practical - Online Retail Store
   STARTER SCRIPT

   Scenario:
   -----------
   You're designing a database for an online retail store that
   sells physical products to customers. Customers can place
   multiple orders; each order can contain multiple products.

   Your tasks:
   1) Create tables for:
        - Customers
        - Products
        - Orders
        - OrderItems (line items)
   2) Enforce primary keys and foreign keys.
   3) Add sensible constraints (e.g. no negative prices).
   4) Insert the sample data provided.
   5) Run the validation queries at the bottom to check your design.

   Target RDBMS: SQL Server
   ========================================================== */

IF DB_ID('OnlineRetailTraining') IS NULL
BEGIN
    CREATE DATABASE OnlineRetailTraining;
END;
GO

USE OnlineRetailTraining;
GO

IF OBJECT_ID('dbo.OrderItems', 'U') IS NOT NULL DROP TABLE dbo.OrderItems;
IF OBJECT_ID('dbo.Orders',     'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Products',   'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Customers',  'U') IS NOT NULL DROP TABLE dbo.Customers;
GO

--------------------------------------------------------------
-- TODO 1: Create Customers table
--------------------------------------------------------------

-- WRITE YOUR CREATE TABLE FOR dbo.Customers BELOW THIS LINE:

CREATE TABLE dbo.Customers
(
 CustomerID INT IDENTITY UNIQUE PRIMARY KEY,
 FirstName NVARCHAR(100) NOT NULL,
 LastName NVARCHAR(100) NOT NULL,
 Email NVARCHAR(255) NOT NULL,
 PhoneNumber NVARCHAR(30) NULL,
 CreatedAt DEFAULT DATETIME2(0)

);

-- END OF TODO 1
GO

--------------------------------------------------------------
-- TODO 2: Create Products table
--------------------------------------------------------------

-- WRITE YOUR CREATE TABLE FOR dbo.Products BELOW THIS LINE:

CREATE TABLE dbo.Products
(
ProductID INT IDENTITY UNIQUE PRIMARY KEY,
ProductName NVARCHAR(200) NOT NULL,
SKU NVARCHAR(50) NOT NULL,
UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
IsActive BIT NOT NULL DEFAULT 1,
CreatedAt DATETIME2(0)
);

-- END OF TODO 2
GO

--------------------------------------------------------------
-- TODO 3: Create Orders table
--------------------------------------------------------------

-- WRITE YOUR CREATE TABLE FOR dbo.Orders BELOW THIS LINE:

CREATE TABLE dbo.Orders
(
OrderID INT IDENTITY UNIQUE PRIMARY KEY,
OrderDate DATETIME2(0),
OrderStatus NVARCHAR(50) DEFAULT N'Pending',
CustomerID INT NOT NULL FOREIGN KEY (CustomerID) REFERENCES dbo.Customers ON DELETE NO ACTION,
);

-- END OF TODO 3
GO

--------------------------------------------------------------
-- TODO 4: Create OrderItems table
--------------------------------------------------------------

-- WRITE YOUR CREATE TABLE FOR dbo.OrderItems BELOW THIS LINE:

CREATE TABLE dbo.OrderItems
(
OrderID INT NOT NULL,
ProductID INT NOT NULL,
Quantity INT NOT NULL CHECK (QUANTITY > 0),
UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
CONSTRAINT PK_OrderItems PRIMARY KEY (OrderID, ProductID),
CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderID) REFERENCES dbo.Orders (OrderID) ON DELETE CASCADE,
CONSTRAINT FK_OrderItems_Products FOREIGN KEY (ProductID)       REFERENCES dbo.Products (ProductID)
);

-- END OF TODO 4
GO

--------------------------------------------------------------
-- TODO 5 (Challenge): Show each order with its total value
--------------------------------------------------------------

-- Write your SELECT below:
SELECT
    o.OrderID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    o.OrderDate,
    SUM(oi.Quantity * oi.UnitPrice) AS OrderTotal
FROM dbo.Orders AS o
JOIN dbo.Customers AS c
    ON c.CustomerID = o.CustomerID
JOIN dbo.OrderItems AS oi
    ON oi.OrderID = o.OrderID
GROUP BY
    o.OrderID,
    c.FirstName,
    c.LastName,
    o.OrderDate
ORDER BY
    o.OrderID;
