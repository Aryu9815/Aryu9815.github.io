--create table employees
create table Employees(EmployeeID INT PRIMARY KEY,
Name VARCHAR(10),
Age INT CHECK(Age>0),
Salary DECIMAL(10,2))

--Add column Department
ALTER table Employees add column Department varchar(10)

---- Change the data type of the "Salary" column to INTEGER.
Alter table Employees alter column Salary type INT

-- Remove the "Department" column from the "Employees" table.
alter table Employees drop column department


-- Add a unique constraint to the "Name" column to ensure no duplicate names.
alter table employees add constraint UC_Name unique(name)

-- Create a new table "Departments" and link it to "Employees" using a foreign key.
create table Departments(
DepartmentID INT Primary Key,
DepartmentName varchar(50)
)

alter table employees add column DepartmentID INT,add constraint Fk_Department Foreign key(DepartmentID) references Departments(departmentid)

-- Delete the "Departments" table permanently.
drop table departments cascade

-- Remove all rows from the "Employees" table but keep the table structure.
truncate table employees

-- Create an index on the "Name" column to improve query performance.
create index idx_name on employees(name)

-- Remove the index "idx_Name" from the "Employees" table.
drop index idx_name 

-- Rename the "Employees" table to "Staff".
alter table employees rename to staff
alter table staff rename to employees

-- Set a default value of 0 for the "Salary" column.
alter table employees alter column salary set default 0

-- Remove the unique constraint "UC_Name" from the "Employees" table.
alter table employees drop constraint UC_name

-- Create a new schema named "HR".
create schema HR

-- Move the "Employees" table to the "HR" schema.
alter table public.employees set schema hr
