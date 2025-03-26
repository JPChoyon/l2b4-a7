-- create books table 
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(50) NOT NULL,
    price NUMERIC(10, 2) CHECK (price >= 0),
    stock INT CHECK (stock >= 0),
    published_year INT CHECK (published_year >= 0)
);

-- Create customers table 
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    joined_date DATE DEFAULT CURRENT_DATE
);

-- Create orders table 
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    book_id INT REFERENCES books(id),
    quantity INT CHECK (quantity > 0),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- add data in books table 
INSERT INTO books (title, author, price, stock, published_year) 
VALUES
    ('The Pragmatic Programmer', 'Andrew Hunt', 40.00, 10, 1999),
    ('Clean Code', 'Robert C. Martin', 35.00, 5, 2008),
    ('You Don''t Know JS', 'Kyle Simpson', 30.00, 8, 2014),
    ('Refactoring', 'Martin Fowler', 50.00, 3, 1999),
    ('Database Design Principles', 'Jane Smith', 20.00, 0, 2018);

-- add data in customers table
INSERT INTO customers (name, email, joined_date) 
VALUES
    ('Alice', 'alice@email.com', '2023-01-10'),
    ('Bob', 'bob@email.com', '2022-05-15'),
    ('Charlie', 'charlie@email.com', '2023-06-20');

-- add order in order table 
INSERT INTO orders (customer_id, book_id, quantity, order_date) 
VALUES
    (1, 2, 1, '2024-03-10'),
    (2, 1, 1, '2024-02-20'),
    (1, 3, 2, '2024-03-05');

-- find out of stocks book
-- SELECT * from books (check all books)
SELECT title 
FROM books 
WHERE stock = 0;

-- retrieve most expensive books in the store
SELECT * 
FROM books 
WHERE price = (SELECT MAX(price) FROM books);

-- find the total number of orders placed by each customer
SELECT customers.name, COUNT(orders.id) AS total_orders
FROM customers
JOIN orders ON customers.id = orders.customer_id
GROUP BY customers.name;

-- calculate total revenue 
SELECT SUM(books.price * orders.quantity) AS total_revenue
FROM orders
JOIN books ON orders.book_id = books.id;

-- list all customers who placed more than one order 
SELECT customers.name, COUNT(orders.id) AS orders_count
FROM customers
JOIN orders ON customers.id = orders.customer_id
GROUP BY customers.name
HAVING COUNT(orders.id) > 1;

-- average price of books 
SELECT ROUND(AVG(price), 2) AS avg_book_price 
FROM books;

-- increase 10% price for books published before 2000
UPDATE books 
SET price = price * 1.10 
WHERE published_year < 2000;

-- delete customers who did not place any orders 
DELETE FROM customers 
WHERE id NOT IN (SELECT DISTINCT customer_id FROM orders);
