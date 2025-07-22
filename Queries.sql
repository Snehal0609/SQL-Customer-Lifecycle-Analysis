use customer_behaviour;
-- 1.	How many customers registered in the first six months of 2017? Name the column registration_count.
Select 
	count(customer_id) as registration_count 
from 
	customers 
where 
	year(registration_date)=2017 
    and month(registration_date)<=6;

--  2	Show the number of registrations in the current week. Name the column registrations_current_week.
Select
	count(customer_id) as  registrations_current_week 
From 
	customers 
where 
	week(registration_date)= week (current_date);

--  3.	Create a report containing the 2017 monthly registration counts. 
-- Show the registration_month and registration_count columns. Order the results by month.

Select 
	month(registration_date) as registration_month , 
	count(customer_id) as registration_count
From  
	customers 
where 
	year(registration_date)=2017 
group by 
	month(registration_date) 
order by 
	month(registration_date);

--  4.	Find the registration count for each month in each year. Show the following columns: registration_year,
--  registration_month, and registration_count. Order the results by year and month.
Select 
	year(registration_date) as registration_year  ,
	month(registration_date) as registration_month , 
    count(customer_id) as registration_count
From 
	customers 
group by 
	year(registration_date), month(registration_date)
 order by 
	year(registration_date),month(registration_date) asc;
 
 
 -- 5.Write an SQL query to find the number of customer registrations per year for each channel
Select 
	channel_id ,year(registration_date),count(customer_id) 
from 
	customers 
Group by 
	channel_id ,year(registration_date)
order by 
	channel_id ,year(registration_date);

-- 6.Write an SQL query to find the number of customer registrations per year for organic search channel.
Select  
	year(registration_date),count(customer_id ) 
from 
	customers c join  channels ch 
    on c.channel_id = ch.id
where 
	ch.channel_name = 'Organic Search '
group by 
	year(registration_date);

-- 7.Create a report to show the weekly counts of registration in 2017, based on the customer country. 
-- Show the following columns:
-- registration_week, country, and registration_count. Order the results by week.
Select 
	country,
	week(registration_date) as registration_week ,
	count(customer_id)as registration_count 
from 
	customers 
where 
	year(registration_date) =2017 
group by 
	country, week(registration_date) 
order by 
	week(registration_date)  ;

-- 8. Among customers registered in 2017, show how many made at least one purchase
--  (name the column customers_with_purchase) and the number of all the customers registered in 2017 
-- (name the column all_customers).
Select 
	count(customer_id) as all_customers,
	Count(first_order_id) as customers_with_purchase  
FROM 
	customers 
where 
	year(registration_date) = 2017 ;


-- 9. Find the lifetime conversion rate among customers who registered in 2017. 
-- Show the result in a column named conversion_rate. Round the result to four decimal places.
Select 
	round(count(first_order_id)/count(customer_id),4) as conversion_rate 
from 
	customers 
where  
	year(registration_date)=2017;

-- 10. Find the conversion rate for each customer channel. Show the channel_name and conversion_rate columns. 
-- Display the conversion rates as percentages rounded to two decimal places

Select 
	ch.channel_name,
    round(count(first_order_id)/count(customer_id)*100,2) as conversion_rate
from 
	customers c join channels ch 
    on c.channel_id = ch.id  
group by 
	ch.channel_name ;

-- 11. Create a report showing conversion rates in monthly basis. 
-- Display the conversion rates as ratios, rounded to three decimal places. 
-- Show the following columns: year, month, and conversion_rate. 
-- Order the results by year and month.

Select 
	year(registration_date) as year, 
    month(registration_date) as month ,
    round(count(first_order_id)/count(customer_id),3) as conversion_rate                      
from 
	customers c join channels ch 
	on  c.channel_id = ch.id  
    group by 
    year(registration_date), month(registration_date) 
order by 
	year(registration_date), month(registration_date);


-- 12. Create a report containing the conversion rates for weekly registration in each registration channel,
--  based on customers registered in 2017. Show the following columns: week, channel_name, and conversion_rate. 
-- Format the conversion rates as percentages, 
-- rounded to a single decimal place. Order the results by week and channel name.

Select 
	week(registration_date) as week, 
	ch.channel_name as channel_name ,
	round(count(first_order_id)/count(customer_id *100),1) as conversion_rate                     
from 
	customers c join channels ch 
    on  c.channel_id = ch.id 
where 
	year(registration_date)=2017 
group by 
	week(registration_date), 
	ch.channel_name 
order by 
	week(registration_date), ch.channel_name;

-- 13. Show customers' emails and interval between their first purchase and the date of registration.
--  Name the column difference.
Select 
	email , 
    datediff(first_order_date , 
    registration_date) as difference 
from 
	customers 
where 
	first_order_date is not null  ;

-- 14.Find the average time from registration to first order for each channel. 
-- Show two columns: channel_name and avg_days_to_first_order.

Select 
	ch.channel_name ,
	avg(datediff(first_order_date , 
    registration_date)) as avg_days_to_first_order
from 
	customers c join  channels ch 
    on c.channel_id = ch.id
	where first_order_date  is not null 
group by 
	ch.channel_name;

-- 15.Calculate the average number of days that passed between registration and first order in quarterly registration basis. 
-- Show the following columns: year, quarter, and avg_days_to_first_order.
--  Order the results by year and quarter.
select
	year(registration_date) ,
	case 
		when month(registration_date) in (1,2,3) then 'first_quarter'
		when month(registration_date) in (4,5,6) then 'second_quarter'
		when month(registration_date) in (7,8,9) then 'third_quarter'
		when month(registration_date) in (10,11,12) then 'fourth_quarter'
	end as quarterrly_registaration,
	avg(datediff(first_order_date , registration_date)) as avg_days_to_first_order  
from customers 
where 
	first_order_date is not null 
group by 
	year(registration_date) , quarterrly_registaration 
order by 
	year(registration_date) , quarterrly_registaration ;


-- another approch

SELECT 
    YEAR(registration_date) AS year,
    QUARTER(registration_date) AS quarter,
    AVG(DATEDIFF(first_order_date, registration_date)) AS avg_days_to_first_order
FROM 
    customers
WHERE 
    first_order_date IS NOT NULL
GROUP BY 
    YEAR(registration_date), QUARTER(registration_date)
ORDER BY 
    YEAR(registration_date), QUARTER(registration_date);

-- 16. Create a report of the average time to first order for weekly registration basis from 2017 in each registration channel. 
-- Show the following columns: week, channel_name, and avg_days_to_first_order. 
-- Order the results by the week.

Select 
	week(registration_date),ch.channel_name ,
	avg(datediff(first_order_date , registration_date)) as avg_days_to_first_order
from 
	customers c join  channels ch on c.channel_id = ch.id
where 
	year(registration_date)=2017  and first_order_date  is not null 
group by 
	week(registration_date), ch.channel_name 
order by 
	week(registration_date);
    
-- 17. Find all customers who placed their first order within one month from registration,
--  and their last order within three months from registration – let's see who's stopped ordering.
--  For each customer show these columns: email, full_name, first_order_date, last_order_date.
Select
	email, full_name,
	first_order_date, 
    last_order_date 
from 
	customers
    where 
first_order_date is not null 
and DATEDIFF(first_order_date, registration_date) between 1 and  30 
and DATEDIFF(last_order_date, registration_date) < 90;

-- 18  . Our e-store has used three versions of the registration form:
-- 'ver1' – introduced when the e-store started.
-- 'ver2' – introduced on Mar 14, 2017.
-- 'ver3' – introduced on Jan 1, 2018.

SELECT 
  registration_date,
  CASE
    WHEN registration_date < '2017-03-14' THEN 'ver1'
    WHEN registration_date >= '2017-03-14' AND registration_date < '2018-01-01' THEN 'ver2'
    WHEN registration_date >= '2018-01-01' THEN 'ver3'
  END AS form_version
FROM 
	customers;

--  19. Show two metrics in two different columns:
-- order_on_registration_date – the number of people who made their first order within one day from their registration date.
-- order_after_registration_date – the number of people who made their first order after their registration date.

Select
count(case when first_order_date  is not null and datediff(first_order_date, registration_date)=0 then customer_id end) as order_on_registration_date,
count(case when  first_order_date  is not null and datediff(first_order_date, registration_date)>0 then customer_id end) as order_after_registration_date
from customers;

-- 20 .Create a conversion chart for monthly registration. Show the following columns:
-- year
-- month
-- registered_count
-- no_sale
-- three_days – the number of customers who made a purchase within 3 days from registration.
-- first_week – the number of customers who made a purchase during the first week but not within the first three days.
-- after_first_week – the number of customers who made a purchase after the 7th day.
-- Order the results by year and month.

Select 
	year(registration_date ) as year,
	month(registration_date) as month,
	count(customer_id ),
	count( case  when first_order_date is null then customer_id end )as  'no sales ',
	count( case  when first_order_date is not null and datediff( first_order_date ,registration_date) between 0 and 2 then customer_id end ) as  'three_days' ,
	count(case  when first_order_date is not null and datediff(first_order_date ,registration_date) between 3 and 6 then customer_id end )as  'one week',
	count(case  when first_order_date is not null and datediff(first_order_date ,registration_date ) >6  then customer_id  end )as 'after_first_week '
from
	customers 
group by 
	year, month 
order by 
	year, month;






