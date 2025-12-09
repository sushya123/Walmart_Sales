create database Walmart_db;

use Walmart_db;

show tables;

-- Q what is Total Number of Store are There 
select count(distinct Branch)
from walmart;

                                                -- Business Problems  --
                                                
-- Q.1 Find Different payment method and number of Transactions, number of qty sold
select  payment_method, 
	count(*) as no_payments,
     sum(quantity) as no_qty_sold
     from walmart
            group by payment_method;

-- Q.2 Identify the highest-rated category in each branch, displaying the branch, category, Avg Rating
SELECT *
FROM (
    SELECT 
        branch, 
        category, 
        AVG(rating) AS avg_rating,
        RANK() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS rnk
    FROM walmart
    GROUP BY branch, category
) AS t
WHERE rnk = 1;

-- Q.3 Identify the busiest day for each branch based on the number of transactions
SELECT *
FROM (
    SELECT 
        branch,
        DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%y'), '%W') AS day_name,
        COUNT(*) AS no_transactions,
        RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
    FROM walmart
    GROUP BY branch, day_name
) AS t
WHERE rnk = 1;


-- Q.4  Calculate the Total quantity of item sold per payment method. list payment_method and Total_quantity.
select  payment_method, 
     sum(quantity) as no_qty_sold
     from walmart
            group by payment_method;


 -- Q.5 Determine the average, minimum, and maximum rating of categories for each city
SELECT 
    city,
    category,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    AVG(rating) AS avg_rating
FROM walmart
GROUP BY city, category;


-- Q.6 Calculate the total profit for each category
SELECT 
    category,
    SUM(unit_price * quantity * profit_margin) AS total_profit
FROM walmart
GROUP BY category
ORDER BY total_profit DESC;


-- Q7: Determine the most common payment method for each branch
WITH cte AS (
    SELECT 
        branch,
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
    FROM walmart
    GROUP BY branch, payment_method
)
SELECT 
    branch, 
    payment_method AS preferred_payment_method
FROM cte
WHERE rnk = 1;


-- Q8: Categorize sales into Morning, Afternoon, and Evening shifts
SELECT
    branch,
    CASE 
        WHEN HOUR(TIME(time)) < 12 THEN 'Morning'
        WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS num_invoices
FROM walmart
GROUP BY branch, shift
ORDER BY branch, num_invoices DESC;
