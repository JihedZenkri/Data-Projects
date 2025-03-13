-- 1- une requete avec un filtre negatif sur certains types de patterns (inexistence d’un certain pattern)
SELECT DISTINCT c.CustomerID
FROM customers c
LEFT JOIN orders o ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;

-- 2- une requete avec OPTIONAL MATCH
SELECT e.employeeID, e.ReportsTo AS managerID, COUNT(o.OrderID) AS totalSales
FROM employees e
LEFT JOIN orders o ON e.employeeID = o.EmployeeID
WHERE e.ReportsTo IS NOT NULL
GROUP BY e.employeeID, e.ReportsTo;

-- 3- première with
SELECT orders.orderID, COUNT(order_details.productID) AS numberOfProducts
FROM orders
JOIN order_details ON orders.orderID = order_details.orderID
GROUP BY orders.orderID
ORDER BY numberOfProducts DESC
LIMIT 20;

-- 4- unwind et collect
SELECT c.companyName, COUNT(DISTINCT p.productID) AS numberOfProductsPurchased
FROM customers c
JOIN orders o ON c.customerID = o.CustomerID
JOIN order_details od ON o.orderID = od.orderID
JOIN products p ON od.productID = p.productID
GROUP BY c.companyName
ORDER BY numberOfProductsPurchased DESC
LIMIT 10;

-- 5- REDUCE
SELECT s.companyName AS supplierName,
       SUM(p.UnitsOnOrder) AS total_products_on_order
FROM suppliers s
JOIN products p ON s.supplierID = p.supplierID
GROUP BY s.companyName
HAVING SUM(p.UnitsOnOrder) > 0
ORDER BY total_products_on_order DESC;

-- 6- CALL
(SELECT e.employeeID, e.firstName, e.lastName, COUNT(DISTINCT p.productID) AS soldProducts
 FROM employees e
 JOIN orders o ON e.employeeID = o.EmployeeID
 JOIN order_details od ON o.orderID = od.orderID
 JOIN products p ON od.productID = p.productID
 GROUP BY e.employeeID, e.firstName, e.lastName
 ORDER BY soldProducts ASC LIMIT 1)
UNION ALL
(SELECT e.employeeID, e.firstName, e.lastName, COUNT(DISTINCT p.productID) AS soldProducts
 FROM employees e
 JOIN orders o ON e.employeeID = o.EmployeeID
 JOIN order_details od ON o.orderID = od.orderID
 JOIN products p ON od.productID = p.productID
 GROUP BY e.employeeID, e.firstName, e.lastName
 ORDER BY soldProducts DESC LIMIT 1);

-- 7- Utilisation de fonctions de prédicat (any())
SELECT p.productID, p.productName, c.categoryName
FROM products p NATURAL JOIN categories c
WHERE c.categoryName IN ('Beverages', 'Dairy Products')
RETURN p
LIMIT 10;

-- 8- Requette recursive Postgresql
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT EmployeeID, LastName, FirstName, ReportsTo
    FROM employees
    WHERE ReportsTo IS NULL
    
    UNION ALL
    
    SELECT e.EmployeeID, e.LastName, e.FirstName, e.ReportsTo
    FROM employees e
    JOIN EmployeeHierarchy eh ON e.ReportsTo = eh.EmployeeID
)
SELECT * FROM EmployeeHierarchy;
