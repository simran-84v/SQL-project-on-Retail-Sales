-- SQL Retail Sales Analysis --
create database sql_project_p1;

-- Create Table --
create table retail_sales
(transactions_id int primary key,	
sale_date date,
sale_time time,
customer_id	int,
gender text,
age int,	
category text, 
quantiy	int,
price_per_unit float,	
cogs float,	
total_sale float);


select * from retail_sales;

select count(*) from retail_sales;

select * from retail_sales
where 
	transactions_id is null
	or 
    sale_date is null
    or 
    sale_time is null
    or 
    customer_id is null
    or 
    gender is null
    or 
    age is null
    or 
    category is null
    or 
    quantiy is null
    or 
    price_per_unit is null
    or 
    cogs is null
    or 
    total_sale is null;
   
   -- 
delete from retail_sales
where 
    transaction_id is null
    or
    sale_date is null
    or
    sale_time is null
    or
    gender is null
    or
    category is null
    or
    quantity is null
    or
    cogs is null
    or
    total_sale is null;
   
-- data exploration.
    
-- how many sales we have?
    select count(*) as total_sale from retail_sales;
   
-- how many customers we have?
    select count(distinct customer_id) as customers from retail_sales;
    
-- how many categories we have?
	select distinct category from retail_sales;
      
      
      -- data analysis and business key problems.
      
-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05. 
select * from retail_sales
where sale_date = '2022-11-05';
   
   
-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing'
-- and the quantity sold is more than 4 in the month of Nov-2022. 

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
AND quantiy >= 4;
 
 
-- 3. write a sql query to calculate the total sales for each category. 
select sum(total_sale) as total_sales, category
from retail_sales
group by category;


-- 4. write a sql query to find the average age of the customers who purchased items from the beauty category. 
select round(avg(age),0) as avg_age, category
from retail_sales
where category = 'beauty'
group by category;


-- 5. write a sql query to find all the transactions where the total sales is greater than 1000. 
select * from retail_sales
where total_Sale >= 1000;


-- 6. write a query to find the total number of transactions made by each gender in each category. 
select count(*) as total_transactions, gender, category
from retail_sales
group by gender, category
order by category;


-- 7.write a sql query to calculate the avg sale for each month. find out the best selling month in each year. 
select
	year,
    month,
    avg_sale
from
(
select 
	year(sale_date) as year,
	month(sale_date) as month,
    round(avg(total_sale), 1) as avg_sale,
    rank() over(partition by year(sale_date) order by avg(total_sale) desc) as ranking
	from retail_sales
    group by 1, 2
    order by 1, 3 desc
    ) as T1
    where ranking = 1;
    
    
-- 8. wite a query to find the top 5 customers based on the highest sales. 
select
	customer_id,
	sum(total_sale) as sales
from retail_sales
group by customer_id
order by sales desc
limit 5;
   
   
-- 9. wite a query to find the number of unique customers who purchased items from each category. 
select
	category,
	count( distinct customer_id) as Unique_customers
from retail_sales
group by category;


-- 10. write a sql query to create each shift and number of orders (example: morning <=12, afternoon between 12 to 17, evening >= 17)
SELECT 
    CASE 
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS number_of_orders
FROM retail_sales
GROUP BY shift
ORDER BY 
    FIELD(shift, 'Morning', 'Afternoon', 'Evening');