CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

INSERT INTO ProductDetail VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

SELECT 
    OrderID,
    CustomerName,
    TRIM(product) AS Product
FROM ProductDetail,
JSON_TABLE(
    CONCAT('["', REPLACE(Products, ', ', '","'), '"]'),
    "$[*]" COLUMNS (product VARCHAR(100) PATH "$")
) AS jt;
-- The composite primary key is (OrderID, Product).
-- CustomerName depends only on OrderID, not the entire key — hence, a partial dependency.
--
-- Question 2: Achieving 2NF (Second Normal Form)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Create OrderItems table
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Orders contains customer information (no partial dependency).
-- OrderItems depends fully on the composite key.

