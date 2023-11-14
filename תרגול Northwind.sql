USE Northwind;
------------------------------------------------------------------------------------------------------------------
--1.��� �� ���� �� ������� ������ Customers

SELECT customerID AS 'CustomerName' 
FROM customers;
------------------------------------------------------------------------------------------------------------------
--2.��� �� ����� Products ���� �� ������ �� UnitsInStock ���� �-10

SELECT * 
FROM products
WHERE unitsinstock > 10;
------------------------------------------------------------------------------------------------------------------
--3.��� �� ������� ProductName �-UnitPrice ������ Products ������� ���� ���� ��� ����

SELECT ProductName, 
       UnitPrice 
FROM Products
ORDER BY unitprice DESC;
------------------------------------------------------------------------------------------------------------------
--4.���� ��� ������ �� ����� Orders ���� �� ���

SELECT YEAR(orderdate) AS 'YearOfOrder', 
       COUNT(*) 'Orders'
FROM Orders
GROUP BY YEAR(orderdate);
------------------------------------------------------------------------------------------------------------------
--5.��� �� ������ �� ����� ����� (Quantity * UnitPrice) ����� �����  

SELECT TOP 1 OrderID, 
             (UnitPrice * Quantity) AS 'TotalPrice'
FROM [Order Details]
ORDER BY TotalPrice DESC;
------------------------------------------------------------------------------------------------------------------
--6.��� ���� �� ���� �� ���� ������� ��� ��� ���� ������� ���

SELECT Cust.customerID , 
       COUNT(orders.orderID) AS 'NubersOfOrders', 
	   SUM(odeta.unitprice*odeta.quantity) AS 'TotalOrdersValue'
FROM Customers Cust LEFT OUTER JOIN orders  
ON Cust.customerID = Orders.customerID
                    LEFT OUTER JOIN [Order Details] odeta
ON odeta.[OrderID] = Orders.[OrderID] 
GROUP BY Cust.customerID;
------------------------------------------------------------------------------------------------------------------
--7.��� ������ ��� ������ �����

SELECT Pro.ProductID, 
       Pro.ProductName
FROM Products Pro LEFT JOIN [Order Details] OD 
ON Pro.ProductID = OD.ProductID
WHERE OD.ProductID IS NULL;
------------------------------------------------------------------------------------------------------------------
--8.��� �� ��������� �� ����� ��� ����� �� ������ ���  

SELECT Cat.CategoryName, 
       COUNT(Pro.ProductName) AS 'CountsOfProducts'
FROM Categories Cat INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
GROUP BY Cat.CategoryName;
------------------------------------------------------------------------------------------------------------------
--9.��� ������ ��� ������ 

SELECT Cus.CustomerID, 
       Ord.OrderID
FROM Customers Cus LEFT OUTER JOIN Orders Ord 
ON Cus.CustomerID = Ord.CustomerID
WHERE Ord.OrderID  IS NULL;
------------------------------------------------------------------------------------------------------------------
--10.��� �� ����� ����� ��� ������ ������� ������� ���� �� ���� 

SELECT Cus.CustomerID, 
       DATEDIFF(DAY,MIN(Ord.orderdate), MAX(Ord.orderdate)) AS 'DaysBetweenFirstAndLastOrder'
FROM Customers Cus INNER JOIN Orders Ord
ON Cus.CustomerID = Ord.CustomerID
GROUP BY Cus.CustomerID;
------------------------------------------------------------------------------------------------------------------
--11. ��� ���� ������� ��� ���� ���� �������?

SELECT cus.CustomerID, 
       COUNT(ord.OrderID) AS 'OrdersPerCustomerLastYear'
FROM customers cus INNER JOIN orders ord
ON cus.CustomerID = ord.CustomerID
WHERE YEAR(ord.orderdate) IN (SELECT TOP 1 YEAR(orderdate) FROM orders ORDER BY orderdate DESC)
GROUP BY cus.CustomerID;
------------------------------------------------------------------------------------------------------------------
--12.���� ���� ���� ����� ������ ����� ��������� 'Seafood'?

SELECT cat.categoryname, 
       MAX(pro.productName) AS 'MaxSelasInSeaFood', 
	   COUNT(pro.productName) AS 'CountOfMaxProduct'
FROM Categories cat LEFT OUTER JOIN products pro
ON  cat.CategoryID = pro.CategoryID
WHERE cat.categoryname = 'SeaFood'
GROUP BY cat.categoryname;
------------------------------------------------------------------------------------------------------------------
--13.���� ���� ���� �� ������ ������ ����� (���� ���� ����) ���� �������?

SELECT TOP 1 Cus.CustomerID, 
             YEAR(ord.orderdate) AS 'LastYear', 
			 quantity * unitprice AS 'TotalPrice'
FROM Customers Cus LEFT OUTER JOIN orders ord
ON Cus.CustomerID = ord.CustomerID
                   LEFT OUTER JOIN [Order Details] ordeta
ON ord.OrderID = ordeta.OrderID
WHERE YEAR(ord.orderdate) IN (SELECT TOP 1 YEAR(orderdate) FROM orders ORDER BY orderdate DESC)
ORDER BY TotalPrice DESC;
------------------------------------------------------------------------------------------------------------------
--14. ��� �� ���� ������� ���� ���� �-2 ������.

SELECT CustomerID
FROM Customers
WHERE CustomerID IN (SELECT CustomerID 
                      FROM Orders 
					  GROUP BY CustomerID 
					  HAVING COUNT(*) > 2);
------------------------------------------------------------------------------------------------------------------
--15.��� �� ���� ������� ������ ���� �-100 ������ ��� ���.

SELECT ProductName, 
       SUM(Quantity) AS 'SumQuantity'
FROM Products Pro INNER JOIN [Order Details] Ordeta
ON Pro.ProductID = Ordeta.ProductID
WHERE  Quantity > 100
GROUP BY ProductName;
------------------------------------------------------------------------------------------------------------------
--16.���� �� ������� ���� ���� ��� ���� ������� ������ ���.

SELECT Employees.EmployeeID, 
       Employees.FirstName, 
	   Employees.LastName, 
	   COUNT(Orders.OrderID) AS NumOrders
FROM Employees INNER JOIN Orders 
ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.EmployeeID, Employees.FirstName, Employees.LastName
ORDER BY NumOrders ASC;
------------------------------------------------------------------------------------------------------------------
--17.��� �� ������ ��� ����� (����� ������) ������ ���� �� ����.                                           !!!

SELECT Ordeta.OrderID, 
       Cus.CustomerID, 
	   SUM(Ordeta.Quantity) AS 'SumQuantityPerOrder'
FROM [Order Details] Ordeta INNER JOIN Orders Ord
ON Ord.OrderID = Ordeta.OrderID
                 INNER JOIN Customers Cus
ON Cus.CustomerID = Ord.CustomerID
GROUP BY  Ordeta.OrderID, Cus.CustomerID
ORDER BY Cus.CustomerID;
-----------------------------------------
SELECT [Order Details].OrderID, 
       Customers.CustomerID, 
	   SUM([Order Details].Quantity) AS 'SumQuantityPerOrder'
FROM [Order Details] INNER JOIN Orders 
ON Orders.OrderID = [Order Details].OrderID
                    INNER JOIN Customers 
ON Customers.CustomerID = Orders.CustomerID
GROUP BY [Order Details].OrderID, Customers.CustomerID
HAVING SUM([Order Details].Quantity) = (SELECT MAX(SumQuantity)
                                        FROM (SELECT SUM(Quantity) AS SumQuantity
										      FROM [Order Details] INNER JOIN Orders 
											  ON Orders.OrderID = [Order Details].OrderID 
                                              WHERE Orders.CustomerID = Customers.CustomerID
                                              GROUP BY Orders.OrderID)t)
											  ORDER BY Customers.CustomerID;                                 --!!!
------------------------------------------------------------------------------------------------------------------
--18. ��� ������ ������ ��� �����.

SELECT Country, 
       Count(CustomerID) AS 'CustomersPerCountry'
FROM CUSTOMERS
GROUP BY Country;
------------------------------------------------------------------------------------------------------------------
--19.���� �� ��������� ���� ���� ��� ������� �������� ����.

SELECT Cat.CategoryName, 
       AVG(Ordeta.unitprice * Ordeta.quantity) AS 'TotalPrice'
FROM Categories Cat INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
                    INNER JOIN [Order Details] Ordeta
ON Ordeta.ProductID = Pro.ProductID
GROUP BY Cat.CategoryName
ORDER BY TotalPrice DESC;
------------------------------------------------------------------------------------------------------------------
--20. ���� �������� ����� �� ������ ������� ���,
-- ��� ����� ������ [feasibility study]���� ���� ����� ��� ����� �� �� ��������, �� �����, ���� �����, ������ ����� ��� 
-- ����� ������ ���� �10 ����� �� ���� 'A Product Worth Producting'
-- ����� ������ ��� �10 ����� �� ���� 'A Product is not worth producting'
-- ����� ������ ��� ��� (���� �10) ����� �� �� ���� 'A re-examination is required'

SELECT Cat.CategoryName, 
       Pro.ProductName, 
	   Pro.UnitPrice,
       CASE WHEN Pro.UnitPrice > 10 THEN 'A product worth producting'
	        WHEN Pro.UnitPrice < 10 THEN 'A product is not worth producting'
	        WHEN Pro.UnitPrice = 10 THEN 'A re-examination is required'
	        ELSE 'NULL'
	   END AS 'Feasibility Study'
FROM Categories Cat INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID;
------------------------------------------------------------------------------------------------------------------
--21.  SAVEA ������ ��� ����! - ����� ��� ����� �� ���� ������ ����� ���  
-- ����� 1994 � 1997 ����
--���� ��� ����� �� ���� ������ ��� ����� 1997 � 1998 ����  ERNSH ������ ��� 

SELECT CustomerID, 
       YEAR(OrderDate) AS [Year Of Order], 
	   COUNT(OrderID) AS [Num Of Orders]
FROM Orders 
WHERE CustomerID = 'SAVEA' AND YEAR(OrderDate) IN (1994,1997) 
GROUP BY CustomerID , YEAR(OrderDate)
UNION
SELECT CustomerID, 
       YEAR(OrderDate) AS 'YearOfOrder', 
	   COUNT(OrderID) AS 'NumOrdersOfSAVEA'
FROM Orders 
WHERE CustomerID = 'ERNSH' AND YEAR(OrderDate) IN (1997,1998) 
GROUP BY CustomerID , YEAR(OrderDate);
------------------------------------------------------------------------------------------------------------------
-- 22. ��� ����� ��� ����� ���� ������ �� �� ���� �����, ����� �����, ���� ���� ���� ������ �� ���� �� ����.

SELECT Cus.CustomerID, 
       Ord.OrderID, 
	   Ord.OrderDate,
       ROW_NUMBER() OVER (PARTITION BY Cus.CustomerID ORDER BY Ord.OrderDate) AS 'Row'
FROM Orders Ord INNER JOIN Customers Cus
ON Ord.CustomerID = Cus.CustomerID;
------------------------------------------------------------------------------------------------------------------
-- 23. Seafood ��� �� ���� ������ ����� ������ ������� ������ ��������� 

SELECT Supp.CompanyName, 
       Pro.ProductName, 
	   CategoryName
FROM Suppliers Supp INNER JOIN Products Pro
ON Supp.SupplierID = Pro.SupplierID
                     INNER JOIN Categories Cat
ON Cat.CategoryID = Pro.CategoryID
WHERE CategoryName = 'Seafood';
------------------------------------------------------------------------------------------------------------------
-- 24. ���� �� ���� ��������� ���� �� ���� ������ ����� ������� ����� ��������� 

-- ��� ������ ��
SELECT COUNT(*) AS 'NumOfEmployees'
FROM employees;
--------------------------
-- ��� ������ �� ��� �������
SELECT Cat.CategoryName, 
       COUNT(Pro.ProductName) AS 'NumOfProducts'
FROM Products Pro INNER JOIN Categories Cat
ON Cat.CategoryID = Pro.CategoryID
GROUP BY Cat.CategoryName;
--------------------------
SELECT Cat.CategoryName, 
       COUNT(Pro.ProductName) AS 'NumOfProducts'
FROM Products Pro INNER JOIN Categories Cat
ON Cat.CategoryID = Pro.CategoryID
GROUP BY Cat.CategoryName
HAVING COUNT(Pro.ProductName) > (SELECT COUNT(*) AS 'NumOfEmployees'
FROM employees);
------------------------------------------------------------------------------------------------------------------
-- 25. ��� ���� ����� ��������� ���� ���� ���� ������� ���� ����� �����
-- ���� ���� ��������� ������ ����� �� ������� ������   

--���� ����� ���������
--���� ���� �������
--����� �����
--���� ����
--�� ������� ������

SELECT TOP 3 Cat.CategoryName, 
             SUM(Pro.UnitPrice) AS 'TotalPrice'
FROM Categories Cat INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
GROUP BY Cat.CategoryName
ORDER BY SUM(Pro.UnitPrice) DESC;
------------------------------------------------------------------------------------------------------------------
-- 26. ��� ������ �� ������ ������� ���� �� ��� ���� ������ ������� ��� ����� ����

--��� ������
--������ �������
--��� ���� ������
--������� ��� ����� ����

SELECT TOP 3 (Emp.FirstName + ' ' + Emp.LastName) AS 'FullName', 
             COUNT(Ord.OrderID) AS 'NumOfOrders'
FROM Orders Ord INNER JOIN Employees Emp
ON Ord.EmployeeID = Emp.EmployeeID
WHERE MONTH(OrderDate) IN (3,7) 
GROUP BY (Emp.FirstName + ' ' + Emp.LastName)
ORDER BY COUNT(Ord.OrderID) DESC;
------------------------------------------------------------------------------------------------------------------
--27. ���� �� �� ���� ������� ������ ������ ��� 
-- ������ ����� ������ ���� ����� ��������� ����� ���� ������ ������� ��������.

SELECT FirstName + ' ' + LastName AS 'FullNmae', 
       HireDate
FROM Employees
WHERE HireDate >ALL (SELECT TOP 3 HireDate FROM Employees GROUP BY HireDate ORDER BY HireDate);
------------------------------------------------------------------------------------------------------------------
--28.�� ����� �� ����� ����� ������ �� ������� ������ ������ ����� ����� �����

SELECT HireDate 
FROM Employees 
ORDER BY HireDate DESC;
------------------------------------------------------------------------------------------------------------------
--29.���� �2 ������ �� ���� ����� �������� ���� ��� ���� ������ �� ��� ���

SELECT City, 
       COUNT(City) AS 'NumOfEmployeesFromCity'
FROM Employees
GROUP BY City;
------------------------------------------------------------------------------------------------------------------
--30.���� �� ���� ������� ��� ��� �����

SELECT YEAR(OrderDate) AS 'YearOfOrder', 
       COUNT(OrderID) AS 'NumOfOrders'
FROM Orders
GROUP BY YEAR(OrderDate);
------------------------------------------------------------------------------------------------------------------
--31. �� ����� �� ���� ������� �� 2 ������� ������� ��� ���� 

SELECT TOP 2 EmployeeID, 
             COUNT(OrderID) AS 'NumOfOrders'
FROM Orders 
GROUP BY EmployeeID 
ORDER BY COUNT(OrderID) DESC;
-----------------------------
--31.2. �� ����� �� ���� ������� ���� ���� �� ����� ������ ��� ���� 

SELECT Emp.EmployeeID, Emp.FirstName + ' ' + Emp.LastName AS 'FullName', 
       COUNT(Ord.OrderID) AS 'NumOfOrders'
FROM Orders Ord RIGHT OUTER JOIN Employees Emp
ON Ord.EmployeeID = Emp.EmployeeID
GROUP BY Emp.EmployeeID, Emp.FirstName + ' ' + Emp.LastName
ORDER BY COUNT(OrderID) DESC;
------------------------------------------------------------------------------------------------------------------
--32. ������ ���� ��� department_budget �� ������� �����:
-- department code, total salary, total comission and total amount of sales

CREATE TABLE Department_Budget
(
[Department code] int,
[Total salary] int,
[Total comission] int,
[Total amount of sales] int
);
INSERT INTO Department_Budget([Department code], [Total salary], [Total comission], [Total amount of sales])
VALUES('123','12500','350','75');

SELECT * 
FROM Department_Budget;
------------------------------------------------------------------------------------------------------------------
--33. ��� �� ���� ������� ������� �� ���� ���� 11 ������� ������ ���� ����

SELECT Cus.CompanyName, 
       Ordeta.ProductID
FROM Customers Cus INNER JOIN Orders Ord
ON Cus.CustomerID = Ord.CustomerID
                   INNER JOIN [Order Details] Ordeta
ON Ord.OrderID = Ordeta.OrderID
WHERE ProductID = 11 AND MONTH(OrderDate) IN (2,3);
------------------------------------------------------------------------------------------------------------------
--34. ��� �� ��� ���� �� ������� ������ ���
-- ������� ����� ��� �� ����� ������ ���� ������� ��� �����.

SELECT (Emp.FirstName + ' ' + Emp.LastName) AS 'FullName', 
       COUNT(Ord.OrderID) AS 'NumOfOrders'
FROM Employees Emp INNER JOIN Orders Ord
ON Emp.EmployeeID = Ord.EmployeeID
WHERE MONTH(OrderDate) IN (3,7)
GROUP BY (Emp.FirstName + ' ' + Emp.LastName);
------------------------------------------------------------------------------------------------------------------
-- 35. ���� ������ ������ �� ����� ������� ������� ��� ���� ������

SELECT TOP 3 (FirstName + ' ' + LastName) AS 'FullName', 
             COUNT(OrderID) AS 'NumOfOrders'
FROM Employees Emp INNER JOIN Orders Ord
ON Emp.EmployeeID = Ord.EmployeeID
GROUP BY (FirstName + ' ' + LastName)
ORDER BY COUNT(OrderID) DESC;
------------------------------------------------------------------------------------------------------------------
-- 36. ����� ������ ����� ��� ������ �� ��� ���� ����� ������ ���� ����

SELECT (FirstName + ' ' + LastName) AS 'FullName', 
       COUNT(OrderID) AS 'NumOfOrders'
FROM Employees Emp INNER JOIN Orders Ord
ON Emp.EmployeeID = Ord.EmployeeID
WHERE MONTH(OrderDate) IN (2,3)
GROUP BY (FirstName + ' ' + LastName);
------------------------------------------------------------------------------------------------------------------
-- 37. ���� ���� 2 ��� �� ������ ��� ����� �� ����� ��� ������� DELETE.

DELETE Employees
WHERE EmployeeID = 2;
------------------------------------------------------------------------------------------------------------------
-- 38.��� ������ �� ��� ���� ��� ���                                                                         !!!
--   , ��� ������ �� ��� ���� ��� �����
--   , ��� ��� ������ ��
--   , �� ����� �� ����� 38-40 ������� �������� ����� �����
--   . �� ����� �� ������� ������� ������ ��� ����

SELECT Cus.Country, 
       Cus.City, 
	   COUNT(Ord.OrderID) AS 'NumOfOrders'
FROM Customers Cus INNER JOIN Orders Ord
ON Cus.CustomerID = Ord.CustomerID
WHERE Cus.ContactTitle = 'Owner'
GROUP BY  GROUPING SETS (Cus.Country, Cus.City, ());                                                        -- !!!
------------------------------------------------------------------------------------------------------------------
-- 39. ��� ������ �� �� ���
--     ��� ������ �� �� ����
--     ��� ������ ������ ������ ������� 
--     ������� ������� ������� ������ ��� ����� ����
--     ��� ������ ��� ������� �� ���� ����
--     ��� ������ ���

SELECT YEAR(OrderDate) AS 'YEAR', 
       MONTH(OrderDate) AS 'MONTH', 
	   COUNT(OrderID) AS 'NumOfOrders'
FROM Orders
WHERE MONTH(OrderDate) IN (5,7)
GROUP BY GROUPING SETS ( YEAR(OrderDate), MONTH(OrderDate), ());
------------------------------------------------------------------------------------------------------------------
-- 40. ����� �� ���� �����[Order Details] ����� ��� ����� 
--     REVENUSE ��� ���� ������� ������� ���� ��� 
--     ��� ���� ��� ���� ���� ����REVENUSE��_TOTAL ����� ����� ��� ���� ���
--     �� ����� �� ���� ��� ���� ����� ���� ����

SELECT ProductID,
       (UnitPrice * Quantity) AS 'REVENUSE',
	   SUM(UnitPrice * Quantity) OVER (PARTITION BY ProductID ORDER BY ProductID
	   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 'REVENUSE��_TOTAL'
FROM [Order Details];
------------------------------------------------------------------------------------------------------------------
-- 41. ����� �� ���� �����[Order Details] ����� ��� ����� 
--     PROFIT ��� ���� ������� ������� ���� ��� 
--     ��� ���� ��� ���� ���� ����PROFIT��_TOTAL ����� ����� ��� ���� ���
--     �� ����� �� ���� ��� ���� ����� ���� ����
 
 SELECT ProductID,
        CASE WHEN Discount > 0 THEN (UnitPrice * Quantity * (1-Discount)) 
		     WHEN Discount = 0 THEN (UnitPrice * Quantity) 
	    END AS 'PROFIT',
	    SUM(CASE WHEN Discount > 0 THEN (UnitPrice * Quantity * (1-Discount)) 
		    WHEN Discount = 0 THEN (UnitPrice * Quantity) 
	    END) OVER (PARTITION BY ProductID ORDER BY ProductID 
	    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 'PROFIT��_TOTAL'
FROM [Order Details];
---------------------
SELECT ProductID,
        (UnitPrice * Quantity * (1-Discount)) AS 'PROFIT',
	    SUM((UnitPrice * Quantity * (1-Discount))) OVER (PARTITION BY ProductID ORDER BY ProductID 
	    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 'PROFIT��_TOTAL'
FROM [Order Details];
------------------------------------------------------------------------------------------------------------------
-- 42. ���� ��� ����� �� �� ��������, �� �����, ���� �����
--     ���� ����� ��� ����� ����� ����� ��� �����
--     �� ����� �� ����� ��� ��� ���� 

SELECT Cat.CategoryName, 
       Pro.ProductName, 
       Pro.UnitPrice,
	   LAG(Pro.UnitPrice) OVER (ORDER BY Pro.UnitPrice) AS 'LastPrice',
	   LEAD(Pro.UnitPrice) OVER (ORDER BY Pro.UnitPrice) AS 'NextPrice'
FROM Categories Cat INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
ORDER BY Pro.UnitPrice;
------------------------------------------------------------------------------------------------------------------
-- 43. -- ���� ����� ���� �� ���� ������� �� ������ ������� ����� �������
-- [september] [august] [july] 
-- ������ �� ���� ����� ������
-- ���� ���� �� ������� ���� ������� - �� ����� �� ������� ����� ���� ��� ������� �� ����� ��� �����

SELECT *
FROM (SELECT YEAR(Ord.OrderDate) AS 'YearOfOrder',
	   DATENAME(MONTH,Ord.OrderDate) AS 'MonthOfOrder',
	   ROUND(Ordeta.UnitPrice*Ordeta.Quantity*(1-Ordeta.Discount),0) AS 'Profit'
FROM Orders Ord INNER JOIN [Order Details] Ordeta
ON Ord.OrderID = Ordeta.OrderID
WHERE MONTH(Ord.OrderDate) IN (7,8,9)) AS PVIT
PIVOT (SUM(Profit) FOR MonthOfOrder IN ([September], [August], [July])) AS PIVOT1 -- X��� �
------------------------------------------------------------------------------------------------------------------
--44. ���� ��������� ���� ���� �� ����� ������ �� ��������� ������
-- �2 �����

--��� ������: CTE

WITH CTE_Cat
AS (
SELECT Cat.CategoryName, 
       SUM(Pro.UnitPrice) AS [SUM Unit Price]
FROM Categories Cat INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
GROUP BY Cat.CategoryName)

SELECT AVG([SUM Unit Price]) AS [AVG Of Cat]
FROM CTE_Cat;

-- ��� ����: SUBQUERY

SELECT AVG([SUM Unit Price]) AS [AVG Of Cat]
FROM (SELECT Cat.CategoryName, 
       SUM(Pro.UnitPrice) AS [SUM Unit Price]
FROM Categories Cat INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
GROUP BY Cat.CategoryName) AS [Sum];
------------------------------------------------------------------------------------------------------------------
-- 45. ����� ������
--     ����� ����� �� ���� ��� ����� ������ ������ ������ �� ����� ���� �� ������ �����
--     ����� ����� ��� Order demand gap 
--     ����� ���� ����� ����� ����� ���
--     ����� ����� ����� ��� Business efficiency ��� ����� ���:
--     ����� ����� ���� �� 20 ��� ����� - ����� Bed service ��� ���� ��� - ����� Good service

--��� ������: NORMAL

SELECT OrderID,
       DATEDIFF(DAY, OrderDate, RequiredDate) AS [Order demand gap],
       CASE WHEN DATEDIFF(DAY, OrderDate, RequiredDate) >= 20 THEN 'Bed service'
	        ELSE 'Good service'
	   END AS 'Business efficiency'
FROM Orders;
------------------------------------
--��� ����: SUBQUERY

(SELECT DATEDIFF(DAY, OrderDate, RequiredDate) AS [Order demand gap]
FROM Orders) AS [gap order]

SELECT [gap order].[Order demand gap] AS [Gap order],
       CASE WHEN [Order demand gap] >= 20 THEN 'Bed service'
	        ELSE 'Good service'
	   END AS 'Business efficiency'
FROM (SELECT DATEDIFF(DAY, OrderDate, RequiredDate) AS [Order demand gap]
FROM Orders) AS [Gap order];
------------------------------------
--��� ������: CTE

WITH CTE_Gap
AS(
SELECT DATEDIFF(DAY, OrderDate, RequiredDate) AS [Order demand gap]
FROM Orders)

SELECT [Order demand gap],
       CASE WHEN [Order demand gap] >= 20 THEN 'Bed service'
	        ELSE 'Good service'
	   END AS 'Business efficiency'
FROM CTE_Gap;
------------------------------------------------------------------------------------------------------------------
-- 46. �� ����� ����� ������ ����� �� �� ������� ��������� ������ �����
--     ������ ���

(SELECT CategoryName,
       SUM(UnitPrice) AS [Sum Unit Price]
FROM Categories Cat  INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
GROUP BY CategoryName) AS [Sum Col]
-----------------------------------
SELECT MIN([Sum Col].[Sum Unit Price]) AS [MIN & MAX PRICE]
FROM (SELECT CategoryName,
       SUM(UnitPrice) AS [Sum Unit Price]
FROM Categories Cat  INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
GROUP BY CategoryName) AS [Sum Col]
UNION
SELECT MAX([Sum Col].[Sum Unit Price]) AS [MAX PRICE]
FROM (SELECT CategoryName,
       SUM(UnitPrice) AS [Sum Unit Price]
FROM Categories Cat  INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
GROUP BY CategoryName) AS [Sum Col];
------------------------------------------------------------------------------------------------------------------
-- 47. ����� ������ �� �����
--     ���� ��� ����� �� ���� ������ ���� ���� ������� �������� ��� ����
--     ���� ���� ������ ���� ����, �� �����, ���� ������ ������ �� ������� ���� ���� 

SELECT TOP 5 Cus.CustomerID,
             Cus.CompanyName,
	         COUNT(Ord.OrderID) AS [Count Order],
	         ROW_NUMBER() OVER (ORDER BY COUNT(Ord.OrderID) DESC) AS 'Rank'
FROM Customers Cus INNER JOIN Orders Ord
ON Cus.CustomerID = Ord.CustomerID
GROUP BY Cus.CustomerID, Cus.CompanyName
ORDER BY COUNT(Ord.OrderID) DESC;
------------------------------------------------------------------------------------------------------------------
-- 48. ��� �� �� ���� ������� ������ ������� ������ �� ����� ��� CHANG
--     ��� 2 �����

-- ��� ������: EXISTS
SELECT Pro.ProductName, Pro.UnitPrice
FROM Products Pro
WHERE EXISTS (SELECT 1,2
              FROM Products Pro1
			  WHERE Pro1.ProductName = 'CHANG' AND Pro.UnitPrice > Pro1.UnitPrice);

-- ��� ����: SUBQUERY
SELECT ProductName,
       UnitPrice
FROM Products
WHERE UnitPrice > (SELECT UnitPrice
                   FROM Products
                   WHERE ProductName = 'CHANG');
------------------------------------------------------------------------------------------------------------------
--49. �� �� �� �� ����� ������� ��� ����� ���� ������ ���� ���� ������ �� ���� ���� 6
--    ��� 2 �����

-- ��� ������: EXISTS
SELECT Pro.ProductName,
       Pro.UnitPrice
FROM Products Pro
WHERE EXISTS (SELECT 1,2 
              FROM Products Pro1
			  WHERE Pro1.ProductID = 6 AND Pro.UnitPrice > Pro1.UnitPrice);

-- ��� ����: SUBQUERY
SELECT Pro.ProductName,
       Pro.UnitPrice
FROM Products Pro
WHERE Pro.UnitPrice > ( SELECT Pro.UnitPrice 
                        FROM Products Pro 
						WHERE Pro.ProductID = 6);
------------------------------------------------------------------------------------------------------------------
-- 50. ��� ����� ������ �� �� ����� 
--     �� ����, ���� ����� ���� �� ������� ������ ���� ������ ����� �������� ���� 52.

SELECT Pro.ProductName,
       Pro.SupplierID,
       Pro.UnitPrice
FROM Products Pro 
WHERE Pro.UnitPrice > (SELECT MAX(UnitPrice)-52
                          FROM Products)
------------------------------------------------------------------------------------------------------------------
-- 51. ���� �� �� ���� ������� ������ ���� ����� ���� ���� 8 

(SELECT UnitPrice
FROM Products
WHERE ProductID = 8)

SELECT ProductName
FROM Products
WHERE UnitPrice > (SELECT UnitPrice
                   FROM Products
                   WHERE ProductID = 8);
------------------------------------------------------------------------------------------------------------------
-- 52. ���� �� �� ���� ������� ������ ���� ���� ������ �� ����� ������

SELECT AVG(UnitPrice)
FROM Products

SELECT ProductName, 
       UnitPrice
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice)
                   FROM Products);
------------------------------------------------------------------------------------------------------------------
-- 53. ���� �� �� ���� ������� ������ ���� �������� ��������� ������ 8 

SELECT Pro.UnitPrice
FROM Products Pro
WHERE CategoryID = 8

SELECT Pro.ProductName,
       Pro.UnitPrice
FROM Categories Cat INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
WHERE Pro.UnitPrice IN (SELECT Pro.UnitPrice
                        FROM Products Pro
                        WHERE CategoryID = 8);
------------------------------------------------------------------------------------------------------------------
-- 54. ��� �� �� ������� ������ ���� ������ ����� �������� �������� 8

SELECT Pro.UnitPrice
FROM Products Pro
WHERE CategoryID = 8

SELECT Pro.ProductName,
       Pro.UnitPrice
FROM Categories Cat INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
WHERE Pro.UnitPrice >ALL (SELECT Pro.UnitPrice
                        FROM Products Pro
                        WHERE CategoryID = 8);
------------------------------------------------------------------------------------------------------------------
-- 55.�� �� �� ���� ������� ��� ���� ��� ���� ����� �����

(SELECT OrderID,
       SUM(Quantity) AS [Sum Quantity]
FROM [Order Details]
GROUP BY OrderID) AS [Quantity Sum]


SELECT MIN([Quantity Sum].[Sum Quantity]) AS [Min Quantity]
FROM (SELECT OrderID,
             SUM(Quantity) AS [Sum Quantity]
      FROM [Order Details]
      GROUP BY OrderID) AS [Quantity Sum]
------------------------------------------------------------------------------------------------------------------
-- 56. ���� ����� ��������� ����� ���� �� ����� ������ ������
--     ���� ��� ����� �� ������ �����
--     ���� ����, ���� �����, ���� ��� ����� ����� ������ ������
--     ����� ����� ���� ����� ����� ����� ��� Service Quality ����� ���� ������ ���� ��������
--     ����� ����� ��� ����� ������ ������ ������ ���� �3 ���� ����� Bad services
--     ��� �� ���� �3 ���� ����� Good services
--     ��� ����� No relevant

SELECT Ordeta.ProductID,
       Ord.OrderID,
	   DATEDIFF(DAY, Ord.OrderDate, Ord.ShippedDate) AS [Diff Between Ord To Shipp],
	   CASE WHEN DATEDIFF(DAY, Ord.OrderDate, Ord.ShippedDate) > 3 THEN 'Bad services'
	        WHEN DATEDIFF(DAY, Ord.OrderDate, Ord.ShippedDate) <= 3 THEN 'Good services'
			ELSE 'No relevant'
	   END AS [Service Quality]
FROM Orders Ord INNER JOIN [Order Details] Ordeta
ON Ord.OrderID = Ordeta.OrderID;
------------------------------------------------------------------------------------------------------------------
-- 57. ������� ������� ��� ������� ����� ������ ����� ����� ����
--     ����� ��� ����� �� ���� ������, ������ ������, ����� ����� ��� DayOfWeek ������ �� ������� ��� ���� ����� ���� �����
--     �� ���� �� ��� ����� Weekend 
--     �� ���� ���� ����� Weekday

SELECT Ordeta.ProductID,
       Ord.OrderID,
       Ordeta.UnitPrice *  Ordeta.Quantity AS [Revenues],
	   Ord.OrderDate,
	   DATEPART(D,Ord.OrderDate) AS [Day],
	   CASE WHEN DATEPART(weekday,Ord.OrderDate) IN (1,2,3,4,5) THEN 'Weekday'
	        ELSE 'Weekend'
	   END AS [Day Of Week]
FROM Orders Ord INNER JOIN [Order Details] Ordeta
ON Ord.OrderID = Ordeta.OrderID;
------------------------------------------------------------------------------------------------------------------
-- 58. ���� ������ ������ 5 ������� �������� ������ ����� (���� ����� * ����) ���� �� �������            !!!
--     ��� �� ������� ������ �����

SELECT Cat.CategoryName,
       Z.ProductName, 
	   Revenue
FROM 
(
      SELECT Pro.CategoryID,
             Pro.ProductName,
			 SUM(Ordeta.UnitPrice * Ordeta.Quantity) AS [Revenue],
		     ROW_NUMBER() OVER (PARTITION BY Pro.CategoryID ORDER BY SUM(Ordeta.UnitPrice * Ordeta.Quantity) DESC) AS [ROW]
      FROM Products Pro INNER JOIN [Order Details] Ordeta
	  ON Pro.ProductID = Ordeta.ProductID
	  GROUP BY Pro.CategoryID, Pro.ProductName
) AS Z
INNER JOIN Categories Cat 
ON Z.CategoryID = Cat.CategoryID
WHERE [ROW] <= 5
ORDER BY Cat.CategoryName;                                                                                  -- !!!
------------------------------------------------------------------------------------------------------------------
-- 59. ���� ������ ������ ������ ������ ���� �� ��� 
--     ����� ����� ����� ������ ����� ����� * ���� ���� �� ��� �����

SELECT YEAR(OrderDate) AS [Year of Order],
       SUM(Ordeta.UnitPrice * Ordeta.Quantity) AS [Revenue]
FROM Orders Ord INNER JOIN [Order Details] Ordeta
ON Ord.OrderID = Ordeta.OrderID
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate);
------------------------------------------------------------------------------------------------------------------
-- 60. ���� ������ ������ ������ ������ (���� ����� * ����) ��� ���� ���� �� ���                          !!!

-- ��� ������: SUBQUERY

SELECT YEAR(Ord.OrderDate) AS [Year],
       MONTH(Ord.OrderDate) AS [Month],
	   SUM(Ordeta.UnitPrice * Ordeta.Quantity) AS [Revenue]
FROM Orders Ord INNER JOIN [Order Details] Ordeta
ON Ord.OrderID = Ordeta.OrderID
GROUP BY Ord.OrderDate 
ORDER BY YEAR(Ord.OrderDate), MONTH(Ord.OrderDate)
---------------------
SELECT [Order Year],
       [Order Month],
	   [Total Revenue]
FROM 
(
      SELECT YEAR(Ord.OrderDate) AS [Order Year],
             MONTH(Ord.OrderDate) AS [Order Month],
	         SUM(Ordeta.UnitPrice * Ordeta.Quantity) AS [Total Revenue]
      FROM Orders Ord INNER JOIN [Order Details] Ordeta
      ON Ord.OrderID = Ordeta.OrderID
      GROUP BY YEAR(Ord.OrderDate),  MONTH(Ord.OrderDate) 
) AS Z
ORDER BY [Order Year], [Order Month]

-- ��� ����: PIVOT

SELECT [Order Year], 
       [1] AS [January Revenue],
       [2] AS [February Revenue],
       [3] AS [March Revenue],
       [4] AS [April Revenue],
       [5] AS [May Revenue],
       [6] AS [June Revenue],
       [7] AS [July Revenue],
       [8] AS [August Revenue],
       [9] AS [September Revenue],
       [10] AS [October Revenue],
       [11] AS [November Revenue],
       [12] AS [December Revenue]
FROM 
(
  SELECT YEAR(Ord.OrderDate) AS [Order Year],  
         MONTH(Ord.OrderDate) AS [Order Month],
         SUM(Ordeta.UnitPrice * Ordeta.Quantity) AS [Total Revenue]
  FROM Orders Ord INNER JOIN [Order Details] Ordeta 
  ON Ord.OrderID = Ordeta.OrderID  
  GROUP BY YEAR(Ord.OrderDate), MONTH(Ord.OrderDate)
) AS [pd]
PIVOT
(
  SUM([Total Revenue])
  FOR [Order Month] IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) AS [Pivot Table]
ORDER BY [Order Year];

-- ��� ������: CTE 

WITH MonthlyRevenueCTE AS (
    SELECT
        YEAR(Ord.OrderDate) AS [Order Year],
        MONTH(Ord.OrderDate) AS [Order Month],
        SUM(Ordeta.UnitPrice * Ordeta.Quantity) AS [Total Revenue]
    FROM Orders Ord
    INNER JOIN [Order Details] Ordeta ON Ord.OrderID = Ordeta.OrderID
    GROUP BY YEAR(Ord.OrderDate), MONTH(Ord.OrderDate)
)

SELECT [Order Year], [Order Month], [Total Revenue]
FROM MonthlyRevenueCTE
ORDER BY [Order Year], [Order Month];                                                                        --!!!
------------------------------------------------------------------------------------------------------------------
-- 61. ���� ������ ������ 3 ������� �� ������ ������ ������ ����� 
--     ����� ����� ����� ����� ������ ����� ���� ����� * ���� ���� �� ������� ������ �� ��� �� ���� 

SELECT TOP 3 Ord.EmployeeID,
             (Emp.FirstName + ' ' + Emp.LastName) AS [Full Name], 
             SUM(Ordeta.UnitPrice * Ordeta.Quantity) [Revenue]
FROM [Order Details] Ordeta RIGHT OUTER JOIN Orders Ord
ON Ordeta.OrderID = Ord.OrderID 
                            INNER JOIN Employees Emp
ON Ord.EmployeeID = Emp.EmployeeID
GROUP BY Ord.EmployeeID, (Emp.FirstName + ' ' + Emp.LastName)
ORDER BY [Revenue] DESC;
------------------------------------------------------------------------------------------------------------------
-- 62. ���� ������ ������ 5 ������� �������� ������ ����� ����� 
--     ����� ����� ������ ����� ���� ����� * ���� ���� �� ������� �� �� ����

SELECT TOP 3 Ord.CustomerID,
             COUNT(Ord.CustomerID) AS [Num Of Orders],
             SUM(Ordeta.UnitPrice * Ordeta.Quantity) [Revenue]
FROM [Order Details] Ordeta RIGHT OUTER JOIN Orders Ord
ON Ordeta.OrderID = Ord.OrderID 
GROUP BY Ord.CustomerID
ORDER BY [Revenue] DESC;
------------------------------------------------------------------------------------------------------------------
-- 63. ���� ������ ������ ����� ������� ����� �� �������� ����

SELECT Cat.CategoryName,
       SUM(Ordeta.UnitPrice * Ordeta.Quantity) / (SELECT SUM(UnitPrice * Quantity) FROM [Order Details]) * 100 AS [% Revenue]
FROM Categories Cat INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
                    INNER JOIN [Order Details] Ordeta
ON Pro.ProductID = Ordeta.ProductID
GROUP BY Cat.CategoryName;
------------------------------------------------------------------------------------------------------------------
-- 64. ���� ������ ������ 3 ������� ������� ����� �� �� ���� ���� �� ������ ������

SELECT TOP 3 Ord.EmployeeID,
             COUNT(Ord.EmployeeID) AS [Num Of Orders],
             SUM(Ordeta.UnitPrice * Ordeta.Quantity) [Revenue]
FROM [Order Details] Ordeta INNER JOIN Orders Ord
ON Ordeta.OrderID = Ord.OrderID 
GROUP BY Ord.EmployeeID
ORDER BY [Num Of Orders] DESC;
------------------------------------------------------------------------------------------------------------------
-- 65. ���� ������ ������ 5 ������� �������� ������� ������� 
--     ������ ������ �� ���� ����� ���� �� ����

SELECT TOP 5 ProductName,
             SUM(Quantity) AS [Quantity Ordered]
FROM Products Pro INNER JOIN [Order Details] Ordeta
ON Pro.ProductID = Ordeta.ProductID
GROUP BY ProductName
ORDER BY SUM(Quantity) DESC;
------------------------------------------------------------------------------------------------------------------
-- 66. ���� ������ ������ 5 ������� �������� ������� ������� 
--     ��� ����

WITH ProductSalesByYear AS 
(
  SELECT YEAR(O.OrderDate) AS [Year], 
         OD.ProductID, 
		 P.ProductName, 
		 SUM(OD.Quantity) AS TotalQuantitySold
  FROM Orders O
  INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
  INNER JOIN Products P ON OD.ProductID = P.ProductID
  GROUP BY YEAR(O.OrderDate), OD.ProductID, P.ProductName
)
SELECT [Year], 
       ProductName, 
	   TotalQuantitySold
FROM (
  SELECT [Year], 
         ProductName, 
		 TotalQuantitySold,
         ROW_NUMBER() OVER (PARTITION BY [Year] ORDER BY TotalQuantitySold DESC) AS RowNum
  FROM ProductSalesByYear
) AS RankedSales
WHERE RowNum <= 5
ORDER BY [Year], TotalQuantitySold DESC;
------------------------------------------------------------------------------------------------------------------
-- 67. ���� ������ ������ �������  ������� ������� 
--     ��� ����

SELECT ProductName, 
       [1996] AS [1996 Sales], 
	   [1997] AS [1997 Sales], 
	   [1998] AS [1998 Sales]
FROM (
    SELECT P.ProductName, 
	       YEAR(O.OrderDate) AS OrderYear, 
		   SUM(OD.Quantity) AS TotalQuantitySold
    FROM Products P
    INNER JOIN [Order Details] OD ON P.ProductID = OD.ProductID
    INNER JOIN Orders O ON OD.OrderID = O.OrderID
    WHERE YEAR(O.OrderDate) IN (1996, 1997, 1998) 
    GROUP BY P.ProductName, YEAR(O.OrderDate)
) AS SourceData
PIVOT (
    SUM(TotalQuantitySold)
    FOR OrderYear IN ([1996], [1997], [1998])
) AS PivotTable
ORDER BY ProductName;
------------------------------------------------------------------------------------------------------------------
-- 68. ���� ������ ������ ���� ������� ������� ���� �� ��� 
--     ��� ����� ����� ��� ���� ���� �� ���

SELECT [Order Year],
       [1] AS [January],
	   [2] AS [February],
	   [3] AS [March],
	   [4] AS [April],
	   [5] AS [May],
	   [6] AS [June],
	   [7] AS [July],
	   [8] AS [August],
	   [9] AS [September],
	   [10] AS [October],
	   [11] AS [November],
	   [12] AS [December]
FROM
(
SELECT YEAR(OrderDate) AS [Order Year],
       MONTH(OrderDate) AS [Order Month],
	   SUM(UnitPrice * Quantity) AS [Total Revenues]
FROM Orders O INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY YEAR(OrderDate),  MONTH(OrderDate)
) AS PT
PIVOT 
(
SUM([Total Revenues]) FOR [Order Month] IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) AS [Pivot Table]
ORDER BY [Order Year];
---------------------------------------------------
--��� ����:

SELECT *
FROM 
(
  SELECT DATEPART(yyyy, OrderDate) AS Year, DATENAME(MONTH, OrderDate) AS Month, SUM(OD.UnitPrice * OD.Quantity) AS Revenue
  FROM Orders O INNER JOIN [Order Details] OD
  ON O.OrderID = OD.OrderID
  GROUP BY DATEPART(yyyy, OrderDate), DATENAME(MONTH, OrderDate)  
) src
PIVOT
(
  SUM(Revenue)
  FOR Month IN ([January], [February], [March], [April], [May], [June], 
               [July], [August], [September], [October], [November], [December])
) piv;
------------------------------------------------------------------------------------------------------------------
-- 69. ��� 5 ������� ������� ����� �� �� ����?

SELECT TOP 5 ProductName,
             SUM(Quantity) AS [Quantity]
FROM Products P INNER JOIN [Order Details] OD
ON P.ProductID = OD.ProductID
GROUP BY ProductName
ORDER BY SUM(Quantity) DESC;
------------------------------------------------------------------------------------------------------------------
-- 70. ��� 5 ������� �� ������� ������� ����� �� �� ���� ����?

SELECT TOP 5 C.CustomerID,
             SUM(OD.UnitPrice * OD.Quantity) AS [Total Purchases]
FROM Customers C RIGHT OUTER JOIN Orders O 
ON C.CustomerID = O.CustomerID
                 INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY C.CustomerID
ORDER BY SUM(OD.UnitPrice * OD.Quantity) DESC;
------------------------------------------------------------------------------------------------------------------
-- 71. ��� ����� ���� ������� ��� ����? �� �� ���� �� ������ ������ ������� �� ������?

SELECT C.CustomerID,
       AVG(OD.UnitPrice * OD.Quantity) AS [AVG Purchases]
FROM Customers C RIGHT OUTER JOIN Orders O 
ON C.CustomerID = O.CustomerID
                 INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY C.CustomerID
ORDER BY AVG(OD.UnitPrice * OD.Quantity) DESC;
------------------------------------------------------------------------------------------------------------------
-- 72. ��� �� ������� ���� �� ���� ��������? ���� ���� ����� �� ������ ������� �����? ���� ���� ���� ���� ��?

SELECT ShipCountry,
       SUM(UnitPrice * Quantity) AS [Total Sales]
FROM Orders O INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY ShipCountry
ORDER BY SUM(UnitPrice * Quantity) DESC;
------------------------------------------------------------------------------------------------------------------
-- 73. ��� 3 ������ �� ���� ������� ������ ����� �����? ��� �� ���� ��� ����� ��� �� ��� ����� ���� ���?

SELECT CompanyName,
       SUM(UnitsInStock) AS [Sum Units In Stock]
FROM Suppliers S INNER JOIN Products P
ON S.SupplierID = P.SupplierID
GROUP BY CompanyName
ORDER BY  SUM(UnitsInStock) DESC;
------------------------------------------------------------------------------------------------------------------
-- 74. ��� ���� ��� ����� ������ ������ ������ ������? ��� ������ ������� ������ ������?

SELECT OrderID,
       AVG(DATEDIFF(DAY, OrderDate, ShippedDate)) AS [AVG Days Between Order to Ship]
FROM Orders
WHERE ShippedDate IS NOT NULL 
GROUP BY OrderID
ORDER BY AVG(DATEDIFF(DAY, OrderDate, ShippedDate)) DESC
------------------------------------------------------------------------------------------------------------------
-- 75. ��� 3 ������� ��� ��������� (�� ������� ������� �����) �������� ������?

WITH CTE AS
(
SELECT C.CategoryName,
       P.ProductName,
       SUM(OD.UnitPrice * OD.Quantity) AS [Revenues],
	   ROW_NUMBER() OVER (PARTITION BY C.CategoryName ORDER BY SUM(OD.UnitPrice * OD.Quantity) DESC) AS [ROW]
FROM Categories C INNER JOIN Products P
ON C.CategoryID = P.CategoryID
                  INNER JOIN [Order Details] OD
ON P.ProductID = OD.ProductID
GROUP BY C.CategoryName, P.ProductName
)
SELECT CategoryName,
       ProductName,
	   [Revenues],
	   [ROW]
FROM CTE
WHERE [ROW] <= 3
ORDER BY CategoryName, [Revenues] DESC;
------------------------------------------------------------------------------------------------------------------
-- 76. ��� ����� ������� ������� �� �� �����? ���� ������ ���� ����� ������� ���?

SELECT SUM(OD.UnitPrice * OD.Quantity) AS [Revenues],
       YEAR(O.OrderDate) AS [Year],
       DATEPART(Quarter, O.OrderDate) AS [Quarter]
FROM Orders O INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY YEAR(O.OrderDate), DATEPART(Quarter, O.OrderDate)
ORDER BY YEAR(O.OrderDate), DATEPART(Quarter, O.OrderDate)
------------------------------------------------------------------------------------------------------------------
-- 77. ��� �� �� ������� ��� ���? ��� ����� ���� ����� �� ����� ������� ����� ���?

SELECT YEAR(O.OrderDate) AS [Year],
       SUM(OD.UnitPrice * OD.Quantity) AS [Revenues]
FROM Orders O INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY YEAR(O.OrderDate)
ORDER BY YEAR(O.OrderDate)
------------------------------------------------------------------------------------------------------------------
-- 78. ��� ���� �������� ����� ������ ��������? ��� ������� ������ �������� ������ ������?

SELECT YEAR(O.OrderDate) AS [Year],
       SUM(OD.UnitPrice * OD.Quantity * OD.Discount) AS [Sum of Discounts],
       SUM(OD.UnitPrice * OD.Quantity) AS [Revenues],
       SUM(OD.UnitPrice * OD.Quantity * OD.Discount) / SUM(OD.UnitPrice * OD.Quantity) * 100  AS [% of Discounts]
FROM Orders O INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY YEAR(O.OrderDate)
ORDER BY YEAR(O.OrderDate);
------------------------------------------------------------------------------------------------------------------
-- 79. �� ��� ��� ������ ���� ���� �����?

WITH CTE AS
(
  SELECT 
    CustomerID,
    OrderDate,
    LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS [Previous Order Date]
  FROM Orders
)
SELECT
  CustomerID,
  COUNT(OrderDate) AS [Number Of Orders],
  AVG(DATEDIFF(DAY, [Previous Order Date], OrderDate)) AS [Avg Days Between Orders]
FROM CTE
WHERE [Previous Order Date] IS NOT NULL
GROUP BY CustomerID
ORDER BY AVG(DATEDIFF(DAY, [Previous Order Date], OrderDate));
------------------------------------------------------------------------------------------------------------------
-- 80. ��� 3 ������� ��� ������ ��� ���� �������� 

WITH [Highest 3 Customers Sales By Country] AS
(
SELECT C.Country,
       C.CustomerID,
	   COUNT(O.OrderID) AS [Num of Orders],
	   SUM(OD.UnitPrice * OD.Quantity) AS [Total Orders],
	   ROW_NUMBER() OVER (PARTITION BY C.Country ORDER BY SUM(OD.UnitPrice * OD.Quantity) DESC) AS [ROW]
FROM Customers C INNER JOIN Orders O 
ON C.CustomerID = O.CustomerID
                 INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY C.Country, C.CustomerID
) 
SELECT Country,
       CustomerID,
	   [Num of Orders],
	   [Total Orders],
	   [ROW]
FROM [Highest 3 Customers Sales By Country] 
WHERE [ROW] <= 3
ORDER BY Country, [Total Orders] DESC;
------------------------------------------------------------------------------------------------------------------
-- 81. ��� ������� ��� ���� �������� 

SELECT C.Country,
       C.CustomerID,
	   COUNT(O.OrderID) AS [Num of Orders],
	   SUM(OD.UnitPrice * OD.Quantity) AS [Total Orders],
	   ROW_NUMBER() OVER (PARTITION BY C.Country ORDER BY SUM(OD.UnitPrice * OD.Quantity) DESC) AS [ROW]
FROM Customers C INNER JOIN Orders O 
ON C.CustomerID = O.CustomerID
                 INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY C.Country, C.CustomerID
ORDER BY  C.Country, SUM(OD.UnitPrice * OD.Quantity) DESC;
------------------------------------------------------------------------------------------------------------------