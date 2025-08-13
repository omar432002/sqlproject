CREATE TABLE Branch (
    BranchID INT PRIMARY KEY,
    BranchName VARCHAR(100),
    Location VARCHAR(100)
);

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Position VARCHAR(50),
    BranchID INT,
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Inventory (
    BranchID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (BranchID, ProductID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Sale (
    SaleID INT PRIMARY KEY,
    CustomerID INT,
    EmployeeID INT,
    BranchID INT,
    SaleDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);

CREATE TABLE SaleDetails (
    SaleID INT,
    ProductID INT,
    Quantity INT,
    Subtotal DECIMAL(10,2),
    PRIMARY KEY (SaleID, ProductID),
    FOREIGN KEY (SaleID) REFERENCES Sale(SaleID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Branch VALUES
(1, 'Main Branch', 'Cairo'),
(2, 'Mall Branch', 'Giza'),
(3, 'City Center', 'Alexandria');

INSERT INTO Employee VALUES
(101, 'Ali Hassan', 'Cashier', 1),
(102, 'Sarah Nabil', 'Manager', 1),
(103, 'Mostafa Gamal', 'Sales Rep', 2),
(104, 'Nour El Din', 'Cashier', 2),
(105, 'Hanan Said', 'Sales Rep', 3),
(106, 'Omar Fathy', 'Sales Rep', 1);

-- Customers
INSERT INTO Customer VALUES
(201, 'Mohamed Adel', 'mo.adel@mail.com', '0101010101'),
(202, 'Laila Samir', 'laila.s@mail.com', '0102020202'),
(203, 'Karim Hany', 'karim.h@mail.com', '0103030303'),
(204, 'Dina Mostafa', 'dina.m@mail.com', '0104040404'),
(205, 'Khaled Youssef', 'khaled.y@mail.com', '0105050505'),
(206, 'Yara Magdy', 'yara.m@mail.com', '0106060606');

-- Products
INSERT INTO Products VALUES
(301, 'Laptop HP', 'Electronics', 15000.00),
(302, 'iPhone 13', 'Electronics', 22000.00),
(303, 'Desk Chair', 'Furniture', 1800.00),
(304, 'Smart Watch', 'Electronics', 3500.00),
(305, 'Backpack', 'Accessories', 450.00),
(306, 'Office Desk', 'Furniture', 3500.00),
(307, 'Bluetooth Headset', 'Electronics', 750.00);

-- Inventory
INSERT INTO Inventory VALUES
(1, 301, 10), (1, 302, 5), (1, 303, 7), (1, 305, 6),
(2, 301, 2), (2, 304, 10), (2, 305, 15), (2, 306, 3),
(3, 302, 3), (3, 303, 4), (3, 305, 8), (3, 307, 9);

-- Sales
INSERT INTO Sale VALUES
(401, 201, 101, 1, '2024-04-01', 18000.00),
(402, 202, 103, 2, '2024-04-03', 450.00),
(403, 203, 104, 2, '2024-04-05', 3500.00),
(404, 204, 105, 3, '2024-04-06', 4000.00),
(405, 205, 106, 1, '2024-04-07', 750.00),
(406, 206, 103, 2, '2024-04-08', 22500.00);

-- Sale Details
INSERT INTO SaleDetails VALUES
(401, 301, 1, 15000.00),
(401, 303, 1, 1800.00),
(401, 305, 2, 1200.00),
(402, 305, 1, 450.00),
(403, 304, 1, 3500.00),
(404, 303, 2, 3600.00),
(404, 305, 1, 400.00),
(405, 307, 1, 750.00),
(406, 302, 1, 22000.00),
(406, 305, 1, 500.00);

--1 List all customers whose names start with 'K'.
select name from Customer
where name like 'k%'

--2  Show all products that cost more than 1000 LE.
select ProductName,productid, price
from Products
where price > 1000

--3 Display all products that belong to the 'Electronics' category.
select ProductName,productid, Category
from Products
where Category='electronics'

--4 Show products with 'desk' in the name (case insensitive).
select * from Products
where ProductName like '%desk%'

--5 List total number of employees per branch.
select branchid, count (*) as empcount from employee
group by BranchID

--6 Show each product and how many are available across all branches.
select productid , sum(quantity) sum_of_product_in_branch from Inventory
group by ProductID

--7 Show total number of customers.
select count (*) as cust_count from Customer

--8 List customers who made purchases in April.
select c.customerid,name,saledate 
from Customer c join sale s
on c.customerid=s.customerid
where MONTH (s.saledate)= 4

--9 Show the total revenue per branch.
select branchid,sum(totalamount) as revenue
from Sale
group by branchid

-- 10. Find the most sold product (by quantity).
select top 1 PRODUCTid, sum(quantity) as most_sold_product
from SaleDetails
group by ProductID

-- 11. Show employees with more than 1 sale.
select employeeid , count(*) as salecount
from sale 
group by EmployeeID
having count(*) > 1;

-- 12. List branches with less than 5 units of any product.
select distinct BranchID ,Quantity
from Inventory
where Quantity < 5

-- 13. Show average sale amount per employee.
select Employeeid , AVG(totalamount) as avgsaleamount
from Sale
group by EmployeeID

-- 14. List total revenue per product.
select PRODUCTid , sum(subtotal) as totaL_REVENUE
from SaleDetails
group by ProductID

-- 15. Display total quantity sold per category.
select category , SUM (Quantity) AS TOTAL_SOLD
from SaleDetails S join Products p
on S.ProductID = P.ProductID
GROUP BY Category

-- 16. Rank products by revenue using RANK().
select PRODUCTid , sum(subtotal) as totaL_REVENUE
from SaleDetails
group by ProductID 

-- 17. Use DENSE_RANK() to rank customers by number of purchases.
select productid,sum(subtotal) , rank() over (order by sum(subtotal) desc)
from saledetails
group by ProductID

-- 18. Use ROW_NUMBER() to list each customer's purchases chronologically.
select customerid , saleid , saledate,
ROW_NUMBER () over (partition by customerid order by saledate desc) row_num
from Sale

-- 19. Find products that were never sold.
select p. *from Products p left join SaleDetails sd
on p.ProductID=sd.ProductID
where sd.ProductID is null

-- 20. Show customers who didn’t make any purchase.
SELECT * FROM Customer
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Sale)

-- 21. Count how many distinct categories are sold.
SELECT COUNT(DISTINCT P.Category) AS SoldCategories
FROM SaleDetails SD
JOIN Products P
ON SD.ProductID = P.ProductID

-- 22. Get the names of employees who work in Giza.
select Employeeid , b.BranchID, branchname,location from Employee e join Branch b 
on e.BranchID=b.BranchID 
where Location= 'giza'

-- 23. Show all sales made by 'Ali Hassan'.
select name,e.EmployeeID,totalamount from Employee e join sale s
on e.EmployeeID= s.EmployeeID
where name = 'ali hassan'

-- 24. What is the most common product sold?
select top 1 productid,sum(Quantity) as most_sold from SaleDetails
group by productid
order by most_sold desc

-- 25. List each product and how many different customers bought it.
SELECT SD.ProductID, COUNT(DISTINCT S.CustomerID) AS CustomerCount
FROM SaleDetails SD
JOIN Sale S ON SD.SaleID = S.SaleID
GROUP BY SD.ProductID

-- 26. Get the latest sale made in each branch.
SELECT BranchID, MAX(SaleDate) AS LatestSale
FROM Sale
GROUP BY BranchID

-- 27. Find total inventory value per branch.
SELECT I.BranchID, SUM(I.Quantity * P.Price) AS InventoryValue
FROM Inventory I
JOIN Products P ON I.ProductID = P.ProductID
GROUP BY I.BranchID

-- 28. Show products with quantity = 0 (assume updated data).
SELECT * FROM Inventory
WHERE Quantity = 0 

-- 29. Calculate the average price of electronics.
SELECT AVG(Price) AS AvgElectronicsPrice
FROM Products
WHERE Category = 'Electronics'


-- 30. Show revenue per month.
SELECT FORMAT(SaleDate, 'yyyy-MM') AS SaleMonth, SUM(TotalAmount) AS MonthlyRevenue
FROM Sale
GROUP BY FORMAT(SaleDate, 'yyyy-MM')

-- 31. List all transactions for customer 'Laila Samir'.
select c.CustomerID, totalamount , name
from Customer c join Sale s 
on c.CustomerID=s.CustomerID
where name = 'laila samir'

-- 32. Show products with total sold quantity > 2.
SELECT ProductID, SUM(Quantity) AS TotalQuantity
FROM SaleDetails
GROUP BY ProductID
HAVING SUM(Quantity) > 2

-- 33. Find sales with more than one item.
select saleid 
from SaleDetails
where saleid > 1
group by SaleID

--34  Create a VIEW for inventory summary (branch, product, quantity)
create view Inventory_Summary 
as
select b.branchname , p.productname , i.quantity
from Branch b join Inventory i
on b.BranchID = i.BranchID
join Products p
on i.ProductID = p.ProductID

--35 Create a VIEW for sales report (customer name, date, total).
create view sales_report as
select name as customer_name , saledate , totalamount
from Customer c join sale s 
on c.CustomerID = s.CustomerID

--36 Show revenue grouped by employee and branch.
select e.employeeid ,name , branchname , sum(totalamount)
from sale s join branch b 
on s.BranchID = b.BranchID
join Employee e
on b.BranchID = e.BranchID
group by e.EmployeeID, b.BranchName , e.Name

-- 37 List categories ordered by total items sold descending.
select category , sum (quantity) as total_sold
from Products p join SaleDetails s
on p.ProductID = s.ProductID
group by Category
order by total_sold desc

--38 Show sales including product names and quantities.
select productname , quantity , sd.saleid
from products p join SaleDetails sd 
on p.ProductID = sd.ProductID
join sale s
on s.SaleID = sd.SaleID

--39 Show the number of different products sold in April.
select count(distinct sd.productid) as products_sold_in_April
from SaleDetails sd join sale s
on sd.SaleID =s.SaleID
where month (saledate) = 4

--40 Calculate the average sale value.
select avg (totalamount) as avg_sale_value
from Sale

--41 List employees who sold both electronics and furniture.
select e.employeeid ,e.name 
from Products p 
join SaleDetails sd
on p.ProductID = sd.ProductID
join Sale s
on sd.SaleID = s.SaleID
join Employee e 
on s.EmployeeID = e.EmployeeID
where Category in ('electronics' , 'furniture')
group by e.Name , e.EmployeeID
having count (distinct category) = 2

--42 Show total number of sales per day in April.
select saledate , count (*) as total_sales
from sale
where month(saledate) = 4
group by SaleDate

--43 Create a view to show branch, top product by revenue.
CREATE VIEW top_product AS
SELECT 
    t.branchname, 
    t.productname, 
    t.total_revenue
FROM ( 
    SELECT 
        b.branchname, 
        p.productname, 
        SUM(sd.quantity * p.price) AS total_revenue,
        RANK() OVER (
            PARTITION BY b.branchname 
            ORDER BY SUM(sd.quantity * p.price) DESC
        ) AS rnk
    FROM saledetails sd
    JOIN Products p 
        ON sd.productid = p.productid
    JOIN sale s 
        ON sd.saleid = s.saleid
    JOIN branch b 
        ON s.branchid = b.branchid
    GROUP BY 
        b.branchname, 
        p.productname
) AS t
WHERE t.rnk = 1;





--44 Create a view for employee performance (total sales).
CREATE VIEW EmployeePerformance AS
SELECT E.Name, SUM(SD.Quantity * P.Price) AS TotalSales
FROM SaleDetails SD
JOIN Products P ON SD.ProductID = P.ProductID
JOIN Sale S ON SD.SaleID = S.SaleID
JOIN Employee E ON S.EmployeeID = E.EmployeeID
GROUP BY E.Name

--45 List customers who bought accessories.
SELECT DISTINCT C.Name
FROM Sale S
JOIN Customer C ON S.CustomerID = C.CustomerID
JOIN SaleDetails SD ON S.SaleID = SD.SaleID
JOIN Products P ON SD.ProductID = P.ProductID
WHERE Category = 'Accessories'

--46 Show customers and their total spending.
SELECT C.Name, SUM(SD.Quantity * P.Price) AS TotalSpent
FROM SaleDetails SD
JOIN Products P ON SD.ProductID = P.ProductID
JOIN Sale S ON SD.SaleID = S.SaleID
JOIN Customer C ON S.CustomerID = C.CustomerID
GROUP BY C.Name

--47 List top 3 branches by revenue.
SELECT TOP 3 B.BranchName, SUM(SD.Quantity * P.Price) AS Revenue
FROM SaleDetails SD
JOIN Products P ON SD.ProductID = P.ProductID
JOIN Sale S ON SD.SaleID = S.SaleID
JOIN Branch B ON S.BranchID = B.BranchID
GROUP BY B.BranchName
ORDER BY Revenue DESC

--48 Display all employees and their branch names.
SELECT E.Name, B.BranchName
FROM Employee E
JOIN Branch B ON E.BranchID = B.BranchID

--49 List branches that sold more than 5 products.
SELECT B.BranchName, COUNT(DISTINCT P.ProductID) AS ProductCount
FROM SaleDetails SD
JOIN Products P ON SD.ProductID = P.ProductID
JOIN Sale S ON SD.SaleID = S.SaleID
JOIN Branch B ON S.BranchID = B.BranchID
GROUP BY B.BranchName
HAVING COUNT(DISTINCT P.ProductID) > 5

--50 List products sold by each employee.
SELECT E.Name, P.ProductName
FROM SaleDetails SD
JOIN Products P ON SD.ProductID = P.ProductID
JOIN Sale S ON SD.SaleID = S.SaleID
JOIN Employee E ON S.EmployeeID = E.EmployeeID
GROUP BY E.Name, P.ProductName
ORDER BY E.Name, P.ProductName


