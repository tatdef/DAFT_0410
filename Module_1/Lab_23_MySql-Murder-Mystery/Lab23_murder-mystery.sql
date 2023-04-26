-- This file contains queries and their explanations - from the sql murder mystery 

SELECT * FROM crime_scene_report
    WHERE city = 'SQL City'
    AND type = 'murder'
    ;

-- 1. Security footage shows that there were 2 witnesses. 
-- The first witness lives at the last house on "Northwestern Dr". 
-- The second witness, named Annabel, lives somewhere on "Franklin Ave".
-- 2. Someone killed the guard! He took an arrow to the knee!
-- 3. REDACTED REDACTED REDACTED 
-- let's hope it's the first one 

select * from person
    where address_street_name like '%Franklin%'
    and name like 'Annabel%'
    or address_street_name like '%Northwestern%'
    order by address_number
    ;

-- first witness 
-- 6371	Annabel Miller	490173	103	Franklin Ave	318771143
-- second witness 
-- 14887	Morty Schapiro	118009	4919	Northwestern Dr	111564949

select person.name, interview.transcript from person
    join interview on person.id = interview.person_id
    where id = 16371
    ;

-- Annabel: I saw the murder happen, and I recognized the killer from 
-- my gym when I was working out last week on January the 9th.

select person.name, interview.transcript from person
    join interview on person.id = interview.person_id
    where id = 14887;
-- Morty : 
-- I heard a gunshot and then saw a man run out. 
-- He had a "Get Fit Now Gym" bag. 
-- The membership number on the bag started with "48Z". 
-- Only gold members have those bags. 
-- The man got into a car with a plate that included "H42W".

-- At this point we know he is a man, he went to the gym on Jan. 9th, 
-- his membership number starts with 48Z

-- to get the people with a membership number starting with 48Z

select * from get_fit_now_member
where membership_status = 'gold'
and id like '48Z%';

-- returns the following : 
/*id	person_id	name	membership_start_date	membership_status
48Z7A	28819	Joe Germuska	20160305	gold
48Z55	67318	Jeremy Bowers	20160101	gold*/

-- To get the car plate:
select id, plate_number from drivers_license
    where plate_number like '%H42W%';
    
-- Returns the following :
/* id    plate_number
183779    H42W0X    Maxine Whitely
423327    0H42W2    Jeremy Bowers
664760    4H42WR    Tushar Chandra
*/

-- At this point, we have only one person matching the description,  
-- i.e. is included in both lists Jeremy Bowers 
-- The site confirms he is the prime suspect but asks us to keep looking 

-- We need to get his interview 
select * from person
    where name = 'Jeremy Bowers';
    
-- Bowers' ID is 67318
-- and then 
sselect person.name, interview.transcript from person
    join interview on person.id = interview.person_id
    where id =67318;

/* his interview transcript is as follows:
I was hired by a woman with a lot of money.
I don't know her name but I know she's around 5'5" (65") or 5'7" (67").
She has red hair and she drives a Tesla Model S.
I know that she attended the SQL Symphony Concert 3 times in December 2017*/

-- The query below returns the people that attended an SQL event. 
-- The ones that attended three times have the person IDs -- 24556 and 99716
select * from facebook_event_checkin
where date like '201712%'
and event_name like 'SQL%'
order by person_id ;

-- note : we counted manually. 
-- if we had wanted to be thorough, we would have written the query like this : 
select person_id, count(event_name) from facebook_event_checkin
where date like '201712%'
and event_name like 'SQL%'
group by person_id
order by count(event_name) desc ;
-- returns that ids 24556 and 99716 have a count of 3

-- we check those IDs from the person table to get their names
select * from person
where id = 24556
or id = 99716;
-- and then we pick the woman (cf. interview transcript)
-- or, if we want to be thorough, we also check she has the right type of car with the query below 

select car_make, car_model, drivers_license.id, person.name     
from drivers_license     
join person on drivers_license.id = person.license_id     
where car_make = 'Tesla' and car_model = 'Model S';

-- and we have found the killet and the mastermind !