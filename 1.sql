select * from customers
select * from products
select * from orders
select * from order_items

-- List all customers who have placed more than one order.
select c.name from customers c join orders o on c.customer_id = o.customer_id where o.order_id in (select order_id from order_items where quantity>1) 

-- Find the total revenue generated from each product.
select p.name,sum(p.price*oi.quantity) as total_price from products p 
join order_items oi on oi.product_id = p.product_id group by p.name

-- Which customer spent the most money in total?
select c.name,sum(p.price*oi.quantity) as total_price from products p 
join order_items oi on oi.product_id = p.product_id
join orders o on o.order_id = oi.order_id
join customers c on o.customer_id = c.customer_id
group by c.name


-- List all orders that include at least one product from the 'Furniture' category.

select * from orders o 
join order_items oi on o.order_id = oi.order_id
join products p on p.product_id = oi.product_id
where p.category = 'Furniture'

-- Which city has the highest total sales?

select c.city,sum(p.price*oi.quantity) as total_spent from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
join products p on p.product_id = oi.product_id
group by c.city 
order by total_spent desc
limit 1

-- Find customers who placed their first order within 30 days of signing up.
select c.name from customers c 
join (select customer_id,min(order_date) as order_date from orders group by customer_id) o
on o.customer_id = c.customer_id
where o.order_date - c.signup_date <= 30 


-- List the average quantity of products ordered by category.

select p.category, avg(oi.quantity) from products p
join order_items oi on p.product_id = oi.product_id
group by p.category

-- Which product appears most frequently in orders?
select p.name,count(oi.product_id) as freq from products p
join order_items oi on p.product_id = oi.product_id
group by p.product_id
order by freq desc
limit 1

-- Show the monthly revenue for March 2022
select sum(p.price*oi.quantity) as revenue from order_items oi
join products p on p.product_id = oi.product_id 
join orders o on o.order_id = oi.order_id
where extract(year from o.order_date) = '2022'

-- Find the top 2 customers who placed the highest number of orders.

select c.customer_id,c.name , count(o.order_id) as order_placed from customers c 
join orders o on o.customer_id = c.customer_id 
group by c.customer_id
order by order_placed desc
limit 2

-- 1. Which product generated the highest total revenue in a single order?

select p.name,(oi.quantity*p.price) as price from products p
join order_items oi on oi.product_id = p.product_id
order by  price desc
limit 1

-- 2. Which customer has the highest average order value?

SELECT c.name, AVG(order_total) AS avg_order_value
FROM customers c
JOIN (
    SELECT o.customer_id, SUM(p.price * oi.quantity) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON p.product_id = oi.product_id
    GROUP BY o.order_id, o.customer_id
) AS order_summary ON c.customer_id = order_summary.customer_id
GROUP BY c.name
ORDER BY avg_order_value DESC;

-- Find the top 3 cities with the highest total revenue.

select c.city ,sum(p.price*oi.quantity) as revenue from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
join products p on p.product_id = oi.product_id
group by c.city
order by revenue desc

-- Rank products by total sales revenue using a window function.

select p.name ,sum(p.price*oi.quantity) as total_sales from products p
join order_items oi on oi.product_id = p.product_id
group by p.name
order by total_sales desc

-- 5. Find customers who never ordered anything.

select * from customers where customer_id not in (select customer_id from orders)

 -- Find the product(s) that were never ordered.

select * from products where product_id not in (select product_id from orders)

-- Show each customer's most expensive order (total).
select c.name,max(order_total.expense) from customers c
join (
select o.customer_id,o.order_id, sum(oi.quantity*p.price) as expense 
from orders o
join order_items oi on o.order_id = oi.order_id
join products p on p.product_id = oi.product_id
group by o.customer_id, o.order_id) as order_total on order_total.customer_id = c.customer_id
group by c.customer_id,order_total.order_id



----------------------------------------------------------------------------------


select * from employees
select * from projects
select * from project_assignments
select * from salaries

-- Select all employees in the IT department.

select * from employees where department = 'IT'

-- List employees hired after 2020.

select * from employees where extract(year from hire_date) >2020

-- Get the count of employees per department.
select department,count(employee_id) as number_of_employees from employees
group by department

-- Find the average salary by department.

select department,avg(salary) as average from employees
group by department

-- List all employees with salary greater than the average.

select * from employees where salary > (select avg(salary) from employees)

-- Show employees who worked on the 'Website Redesign' project.

select * from employees e 
join project_assignments pa on e.employee_id = pa.employee_id
join projects p on p.project_id = pa.project_id
where p.name = 'Website Redesign'

-- List all departments with more than 1 employee.

select department from employees
group by department
having count(employee_id)>1

-- Add a row number to each employee ordered by hire date.

select row_number() over (order by hire_date) as row_num,
employee_id,name,hire_date from employees

-- Rank employees by salary within each department.

select rank() over(partition by department order by salary desc) as ranks,name,salary,department from employees

select employee_id, name, salary,lag(salary) over (order by hire_date) as previous_salary from  employees;

-- Find the difference between each salary and the department’s average salary (use AVG() OVER).

select salary - avg(salary) over(partition by department) as department_avg ,department, name from employees

SELECT 
  employee_id, name, salary,
  NTILE(2) OVER (ORDER BY salary DESC) AS salary_quartile
FROM employees;


---------------------------------------------------------------

select * from actor
select * from genres
select * from director
select * from movie
select * from movie_genres
select * from movie_direction
select * from reviewer
select * from rating
select * from movie_cast


-- 1. From the following table, write a SQL query to find the name and year of the movies. Return movie title, movie release year.

select mov_title , extract(year from mov_dt_rel) as release_year from movie

-- 2. From the following table, write a SQL query to find when the movie 'American Beauty' released. Return movie release year.

select extract(year from mov_dt_rel) from movie where mov_title = 'Inception'

-- 3. From the following table, write a SQL query to find the movie that was released in 1999. Return movie title.

select mov_title from movie where extract(year from mov_dt_rel) = 1999

-- 4. From the following table, write a SQL query to find those movies, which were released before 1998. Return movie title.

select mov_title from movie where extract(year from mov_dt_rel) < 1999

-- 5. From the following tables, write a SQL query to find the name of all reviewers and movies together in a single list.

select re.rev_name , m.mov_title from reviewer re
join rating ra on ra.rev_id = re.rev_id
join movie m on m.mov_id = ra.mov_id

-- 6. From the following table, write a SQL query to find all reviewers who have rated seven or more stars to their rating. Return reviewer name.

select re.rev_name from reviewer re
join rating ra on ra.rev_id = re.rev_id
where rev_stars > 4.5

-- 7. From the following tables, write a SQL query to find the movies without any rating. Return movie title.

select mov_title from movie
where mov_id not in (select mov_id from rating)

-- 8. From the following table, write a SQL query to find the movies with ID 905 or 907 or 917. Return movie title.

select mov_title from movie where mov_id in (2, 8 , 9)

-- 9. From the following table, write a SQL query to find the movie titles that contain the word 'Boogie Nights'. Sort the result-set in ascending order by movie year. Return movie ID, movie title and movie release year.

select mov_id,mov_title,mov_year from movie where mov_title like 'T%' order by mov_year

-- 10. From the following table, write a SQL query to find those actors with the first name 'Woody' and the last name 'Allen'. Return actor ID.

select act_id from actor where act_fname = 'Jennifer' and act_lname = 'Lawrence'


-- 1. From the following table, write a SQL query to find the actors who played a role in the movie 'Annie Hall'. Return all the fields of actor table.

select * from actor where act_id in (select act_id from movie_cast where mov_id in (select mov_id from movie where mov_title = 'Inception') )

-- 2. From the following tables, write a SQL query to find the director of a film that cast a role in 'Eyes Wide Shut'. Return director first name, last name.

select d.dir_fname,d.dir_lname from director d
join movie_direction md on md.dir_id = d.dir_id
join movie m on md.mov_id = m.mov_id
join movie_cast mc on mc.mov_id = m.mov_id
where mov_title = 'Titanic'

-- 4. From the following tables, write a SQL query to find for movies whose reviewer is unknown. 
-- Return movie title, year, release date, director first name, last name, actor first name, last name

select m.mov_title , m.mov_year , m.mov_dt_rel ,d.dir_fname,d.dir_lname from movie m 
join movie_direction md on md.mov_id = m.mov_id
join director d on md.dir_id = d.dir_id
join rating ra on ra.mov_id = m.mov_id
where ra.rev_id not in (select rev_id from reviewer)

-- 5. From the following tables, write a SQL query to find those movies directed by the director whose first name is Woddy and last name is Allen.
-- Return movie title.

select m.mov_title from movie m
join movie_direction md on md.mov_id = m.mov_id
join director d on md.dir_id = d.dir_id
where dir_fname = 'Steven' and dir_lname = 'Spielberg'

-- 6. From the following tables, write a SQL query to determine those years in which there was at least 
-- one movie that received a rating of at least three stars. Sort the result-set in ascending order by movie year. Return movie year.

select m.mov_year from movie m
join rating r on r.mov_id = m.mov_id
where r.rev_stars >= 4.5
group by m.mov_year
order by m.mov_year

-- 7. From the following table, write a SQL query to search for movies that do not have any ratings. Return movie title.

select m.mov_title from movie m where mov_id not in (select mov_id from rating)

-- 8. From the following table, write a SQL query to find those reviewers 
-- who have not given a rating to certain films. Return reviewer name.

select rev_name from  reviewer 
where rev_id not in (select ra.rev_id from rating ra
join movie m on m.mov_id =ra.mov_id where m.mov_title = 'Titanic')

-- 9. From the following tables, write a SQL query to find movies that have been reviewed by a reviewer and received a rating. 
-- Sort the result-set in ascendingorder by reviewer name, movie title, review Stars. Return reviewer name, movie title, review Stars.

select re.rev_name , m.mov_title, ra.rev_stars from reviewer re
join rating ra on ra.rev_id = re.rev_id
join movie m on m.mov_id = ra.mov_id
order by re.rev_name,m.mov_title,ra.rev_stars

-- 10. From the following table, write a SQL query to find movies that have been reviewed by a reviewer and received a rating.
-- Group the result set on reviewer’s name, movie title. Return reviewer’s name, movie title.

select re.rev_name , m.mov_title from reviewer re
join rating ra on ra.rev_id = re.rev_id
join movie m on m.mov_id = ra.mov_id
where re.rev_name is not null and ra.rev_stars is not null
group by re.rev_name , m.mov_title

-- 11. From the following tables, write a SQL query to find those movies, which have received highest number of stars.
-- Group the result set on movie title and sorts the result-set in ascending order by movie title.
-- Return movie title and maximum number of review stars.

select m.mov_title , max(ra.rev_stars) as max_review from movie m 
join rating ra on m.mov_id = ra.mov_id 
group by m.mov_title
order by m.mov_title

-- 12. From the following tables, write a SQL query to find all reviewers who rated the movie 'American Beauty'. Return reviewer name.

select re.rev_name from reviewer re
join rating ra on ra.rev_id = re.rev_id
join movie m on ra.mov_id = m.mov_id
where m.mov_title = 'Titanic'

-- 13. From the following table, write a SQL query to find the movies that have not been reviewed 
-- by any reviewer body other than 'Paul Monks'. Return movie title.

select m.mov_title from movie m
inner join rating r on m.mov_id = r.mov_id
where r.rev_id not in (
    select rev_id from reviewer
    where rev_name = 'IGN'
)

-- 14. From the following table, write a SQL query to find the movies with the lowest ratings.
-- Return reviewer name, movie title, and number of stars for those movies.

select re.rev_name,m.mov_title,ra.rev_stars from reviewer re
join rating ra on ra.rev_id = re.rev_id
join movie m on m.mov_id = ra.mov_id
where ra.rev_stars = (select min(rev_stars) from rating r2
WHERE r2.mov_id = ra.mov_id)

-- 15. From the following tables, write a SQL query to find the movies directed by 'James Cameron'. Return movie title.
select m.mov_title from movie m 
join movie_direction md on md.mov_id = m.mov_id
join director d on d.dir_id = md.dir_id
where d.dir_fname = 'James' and d.dir_lname = 'Cameron' 

-- 16. Write a query in SQL to find the movies in which one or more actors appeared in more than one film.

select m.mov_title from movie m
join movie_cast mc on mc.mov_id = m.mov_id
where mc.act_id = (select act_id from movie_cast group by act_id having count(Distinct mov_id)>1)
