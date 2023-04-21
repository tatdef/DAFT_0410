-- Lab 20

Create database lab_mysql;
USE lab_mysql;
SHOW TABLES;
drop table if exists customers; 
CREATE TABLE customers (cust_index int, cust_id int, cust_name VARCHAR(20), phone VARCHAR(20),
       email VARCHAR(30), address VARCHAR(30), city VARCHAR(20), state VARCHAR(20), country VARCHAR(20), 
       zipcode VARCHAR (12));

drop table if exists invoices; 
CREATE TABLE invoices (invoice_index int, invoice_nbr int, inv_date date, car_index int, cust_index int, staff_index int);

CREATE TABLE cars (car_index int, car_vin VARCHAR(20), manufacturer VARCHAR(20), model VARCHAR (20), car_year YEAR, color VARCHAR (10)); 

drop table if exists salespersons;
CREATE TABLE salespersons (staff_index int, staff_id int, staff_name VARCHAR(20), store VARCHAR(20)); 

SHOW TABLES;
DESCRIBE customers;
DESCRIBE invoices;
DESCRIBE cars;
DESCRIBE salespersons;