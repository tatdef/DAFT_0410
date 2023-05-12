USE sakila; 

/*1. find the running total of rental payments for each customer in the payment table, ordered by payment date. 
-- sum(column_name) over (order by column_name)  
By selecting the customer_id, payment_date, and amount columns from the payment table, 
and then applying the SUM function to the amount column within each customer_id partition, 
ordering by payment_date.*/

SELECT customer_id, payment_date, amount
, sum(amount) over (partition by customer_id order by payment_date) as running_sum_of_amount
from payment
order by customer_id, payment_date
; 

/*2.  find the rank and dense rank of each payment amount within each payment date by selecting the payment_date 
and amount columns from the payment table, and then applying the RANK and DENSE_RANK functions to the amount column 
within each payment_date partition, ordering by amount in descending order.
Hint: you need to extract only the date from the payment_date*/

SELECT date_format(payment_date, '%Y-%m-%d') as payment_dt, amount
, rank() over (partition by date_format(payment_date, '%Y-%m-%d') order by amount desc) as rnk
, dense_rank() over (partition by date_format(payment_date, '%Y-%m-%d') order by amount desc) as dense_rnk
FROM payment
ORDER BY payment_dt, rnk;

/* other solution : select date(payment_date) as payment_date2, amount
, rank() over (partition by date(payment_date) order by amount desc) as rank_payment
, dense_rank() over (partition by date(payment_date) order by amount desc) as dense_rank_payment
from payment limit 50;
Note= "date(payment_date) as payment_date2" will not work because this rename is temporary 
and will not be rememberd without having created a column based on it*/


/* 3. find the ranking of each film based on its rental rate, within its respective category. 
Hint: you need to extract the information from the film,film_category and category tables after applying join on them.*/ 

SELECT  cc.name as category, f.title as film_title, f.rental_rate as rental_rate  
, rank() over (partition by c.category_id order by f.rental_rate desc) as ranking
, dense_rank() over (partition by c.category_id order by f.rental_rate desc) as dense_ranking
FROM film f 
INNER JOIN film_category c using (film_id)
INNER JOIN category cc using (category_id)
ORDER BY cc.name, ranking, f.title ;


/*4.(OPTIONAL) update the previous query from above to retrieve only the top 5 films within each category
Hint: you can use ROW_NUMBER function in order to limit the number of rows.*/


WITH new_table as (
SELECT  cc.name as category, f.title as film_title, f.rental_rate as rental_rate  
, rank() over (partition by c.category_id order by f.rental_rate desc) as ranking
, dense_rank() over (partition by c.category_id order by f.rental_rate desc) as dense_ranking
, row_number() over (partition by c.category_id order by f.rental_rate desc) as rw
FROM film f 
INNER JOIN film_category c using (film_id)
INNER JOIN category cc using (category_id)
ORDER BY cc.name, rw, f.title)
SELECT * from new_table
WHERE rw<6;


/*5. find the difference between the current and previous payment amount and 
the difference between the current and next payment amount, for each customer in the payment table
Hint: select the payment_id, customer_id, amount, and payment_date columns from the payment table, 
and then applying the LAG and LEAD functions to the amount column, partitioning by customer_id and ordering by payment_date.*/

SELECT payment_id, customer_id, amount, payment_date 
, lag(amount) over (partition by customer_id order by payment_date) as previous_amount
, lead(amount) over (partition by customer_id order by payment_date) as next_amount
FROM payment
ORDER BY payment_id; 

-- FINALIZE THIS QUERY WITH THE DIFFERENCE CALCULATION 
Expected output:
payment_id customer_id amount payment_date diff_from_prev diff_from_next

1 1 2.99 2005-05-25 11:30:37 NULL 2.00

2 1 0.99 2005-05-28 10:35:23 -2.00 -5.00

3 1 5.99 2005-06-15 00:54:12 5.00 5.00

4 1 0.99 2005-06-15 18:02:53 -5.00 -9.00

5 1 9.99 2005-06-15 21:08:46 9.00 5.00

6 1 4.99 2005-06-16 15:18:57 -5.00 0.00

7 1 4.99 2005-06-18 08:41:48 0.00 4.00

..................