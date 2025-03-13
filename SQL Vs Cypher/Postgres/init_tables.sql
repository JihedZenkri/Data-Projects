drop table if exists categories cascade;
drop table if exists employees cascade;
drop table if exists order_details cascade;
drop table if exists orders cascade;
drop table if exists products cascade;
drop table if exists suppliers cascade;
drop table if exists customers cascade;

CREATE TABLE employees (
    EmployeeID INTEGER NOT NULL,
    LastName character varying(20) NOT NULL,
    FirstName character varying(10) NOT NULL,
    Title character varying(30),
    TitleOfCourtesy character varying(25),
    BirthDate date,
    HireDate date,
    Address character varying(60),
    City character varying(15),
    Region character varying(15),
    PostalCode character varying(10),
    Country character varying(15),
    HomePhone character varying(24),
    Extension character varying(4),
    Photo bytea,
    Notes text,
    ReportsTo INTEGER,
	PhotoPath character varying(255),
	
	FOREIGN KEY (ReportsTo) REFERENCES employees(EmployeeID),
	PRIMARY KEY (EmployeeID)
	
);


CREATE TABLE categories (
    CategoryID INTEGER NOT NULL,
    CategoryName character varying(15) NOT NULL,
    Description text,
	Picture bytea,
	PRIMARY KEY (CategoryID)
);

CREATE TABLE customers (
    CustomerID bpchar NOT NULL,
    CompanyName character varying(40) NOT NULL,
    ContactName character varying(30),
    ContactTitle character varying(30),
    Address character varying(60),
    City character varying(15),
    Region character varying(15),
    PostalCode character varying(10),
    Country character varying(15),
    Phone character varying(24),
    Fax character varying(24),
	
	PRIMARY KEY (CustomerID)
);

CREATE TABLE orders (
    OrderID INTEGER NOT NULL,
    CustomerID bpchar,
    EmployeeID INTEGER,
    OrderDate date,
    RequiredDate date,
    ShippedDate date,
    ShipVia INTEGER,
    Freight real,
    ShipName character varying(40),
    ShipAddress character varying(60),
    ShipCity character varying(15),
    ShipRegion character varying(15),
    ShipPostalCode character varying(10),
    ShipCountry character varying(15),
	
	FOREIGN KEY (EmployeeID) REFERENCES employees(EmployeeID),
	FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID),
	PRIMARY KEY (OrderID)
);



CREATE TABLE suppliers (
    SupplierID INTEGER NOT NULL,
    CompanyName character varying(40) NOT NULL,
    ContactName character varying(30),
    ContactTitle character varying(30),
    Address character varying(60),
    City character varying(15),
    Region character varying(15),
    PostalCode character varying(10),
    Country character varying(15),
    Phone character varying(24),
    Fax character varying(24),
    HomePage text,
	PRIMARY KEY (SupplierID)
);

CREATE TABLE products (
    ProductID INTEGER NOT NULL,
    ProductName character varying(40) NOT NULL,
    SupplierID INTEGER,
    CategoryID INTEGER,
    QuantityPerUnit character varying(20),
    UnitPrice real,
    UnitsInStock INTEGER,
    UnitsOnOrder INTEGER,
    ReorderLevel INTEGER,
    Discontinued integer NOT NULL,
	
	FOREIGN KEY (SupplierID) REFERENCES suppliers(SupplierID),
	FOREIGN KEY (CategoryID) REFERENCES categories(CategoryID),
	PRIMARY KEY (ProductID)
);

CREATE TABLE order_details (
    OrderID INTEGER NOT NULL,
    ProductID INTEGER NOT NULL,
    UnitPrice real NOT NULL,
    Quantity INTEGER NOT NULL,
    Discount real NOT NULL,
	
	FOREIGN KEY (OrderID) REFERENCES orders(OrderID),
	FOREIGN KEY (ProductID) REFERENCES products(ProductID),
	PRIMARY KEY (OrderID, ProductID)
);
