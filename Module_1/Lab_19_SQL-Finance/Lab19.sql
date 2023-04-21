
/*Lab | MySQL Select
finish all questions with only these clauses:
    SELECT
    SELECT DISTINCT
    COUNT
    FROM
    WHERE
    ORDER BY
    GROUP BY
    SUM, MAX, MIN, COUNT
    LIMIT

The Sql script is here: https://drive.google.com/file/d/1tT1OTdIgkI5tkeeXIsnZwMC5SxI1FE9m/view Please submit your solutions in a text file solutions.sql.
1. From the order_items table, find the price of the highest priced order and lowest price order.
2. From the order_items table, what is range of the shipping_limit_date of the orders?
3. From the customers table, find the states with the greatest number of customers.
4. From the customers table, within the state with the greatest number of customers, find the cities with the greatest number of customers.
5. From the closed_deals table, how many distinct business segments are there (not including null)?
6. From the closed_deals table, sum the declared_monthly_revenue for duplicate row values in business_segment and find the 3 business segments with the highest declared monthly revenue (of those that declared revenue).
7. From the order_reviews table, find the total number of distinct review score values.
8. In the order_reviews table, create a new column with a description that corresponds to each number category for each review score from 1 - 5, then find the review score and category occurring most frequently in the table.
9. From the order_reviews table, find the review value occurring most frequently and how many times it occurs.*/

-- From the order items table, find the price of the highest priced order and lowest price order. 
-- The lowest price for an order is 0.85 and three orders are concerned
-- The highest price for an order is 6735 and one order is concerned. 

-- In detail
-- Chose database 
use olist ;

-- Explore columns and rows
SELECT * from olist.order_items limit 5; 

-- get the lowest order prices
SELECT order_id, price
from olist.order_items
order by price asc limit 10;
-- get the highest order prices 
SELECT order_id, price
from olist.order_items
order by price desc limit 10;

-- 2. From the order_items table, what is range of the shipping_limit_date of the orders?
SELECT order_id, shipping_limit_date
from olist.order_items
order by shipping_limit_date asc limit 10;
-- 19 septembre 2016 

SELECT order_id, shipping_limit_date
from olist.order_items
order by shipping_limit_date desc limit 10;
-- 10 april 2020 

SELECT min(shipping_limit_date), max(shipping_limit_date), ((max(shipping_limit_date))-(min(shipping_limit_date)))
from olist.order_items;
-- returns three rows 

SELECT datediff(max(shipping_limit_date),min(shipping_limit_date))
from olist.order_items;
-- returns 1299

-- 3. From the customers table, find the states with the greatest number of customers.
-- States with greatest number of customers are Sao Paulo, Rio de Janeiro, Minas Gerais, Rio Grande do Sul. 
SELECT customer_state, count(customer_unique_id)
from olist.customers
group by customer_state
order by count(customer_unique_id);

-- 4. From the customers table, within the state with the greatest number of customers, find the cities with the greatest number of customers.
-- Sao Paulo and Campinas (but Sao Paulo is far ahead, 10 times the amount of Campinas). 
SELECT customer_city, count(customer_unique_id)
from olist.customers
where customer_state = 'SP'
group by customer_city
order by count(customer_unique_id) desc;

-- 5. From the closed_deals table, how many distinct business segments are there (not including null)?
SELECT count(distinct business_segment)
from olist.closed_deals
where business_segment <> "Null";
-- also possible to use IS NOT NULL but this seems to return 33 with or without the where clause... 


-- 6. From the closed_deals table, sum the declared_monthly_revenue 
-- for duplicate row values in business_segment 
-- and find the 3 business segments with the highest declared monthly revenue 
-- (of those that declared revenue).

SELECT business_segment, sum(declared_monthly_revenue) 
from olist.closed_deals
where declared_monthly_revenue > 0
group by business_segment
order by sum(declared_monthly_revenue) desc
limit 3
;
-- not sure of this answer, what does "duplicate row values in business_segment" mean ? 

-- 7. From the order_reviews table, find the total number of distinct review score values.
SELECT distinct review_score from olist.order_reviews;
-- Is 5 the right answer ? 

-- 8. In the order_reviews table, create a new column with a description that corresponds 
-- to each number category for each review score from 1 - 5, 
-- then find the review score and category occurring most frequently in the table.

-- I don't understand the question...

-- 9. From the order_reviews table, find the review value occurring most frequently and how many times it occurs.
-- 5, and it occurs 57 420 times.
SELECT review_score, count(review_id)
from olist.order_reviews
group by review_score
order by count(review_id) desc;