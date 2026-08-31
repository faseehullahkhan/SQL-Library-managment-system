-- Verifying the data
select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;

-- Question number - 1 
-- Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

insert into books(isbn , book_title , category , rental_price , status, author , publisher)
values('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');


-- Question number - 2 - Update members address
update members
set member_address = '125 oak street'
where member_id = 'C103';

-- QUESTION - 03 - Delete the record with issued_id = 'IS121' from the issued_status table.
select * from issued_status;
delete from issued_status 
where issued_id = 'IS121';

-- QUESTION - 04 - Select all books issued by the employee with emp_id = 'E101'.

select * from issued_status where issued_emp_id = 'E101';


-- Question - 05 Use GROUP BY to find members who have issued more than one book.
select * from issued_status;
select issued_emp_id, count(*) from issued_status group by issued_emp_id having count(*)  > 1;

-- Question - 06 Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
create table ISSUED_BOOK_STATUS as	
select issued_book_name, issued_book_isbn, count(*) as issue_count from issued_status group by issued_book_name ,issued_book_isbn;
-- or
create table ISSUED_BOOK_STATUS as
select b.isbn , b.book_title , count(issued_book_isbn) as issued_count from books as b
join issued_status as ist 
on ist.issued_book_isbn = b.isbn
group by b.isbn , b.book_title;

select * from issued_book_status;

-- Question - 07 Retreive everything in a specific category
select * from books where category = 'Classic';

select * from books;
-- Question - 08 Find the total rental income by category
select category, sum(rental_price) as Individual_TOTAL_Rental_Price from books group by category;

-- Question - 09 - List member who are listed in the last 180 days
select * from members where reg_date >= current_date - interval '180 days'; -- Gives 0 members

-- Question - 10 List Employees with Their Branch Manager's Name and their branch details
select e1.* , b.manager_id, e2.emp_name as manager_name from employees as e1
join branch as b
on e1.branch_id = b.branch_id
join employees as e2
on b.manager_id = e2.emp_id;

-- question -11 Create a Table of Books with Rental Price Above a Certain Threshold
create table rental_price_threshold as
select * from books where rental_price > 6.00;

select * from rental_price_threshold;

-- question - 12 : Retrieve the List of Books Not Yet Returned

select * from issued_status as iss
left join return_status as rs
on iss.issued_id = rs.issued_id;

