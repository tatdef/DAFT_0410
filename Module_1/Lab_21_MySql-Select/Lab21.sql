/*Challenge 1 - Who Have Published What At Where?

In this challenge you will write a MySQL SELECT query that joins various tables 
to figure out what titles each author has published at which publishers. Your output should have at least the following columns:

    AUTHOR ID - the ID of the author
    LAST NAME - author last name
    FIRST NAME - author first name
    TITLE - name of the published title
    PUBLISHER - name of the publisher where the title was published

If your query is correct, the total rows in your output should be the same as the total number of records in Table titleauthor.*/

use publications;

SELECT auth.au_id as author_id, auth.au_lname as last_name, auth.au_fname as first_name, titauth.title_id
FROM publications.authors auth
LEFT JOIN publications.titleauthor titauth 
USING(au_id);

SELECT titauth.title_id, titles.title
FROM publications.titleauthor titauth 
LEFT JOIN publications.titles titles USING(title_id)
GROUP BY titauth.title_id;
-- the group by is just to check - it returns distinct 

SELECT titles.title, pub.pub_name
FROM publications.titles titles
INNER JOIN publications.publishers pub USING (pub_id);

-- so here we have three separate queries 
-- if we bring them all together as a left join (to keep the original number of rows, i.e. we only want publishing authors) 

SELECT auth.au_id as author_id, auth.au_lname as last_name, auth.au_fname as first_name, titles.title, pub.pub_name
FROM publications.authors auth
INNER JOIN publications.titleauthor titauth USING (au_id)
LEFT JOIN publications.titles titles USING (title_id)
LEFT JOIN publications.publishers pub USING (pub_id)
ORDER BY auth.au_lname; 
-- this could also be ordered by author_id to fit the lab requirements, but here it is by author last name

/*Challenge 2 - Who Have Published How Many At Where?

Elevating from your solution in Challenge 1, query how many titles each author has published at each publisher.

To check if your output is correct, sum up the TITLE COUNT column. 
The sum number should be the same as the total number of records in Table titleauthor.

Hint: In order to count the number of titles published by an author, you need to use MySQL COUNT. 
Also check out MySQL Group By because you will count the rows of different groups of data. 
Refer to the references and learn by yourself. 
These features will be formally discussed in the Temp Tables and Subqueries lesson.*/

SET sql_mode = '';
SET sql_mode = 'ONLY_FULL_GROUP_BY';
-- tried changing the sql mode (it actually helps to get other views) 

SELECT auth.au_id as author_id, auth.au_lname as last_name, auth.au_fname as first_name, pub.pub_name as publisher_name, count(pub_name) as number_titles
FROM publications.authors auth
INNER JOIN publications.titleauthor titauth USING (au_id)
LEFT JOIN publications.titles titles USING (title_id)
LEFT JOIN publications.publishers pub USING (pub_id)
GROUP BY auth.au_id
ORDER BY count(pub_name) desc
; 

/*Challenge 3 - Best Selling Authors

Who are the top 3 authors who have sold the highest number of titles? Write a query to find out.

Requirements:

    Your output should have the following columns:
        AUTHOR ID - the ID of the author
        LAST NAME - author last name
        FIRST NAME - author first name
        TOTAL - total number of titles sold from this author
    Your output should be ordered based on TOTAL from high to low.
    Only output the top 3 best selling authors.*/

SELECT auth.au_id, concat(auth.au_lname," ",auth.au_fname) as last_name, sum(sales.qty) as books_sold
FROM publications.authors auth
INNER JOIN publications.titleauthor titauth USING (au_id)
LEFT JOIN publications.titles titles USING (title_id)
LEFT JOIN publications.sales sales USING (title_id)
GROUP BY auth.au_id
ORDER BY sum(sales.qty) desc limit 5
; 

/*this required checking if the result was correct - it wasn't at first
because there are three people who sold 50 books each, so the result was right for the first 3
but it was wrong if we went until 5. 
SELECT sales.qty, sales.title_id, titles.title, auth.au_lname
from publications.sales sales
INNER JOIN publications.titles titles USING (title_id)
INNER JOIN publications.titleauthor titauth USING (title_id)
INNER JOIN publications.authors auth using(au_id)
order by sales.qty desc; */

/*Challenge 4 - Best Selling Authors Ranking
Now modify your solution in Challenge 3 so that the output will display all 23 authors instead of the top 3. 
Note that the authors who have sold 0 titles should also appear in your output (ideally display 0 instead of NULL as the TOTAL). 
Also order your results based on TOTAL from high to low.*/

SELECT auth.au_id, concat(auth.au_lname," ",auth.au_fname) as last_name, IFNULL(sum(sales.qty),0) as Total
FROM publications.authors auth
LEFT JOIN publications.titleauthor titauth USING (au_id)
LEFT JOIN publications.titles titles USING (title_id)
LEFT JOIN publications.sales sales USING (title_id)
GROUP BY auth.au_id
ORDER BY sum(sales.qty) desc;
