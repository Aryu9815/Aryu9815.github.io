-- Insert a new employee record into the "Employees" table.
insert into employees(EmployeeID, Name, Age, Salary) values (1, 'Ziynet Safiyyah', 30, 50000)

-- Insert multiple employee records into the "Employees" table.
insert into oldemployees values (2, 'Berna Alder', 25, 45000), 
    (3, 'Khayri Ivo', 28, 52000),
    (4, 'Teppo Abel', 35, 60000);

-- Update the salary of an employee with EmployeeID = 1.
update employees set salary = 50000 where employeeid = 1

-- Increase the salary of all employees aged over 30 by 10%.
update employees set salary = salary + salary*0.01 where age > 30

-- Delete the employee with EmployeeID = 4.
delete from employees where employeeid = 4

-- Delete all employees with a salary less than 50000.
delete from employees where salary <50000

-- Insert a record with default values for unspecified columns.
insert into employees values(5, 'Charlie Davis');

-- Update the salary of employees in the same department as EmployeeID = 1.
update employees set salary = salary + 5000 where departmentID = (select departmentid from departments where employeeid = 1)

-- Delete employees who work in the same department as EmployeeID = 2.
delete from employees where departmentid = (select departmentid from departments where employeeid = 2)

-- Insert employees from the "OldEmployees" table into the "Employees" table.
insert into employees (EmployeeID, Name, Age, Salary) select  EmployeeID, Name, Age, Salary from oldemployees

-- Update salaries based on age: increase by 5000 if age > 30, otherwise increase by 2000.
update employees set salary = case
when age>30 then salary + 5000
else salary + 2000 end

-- Delete all records from the "Employees" table.
delete from employees

-- Insert a record where EmployeeID is auto-generated.
INSERT INTO Employees (Name, Age, Salary)
VALUES ('Eve White', 27, 48000);

-- Delete employees who belong to a department that has been marked as inactive.
DELETE FROM employees e
USING departments d
WHERE e.departmentid = d.departmentid
AND d.isActive = 0;
