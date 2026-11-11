/*
===============================================================================
PROJECT: Database and Data Types in SQL - Practice Exercise
AUTHOR: Anurag
DESCRIPTION:
  SQL solutions for the six questions in the accompanying practice exercise.

DIALECT NOTE:
  The metadata queries use INFORMATION_SCHEMA and are broadly supported by
  common relational databases, though schema filters and metadata details can
  vary. The Events DDL in Question 4 uses PostgreSQL-style TIMESTAMP WITH TIME
  ZONE and JSONB. Adjust the DDL if you use another database system.

IMPORTANT:
  The exercise document does not provide the actual Customers or Products
  table definitions, nor the real declared type of Orders.OrderTotal.
  Therefore, metadata queries below inspect the live database. Product type
  recommendations are examples and should be adapted to the actual columns
  and expected data ranges.
===============================================================================
*/


/* ---------------------------------------------------------------------------
   QUESTION 1
   Inspect the Customers table schema:
   - Column name
   - Data type
   - Nullability
--------------------------------------------------------------------------- */

SELECT
    COLUMN_NAME AS ColumnName,
    DATA_TYPE AS DataType,
    IS_NULLABLE AS IsNullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Customers'
-- AND TABLE_SCHEMA = 'public'  -- Uncomment and change if needed.
ORDER BY ORDINAL_POSITION;


/* ---------------------------------------------------------------------------
   QUESTION 2
   Recommend suitable data types for a Products table.

   The source exercise does not list the actual Products columns. These are
   illustrative recommendations for common product fields:

   ProductID        INT             Whole-number identifier.
   ProductName      VARCHAR(150)    Variable-length product name.
   UnitPrice        DECIMAL(12, 2)  Exact currency value with 2 decimal places.
   QuantityInStock  INT             Whole-number stock quantity.

   DECIMAL(12, 2) is generally preferable to FLOAT for exact currency values.
   Choose precision and scale based on the business's maximum expected values.

   Example schema (OPTIONAL; run only if you need a sample Products table):

   CREATE TABLE Products (
       ProductID       INT PRIMARY KEY,
       ProductName     VARCHAR(150) NOT NULL,
       UnitPrice       DECIMAL(12, 2) NOT NULL,
       QuantityInStock INT NOT NULL
   );
--------------------------------------------------------------------------- */


/* ---------------------------------------------------------------------------
   QUESTION 3
   Inspect the current data types of Orders.OrderDate and Orders.OrderTotal.
   Use the result to identify columns stored as text that may need review.
--------------------------------------------------------------------------- */

SELECT
    COLUMN_NAME AS ColumnName,
    DATA_TYPE AS CurrentDataType
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders'
  AND COLUMN_NAME IN ('OrderDate', 'OrderTotal')
-- AND TABLE_SCHEMA = 'public'  -- Uncomment and change if needed.
ORDER BY COLUMN_NAME;


/* Optional: inspect example stored values.
   This is a data query, not a metadata query. */

SELECT
    OrderDate,
    OrderTotal
FROM Orders
WHERE OrderDate IS NOT NULL
   OR OrderTotal IS NOT NULL;


/* ---------------------------------------------------------------------------
   QUESTION 4
   Create a minimal Events table.

   PostgreSQL version:
   - EventTime is required.
   - Metadata is optional and stores structured JSON data.
--------------------------------------------------------------------------- */

CREATE TABLE Events (
    EventTime TIMESTAMP WITH TIME ZONE NOT NULL,
    Metadata  JSONB NULL
);


/* ---------------------------------------------------------------------------
   QUESTION 5
   Inspect the Email column in Customers:
   - Data type
   - Whether NULL values are allowed
--------------------------------------------------------------------------- */

SELECT
    COLUMN_NAME AS ColumnName,
    DATA_TYPE AS DataType,
    IS_NULLABLE AS IsNullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Customers'
  AND COLUMN_NAME = 'Email'
-- AND TABLE_SCHEMA = 'public'  -- Uncomment and change if needed.
;


/* ---------------------------------------------------------------------------
   QUESTION 6
   Inspect Orders.OrderTotal precision and scale.
   For DECIMAL/NUMERIC:
   - NUMERIC_PRECISION = total number of digits
   - NUMERIC_SCALE = number of digits after the decimal point
--------------------------------------------------------------------------- */

SELECT
    COLUMN_NAME AS ColumnName,
    DATA_TYPE AS DeclaredType,
    NUMERIC_PRECISION AS NumericPrecision,
    NUMERIC_SCALE AS NumericScale
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders'
  AND COLUMN_NAME = 'OrderTotal'
-- AND TABLE_SCHEMA = 'public'  -- Uncomment and change if needed.
;


/* ---------------------------------------------------------------------------
   END OF PRACTICE EXERCISE

   Review the metadata query results in your own database. The actual schema,
   nullability, data types, precision, and scale cannot be known until these
   queries are executed against the target database.
--------------------------------------------------------------------------- */
