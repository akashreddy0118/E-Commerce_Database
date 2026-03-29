-- Part 1: Insert, Delete, Update Queries

-- Insert Queries
INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber, Address)
VALUES ('John', 'Doe', 'john.doe@example.com', '1234567890', '123 Elm Street');

INSERT INTO Products (StockCode, Name, Category, Brand, Description, UnitPrice, StockQuantity)
VALUES ('SC1234', 'Wireless Mouse', 'Electronics', 'Logitech', 'Ergonomic wireless mouse', 29.99, 500);

-- Safe Delete Queries (ensure no foreign key constraint violations)
-- First delete dependent rows, then delete main entity

-- Deleting from Cart safely: check if CartID exists before deleting
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM Cart WHERE CartID = 1) THEN
        DELETE FROM Cart WHERE CartID = 1;
    END IF;
END $$;

-- Deleting a Review safely: delete associated review only if it exists
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM Reviews WHERE ReviewID = 1) THEN
        DELETE FROM Reviews WHERE ReviewID = 1;
    END IF;
END $$;

-- Update Queries
UPDATE Orders SET PaymentStatus = 'Completed' WHERE OrderID = 1;

UPDATE Products SET StockQuantity = StockQuantity - 1 WHERE ProductID = 2;

-- Part 2: SELECT Queries Using Various Techniques

-- 1. JOIN Query: List customer names and their order totals
SELECT c.FirstName, c.LastName, o.TotalAmount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 2. ORDER BY Query: List products ordered by price descending
SELECT Name, UnitPrice FROM Products
ORDER BY UnitPrice DESC;

-- 3. GROUP BY Query: Total payments received per payment method
SELECT PaymentMethod, SUM(AmountPaid) as TotalCollected
FROM Payments
GROUP BY PaymentMethod;

-- 4. Subquery: Find customers who placed orders over $500
SELECT FirstName, LastName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID FROM Orders WHERE TotalAmount > 500
);

-- Aggregate Function Example (already partially covered in GROUP BY):
SELECT COUNT(*) AS TotalOrders FROM Orders;

-- Part 3: Stored Procedures / Functions

-- 1. Stored Procedure: Insert a new payment
CREATE OR REPLACE FUNCTION InsertPayment(p_order_id INT, p_customer_id INT, p_method VARCHAR, p_amount DECIMAL)
RETURNS VOID AS $$
BEGIN
    INSERT INTO Payments (OrderID, CustomerID, PaymentMethod, AmountPaid, TransactionStatus)
    VALUES (p_order_id, p_customer_id, p_method, p_amount, 'Pending');
END;
$$ LANGUAGE plpgsql;

-- 2. Stored Procedure: Update product stock after purchase
CREATE OR REPLACE FUNCTION UpdateProductStock(p_product_id INT, p_quantity INT)
RETURNS VOID AS $$
BEGIN
    UPDATE Products
    SET StockQuantity = StockQuantity - p_quantity
    WHERE ProductID = p_product_id;
END;
$$ LANGUAGE plpgsql;

-- Part 4: Transaction + Trigger for Failure Handling

-- Create error log table
CREATE TABLE IF NOT EXISTS TransactionErrors (
    ErrorID SERIAL PRIMARY KEY,
    ErrorMessage TEXT,
    ErrorTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger to handle failure logging
DO $$
BEGIN
    BEGIN
        -- Attempt a transaction that should fail
        INSERT INTO Orders (CustomerID, TotalAmount) VALUES (9999, 200); -- Invalid CustomerID -> Should fail
        INSERT INTO Payments (OrderID, CustomerID, PaymentMethod, AmountPaid, TransactionStatus)
        VALUES (1, 9999, 'Credit Card', 200, 'Pending');
    EXCEPTION
        WHEN OTHERS THEN
            -- Log error upon failure
            INSERT INTO TransactionErrors (ErrorMessage)
            VALUES ('Transaction failed at ' || NOW());
    END;
END $$;

-- Part 5: Index Creation and Query Analysis

-- 1. Problematic query (without index)
EXPLAIN ANALYZE
SELECT * FROM Customers WHERE Email = 'john.doe@example.com';

-- Create Index
CREATE INDEX IF NOT EXISTS idx_customers_email ON Customers(Email);

-- Query after indexing
EXPLAIN ANALYZE
SELECT * FROM Customers WHERE Email = 'john.doe@example.com';

-- 2. Problematic query (Orders by CustomerID)
EXPLAIN ANALYZE
SELECT * FROM Orders WHERE CustomerID = 10;

-- Create Index
CREATE INDEX IF NOT EXISTS idx_orders_customerid ON Orders(CustomerID);

-- 3. Problematic query (Products search by Name)
EXPLAIN ANALYZE
SELECT * FROM Products WHERE Name ILIKE '%mouse%';

-- Create Index (Partial or Full Text Indexing recommended)
CREATE INDEX IF NOT EXISTS idx_products_name ON Products(Name);

-- After Indexing:
EXPLAIN ANALYZE
SELECT * FROM Products WHERE Name ILIKE '%mouse%';