-- E-commerce Platform: MySQL Stored Procedures and Function
-- GitHub-ready practice script
-- Run this script in MySQL Workbench or another MySQL client.

-- ------------------------------------------------------------
-- 1. Create tables
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    email VARCHAR(50),
    signup_date DATE
);

CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ------------------------------------------------------------
-- 2. Sample data
-- INSERT IGNORE avoids duplicate-primary-key errors if rerun.
-- ------------------------------------------------------------

INSERT IGNORE INTO customers
    (customer_id, customer_name, email, signup_date)
VALUES
    (1, 'Alice', 'alice@example.com', '2022-01-10'),
    (2, 'Bob', 'bob@example.com', '2022-03-15'),
    (3, 'Charlie', 'charlie@example.com', '2022-05-20');

INSERT IGNORE INTO products
    (product_id, product_name, price)
VALUES
    (1, 'Laptop', 1500.00),
    (2, 'Headphones', 100.00),
    (3, 'Smartphone', 800.00);

INSERT IGNORE INTO orders
    (order_id, customer_id, product_id, order_date, quantity, total_amount)
VALUES
    (1, 1, 1, '2023-05-01', 1, 1500.00),
    (2, 2, 2, '2023-06-15', 2, 200.00),
    (3, 3, 3, '2023-07-18', 1, 800.00),
    (4, 1, 2, '2023-08-05', 1, 100.00);

-- ------------------------------------------------------------
-- 3. Function: calculate_total_sales
-- Input: product ID
-- Returns: total sales amount for that product.
-- Sales are calculated from orders.total_amount, not products.price.
-- ------------------------------------------------------------

DROP FUNCTION IF EXISTS calculate_total_sales;

DELIMITER $$

CREATE FUNCTION calculate_total_sales(product_idd INT)
RETURNS DECIMAL(10, 2)
READS SQL DATA
BEGIN
    DECLARE total_sales DECIMAL(10, 2);

    SELECT COALESCE(SUM(total_amount), 0.00)
    INTO total_sales
    FROM orders
    WHERE product_id = product_idd;

    RETURN total_sales;
END $$

DELIMITER ;

-- Example:
-- SELECT calculate_total_sales(1) AS total_sales;


-- ------------------------------------------------------------
-- 4. Stored procedure: update_email
-- Inputs: customer ID and new email address
-- Updates the customer's email.
-- ------------------------------------------------------------

DROP PROCEDURE IF EXISTS update_email;

DELIMITER $$

CREATE PROCEDURE update_email(
    IN customer_idd INT,
    IN new_email VARCHAR(50)
)
BEGIN
    UPDATE customers
    SET email = new_email
    WHERE customer_id = customer_idd;
END $$

DELIMITER ;

-- Example:
-- CALL update_email(1, 'anurag@gmail.com');
-- SELECT * FROM customers WHERE customer_id = 1;


-- ------------------------------------------------------------
-- 5. Stored procedure: get_total_orders
-- Input: customer ID
-- Returns: number of orders placed by that customer.
-- Returns 0 when the customer has no orders.
-- ------------------------------------------------------------

DROP PROCEDURE IF EXISTS get_total_orders;

DELIMITER $$

CREATE PROCEDURE get_total_orders(
    IN customer_idd INT
)
BEGIN
    SELECT COUNT(*) AS total_orders
    FROM orders
    WHERE customer_id = customer_idd;
END $$

DELIMITER ;

-- Example:
-- CALL get_total_orders(1);


-- ------------------------------------------------------------
-- 6. Quick test queries
-- Uncomment and run these after creating the function/procedures.
-- ------------------------------------------------------------

-- SELECT calculate_total_sales(1) AS laptop_total_sales;
-- CALL update_email(1, 'anurag@gmail.com');
-- CALL get_total_orders(1);
