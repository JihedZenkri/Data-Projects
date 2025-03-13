
// Create customers
LOAD CSV WITH HEADERS FROM "file:/customers.csv" AS row
CREATE (:Customer {companyName: row.CompanyName, customerID: row.CustomerID, fax: row.Fax, phone: row.Phone});

// Create products
LOAD CSV WITH HEADERS FROM "file:/products.csv" AS row
CREATE (:Product {productName: row.ProductName, productID: row.ProductID,UnitsOnOrder:row.UnitsOnOrder, categoryID: row.CategoryID,unitPrice: toFloat(row.UnitPrice)});

// Create suppliers
LOAD CSV WITH HEADERS FROM "file:/suppliers.csv" AS row
CREATE (:Supplier {companyName: row.CompanyName, supplierID: row.SupplierID});

// Create employees
LOAD CSV WITH HEADERS FROM "file:/employees.csv" AS row
CREATE (:Employee {employeeID:row.EmployeeID,  firstName: row.FirstName, lastName: row.LastName, title: row.Title});

// Create categories
LOAD CSV WITH HEADERS FROM "file:/categories.csv" AS row
CREATE (:Category {categoryID: row.CategoryID, categoryName: row.CategoryName, description: row.Description});

LOAD CSV WITH HEADERS FROM "file:/orders.csv" AS row
MERGE (order:Order {orderID: row.OrderID}) ON CREATE SET order.shipName =  row.ShipName, order.productID = row.ProductID;


//Constraint
CREATE CONSTRAINT FOR (o:Order) REQUIRE o.orderID IS UNIQUE;


//Relationship PRODUCT
LOAD CSV WITH HEADERS FROM "file:/orders.csv" AS row
MATCH (order:Order {orderID: row.OrderID})
MATCH (product:Product {productID: row.ProductID})
MERGE (order)-[pu:PRODUCT]->(product)
ON CREATE SET pu.unitPrice = toFloat(row.UnitPrice), pu.quantity = toFloat(row.Quantity);

//Relastionship SOLD
LOAD CSV WITH HEADERS FROM "file:/orders.csv" AS row
MATCH (order:Order {orderID: row.OrderID})
MATCH (employee:Employee {employeeID: row.EmployeeID})
MERGE (employee)-[:SOLD]->(order);

//Relastionship PURCHASED
LOAD CSV WITH HEADERS FROM "file:/orders.csv" AS row
MATCH (order:Order {orderID: row.OrderID})
MATCH (customer:Customer {customerID: row.CustomerID})
MERGE (customer)-[:PURCHASED]->(order);

//Relastionship SUPPLIES
LOAD CSV WITH HEADERS FROM "file:/products.csv" AS row
MATCH (product:Product {productID: row.ProductID})
MATCH (supplier:Supplier {supplierID: row.SupplierID})
MERGE (supplier)-[:SUPPLIES]->(product);

//Relastionship PART_OF
LOAD CSV WITH HEADERS FROM "file:/products.csv" AS row
MATCH (product:Product {productID: row.ProductID})
MATCH (category:Category {categoryID: row.CategoryID})
MERGE (product)-[:PART_OF]->(category);


//Relastionship REPORTS_TO
LOAD CSV WITH HEADERS FROM "file:/employees.csv" AS row
MATCH (employee:Employee {employeeID: row.EmployeeID})
MATCH (manager:Employee {employeeID: row.ReportsTo})
MERGE (employee)-[:REPORTS_TO]->(manager);


