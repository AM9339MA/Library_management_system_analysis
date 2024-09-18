
-- Project Overview 
-- Project Title : Library Management System 
-- Level : Intermidiat

-- This project demonstrates the implimentation of a library management system . In includes creating and managing tables, 
-- perfoming CRUD opration and exicuting advance queries. The goal is to showcase skill in database design, manipulation, and querying.

-- Objectives
--    1.  Set up library management system database. Create and populate the dabases with table for branches, emplyee, members, books, 
--        issued_status and return_status.
--    2.  CRUD Oprations : Performing Create , Read, Update, and delet on the data.
--    3.  CTAS (Create table and select): Utilize CTAS to create new table based on query result.
--    4.  Advance SQL Query : Devolop complex queries to analysis and retrieve specific data.

-- Create Database name(library_management_system)

-- Create all table:-

CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);
select * from branch;


CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);

select * from issued_status;


CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);

select * from members;


CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);

select * from return_status;


CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);

select * from books;


DROP TABLE employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);






-- Q 1. Create a New Book Record,
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')".

select * from books;

insert into books(isbn, book_title, category, rental_price, status, author, publisher)
    values
           ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

SELECT 
    *
FROM
    books
WHERE
    isbn = '978-1-60129-456-2';
    
-- Q 2: Update an Existing Member's Address.

select * from members;

select count(*) from members;

UPDATE members 
SET 
    member_address = '125 Main St'
WHERE
    member_id = 'C101';
select * from members;

-- Q 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS107' from the issued_status table.

select * from issued_status;

SELECT 
    *
FROM
    issued_status
WHERE
    issued_id = 'IS107';

DELETE FROM issued_status 
WHERE
    issued_id = 'IS107';

SELECT 
    *
FROM
    issued_status
WHERE
    issued_id = 'IS107';

-- Q 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with issued_emp_id = 'E101'.

select * from issued_status;

SELECT 
    *
FROM
    issued_status
WHERE
    issued_emp_id = 'E101';

-- Q 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.

select * from issued_status;

SELECT 
    issued_emp_id, COUNT(issued_id) AS total_book_issued
FROM
    issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1;

-- ### 3. CTAS (Create Table As Select)

-- Q 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt

select * from books;
select * from issued_status;

SELECT 
    *
FROM
    books AS b
        JOIN
    issued_status AS ist ON ist.issued_book_isbn = b.isbn; 
    
------------------------------------------------------------
create table books_cnts as
SELECT 
    b.isbn, b.book_title, COUNT(ist.issued_id) AS no_issued
FROM
    books AS b
        JOIN
    issued_status AS ist ON ist.issued_book_isbn = b.isbn
GROUP BY 1 , 2;

select * from books_cnts;

-- Q 7. **Retrieve All Books in a Specific Category.alter

select * from books;

SELECT 
    *
FROM
    books
WHERE
    category = 'Classic';
    
-- Q 8: Find Total Rental Income by Category:

select * from books;

select * from issued_status;
    
SELECT 
    category, SUM(rental_price) AS total_rental_price, count(*) as number_time
FROM
    books
GROUP BY category order by total_rental_price desc;

------------------------------------------

SELECT 
    b.category, SUM(b.rental_price) as total_rental_price, count(*) as number_time
FROM
    books AS b
        JOIN
    issued_status AS ist ON ist.issued_book_isbn = b.isbn
GROUP BY 1 order by total_rental_price desc;

-- Q 9. List Members Who Registered in the Last 180 Days:

select * from members;

SELECT 
    *
FROM
    members
WHERE
    reg_date >= CURDATE() - INTERVAL 180 DAY;

-- Q 10: List Employees with Their Branch Manager's Name and their branch details: self join used

select * from branch;
select * from employees;

SELECT 
   *
FROM
    employees AS e1
        JOIN
    branch AS b ON b.branch_id = e1.branch_id
        JOIN
    employees AS e2 ON b.manager_id = e2.emp_id;
    
----------------------------------------------------
    
SELECT 
    e1.*,
    b.manager_id,
    e2.emp_name as manager
FROM
    employees AS e1
        JOIN
    branch AS b ON b.branch_id = e1.branch_id
        JOIN
    employees AS e2 ON b.manager_id = e2.emp_id;
    
-- Q 11. Create a Table of Books with Rental Price Above a Certain Threshold 7 USD.

select * from books;

CREATE TABLE books_gtr_seven AS SELECT * FROM
    books
WHERE
    rental_price > 7;

select * from books_gtr_seven;

-- Task 12: Retrieve the List of Books Not Yet Returned

select * from issued_status;
select * from return_status;

SELECT 
    *
FROM
    issued_status
        LEFT JOIN
    return_status ON issued_status.issued_id = return_status.isuued_id
WHERE
    return_status.return_id IS NULL;
    
-----------------------------------

SELECT 
    distinct issued_status.issued_book_name
FROM
    issued_status
        LEFT JOIN
    return_status ON issued_status.issued_id = return_status.isuued_id
WHERE
    return_status.return_id IS NULL;
-- Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's 
-- name, book title, issue date, and days.

-- filter books which is return in 30 days 

select * from members;
select * from books;
select* from issued_status;
select * from return_status;

SELECT 
    issued_status.issued_member_id,
    members.member_name,
    books.book_title,
    issued_status.issued_date,
    return_status.return_date
FROM
    issued_status
        JOIN
    members ON members.member_id = issued_status.issued_member_id
        JOIN
    return_status ON return_status.isuued_id = issued_status.issued_id
        left JOIN
    books ON books.isbn = issued_status.issued_book_isbn;    
    
---------------
SELECT 
    issued_status.issued_member_id,
    members.member_name,
    books.book_title,
    issued_status.issued_date,
    CURRENT_DATE() - issued_status.issued_date AS over_dues_days
FROM
    issued_status
        JOIN
    members ON members.member_id = issued_status.issued_member_id
        JOIN
    books ON books.isbn = issued_status.issued_book_isbn
        LEFT JOIN
    return_status ON return_status.isuued_id = issued_status.issued_id
WHERE
    return_status.return_date IS NULL
        AND (CURRENT_DATE() - issued_status.issued_date) > 30
ORDER BY 1;
    
-- Q 14: Update Book Status on Return
-- Write a query to update the status of books in the books table to "available" when they are returned 
-- (based on entries in the return_status table).

select * from books;
select * from return_status;
select * from issued_status;
---------
SELECT 
    *
FROM
    issued_status
WHERE
    issued_book_isbn = '978-0-451-52994-2';
------------
SELECT 
    *
FROM
    books
WHERE
    isbn = '978-0-451-52994-2';

UPDATE books 
SET 
    status = 'no'
WHERE
    isbn = '978-0-451-52994-2';
----------
SELECT 
    *
FROM
    return_status
    where isuued_id = "IS130";
--------------
insert into return_status (return_id, issued_id, return_date, book_quality)
values 
       ("RS125","IS130",current_date, "good");
-------------
UPDATE books 
SET 
    status = 'yes'
WHERE
    isbn = '978-0-451-52994-2';
    
-- Store Procedures --procedur language possgress SQL

delimiter //
create procedure add_return_records(
     p_return_id varchar(10), 
     p_id varchar(10),
	 p_book_quality varchar(15)
) 
begin 
     declare v_isbn varchar(50); 
     declare v_book_name varchar(80);
     
     -- all your logic and code
     -- inserting into returns based on users input
     
     select * from issuede_status;
     
     select issued_book_name, issued_book_isbn
     into v_isbn, v_book_name 
     from issuede_status 
     where id = p_id; 
     
     INSERT INTO return_status(return_id, id, return_date, book_quality)
     VALUES (p_return_id, p_id, current_date, p_book_quality); 
     UPDATE books 
     SET status = 'yes'
	 WHERE isbn = v_isbn; 
     
    SELECT CONCAT('thanks you for returning the book: %', v_book_name) as message;
    end //
delimiter ;

call addd_return_records();

-- testing function add_return_records

-- issued_id = IS135
-- ISBN = where isbn = "978-0-375-41398-8"

select * from issued_status where issued_id = "IS134";
select * from return_status where isuued_id = "IS134";
select * from return_status where isuued_id = "978-0-375-41398-8";
select * from books where isbn = "978-0-375-41398-8";
SELECT 
    *
FROM
    issued_status
WHERE
    issued_book_isbn = '978-0-375-41398-8';

-- Calling Stored Procedure 

call add_return_records('RS138','IS134','good');

desc issued_status;

-- 15: Branch Performance Report
-- Create a query that generates a performance report for each branch, showing the number of books issued, the
-- number of books returned, and the total revenue generated from book rentals.

select * from branch;
select * from issued_status;
select * from return_status;
select * from books;
select * from members;
select * from employees;

CREATE TABLE branch_report AS SELECT b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) AS number_book_issued,
    COUNT(rst.isuued_id) AS number_of_book_return,
    SUM(bk.rental_price) AS total_revenue FROM
    issued_status AS ist
        JOIN
    employees AS e ON e.emp_id = ist.issued_emp_id
        JOIN
    branch AS b ON e.branch_id = b.branch_id
        LEFT JOIN
    return_status AS rst ON rst.isuued_id = ist.issued_id
        JOIN
    books AS bk ON ist.issued_book_isbn = bk.isbn
GROUP BY 1 , 2;

select * from branch_report;

-- 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued 
-- at least one book in the last 5 months.

select * from issued_status;
select * from books;
select * from members;

select curdate() - interval 6 month;

CREATE TABLE active_members AS SELECT * FROM
    members
WHERE
    member_id IN (SELECT DISTINCT
            issued_member_id
        FROM
            issued_status
        WHERE
            issued_date >= CURDATE() - INTERVAL 5 MONTH);

select * from active_members;

-- 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, 
-- number of books processed, and their branch.

select * from issued_status;
select * from books;
select * from members;
select * from employees;
select * from branch;

SELECT 
    e.emp_name, b.*, COUNT(ist.issued_id) AS no_of_book_issued
FROM
    issued_status AS ist
        JOIN
    employees AS e ON e.emp_id = ist.issued_emp_id
        JOIN
    branch AS b ON e.branch_id = b.branch_id
        JOIN
    books AS bk ON bk.isbn = ist.issued_book_isbn
GROUP BY 1 , 2
ORDER BY no_of_book_issued DESC
LIMIT 3;

-- 18: Stored Procedure
-- Objective: Create a stored procedure to manage the status of books in a library system.
-- Description: Write a stored procedure that updates the status of a book based on its issuance or return. Specifically:
-- If a book is issued, the status should change to 'no'.
-- If a book is returned, the status should change to 'yes'.

select * from books;
select * from issued_status;

delimiter //

create procedure issued_bookss(
    p_issued_id varchar(10),
    p_issued_member_id varchar(30),
    p_issued_book_isbn varchar(30),
    p_issued_emp_id varchar(10)
)
begin
    -- all the variable
    declare v_status varchar(10);
  
	-- all the code
    -- checking if book is avalable 'yes'
    select status
    into v_status
    from books
    where isbn = p_issued_book_isbn;

    if v_status = 'yes' then
        insert into issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        values (p_issued_id, p_issued_member_id, current_date, p_issued_book_isbn, p_issued_emp_id);

        update books 
        set status = 'no' 
        where isbn = p_issued_book_isbn;
    end if;
end //

delimiter ;

select * from books;
-- '978-0-451-52994-2' -- 'yes'
-- '978-0-375-41398-8' -- 'no'
select * from issued_status;

call issued_bookss('IS155', 'C108', '978-0-451-52994-2', 'E105');

call issued_bookss('IS156', 'C108', '978-0-375-41398-8', 'E104');

select * from books where isbn ='978-0-451-52994-2';

select * from books where isbn = '978-0-375-41398-8';

