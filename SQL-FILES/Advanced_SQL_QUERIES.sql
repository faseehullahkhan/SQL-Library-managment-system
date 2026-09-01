-- Advanced Queries Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.
select * from members;
select * from issued_status;
select * from branch;
select * from employees;
select * from return_status;
select * from books;


select m.member_id , m.member_name , ist.issued_id , ist.issued_member_id , ist.issued_book_name, 
ist.issued_date , rst.return_id, rst.issued_id , rst.return_date , current_date - ist.issued_date as over_due_days from members m
left join issued_status ist
on m.member_id = ist.issued_member_id
left join return_status as rst
on rst.issued_id = ist.issued_id
where issued_date is not null and return_date is null and (current_date - ist.issued_date) > 30
;

-- Question - 02 update the book status as soon as the book returns
create or replace procedure change_returned_book_status(returned_id VARCHAR(10), p_issued_id VARCHAR(10))
language plpgsql
As $$
	DECLARE
		var_isbn varchar(20); 
		var_name varchar(55);
	Begin
		insert into return_status(return_id , issued_id , return_date)
		values(returned_id ,p_issued_id , current_date);

		select issued_book_isbn , issued_book_name
		into var_isbn , var_name
		from issued_status
		where issued_id = p_issued_id;

		update books
		set status = 'yes'
		where isbn = var_isbn;

		Raise notice 'Thank you for returning the book: %', var_name;

	end;
$$

CALL change_returned_book_status('RS138', 'IS135');
CALL change_returned_book_status('RS148', 'IS140');

-- Question - 03 : Create a query that generates a performance report 
-- for each branch, showing the number of books issued, the number of 
-- books returned, and the total revenue generated from book rentals.
SELECT 
    b.branch_id,
    COUNT(DISTINCT ist.issued_id) AS books_issued,
    COUNT(DISTINCT rs.return_id) AS books_returned,
    SUM(bo.rental_price) AS total_revenue
FROM branch b
LEFT JOIN employees e
    ON e.branch_id = b.branch_id
LEFT JOIN issued_status ist
    ON ist.issued_emp_id = e.emp_id
LEFT JOIN books bo
    ON bo.isbn = ist.issued_book_isbn
LEFT JOIN return_status rs
    ON rs.issued_id = ist.issued_id
GROUP BY b.branch_id;


-- CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members 
-- containing members who have issued at least one book in the last 2 months.

CREATE TABLE Active_Members AS
SELECT 
    ist.issued_member_id,
    m.member_name
FROM issued_status ist
LEFT JOIN members m
    ON m.member_id = ist.issued_member_id
WHERE ist.issued_date >= CURRENT_DATE - INTERVAL '2 months';


-- Task 20: Create Table As Select (CTAS) Objective: 
-- Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.
-- Description: Write a CTAS query to create a new table that lists each member and 
-- the books they have issued but not returned within 30 days. 
-- The table should include: The number of overdue books. 
-- The total fines, with each day's fine calculated at $0.50. 
-- The number of books issued by each member. The resulting table should show: 
-- Member ID Number of overdue books Total fines

select * from issued_Status;
select * from return_status;

CREATE TABLE overdue_books AS
SELECT 
    ist.issued_member_id AS member_id,
    COUNT(ist.issued_id) AS number_of_overdue_books,
    SUM((CURRENT_DATE - ist.issued_date - 30) * 0.50) AS total_fines
FROM issued_status ist
LEFT JOIN return_status rst
    ON rst.issued_id = ist.issued_id
JOIN books b
    ON b.book_title = ist.issued_book_name
WHERE b.status = 'no'
  AND (CURRENT_DATE - ist.issued_date) > 30
  AND rst.issued_id IS NULL
GROUP BY ist.issued_member_id;