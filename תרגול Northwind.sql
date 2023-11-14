USE Northwind;
------------------------------------------------------------------------------------------------------------------
--1.הצג את שמות כל הלקוחות מהטבלה Customers

SELECT customerID AS 'CustomerName' 
FROM customers;
------------------------------------------------------------------------------------------------------------------
--2.סנן את הטבלה Products והצג רק מוצרים עם UnitsInStock גדול מ-10

SELECT * 
FROM products
WHERE unitsinstock > 10;
------------------------------------------------------------------------------------------------------------------
--3.הצג את העמודות ProductName ו-UnitPrice מהטבלה Products ממוינים בסדר עולה לפי מחיר

SELECT ProductName, 
       UnitPrice 
FROM Products
ORDER BY unitprice DESC;
------------------------------------------------------------------------------------------------------------------
--4.ספור כמה הזמנות יש בטבלה Orders עבור כל שנה

SELECT YEAR(orderdate) AS 'YearOfOrder', 
       COUNT(*) 'Orders'
FROM Orders
GROUP BY YEAR(orderdate);
------------------------------------------------------------------------------------------------------------------
--5.מצא את ההזמנה עם המחיר הכולל (Quantity * UnitPrice) הגבוה ביותר  

SELECT TOP 1 OrderID, 
             (UnitPrice * Quantity) AS 'TotalPrice'
FROM [Order Details]
ORDER BY TotalPrice DESC;
------------------------------------------------------------------------------------------------------------------
--6.הצג עבור כל לקוח את מספר ההזמנות שלו ואת סכום ההזמנות שלו

SELECT Cust.customerID , 
       COUNT(orders.orderID) AS 'NubersOfOrders', 
	   SUM(odeta.unitprice*odeta.quantity) AS 'TotalOrdersValue'
FROM Customers Cust LEFT OUTER JOIN orders  
ON Cust.customerID = Orders.customerID
                    LEFT OUTER JOIN [Order Details] odeta
ON odeta.[OrderID] = Orders.[OrderID] 
GROUP BY Cust.customerID;
------------------------------------------------------------------------------------------------------------------
--7.מצא מוצרים שלא הוזמנו מעולם

SELECT Pro.ProductID, 
       Pro.ProductName
FROM Products Pro LEFT JOIN [Order Details] OD 
ON Pro.ProductID = OD.ProductID
WHERE OD.ProductID IS NULL;
------------------------------------------------------------------------------------------------------------------
--8.מצא את הקטגוריות עם המספר הרב ביותר של מוצרים בהן  

SELECT Cat.CategoryName, 
       COUNT(Pro.ProductName) AS 'CountsOfProducts'
FROM Categories Cat INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
GROUP BY Cat.CategoryName;
------------------------------------------------------------------------------------------------------------------
--9.מצא לקוחות ללא הזמנות 

SELECT Cus.CustomerID, 
       Ord.OrderID
FROM Customers Cus LEFT OUTER JOIN Orders Ord 
ON Cus.CustomerID = Ord.CustomerID
WHERE Ord.OrderID  IS NULL;
------------------------------------------------------------------------------------------------------------------
--10.מצא את ההפרש בימים בין ההזמנה הראשונה לאחרונה עבור כל לקוח 

SELECT Cus.CustomerID, 
       DATEDIFF(DAY,MIN(Ord.orderdate), MAX(Ord.orderdate)) AS 'DaysBetweenFirstAndLastOrder'
FROM Customers Cus INNER JOIN Orders Ord
ON Cus.CustomerID = Ord.CustomerID
GROUP BY Cus.CustomerID;
------------------------------------------------------------------------------------------------------------------
--11. מהו מספר ההזמנות לכל לקוח בשנה האחרונה?

SELECT cus.CustomerID, 
       COUNT(ord.OrderID) AS 'OrdersPerCustomerLastYear'
FROM customers cus INNER JOIN orders ord
ON cus.CustomerID = ord.CustomerID
WHERE YEAR(ord.orderdate) IN (SELECT TOP 1 YEAR(orderdate) FROM orders ORDER BY orderdate DESC)
GROUP BY cus.CustomerID;
------------------------------------------------------------------------------------------------------------------
--12.איזה מוצר נמכר בכמות הגדולה ביותר בקטגוריית 'Seafood'?

SELECT cat.categoryname, 
       MAX(pro.productName) AS 'MaxSelasInSeaFood', 
	   COUNT(pro.productName) AS 'CountOfMaxProduct'
FROM Categories cat LEFT OUTER JOIN products pro
ON  cat.CategoryID = pro.CategoryID
WHERE cat.categoryname = 'SeaFood'
GROUP BY cat.categoryname;
------------------------------------------------------------------------------------------------------------------
--13.איזה לקוח ביצע את ההזמנה הגדולה ביותר (בערך כספי כולל) בשנה האחרונה?

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
--14. הצג את שמות הלקוחות שעשו יותר מ-2 הזמנות.

SELECT CustomerID
FROM Customers
WHERE CustomerID IN (SELECT CustomerID 
                      FROM Orders 
					  GROUP BY CustomerID 
					  HAVING COUNT(*) > 2);
------------------------------------------------------------------------------------------------------------------
--15.הצג את שמות המוצרים שנמכרו יותר מ-100 יחידות בסך הכל.

SELECT ProductName, 
       SUM(Quantity) AS 'SumQuantity'
FROM Products Pro INNER JOIN [Order Details] Ordeta
ON Pro.ProductID = Ordeta.ProductID
WHERE  Quantity > 100
GROUP BY ProductName;
------------------------------------------------------------------------------------------------------------------
--16.מיין את העובדים בסדר עולה לפי מספר ההזמנות שטיפלו בהן.

SELECT Employees.EmployeeID, 
       Employees.FirstName, 
	   Employees.LastName, 
	   COUNT(Orders.OrderID) AS NumOrders
FROM Employees INNER JOIN Orders 
ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.EmployeeID, Employees.FirstName, Employees.LastName
ORDER BY NumOrders ASC;
------------------------------------------------------------------------------------------------------------------
--17.הצג את ההזמנה הכי גדולה (במספר פריטים) שבוצעה עבור כל לקוח.                                           !!!

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
--18. כמה לקוחות קיימים מכל מדינה.

SELECT Country, 
       Count(CustomerID) AS 'CustomersPerCountry'
FROM CUSTOMERS
GROUP BY Country;
------------------------------------------------------------------------------------------------------------------
--19.מיין את הקטגוריות בסדר יורד לפי המכירות הממוצעות שלהן.

SELECT Cat.CategoryName, 
       AVG(Ordeta.unitprice * Ordeta.quantity) AS 'TotalPrice'
FROM Categories Cat INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
                    INNER JOIN [Order Details] Ordeta
ON Ordeta.ProductID = Pro.ProductID
GROUP BY Cat.CategoryName
ORDER BY TotalPrice DESC;
------------------------------------------------------------------------------------------------------------------
--20. חברת שליחויות בודקת את כדאיות המוצרים שלה,
-- שזה בחינת כדאיות [feasibility study]תבנה עבור החברה דוח המציג את שם הקטגוריה, שם המוצר, מחיר המוצר, ועמודה נוספת בשם 
-- במידה והמוצר גדול מ10 תחזיר את הערך 'A Product Worth Producting'
-- במידה והמחיר קטן מ10 תחזיר את הערך 'A Product is not worth producting'
-- במידה ומתקבל ערך אחר (שווה ל10) תחזיר לי את הערך 'A re-examination is required'

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
--21.  SAVEA בשליפה אחת בלבד! - תייצר דוח שמציג את כמות הזמנות ללקוח בשם  
-- בשנים 1994 ו 1997 בלבד
--תיצר דוח שמציג את כמות הזמנות שלו בשנים 1997 ו 1998 בלבד  ERNSH וללקוח בשם 

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
-- 22. דוח המציג לפי תאריך וסדר סידורי רץ את מספר הזמנה, תאריך הזמנה, מספר לקוח וכמה הזמנות יש עבור כל לקוח.

SELECT Cus.CustomerID, 
       Ord.OrderID, 
	   Ord.OrderDate,
       ROW_NUMBER() OVER (PARTITION BY Cus.CustomerID ORDER BY Ord.OrderDate) AS 'Row'
FROM Orders Ord INNER JOIN Customers Cus
ON Ord.CustomerID = Cus.CustomerID;
------------------------------------------------------------------------------------------------------------------
-- 23. Seafood הצג את שמות החברות מטבלת הספקים המספקות מוצרים מקטגוריית 

SELECT Supp.CompanyName, 
       Pro.ProductName, 
	   CategoryName
FROM Suppliers Supp INNER JOIN Products Pro
ON Supp.SupplierID = Pro.SupplierID
                     INNER JOIN Categories Cat
ON Cat.CategoryID = Pro.CategoryID
WHERE CategoryName = 'Seafood';
------------------------------------------------------------------------------------------------------------------
-- 24. הציג את שמות הקטגוריות שבהם יש יותר מוצרים ממספר העובדים בחברת השליחויות 

-- כמה עובדים יש
SELECT COUNT(*) AS 'NumOfEmployees'
FROM employees;
--------------------------
-- כמה מוצרים יש לכל קטגוריה
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
-- 25. מהם שמות שלושת הקטגוריות שבהם סכום מחיר המוצרים הינו הגדול ביותר
-- בסדר יורד מהקטגוריה הנמכרת ביותר עד השלישית הנמכרת   

--שמות שלושת הקטגוריות
--סכום מחיר המוצרים
--הגדול ביותר
--בסדר יורד
--עד השלישית הנמכרת

SELECT TOP 3 Cat.CategoryName, 
             SUM(Pro.UnitPrice) AS 'TotalPrice'
FROM Categories Cat INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
GROUP BY Cat.CategoryName
ORDER BY SUM(Pro.UnitPrice) DESC;
------------------------------------------------------------------------------------------------------------------
-- 26. כמה הזמנות יש לשלושת העובדים שלהם יש הכי הרבה הזמנות בחודשים מרץ ויולי בלבד

--כמה הזמנות
--לשלושת העובדים
--הכי הרבה הזמנות
--בחודשים מרץ ויולי בלבד

SELECT TOP 3 (Emp.FirstName + ' ' + Emp.LastName) AS 'FullName', 
             COUNT(Ord.OrderID) AS 'NumOfOrders'
FROM Orders Ord INNER JOIN Employees Emp
ON Ord.EmployeeID = Emp.EmployeeID
WHERE MONTH(OrderDate) IN (3,7) 
GROUP BY (Emp.FirstName + ' ' + Emp.LastName)
ORDER BY COUNT(Ord.OrderID) DESC;
------------------------------------------------------------------------------------------------------------------
--27. תציג לי את שמות העובדים המלאים בעמודה אחת 
-- שתאריך תחילת ההעסקה שלהם בחברת השליחויות מאוחר יותר משלושת העובדים הראשונים.

SELECT FirstName + ' ' + LastName AS 'FullNmae', 
       HireDate
FROM Employees
WHERE HireDate >ALL (SELECT TOP 3 HireDate FROM Employees GROUP BY HireDate ORDER BY HireDate);
------------------------------------------------------------------------------------------------------------------
--28.יש למיין את תאריך תחילת העבודה של העובדים מתאריך המאוחר ביותר לקרוב ביותר

SELECT HireDate 
FROM Employees 
ORDER BY HireDate DESC;
------------------------------------------------------------------------------------------------------------------
--29.תציג ב2 עמודות את שמות הערים שהעובדים גרים בהם וכמה עובדים יש בכל עיר

SELECT City, 
       COUNT(City) AS 'NumOfEmployeesFromCity'
FROM Employees
GROUP BY City;
------------------------------------------------------------------------------------------------------------------
--30.תציג את כמות ההזמנות לפי שנת הזמנה

SELECT YEAR(OrderDate) AS 'YearOfOrder', 
       COUNT(OrderID) AS 'NumOfOrders'
FROM Orders
GROUP BY YEAR(OrderDate);
------------------------------------------------------------------------------------------------------------------
--31. יש לשלוף את כמות ההזמנות של 2 העובדים שהזמינו הכי הרבה 

SELECT TOP 2 EmployeeID, 
             COUNT(OrderID) AS 'NumOfOrders'
FROM Orders 
GROUP BY EmployeeID 
ORDER BY COUNT(OrderID) DESC;
-----------------------------
--31.2. יש לשלוף את כמות ההזמנות והשם המלא של העובד שהזמין הכי הרבה 

SELECT Emp.EmployeeID, Emp.FirstName + ' ' + Emp.LastName AS 'FullName', 
       COUNT(Ord.OrderID) AS 'NumOfOrders'
FROM Orders Ord RIGHT OUTER JOIN Employees Emp
ON Ord.EmployeeID = Emp.EmployeeID
GROUP BY Emp.EmployeeID, Emp.FirstName + ' ' + Emp.LastName
ORDER BY COUNT(OrderID) DESC;
------------------------------------------------------------------------------------------------------------------
--32. תייצרו טבלה בשם department_budget עם העמודות הבאות:
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
--33. הצג את שמות הלקוחות שהזמינו את מוצר מספר 11 בחודשים פברואר ומרץ בלבד

SELECT Cus.CompanyName, 
       Ordeta.ProductID
FROM Customers Cus INNER JOIN Orders Ord
ON Cus.CustomerID = Ord.CustomerID
                   INNER JOIN [Order Details] Ordeta
ON Ord.OrderID = Ordeta.OrderID
WHERE ProductID = 11 AND MONTH(OrderDate) IN (2,3);
------------------------------------------------------------------------------------------------------------------
--34. הצג את השם המלא של העובדים בעמודה אחת
-- ובעמודה שנייה הצג את הכמות הזמנות שלהם בחודשים מרץ ויולי.

SELECT (Emp.FirstName + ' ' + Emp.LastName) AS 'FullName', 
       COUNT(Ord.OrderID) AS 'NumOfOrders'
FROM Employees Emp INNER JOIN Orders Ord
ON Emp.EmployeeID = Ord.EmployeeID
WHERE MONTH(OrderDate) IN (3,7)
GROUP BY (Emp.FirstName + ' ' + Emp.LastName);
------------------------------------------------------------------------------------------------------------------
-- 35. כתוב שאילתא ששולפת את שלושת העובדים שהזמינו הכי הרבה הזמנות

SELECT TOP 3 (FirstName + ' ' + LastName) AS 'FullName', 
             COUNT(OrderID) AS 'NumOfOrders'
FROM Employees Emp INNER JOIN Orders Ord
ON Emp.EmployeeID = Ord.EmployeeID
GROUP BY (FirstName + ' ' + LastName)
ORDER BY COUNT(OrderID) DESC;
------------------------------------------------------------------------------------------------------------------
-- 36. תכתוב שאילתא שמראה כמה הזמנות יש לכל עובד בחודש פברואר ומרץ בלבד

SELECT (FirstName + ' ' + LastName) AS 'FullName', 
       COUNT(OrderID) AS 'NumOfOrders'
FROM Employees Emp INNER JOIN Orders Ord
ON Emp.EmployeeID = Ord.EmployeeID
WHERE MONTH(OrderDate) IN (2,3)
GROUP BY (FirstName + ' ' + LastName);
------------------------------------------------------------------------------------------------------------------
-- 37. עובד מספר 2 עזב את הארגון אנא תמחקו את השורה שלו באמצעות DELETE.

DELETE Employees
WHERE EmployeeID = 2;
------------------------------------------------------------------------------------------------------------------
-- 38.כמה הזמנות יש לכל לקוח בכל עיר                                                                         !!!
--   , כמה הזמנות יש לכל לקוח בכל מדינה
--   , כמה סהכ הזמנות יש
--   , יש לענות על שאלות 38-40 שהזמנות מתייחסות לבעלי החברה
--   . יש לענות על הסעיפים הקודמים בשליפה אחת בלבד

SELECT Cus.Country, 
       Cus.City, 
	   COUNT(Ord.OrderID) AS 'NumOfOrders'
FROM Customers Cus INNER JOIN Orders Ord
ON Cus.CustomerID = Ord.CustomerID
WHERE Cus.ContactTitle = 'Owner'
GROUP BY  GROUPING SETS (Cus.Country, Cus.City, ());                                                        -- !!!
------------------------------------------------------------------------------------------------------------------
-- 39. כמה הזמנות יש כל שנה
--     כמה הזמנות יש כל חודש
--     כמה הזמנות הוזמנו מתחילת הפעילות 
--     התייחסו לסעיפים הקודמים לחודשי מאי ויולי בלבד
--     כמה הזמנות היו בחודשים של סעיף קודם
--     הכל בשליפה אחת

SELECT YEAR(OrderDate) AS 'YEAR', 
       MONTH(OrderDate) AS 'MONTH', 
	   COUNT(OrderID) AS 'NumOfOrders'
FROM Orders
WHERE MONTH(OrderDate) IN (5,7)
GROUP BY GROUPING SETS ( YEAR(OrderDate), MONTH(OrderDate), ());
------------------------------------------------------------------------------------------------------------------
-- 40. המציג את מספר המוצר[Order Details] תייצר דוח מטבלת 
--     REVENUSE ואת כמות ההכנסות ממכירות בשדה בשם 
--     שבו מוצג בכל שורה מידע צוברREVENUSEֹֹ_TOTAL בנוסף תייצר שדה נוסף בשם
--     יש למיין את הדוח לפי מספר המוצר בסדר עולה

SELECT ProductID,
       (UnitPrice * Quantity) AS 'REVENUSE',
	   SUM(UnitPrice * Quantity) OVER (PARTITION BY ProductID ORDER BY ProductID
	   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 'REVENUSEֹֹ_TOTAL'
FROM [Order Details];
------------------------------------------------------------------------------------------------------------------
-- 41. המציג את מספר המוצר[Order Details] תייצר דוח מטבלת 
--     PROFIT ואת כמות הרווחים ממכירות בשדה בשם 
--     שבו מוצג בכל שורה מידע צוברPROFITֹֹ_TOTAL בנוסף תייצר שדה נוסף בשם
--     יש למיין את הדוח לפי מספר המוצר בסדר עולה
 
 SELECT ProductID,
        CASE WHEN Discount > 0 THEN (UnitPrice * Quantity * (1-Discount)) 
		     WHEN Discount = 0 THEN (UnitPrice * Quantity) 
	    END AS 'PROFIT',
	    SUM(CASE WHEN Discount > 0 THEN (UnitPrice * Quantity * (1-Discount)) 
		    WHEN Discount = 0 THEN (UnitPrice * Quantity) 
	    END) OVER (PARTITION BY ProductID ORDER BY ProductID 
	    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 'PROFITֹֹ_TOTAL'
FROM [Order Details];
---------------------
SELECT ProductID,
        (UnitPrice * Quantity * (1-Discount)) AS 'PROFIT',
	    SUM((UnitPrice * Quantity * (1-Discount))) OVER (PARTITION BY ProductID ORDER BY ProductID 
	    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 'PROFITֹֹ_TOTAL'
FROM [Order Details];
------------------------------------------------------------------------------------------------------------------
-- 42. תציג דוח המציג את שם הקטגוריה, שם המוצר, מחיר המוצר
--     מחיר המוצר הבא אחריו ומחיר המוצר הבא לפניו
--     יש למיין את המחיר לפי סדר עולה 

SELECT Cat.CategoryName, 
       Pro.ProductName, 
       Pro.UnitPrice,
	   LAG(Pro.UnitPrice) OVER (ORDER BY Pro.UnitPrice) AS 'LastPrice',
	   LEAD(Pro.UnitPrice) OVER (ORDER BY Pro.UnitPrice) AS 'NextPrice'
FROM Categories Cat INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
ORDER BY Pro.UnitPrice;
------------------------------------------------------------------------------------------------------------------
-- 43. -- חברה מבקשת לדעת מה סכום הרווחים של הארגון מהזמנות שיצאו בחודשים
-- [september] [august] [july] 
-- בחלוקה של שנים לצורך השוואה
-- אופן הצגה של הנתונים הינו משמעותי - יש להציג את החודשים בשמות שלהם ואת הרווחים יש להציג ללא נקודה

SELECT *
FROM (SELECT YEAR(Ord.OrderDate) AS 'YearOfOrder',
	   DATENAME(MONTH,Ord.OrderDate) AS 'MonthOfOrder',
	   ROUND(Ordeta.UnitPrice*Ordeta.Quantity*(1-Ordeta.Discount),0) AS 'Profit'
FROM Orders Ord INNER JOIN [Order Details] Ordeta
ON Ord.OrderID = Ordeta.OrderID
WHERE MONTH(Ord.OrderDate) IN (7,8,9)) AS PVIT
PIVOT (SUM(Profit) FOR MonthOfOrder IN ([September], [August], [July])) AS PIVOT1 -- Xציר ה
------------------------------------------------------------------------------------------------------------------
--44. חברת השליחויות רוצה לקבל את המחיר הממוצע של הקטגוריות בארגון
-- ב2 דרכים

--דרך ראשונה: CTE

WITH CTE_Cat
AS (
SELECT Cat.CategoryName, 
       SUM(Pro.UnitPrice) AS [SUM Unit Price]
FROM Categories Cat INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
GROUP BY Cat.CategoryName)

SELECT AVG([SUM Unit Price]) AS [AVG Of Cat]
FROM CTE_Cat;

-- דרך שניה: SUBQUERY

SELECT AVG([SUM Unit Price]) AS [AVG Of Cat]
FROM (SELECT Cat.CategoryName, 
       SUM(Pro.UnitPrice) AS [SUM Unit Price]
FROM Categories Cat INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
GROUP BY Cat.CategoryName) AS [Sum];
------------------------------------------------------------------------------------------------------------------
-- 45. איכות השירות
--     מבקשת למדוד את הפער בין תאריך ההזמנה לתאריך הדרישה של הלקוח לקבל את ההזמנה בימים
--     תיצור עמודה בשם Order demand gap 
--     בנוסף חשוב לחברה לקטלג שירות טוב
--     תיצור עמודה נוספת בשם Business efficiency לפי התנאי הבא:
--     במידה והפער עומד על 20 יום ומעלה - תחזיר Bed service בכל מקרה אחר - תחזיר Good service

--דרך ראשונה: NORMAL

SELECT OrderID,
       DATEDIFF(DAY, OrderDate, RequiredDate) AS [Order demand gap],
       CASE WHEN DATEDIFF(DAY, OrderDate, RequiredDate) >= 20 THEN 'Bed service'
	        ELSE 'Good service'
	   END AS 'Business efficiency'
FROM Orders;
------------------------------------
--דרך שניה: SUBQUERY

(SELECT DATEDIFF(DAY, OrderDate, RequiredDate) AS [Order demand gap]
FROM Orders) AS [gap order]

SELECT [gap order].[Order demand gap] AS [Gap order],
       CASE WHEN [Order demand gap] >= 20 THEN 'Bed service'
	        ELSE 'Good service'
	   END AS 'Business efficiency'
FROM (SELECT DATEDIFF(DAY, OrderDate, RequiredDate) AS [Order demand gap]
FROM Orders) AS [Gap order];
------------------------------------
--דרך שלישית: CTE

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
-- 46. מה המחיר הנמוך והגבוה ביותר של סך המוצרים בקטגוריות שהחברה מוכרת
--     בשליפה אחת

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
-- 47. פילוח לקוחות של החברה
--     תבנה דוח שמציג את כמות הזמנות עבור חמשת הלקוחות שמזמינים הכי הרבה
--     בדוח חשוב שיופיע מספר לקוח, שם החברה, כמות הזמנות ודירוג של הלקוחות בסדר יורד 

SELECT TOP 5 Cus.CustomerID,
             Cus.CompanyName,
	         COUNT(Ord.OrderID) AS [Count Order],
	         ROW_NUMBER() OVER (ORDER BY COUNT(Ord.OrderID) DESC) AS 'Rank'
FROM Customers Cus INNER JOIN Orders Ord
ON Cus.CustomerID = Ord.CustomerID
GROUP BY Cus.CustomerID, Cus.CompanyName
ORDER BY COUNT(Ord.OrderID) DESC;
------------------------------------------------------------------------------------------------------------------
-- 48. הצג את כל שמות המוצרים ומחירם שגדולים מהמחיר של המוצר בשם CHANG
--     הצג 2 דרכים

-- דרך ראשונה: EXISTS
SELECT Pro.ProductName, Pro.UnitPrice
FROM Products Pro
WHERE EXISTS (SELECT 1,2
              FROM Products Pro1
			  WHERE Pro1.ProductName = 'CHANG' AND Pro.UnitPrice > Pro1.UnitPrice);

-- דרך שניה: SUBQUERY
SELECT ProductName,
       UnitPrice
FROM Products
WHERE UnitPrice > (SELECT UnitPrice
                   FROM Products
                   WHERE ProductName = 'CHANG');
------------------------------------------------------------------------------------------------------------------
--49. תן לי את כל השמות המוצרים ואת המחיר שלהם שמחירם גדול יותר מהמחיר של מוצר מספר 6
--    הצג 2 דרכים

-- דרך ראשונה: EXISTS
SELECT Pro.ProductName,
       Pro.UnitPrice
FROM Products Pro
WHERE EXISTS (SELECT 1,2 
              FROM Products Pro1
			  WHERE Pro1.ProductID = 6 AND Pro.UnitPrice > Pro1.UnitPrice);

-- דרך שניה: SUBQUERY
SELECT Pro.ProductName,
       Pro.UnitPrice
FROM Products Pro
WHERE Pro.UnitPrice > ( SELECT Pro.UnitPrice 
                        FROM Products Pro 
						WHERE Pro.ProductID = 6);
------------------------------------------------------------------------------------------------------------------
-- 50. הצג מטבלת מוצרים את שם המוצר 
--     שם הספק, מחיר יחידה עבור כל המוצרים שמחירם גדול מהמחיר המוצר המקסימלי פחות 52.

SELECT Pro.ProductName,
       Pro.SupplierID,
       Pro.UnitPrice
FROM Products Pro 
WHERE Pro.UnitPrice > (SELECT MAX(UnitPrice)-52
                          FROM Products)
------------------------------------------------------------------------------------------------------------------
-- 51. תמצא את כל שמות המוצרים שמחירם גדול ממחיר מוצר מספר 8 

(SELECT UnitPrice
FROM Products
WHERE ProductID = 8)

SELECT ProductName
FROM Products
WHERE UnitPrice > (SELECT UnitPrice
                   FROM Products
                   WHERE ProductID = 8);
------------------------------------------------------------------------------------------------------------------
-- 52. תמצא את כל שמות המוצרים שהמחיר שלהם גדול מהמחיר של המוצר הממוצע

SELECT AVG(UnitPrice)
FROM Products

SELECT ProductName, 
       UnitPrice
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice)
                   FROM Products);
------------------------------------------------------------------------------------------------------------------
-- 53. תמצא את כל שמות המוצרים שמחירם גדול מהמוצרים שבקטגוריה מהמספר 8 

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
-- 54. מצא את כל המוצרים שמחירם גדול מהמחיר המוצר המקסימלי בקטגוריה 8

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
-- 55.תן לי את מספר הפריטים הכי נמוך בכל מספר הזמנה מסוים

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
-- 56. עזור לחברת השליחויות להבין איפה יש בעיות בשרשרת החלוקה
--     תבנה דוח המציג את הפרטים הבאים
--     מספר מוצר, מספר הזמנה, הפער בין תאריך הזמנה לתאריך המשלוח
--     בנוסף תייצר עבור החברה עמודה נוספת בשם Service Quality שתבחן איזה הזמנות אינן שירותיות
--     במידה והפרש בין תאריך ההזמנה לתאריך המשלוח גדול מ3 ימים תחזיר Bad services
--     קטן או שווה ל3 ימים תחזיר Good services
--     אחר תחזיר No relevant

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
-- 57. התפלגות המכירות שלה והזמנות בימים רגילים בשבוע ובסוף שבוע
--     תייצר דוח המציג את מספר ההזמנה, הכנסות מהמוצר, עמודה נוספת בשם DayOfWeek שתסווג את ההזמנות לפי אמצע השבוע וסוף השבוע
--     אם שישי או שבת תחזיר Weekend 
--     אם אמצע שבוע תחזיר Weekday

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
-- 58. כתוב שאילתה למציאת 5 המוצרים המובילים מבחינת הכנסה (מחיר יחידה * כמות) עבור כל קטגוריה            !!!
--     סדר את התוצאות בהכנסה יורדת

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
-- 59. כתוב שאילתה למציאת ההכנסה הכוללת עבור כל שנה 
--     הכנסה צריכה להיות מחושבת כמחיר יחידה * כמות עבור כל פרט הזמנה

SELECT YEAR(OrderDate) AS [Year of Order],
       SUM(Ordeta.UnitPrice * Ordeta.Quantity) AS [Revenue]
FROM Orders Ord INNER JOIN [Order Details] Ordeta
ON Ord.OrderID = Ordeta.OrderID
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate);
------------------------------------------------------------------------------------------------------------------
-- 60. כתוב שאילתה למציאת ההכנסה הכוללת (מחיר יחידה * כמות) לפי חודש עבור כל שנה                          !!!

-- דרך ראשונה: SUBQUERY

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

-- דרך שניה: PIVOT

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

-- דרך שלישית: CTE 

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
-- 61. כתוב שאילתה למציאת 3 העובדים עם ההכנסה הכוללת הגבוהה ביותר 
--     הכנסה כוללת צריכה להיות מחושבת כסכום מחיר יחידה * כמות עבור כל ההזמנות שטופלו על ידי כל עובד 

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
-- 62. כתוב שאילתה למציאת 5 הלקוחות המובילים מבחינת הוצאה כוללת 
--     הוצאה כוללת מחושבת כסכום מחיר יחידה * כמות עבור כל ההזמנות של כל לקוח

SELECT TOP 3 Ord.CustomerID,
             COUNT(Ord.CustomerID) AS [Num Of Orders],
             SUM(Ordeta.UnitPrice * Ordeta.Quantity) [Revenue]
FROM [Order Details] Ordeta RIGHT OUTER JOIN Orders Ord
ON Ordeta.OrderID = Ord.OrderID 
GROUP BY Ord.CustomerID
ORDER BY [Revenue] DESC;
------------------------------------------------------------------------------------------------------------------
-- 63. כתוב שאילתה למציאת האחוז מההכנסה שתורם כל קטגוריית מוצר

SELECT Cat.CategoryName,
       SUM(Ordeta.UnitPrice * Ordeta.Quantity) / (SELECT SUM(UnitPrice * Quantity) FROM [Order Details]) * 100 AS [% Revenue]
FROM Categories Cat INNER JOIN Products Pro
ON Cat.CategoryID = Pro.CategoryID
                    INNER JOIN [Order Details] Ordeta
ON Pro.ProductID = Ordeta.ProductID
GROUP BY Cat.CategoryName;
------------------------------------------------------------------------------------------------------------------
-- 64. כתוב שאילתה למציאת 3 העובדים המבצעים ביותר על פי מספר כולל של הזמנות שמולאו

SELECT TOP 3 Ord.EmployeeID,
             COUNT(Ord.EmployeeID) AS [Num Of Orders],
             SUM(Ordeta.UnitPrice * Ordeta.Quantity) [Revenue]
FROM [Order Details] Ordeta INNER JOIN Orders Ord
ON Ordeta.OrderID = Ord.OrderID 
GROUP BY Ord.EmployeeID
ORDER BY [Num Of Orders] DESC;
------------------------------------------------------------------------------------------------------------------
-- 65. כתוב שאילתה למציאת 5 המוצרים המובילים במכירות ביחידות 
--     יחידות שנמכרו הן סכום הכמות עבור כל מוצר

SELECT TOP 5 ProductName,
             SUM(Quantity) AS [Quantity Ordered]
FROM Products Pro INNER JOIN [Order Details] Ordeta
ON Pro.ProductID = Ordeta.ProductID
GROUP BY ProductName
ORDER BY SUM(Quantity) DESC;
------------------------------------------------------------------------------------------------------------------
-- 66. כתוב שאילתה למציאת 5 המוצרים המובילים במכירות ביחידות 
--     לפי שנים

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
-- 67. כתוב שאילתה למציאת המוצרים  הנמכרים ביחידות 
--     לפי שנים

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
-- 68. כתוב שאילתה למציאת מגמת המכירות החודשית עבור כל שנה 
--     חשב הכנסה כוללת לפי חודש עבור כל שנה

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
--דרך אחרת:

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
-- 69. מהם 5 המוצרים הנמכרים ביותר על פי כמות?

SELECT TOP 5 ProductName,
             SUM(Quantity) AS [Quantity]
FROM Products P INNER JOIN [Order Details] OD
ON P.ProductID = OD.ProductID
GROUP BY ProductName
ORDER BY SUM(Quantity) DESC;
------------------------------------------------------------------------------------------------------------------
-- 70. מהם 5 הלקוחות עם המכירות הגבוהות ביותר על פי סכום כולל?

SELECT TOP 5 C.CustomerID,
             SUM(OD.UnitPrice * OD.Quantity) AS [Total Purchases]
FROM Customers C RIGHT OUTER JOIN Orders O 
ON C.CustomerID = O.CustomerID
                 INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY C.CustomerID
ORDER BY SUM(OD.UnitPrice * OD.Quantity) DESC;
------------------------------------------------------------------------------------------------------------------
-- 71. מהו ממוצע כמות ההזמנות לכל לקוח? מה זה אומר על תדירות ההזמנה הממוצעת של לקוחות?

SELECT C.CustomerID,
       AVG(OD.UnitPrice * OD.Quantity) AS [AVG Purchases]
FROM Customers C RIGHT OUTER JOIN Orders O 
ON C.CustomerID = O.CustomerID
                 INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY C.CustomerID
ORDER BY AVG(OD.UnitPrice * OD.Quantity) DESC;
------------------------------------------------------------------------------------------------------------------
-- 72. מהו סך המכירות עבור כל אזור גיאוגרפי? איזה אזור מייצר את הכנסות הגבוהות ביותר? כיצד ניתן לנצל מידע זה?

SELECT ShipCountry,
       SUM(UnitPrice * Quantity) AS [Total Sales]
FROM Orders O INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY ShipCountry
ORDER BY SUM(UnitPrice * Quantity) DESC;
------------------------------------------------------------------------------------------------------------------
-- 73. מהם 3 הספקים עם כמות המוצרים הגדולה ביותר במלאי? האם יש בעיה אצל ספקים אלה עם זמן אחסנה ארוך מדי?

SELECT CompanyName,
       SUM(UnitsInStock) AS [Sum Units In Stock]
FROM Suppliers S INNER JOIN Products P
ON S.SupplierID = P.SupplierID
GROUP BY CompanyName
ORDER BY  SUM(UnitsInStock) DESC;
------------------------------------------------------------------------------------------------------------------
-- 74. מהו הפער בין תאריך ההזמנה לתאריך המשלוח בממוצע? האם קיימים עיכובים באספקה ומשלוח?

SELECT OrderID,
       AVG(DATEDIFF(DAY, OrderDate, ShippedDate)) AS [AVG Days Between Order to Ship]
FROM Orders
WHERE ShippedDate IS NOT NULL 
GROUP BY OrderID
ORDER BY AVG(DATEDIFF(DAY, OrderDate, ShippedDate)) DESC
------------------------------------------------------------------------------------------------------------------
-- 75. מהם 3 המוצרים הכי פופולריים (עם המכירות הגבוהות ביותר) בקטגוריה מסוימת?

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
-- 76. האם קיימת עונתיות במכירות על פי רבעון? אילו תובנות ניתן להפיק מנתונים אלה?

SELECT SUM(OD.UnitPrice * OD.Quantity) AS [Revenues],
       YEAR(O.OrderDate) AS [Year],
       DATEPART(Quarter, O.OrderDate) AS [Quarter]
FROM Orders O INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY YEAR(O.OrderDate), DATEPART(Quarter, O.OrderDate)
ORDER BY YEAR(O.OrderDate), DATEPART(Quarter, O.OrderDate)
------------------------------------------------------------------------------------------------------------------
-- 77. מהו סך כל המכירות בכל שנה? האם ניכרת מגמת צמיחה או ירידה במכירות לאורך זמן?

SELECT YEAR(O.OrderDate) AS [Year],
       SUM(OD.UnitPrice * OD.Quantity) AS [Revenues]
FROM Orders O INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY YEAR(O.OrderDate)
ORDER BY YEAR(O.OrderDate)
------------------------------------------------------------------------------------------------------------------
-- 78. כמה אחוז מהמכירות מקורן בהנחות וקופונים? האם מדיניות ההנחות אפקטיבית להגדלת מכירות?

SELECT YEAR(O.OrderDate) AS [Year],
       SUM(OD.UnitPrice * OD.Quantity * OD.Discount) AS [Sum of Discounts],
       SUM(OD.UnitPrice * OD.Quantity) AS [Revenues],
       SUM(OD.UnitPrice * OD.Quantity * OD.Discount) / SUM(OD.UnitPrice * OD.Quantity) * 100  AS [% of Discounts]
FROM Orders O INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY YEAR(O.OrderDate)
ORDER BY YEAR(O.OrderDate);
------------------------------------------------------------------------------------------------------------------
-- 79. כל כמה זמן בממוצע לקוח מבצע הזמנה?

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
-- 80. מהם 3 הלקוחות הכי גדולים בכל אזור גיאוגרפי 

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
-- 81. מהם הלקוחות בכל אזור גיאוגרפי 

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