-- CREATE DATABASE
CREATE DATABASE RetailDashboard;
GO

USE RetailDashboard;
GO

-- CREATE DIMENSION TABLES

-- 1. Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50),
    CustomerSegment VARCHAR(20),
    JoinDate DATE,
    AnnualIncome DECIMAL(10,2)
);

-- 2. Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    SubCategory VARCHAR(50),
    UnitPrice DECIMAL(10,2),
    Cost DECIMAL(10,2),
    Supplier VARCHAR(100),
    Stock INT
);

-- 3. Date Dimension Table
CREATE TABLE DateDimension (
    DateID INT PRIMARY KEY,
    FullDate DATE,
    Day INT,
    Month INT,
    Quarter INT,
    Year INT,
    MonthName VARCHAR(20),
    DayName VARCHAR(20),
    WeekNumber INT
);

-- 4. Orders Fact Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    OrderDate DATE,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    TotalSales DECIMAL(10,2),
    Cost DECIMAL(10,2),
    Profit DECIMAL(10,2),
    ShipDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

GO

-- INSERT CUSTOMERS (10 records)
INSERT INTO Customers VALUES
('Alice Johnson', 'alice@email.com', '555-0001', 'New York', 'NY', 'USA', 'Premium', '2022-01-15', 150000),
('Bob Smith', 'bob@email.com', '555-0002', 'Los Angeles', 'CA', 'USA', 'Standard', '2022-06-20', 75000),
('Carol White', 'carol@email.com', '555-0003', 'Chicago', 'IL', 'USA', 'Budget', '2023-03-10', 45000),
('David Brown', 'david@email.com', '555-0004', 'Houston', 'TX', 'USA', 'Premium', '2021-12-05', 180000),
('Emma Davis', 'emma@email.com', '555-0005', 'Phoenix', 'AZ', 'USA', 'Standard', '2023-01-22', 80000),
('Frank Miller', 'frank@email.com', '555-0006', 'Denver', 'CO', 'USA', 'Budget', '2023-05-12', 50000),
('Grace Lee', 'grace@email.com', '555-0007', 'Seattle', 'WA', 'USA', 'Premium', '2020-11-08', 200000),
('Henry Wilson', 'henry@email.com', '555-0008', 'Boston', 'MA', 'USA', 'Standard', '2022-08-30', 90000),
('Iris Chen', 'iris@email.com', '555-0009', 'Miami', 'FL', 'USA', 'Budget', '2023-02-14', 55000),
('Jack Taylor', 'jack@email.com', '555-0010', 'Portland', 'OR', 'USA', 'Standard', '2022-04-18', 85000);

-- INSERT PRODUCTS (15 records)
INSERT INTO Products VALUES
('Laptop Pro', 'Electronics', 'Computers', 1299.99, 800, 'TechCorp', 45),
('Wireless Mouse', 'Electronics', 'Accessories', 29.99, 8, 'TechCorp', 200),
('USB-C Cable', 'Electronics', 'Cables', 12.99, 3, 'TechCorp', 500),
('Office Chair', 'Furniture', 'Office', 299.99, 150, 'FurnitureCo', 60),
('Standing Desk', 'Furniture', 'Office', 499.99, 250, 'FurnitureCo', 35),
('Monitor 4K', 'Electronics', 'Displays', 599.99, 350, 'DisplayTech', 50),
('Keyboard Mechanical', 'Electronics', 'Accessories', 149.99, 60, 'TechCorp', 80),
('Coffee Maker', 'Furniture', 'Breakroom', 99.99, 40, 'KitchenPro', 120),
('Desk Lamp', 'Furniture', 'Office', 49.99, 20, 'LightCo', 150),
('Headphones Wireless', 'Electronics', 'Audio', 199.99, 80, 'AudioPro', 95),
('T-Shirt Premium', 'Clothing', 'Apparel', 29.99, 10, 'TextileCo', 300),
('Jeans Classic', 'Clothing', 'Apparel', 69.99, 25, 'TextileCo', 250),
('Sneakers Sport', 'Clothing', 'Footwear', 89.99, 40, 'SportGear', 180),
('Backpack Pro', 'Clothing', 'Bags', 79.99, 30, 'BagCo', 95),
('Blazer Formal', 'Clothing', 'Apparel', 149.99, 60, 'FashionCo', 70);

-- INSERT DATE DIMENSION (2023-2024)
DECLARE @StartDate DATE = '2023-01-01';
DECLARE @EndDate DATE = '2024-12-31';
DECLARE @CurrentDate DATE = @StartDate;
DECLARE @DateID INT = 1;

WHILE @CurrentDate <= @EndDate
BEGIN
    INSERT INTO DateDimension (DateID, FullDate, Day, Month, Quarter, Year, MonthName, DayName, WeekNumber)
    VALUES (
        @DateID,
        @CurrentDate,
        DAY(@CurrentDate),
        MONTH(@CurrentDate),
        CEILING(MONTH(@CurrentDate) / 3.0),
        YEAR(@CurrentDate),
        DATENAME(MONTH, @CurrentDate),
        DATENAME(WEEKDAY, @CurrentDate),
        DATEPART(WEEK, @CurrentDate)
    );
    
    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
    SET @DateID = @DateID + 1;
END;

-- INSERT 500 ORDERS
INSERT INTO Orders (CustomerID, OrderDate, ProductID, Quantity, UnitPrice, TotalSales, Cost, Profit, ShipDate, Status)
SELECT TOP 500
    (ABS(CHECKSUM(NEWID())) % 10) + 1,
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 730, '2023-01-01'),
    (ABS(CHECKSUM(NEWID())) % 15) + 1,
    (ABS(CHECKSUM(NEWID())) % 5) + 1,
    CAST((ABS(CHECKSUM(NEWID())) % 100) + 10 AS DECIMAL(10,2)),
    CAST((ABS(CHECKSUM(NEWID())) % 5000) + 500 AS DECIMAL(10,2)),
    CAST((ABS(CHECKSUM(NEWID())) % 2000) + 100 AS DECIMAL(10,2)),
    CAST((ABS(CHECKSUM(NEWID())) % 1000) + 100 AS DECIMAL(10,2)),
    DATEADD(DAY, 3, DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 730, '2023-01-01')),
    CASE WHEN ABS(CHECKSUM(NEWID())) % 10 < 9 THEN 'Completed' ELSE 'Cancelled' END
FROM sys.objects a
CROSS JOIN sys.objects b
WHERE a.type = 'U';

GO

-- VERIFY DATA
SELECT COUNT(*) AS TotalCustomers FROM Customers;
SELECT COUNT(*) AS TotalProducts FROM Products;
SELECT COUNT(*) AS TotalDates FROM DateDimension;
SELECT COUNT(*) AS TotalOrders FROM Orders;

GO