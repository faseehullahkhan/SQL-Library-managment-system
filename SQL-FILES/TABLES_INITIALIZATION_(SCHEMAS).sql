-- Library-Management-system

-- Create table branch;
Drop table if exists branch;
create table branch(
	branch_id varchar(6),	
	manager_id varchar(6),	
	branch_address varchar(15),
	contact_no varchar(15),
	constraint Branch_id_key primary key(branch_id)
);

-- Create table employee;
drop table if exists employees;
create table employees(
	emp_id varchar(6) primary key ,
	emp_name char(18),
	position char(12),
	salary decimal(7,2),
	branch_id varchar(6),

	foreign key(branch_id) REFERENCES branch(branch_id)
	
);

-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
    member_id VARCHAR(6) PRIMARY KEY,
    member_name VARCHAR(18),
    member_address VARCHAR(15),
    reg_date DATE
);

-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
    isbn VARCHAR(20) PRIMARY KEY,
    book_title VARCHAR(55),
    category VARCHAR(20),
    rental_price numeric(5,2),
    status VARCHAR(3),
    author VARCHAR(25),
    publisher VARCHAR(30)
);

-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
    issued_id VARCHAR(5) PRIMARY KEY,
    issued_member_id VARCHAR(6),
    issued_book_name VARCHAR(53),
    issued_date DATE,
    issued_book_isbn VARCHAR(20),
    issued_emp_id VARCHAR(6),
	
       FOREIGN KEY(issued_member_id) REFERENCES members(member_id),
       FOREIGN KEY(issued_emp_id) REFERENCES employees(emp_id),
       FOREIGN KEY(issued_book_isbn) REFERENCES books(isbn) 
);

-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
       return_id VARCHAR(10) PRIMARY KEY,
       issued_id VARCHAR(5),
       return_book_name VARCHAR(53),
       return_date DATE,
       return_book_isbn VARCHAR(20),
         FOREIGN KEY(issued_id) REFERENCES issued_status(issued_id),
		 FOREIGN KEY(return_book_isbn) REFERENCES books(isbn)
);