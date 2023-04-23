/*Challenge 1 - Most Profiting Authors

In this challenge you'll find out who are the top 3 most profiting authors in the publications database. 
Step-by-step guidances to train your problem-solving thinking will help you get through this lab.

In order to solve this problem, it is important for you to keep the following points in mind:
    - In table sales, a title can appear several times. The royalties need to be calculated for each sale.
    - Despite a title can have multiple sales records, the advance must be calculated only once for each title.
    - In your eventual solution, you need to sum up the following profits for each individual author:
        All advances, which are calculated exactly once for each title.
        All royalties in each sale.

Therefore, you will not be able to achieve the goal with a single SELECT query, you will need to use subqueries. 
Instead, you will need to follow several steps in order to achieve the solution. 
There is an overview of the steps below:
    1. Calculate the royalty of each sale for each author and the advance for each author and publication.
    2. Using the output from Step 1 as a subquery, aggregate the total royalties for each title and author.
    3. Using the output from Step 2 as a subquery, calculate the total profits of each author 
    by aggregating the advances and total royalties of each title.

Below we'll guide you through each step. 
In your solutions.sql, please include the SELECT queries of each step.*/

-- Top 3 most profiting authors 
-- we need to find the amount made by each author everytime they sell a book - royalty
-- but also the advance (only once per title)
-- and then agregate the two 

/*Step 1: Calculate the royalty of each sale for each author and the advance for each author and publication

Write a SELECT query to obtain the following output:

    Title ID
    Author ID
    Advance of each title and author
        The formula is:

        advance = titles.advance * titleauthor.royaltyper / 100

    Royalty of each sale
        The formula is:

        sales_royalty = titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100

        Note that titles.royalty and titleauthor.royaltyper are divided by 100 respectively 
        because they are percentage numbers instead of floats.

In the output of this step, each title may appear more than once for each author. 
This is because a title can have more than one sale.*/

SELECT titles.title_id, auth.au_id, titles.advance*titleauthor.royaltyper/100 as advance, 
titles.price * sales.qty * titles.royalty/100 * titleauthor.royaltyper/100 as sales_royalty
FROM publications.titles titles
LEFT JOIN publications.sales sales USING(title_id)
LEFT JOIN publications.titleauthor titleauthor USING(title_id)
LEFT JOIN publications.authors auth USING (au_id)
ORDER BY titles.title_id;

/*Step 2: Aggregate the total royalties for each title and author

Using the output from Step 1, write a query, containing a subquery, to obtain the following output:

    Title ID
    Author ID
    Aggregated royalties of each title for each author
        Hint: use the SUM subquery and group by both au_id and title_id

In the output of this step, each title should appear only once for each author.*/

SELECT titles.title_id, auth.au_id, sum(summary.sales_royalty) as sum_royalties
FROM publications.titles titles
LEFT JOIN (
SELECT titles.title_id, auth.au_id, titles.advance*titleauthor.royaltyper/100 as advance, 
titles.price * sales.qty * titles.royalty/100 * titleauthor.royaltyper/100 as sales_royalty
FROM publications.titles titles
LEFT JOIN publications.sales sales USING(title_id)
LEFT JOIN publications.titleauthor titleauthor USING(title_id)
LEFT JOIN publications.authors auth USING (au_id) 
ORDER BY titles.title_id) summary USING (title_id)
LEFT JOIN publications.authors auth USING (au_id)
GROUP BY auth.au_id, titles.title_id;
 
/*Step 3: Calculate the total profits of each author

Now that each title has exactly one row for each author where the advance and royalties are available, 
we are ready to obtain the eventual output. 
Using the output from Step 2, write a query, containing two subqueries, to obtain the following output:

    Author ID
    Profits of each author by aggregating the advance and total royalties of each title

Sort the output based on a total profits from high to low, and limit the number of rows to 3. */

SELECT auth.au_id as author_id, subsub.sum_royalties + summary.advance as total_profit
FROM publications.authors auth
LEFT JOIN(
SELECT titles.title_id, auth.au_id, titles.advance*titleauthor.royaltyper/100 as advance, 
titles.price * sales.qty * titles.royalty/100 * titleauthor.royaltyper/100 as sales_royalty
FROM publications.titles titles
LEFT JOIN publications.sales sales USING(title_id)
LEFT JOIN publications.titleauthor titleauthor USING(title_id)
LEFT JOIN publications.authors auth USING (au_id) 
ORDER BY titles.title_id) summary USING (au_id)
LEFT JOIN(
SELECT titles.title_id, auth.au_id, sum(summary.sales_royalty) as sum_royalties
FROM publications.titles titles
LEFT JOIN (
SELECT titles.title_id, auth.au_id, titles.advance*titleauthor.royaltyper/100 as advance, 
titles.price * sales.qty * titles.royalty/100 * titleauthor.royaltyper/100 as sales_royalty
FROM publications.titles titles
LEFT JOIN publications.sales sales USING(title_id)
LEFT JOIN publications.titleauthor titleauthor USING(title_id)
LEFT JOIN publications.authors auth USING (au_id) 
ORDER BY titles.title_id) summary USING (title_id)
LEFT JOIN publications.authors auth USING (au_id)
GROUP BY auth.au_id, titles.title_id) subsub USING (au_id)
GROUP BY auth.au_id
ORDER BY total_profit desc LIMIT 3;

/*Challenge 2 - Alternative Solution

In the previous challenge, you have developed your solution the following way:
    Derived tables (subqueries).(see reference)

We'd like you to try the other way:
    Creating MySQL temporary tables and query the temporary tables in the subsequent steps.*/
    
/*Challenge 3

Elevating from your solution in Challenge 1 & 2, create a permanent table named most_profiting_authors to hold the data about the most profiting authors. The table should have 2 columns:

    au_id - Author ID
    profits - The profits of the author aggregating the advances and royalties*/

/* To balance the performance of database transactions and the timeliness of the data, software/data engineers often 
schedule automatic scripts to query the data periodically  and save the results in persistent summary tables. 
Then when needed they retrieve the data from the summary tables instead of performing the expensive database transactions 
again and again. In this way, the results will be a little outdated but the data we want can be instantly retrieved.*/
