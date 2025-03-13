//une requˆete avec un filtre n´egatif sur certains types de patterns (inexistence d’un certain pattern)

MATCH (customer:Customer)
WHERE NOT (customer)-[:PURCHASED]->(:Order)
RETURN  distinct customer;





//optional match
MATCH (e:Employee)-[:REPORTS_TO]->(manager:Employee)
OPTIONAL MATCH (e)-[:SOLD]->(o:Order)
RETURN e.employeeID, manager.employeeID, COUNT(o) AS totalSales
order by totalSales;




//2 with 
// Analyzing Data Query
MATCH (order:Order)-[pu:PRODUCT]->(product:Product)
WITH order, COUNT(pu) AS numberOfProducts
RETURN order.orderID, numberOfProducts
ORDER BY numberOfProducts DESC
LIMIT 20;


// Updating Graph Query
MATCH (order:Order)-[pu:PRODUCT]->(product:Product)
WITH order, SUM(pu.quantity) AS totalQuantity
WHERE totalQuantity > 100
SET order.highQuantity = true;


//unwidn & collect 
MATCH (customer:Customer)-[:PURCHASED]->(order:Order)-[pu:PRODUCT]->(product:Product)
WITH customer, order, COLLECT(product) AS purchasedProducts
UNWIND purchasedProducts AS purchasedProduct
RETURN customer.companyName, order.orderID, COUNT(DISTINCT purchasedProduct) AS numberOfProductsPurchased
ORDER BY numberOfProductsPurchased DESC
limit 10;


//reduce 
// Calculate Total UnitOnOrder for Each Supplier
MATCH (supplier:Supplier)-[:SUPPLIES]->(product:Product)
WITH supplier, COLLECT(product.UnitsOnOrder) AS unitOnOrders
WITH
  supplier.companyName AS supplierName,
  REDUCE(totalunitOnOrders = 0, unitOnOrders IN unitOnOrders | totalunitOnOrders + unitOnOrders) AS totalSupplierunitOnOrders
WHERE totalSupplierunitOnOrders <> 0
RETURN supplierName, totalSupplierunitOnOrders
ORDER BY totalSupplierunitOnOrders DESC;



//call
CALL {
    MATCH (employee:Employee)-[:SOLD]->(order:Order)-[:PRODUCT]->(product:Product)
    RETURN employee, COUNT(DISTINCT product) AS soldProducts
    ORDER BY soldProducts ASC LIMIT 1
        UNION
    MATCH (employee:Employee)-[:SOLD]->(order:Order)-[:PRODUCT]->(product:Product)
    RETURN employee, COUNT(DISTINCT product) AS soldProducts
    ORDER BY soldProducts DESC LIMIT 1
}
RETURN employee.firstName, employee.lastName, soldProducts
ORDER BY soldProducts DESC;

//Predicat none() 
MATCH p = (e:Employee)-[*]->(m:Employee)
WHERE none(node IN nodes(p) WHERE node.employeeID='5')
RETURN p;
//predicat any()
MATCH (p:Product)-[:PART_OF]->(cat:Category)
WHERE ANY(category IN ['Beverages', 'Dairy Products'] WHERE cat.categoryName = category)
RETURN p.productName, cat.categoryName;


//topologie graphe 
MATCH p = (start_order:Order)-[*1..5]-(:Order)
RETURN p
LIMIT 10;

//Equivalent de requete récursive SQL
MATCH (root:Employee)<-[:REPORTS_TO*]-(employee:Employee)
WHERE NOT (root)-[:REPORTS_TO]->()
with root
match (p:Employee)-[:REPORTS_TO*]->(root)
RETURN root,p




