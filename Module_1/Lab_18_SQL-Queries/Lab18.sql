create database mynewdatabase;
/*
Use the data table to query the data about Apple Store Apps and answer the following questions:
1. What are the different genres?
2. Which is the genre with the most apps rated?
3. Which is the genre with most apps?
4. Which is the one with least?
5. Find the top 10 apps most rated.
6. Find the top 10 apps best rated by users.
7. Take a look at the data you retrieved in question 5. Give some insights.
8. Take a look at the data you retrieved in question 6. Give some insights.
9. Now compare the data from questions 5 and 6. What do you see?
10. How could you take the top 3 regarding both user ratings and number of votes?
11. Do people care about the price of an app? Do some queries, comment why are you doing them and the results you retrieve. What is your conclusion?
*/

SELECT * from mynewdatabase.applestore2 limit 5;

-- 1. The different genres are:
select distinct prime_genre from mynewdatabase.applestore2;

--  2. The genre with the most apps rated is Games 
select prime_genre, sum(rating_count_tot)
from mynewdatabase.applestore2
group by prime_genre
order by sum(rating_count_tot) desc;
 
-- 3. The genre with most apps is Games 
select prime_genre, count(distinct track_name)
from mynewdatabase.applestore2
group by prime_genre
order by count(distinct track_name) desc;

-- 4. The genre with least apps is Medical 
select prime_genre, count(distinct track_name)
from mynewdatabase.applestore2
group by prime_genre
order by count(distinct track_name) asc;

-- 5. Top 10 most rated apps : 
select track_name, rating_count_tot
from mynewdatabase.applestore2
order by rating_count_tot desc limit 10;

-- 6. Top 10 apps best rated by users.
select track_name, user_rating
from mynewdatabase.applestore2
order by user_rating desc limit 10;
-- although there is an issue because there are other apps rated 5. 
-- we would need to combine the user_rating to the number of ratings by users to get a better idea. 
select track_name, user_rating, rating_count_tot
from mynewdatabase.applestore2
where user_rating>4.9
order by rating_count_tot desc limit 10;

-- 7. Insights on results from question 5 - top 10 apps most rated
select track_name, rating_count_tot, user_rating, user_rating_ver, price, prime_genre 
from mynewdatabase.applestore2
where rating_count_tot > 500000
order by user_rating desc;
-- 1. The most rated apps are mainly leisure apps (games, music, social networks), with the exception of the bible app and a health app. 
-- 2. Having a high number of rates does not necessarily mean the rating will be higher. 
-- Facebook has the highest number of rates but one of the lowest scores.
-- On the other hand, the Calorie counter app has relatively fewer ratings, but a highest score (4.5). 
-- 3. Some apps show that ratings have improved with the newest version (Pandora, Bible, Pac-Man). 
-- 4. It would be interesting to know how many of the ratings were formulated on the new version, 
-- vs. how many were formulated on the previous versions. 
-- This would tell us whether satisfaction is growing or decreasing, and whether an app is recent or not.  

-- 8. Insight on answers from question 6 - Top 10 apps best rated by users.
select track_name, user_rating
from mynewdatabase.applestore2
order by user_rating desc limit 10;
-- If we only consider the user rating, a lot of apps seem to have the top score of 5. 

select track_name, user_rating, rating_count_tot, prime_genre, price
from mynewdatabase.applestore2
where user_rating>4.9
order by rating_count_tot desc limit 10;
-- However, if we consider the ones that have a top score of 5 and have the high number of user ratings (signaling a high number of users) 
-- Then we notice that these apps are not the ones that are most often rated. 
-- We still have mainly games, but a higher presence of health and fitness apps, and a couple Food&Drink and Business apps. 
-- In addition, the best rated apps with the most ratings are less often free (only 3 are freeà.

-- 9. Comparing responses 
-- Both most rated apps (Q5) and best rated apps (Q6) include mostly games. 
-- A higher rate count does not mean a higher rate. It might actually mean the opposite. 
-- Most Q5 apps are free, which may mean that free apps are more often downloaded. 
-- On the other hand, only 3/10 apps in Q6 are free. Relatively "expensive" apps (4.99) can be very highly rated. 

-- 10. How could you take the top 3 regarding both user ratings and number of votes?
select track_name, user_rating, rating_count_tot, prime_genre, price
from mynewdatabase.applestore2
where user_rating=5
order by rating_count_tot desc limit 3;
-- Like this. But I had done it before (cf. Q6, Q8 and Q9). 

-- 11. Do people care about the price of an app? 
-- user_rating, rating_count_tot,prime_genre, price
-- Do some queries, comment why are you doing them and the results you retrieve. 
-- What is your conclusion?
-- This question makes no sense. There is no such category as "people". 
-- Unless you have user data about who are the users, 
-- we can only say there doesn't seem to be a correlation between price and rate.
-- With the variables we have (user rating, number of ratings, price, genre), 
-- and after trying a bunch of things to group by user_rating or price (which we can't do because they are not character strings) 
-- we would need more information about sql functions to answer more precisely. 
