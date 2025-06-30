create database Project_SenSei;

-- setup process
create table sales
			(
				transaction_id int primary key,
				sale_date date,
				sale_time time,
				customer_id int,
				gender varchar(15),
				age int,
				category varchar(25),
				quantity int,
				price_per_unit float,
				cogs float,
				total_sales float
			);
select *
from sales;

-- cleaning process

select sale_date, category, quantity, price_per_unit, total_sales
from sales;

select *
from sales
where transaction_id is null
	or sale_date is null
	or sale_time is null
	or customer_id is null
	or gender is null
	or age is null
	or category is null
	or quantity is null
	or price_per_unit is null
	or cogs is null
	or total_sales is null;

delete from sales
where quantity is null
	or price_per_unit is null
	or cogs is null
	or total_sales is null;

select *
from sales;
 
-- data exploration process

-- number of unique customers

select count
(distinct customer_id) as total_customers
from sales;

select distinct category
from sales;

select distinct price_per_unit
from sales;

-- Business Data Analysis

-- all sales made in May 2022

select *
from sales
where sale_date >= '2022-05-01'
	and sale_date < '2022-06-01';

-- how many transactions took place in November 2022 in the clothing category where the quantity was more than 3?

select *
from sales
where category = 'Clothing'
	and
		to_char(sale_date, 'yyyy-mm') = '2022-11'
	and 
		quantity > 3 ;

-- Total Sales and orders for each categories

select
	category,
	sum(total_sales) net_sales,
	count(*) total_orders
from sales
group by 1
order by 2 desc;

-- average age of customers in the Beauty Category

select
	round(avg(age), 2)
from sales
where 
	category = 'Beauty';

-- Every transaction where total sales is greater than 1000

select
	transaction_id,
	total_sales
from sales
where
	total_sales > '1000';

-- gender  based analysis of each category

select
	category,
	gender,
	count(*) as total_transaction
from sales
group by
	1,2
order by
	1;

-- average sales by month

select
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sales) as avg_sales
from sales
group by 1,2
order by 1,3 desc;

-- Most profitable months in each year

select
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sales) as avg_sales,
	rank() over(partition by extract(year from sale_date)
	order by avg(total_sales) desc) as month_ranking
from sales
group by 1,2;

-- Best Months

with month_table
	as
	(	select
		extract(year from sale_date) as year,
		extract(month from sale_date) as month,
		avg(total_sales) as avg_sales,
		rank() over(partition by extract(year from sale_date)
		order by avg(total_sales) desc) as month_ranking
	from sales
	group by 1,2
	)
select 
	year,
	month,
	avg_sales
from month_table
where
	month_ranking = 1;

-- Top 3 Customers
select 
	customer_id,
	sum(total_sales)
from sales
group by 1
order by 2 desc
limit 5;

-- Unique customers by category

select
	category,
	count(distinct customer_id) unique_customers
from sales
group by 1;
	
-- TOTAL ORDERS PER SHITF (MORNING(<12:00), AFTERNOON(12:00<=S<=18:00), EVENING(>18:00))

select *,
	case
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 18 then 'Afternoon'
		else 'Evening'
	end as shift
from sales;	

with Hourly_Sales as
		(select *,
		case
			when extract(hour from sale_time) < 12 then 'Morning'
			when extract(hour from sale_time) between 12 and 18 then 'Afternoon'
			else 'Evening'
		end as shift
		from sales
		)
select
	shift,
	count(*) as total_orders
from Hourly_Sales
group by 1
order by 2 desc;
		
-- Proft Per Category

select
	category,
	sum(quantity) Quantity_Sold,
	sum(cogs) Total_COGS,
	sum(total_sales) Revenue,
	sum(total_sales) - sum(cogs) Profit
from sales	
group by category
order by Profit desc;
















