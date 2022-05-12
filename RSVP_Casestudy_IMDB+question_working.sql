USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) FROM DIRECTOR_MAPPING;

SELECT COUNT(*) FROM GENRE ;

SELECT COUNT(*) FROM  MOVIE;

SELECT COUNT(*) FROM  NAMES;

SELECT COUNT(*) FROM  RATINGS;


SELECT COUNT(*) FROM  ROLE_MAPPING;

-- Answer -> We have 6 tables in Databse, total number of rows in each table as follows:
-- Number of rows in DIRECTOR_MAPPING= 3867
-- Number of rows in GENRE = 14662
-- Number of rows in MOVIE= 7997
-- Number of rows in NAMES= 25735
-- Number of rows in RATINGS= 7997
-- Number of rows ROLE_MAPPING= 15615



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNT_ID,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNT_title,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNT_year,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNT_date_published,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNT_duration,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNT_country,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNT_worlwide_gross_income,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNT_languages,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNT_production_company
FROM   movie;
-- Answer -> following columns in the movie table have null values: 
-- Country, worlwide_gross_income, languages and production_company







-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- query for Number of movies released each year


SELECT year, Count(title) AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY year;

-- query for Number of movies released each month 
SELECT Month(date_published) AS MONTH_NUM,
       Count(*)              AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 









/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- query : 
SELECT Count(DISTINCT id) AS number_of_movies, year
FROM   movie
WHERE  ( country LIKE '%INDIA%' OR country LIKE '%USA%' )
AND year = 2019; 
-- Answer: Number of Movies produced in the USA or India in the year 2019: 1059 










/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM   genre; 
-- above query shows unique list of genres in dataset.









/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT     genre,
           Count(mov.id) AS number_of_movies
FROM       movie       AS mov
INNER JOIN genre       AS gen
where      gen.movie_id = mov.id
GROUP BY   genre
ORDER BY   number_of_movies DESC limit 1 ;

-- Answer: Drama genre has highest number of movies produced overall. (4285 movies). 
-- comment: Since we have to display only the genre with highest number of movies produced used LIMIT clause with limit 1.









/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH movies_belonging_one_genre
     AS (SELECT movie_id
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(DISTINCT genre) = 1)
SELECT Count(*) AS movies_belonging_one_genre
FROM   movies_belonging_one_genre; 


-- Answer-> Movies belonging to only one genre: 3289
-- Comment: table 'genre' -> find all movies belong to only one genre. 
-- grouping rows based on movie id, using 'HAVING' along with 'Count =1' function and using DISTINCT =1. 








/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

 SELECT     genre,
           Round(Avg(duration),2) AS avg_duration
FROM       movie                  AS mov
INNER JOIN genre                  AS gen
ON      gen.movie_id = mov.id
GROUP BY   genre
ORDER BY avg_duration DESC;
-- Comment: Query for finding average duration of each genre








/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_summary AS
(
           SELECT     genre,
                      Count(movie_id)                            AS movie_count ,
                      Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_wise_rank
           FROM       genre                                 
           GROUP BY   genre )
SELECT *
FROM   genre_summary
WHERE  genre = "THRILLER" ;
-- Answer -> Rank of Thriller genre: 3 (number of Movies: 1484) 
-- Comment: first find genre based on the number of movies in each of them order them in Rank.
-- then query to displays the genre rank for 'Thriller' and column having the number of movies belonging to 'Thriller' genre.









/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

-- minimum and maximum values in  each column 
SELECT Min(avg_rating)    AS MIN_AVG_RATING,
       Max(avg_rating)    AS MAX_AVG_RATING,
       Min(total_votes)   AS MIN_TOTAL_VOTES,
       Max(total_votes)   AS MAX_TOTAL_VOTES,
       Min(median_rating) AS MIN_MEDIAN_RATING,
       Max(median_rating) AS MAX_MEDIAN_RATING
FROM   ratings; 

-- Comment: Since we wanted to find min & max values, we used Min() & Max() functions. table ratings. 




    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too


WITH MOVIE_RANK AS
(
SELECT     title,
           avg_rating,
           ROW_NUMBER() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM       ratings                               AS rat
INNER JOIN movie                                 AS mov
ON         mov.id = rat.movie_id
)
SELECT * FROM MOVIE_RANK
WHERE movie_rank<=10;
-- query to Find the rank of each movie based on it's average rating
-- Comment: first find rank of each movie based on it's average rating then use LIMIT clause (LIMIT=10) to show top 10 movies.  






/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have


SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC; 
-- number of movies as per median rating. (sorting is based on movie count)







/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH production_company_hit_movie_summary
     AS (SELECT production_company,
                Count(movie_id)       AS movie_count,
                Rank()
                  OVER(
                    ORDER BY Count(movie_id) DESC ) AS PRODUCTION_HOUSE_RANK
         FROM   ratings AS rat
                INNER JOIN movie AS mov
                        ON mov.id = rat.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   production_company_hit_movie_summary
WHERE  PRODUCTION_HOUSE_RANK = 1; 

-- Comment: Production companies which has produced the most number of hit movies (average rating > 8) are 'Dream Warrior Pictures' & 'National Theatre Live'.  






-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT genre,
       Count(M.id) AS MOVIE_COUNT
FROM   movie AS M
       INNER JOIN genre AS G
               ON G.movie_id = M.id
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  year = 2017
       AND Month(date_published) = 3
       AND country LIKE '%USA%'
       AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC;

-- Comment: above query has following things in WHERE clause:
-- Number of movies released in==>  each 'genre' & 'During March 2017' & In 'the USA' & Movies had more than 1,000 votes

  




-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT  title,
       avg_rating,
       genre
FROM   movie AS mov
       INNER JOIN genre AS gen
               ON gen.movie_id = mov.id
       INNER JOIN ratings AS rat
               ON rat.movie_id = mov.id
WHERE  avg_rating > 8
       AND title LIKE 'THE%'
GROUP BY title
ORDER BY avg_rating DESC;
-- Comment: Query has following things in where clause: LIKE operator for 'THE%' & average rating > 8
-- then grouped bt title and ordered by avg_rating (in descending order).







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT median_rating, Count(*) AS movie_count
FROM   movie AS mov
       INNER JOIN ratings AS rat
               ON rat.movie_id = mov.id
WHERE  median_rating = 8
       AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;
-- Answer: Of the movies released between 1 April 2018 and 1 April 2019, Movies given a median rating of 8 are 361.








-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


-- part1 of query : the total number of votes for German and Italian movies.
SELECT languages,
       Sum(total_votes) AS VOTES
FROM   movie AS mov
       INNER JOIN ratings AS rat
               ON rat.movie_id = mov.id
WHERE  languages LIKE '%Italian%'
UNION
SELECT languages,
       Sum(total_votes) AS VOTES
FROM   movie AS mov
       INNER JOIN ratings AS rat
               ON rat.movie_id = mov.id
WHERE  languages LIKE '%GERMAN%'
ORDER  BY votes DESC; 
-- part 2 of query 
WITH VOTES_SUMMARY AS 
(
SELECT languages, SUM(total_votes) AS VOTES 
FROM MOVIE AS mov
INNER JOIN RATINGS AS rat 
ON rat.MOVIE_ID = mov.ID
WHERE languages like '%Italian%'
UNION
SELECT languages, SUM(total_votes) AS VOTES 
FROM MOVIE AS mov
INNER JOIN RATINGS AS rat 
ON rat.MOVIE_ID = mov.ID
WHERE languages like '%GERMAN%'
),
LANGUAGE_VOTE AS
(
SELECT languages FROM VOTES_SUMMARY
ORDER BY VOTES DESC
LIMIT 1)
SELECT IF (languages LIKE 'GERMAN' , 'YES', 'NO') AS ANSWER
FROM LANGUAGE_VOTE ;

-- Answer: Yes
-- comment: Since we have to find if German movies get more votes than Italian movies? 
-- here we can find it based on 'language' column or based on 'country' column but 
-- we know Germen language can used in Austria and Switzerland too so based on country might not be right approach, so based on Language. 
-- total number of votes for German and Italian movies ->check Which one have more votes.

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
-- Part 1 of query 
SELECT Count(*) AS name_nulls
FROM   names
WHERE  NAME IS NULL;

SELECT Count(*) AS height_nulls
FROM   names
WHERE  height IS NULL;

SELECT Count(*) AS date_of_birth_nulls
FROM   names
WHERE  date_of_birth IS NULL;

SELECT Count(*) AS known_for_movies_nulls
FROM   names
WHERE  known_for_movies IS NULL; 


-- part2
SELECT 
		SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
		
FROM names;


-- Answer: columns containing NULLS: Height, date_of_birth, known_for_movies.  






/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_3_genres AS
(
           SELECT     genre,
                      Count(m.id)                            AS movie_count ,
                      Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM       movie                                  AS m
           INNER JOIN genre                                  AS g
           ON         g.movie_id = m.id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 )
SELECT     n.NAME            AS director_name ,
           Count(d.movie_id) AS movie_count
FROM       director_mapping  AS d
INNER JOIN genre G
using     (movie_id)
INNER JOIN names AS n
ON         n.id = d.name_id
INNER JOIN top_3_genres
using     (genre)
INNER JOIN ratings
using      (movie_id)
WHERE      avg_rating > 8
GROUP BY   NAME
ORDER BY   movie_count DESC limit 3 ;

-- Answer: top three directors in the top three genres whose movies have an average rating > 8 : James Mangold (movie count:4), Joe Russo (movie count:3) and Anthony Russo (movie count:3) 






/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT nam.name          AS actor_name,
       Count(movie_id) AS movie_count
FROM   role_mapping AS rol
       INNER JOIN movie AS mov
               ON mov.id = rol.movie_id
       INNER JOIN ratings AS rat USING(movie_id)
       INNER JOIN names AS nam
               ON nam.id = rol.name_id
WHERE  rat.median_rating >= 8
AND category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2;

-- Answer: top two actors whose movies have a median rating >= 8 : 1. Mammootty  2.Mohanlal





/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     production_company,
           Sum(total_votes)                            AS vote_count,
           Rank() OVER(ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
FROM       movie                                       AS mov
INNER JOIN ratings                                     AS rat
ON         rat.movie_id = mov.id
GROUP BY   production_company limit 3;

-- Answer: top three production houses based on the number of votes received by their movies: 
-- 1. Marvel Studios
-- 2. Twentieth Century Fox
-- 3. Warner Bros. 








/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actor_summary
     AS (SELECT nam.NAME   AS actor_name,
                total_votes,
                Count(rat.movie_id)   AS movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating
         FROM   movie AS mov
                INNER JOIN ratings AS rat
                        ON mov.id = rat.movie_id
                INNER JOIN role_mapping AS rol
                        ON mov.id = rol.movie_id
                INNER JOIN names AS nam
                        ON rol.name_id = nam.id
         WHERE  category = 'ACTOR'
                AND country = "india"
         GROUP  BY NAME
         HAVING movie_count >= 5)
SELECT *,
       Rank()
         OVER(
           ORDER BY actor_avg_rating DESC) AS actors_rank
FROM   actor_summary; 

-- actors at the top of the list: 1.Vijay Sethupathi, 2.Fahadh Faasil & 3.Yogi Babu. 








-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:



WITH actress_summary AS
(
           SELECT     nam.NAME AS actress_name,
                      total_votes,
                      Count(rat.movie_id)                                     AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS avg_rating
           FROM       movie                                                 AS mov
           INNER JOIN ratings                                               AS rat
           ON         mov.id=rat.movie_id
           INNER JOIN role_mapping AS rol
           ON         mov.id = rol.movie_id
           INNER JOIN names AS nam
           ON         rol.name_id = nam.id
           WHERE      category = 'ACTRESS'
           AND        country = "INDIA"
           AND        languages LIKE '%HINDI%'
           GROUP BY   NAME
           HAVING     movie_count>=3 )
SELECT   *,
         Rank() OVER(ORDER BY avg_rating DESC) AS actress_rank
FROM     actress_summary LIMIT 5;

-- top five actresses in Hindi movies released in India based on their average ratings:
-- 1. Taapsee Pannu
-- 2. Kriti Sanon
-- 3. Divya Dutta
-- 4. Shraddha Kapoor
-- 5. Kriti Kharbanda



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


WITH thriller_movies
     AS (SELECT DISTINCT title,
                         avg_rating
         FROM   movie AS mov
                INNER JOIN ratings AS rat
                        ON rat.movie_id = mov.id
                INNER JOIN genre AS gen using(movie_id)
         WHERE  genre LIKE 'THRILLER')
SELECT *,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END AS avg_rating_category
FROM   thriller_movies; 

-- Above query can be used to categorise thriller movies as per avg rating.




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT genre,
		ROUND(AVG(duration),2) AS avg_duration,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM movie AS mov 
INNER JOIN genre AS gen 
ON mov.id= gen.movie_id
GROUP BY genre
ORDER BY genre;








-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies



WITH top_genres AS
(
           SELECT     genre,
                      Count(mov.id)                            AS movie_count ,
                      Rank() OVER(ORDER BY Count(mov.id) DESC) AS genre_rank
           FROM       movie                                  AS mov
           INNER JOIN genre                                  AS gen
           ON         gen.movie_id = mov.id
           INNER JOIN ratings AS rat
           ON         rat.movie_id = mov.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 ), movie_summary AS
(
           SELECT     genre,
                      year,
                      title AS movie_name,
                      CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS worlwide_gross_income ,
                      DENSE_RANK() OVER(partition BY year ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10))  DESC ) AS movie_rank
           FROM       movie                                                                     AS mov
           INNER JOIN genre                                                                     AS gen
           ON         mov.id = gen.movie_id
           WHERE      genre IN
                      (
                             SELECT genre
                             FROM   top_genres)
            GROUP BY   movie_name
           )
SELECT *
FROM   movie_summary
WHERE  movie_rank<=5
ORDER BY YEAR;






-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:



WITH production_company_summary
     AS (SELECT production_company,
                Count(*) AS movie_count
         FROM   movie AS mov
                inner join ratings AS rat
                        ON rat.movie_id = mov.id
         WHERE  median_rating >= 8
                AND production_company IS NOT NULL
                AND Position(',' IN languages) > 0
         GROUP  BY production_company
         ORDER  BY movie_count DESC)
SELECT *,
       Rank()
         over(
           ORDER BY movie_count DESC) AS prod_comp_rank
FROM   production_company_summary
LIMIT 2; 

-- Answer -> top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies: Star Cinema & Twentieth Century Fox. 






-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actress_summary AS
(
           SELECT     nam.NAME AS actress_name,
                      SUM(total_votes) AS total_votes,
                      Count(rat.movie_id)                                     AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM       movie                                                 AS mov
           INNER JOIN ratings                                               AS rat
           ON         mov.id=rat.movie_id
           INNER JOIN role_mapping AS rol
           ON         mov.id = rol.movie_id
           INNER JOIN names AS nam
           ON         rol.name_id = nam.id
           INNER JOIN GENRE AS gen
           ON gen.movie_id = mov.id
           WHERE      category = 'ACTRESS'
           AND        avg_rating>8
           AND genre = "Drama"
           GROUP BY   NAME )
SELECT   *,
         Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM     actress_summary LIMIT 3;



-- Answer-> top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre:
-- 1.Parvathy Thiruvothu 
-- 2.Susan Brown 
-- 3.Amanda Lawrence




/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH next_date_published_summary AS
(
           SELECT     dir.name_id,
                      NAME,
                      dir.movie_id,
                      duration,
                      rat.avg_rating,
                      total_votes,
                      mov.date_published,
                      Lead(date_published,1) OVER(partition BY dir.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping                                                                      AS dir
           INNER JOIN names                                                                                 AS nam
           ON         nam.id = dir.name_id
           INNER JOIN movie AS mov
           ON         mov.id = dir.movie_id
           INNER JOIN ratings AS rat
           ON         rat.movie_id = mov.id ), top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   next_date_published_summary )
SELECT   name_id                       AS director_id,
         NAME                          AS director_name,
         Count(movie_id)               AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2)               AS avg_rating,
         Sum(total_votes)              AS total_votes,
         Min(avg_rating)               AS min_rating,
         Max(avg_rating)               AS max_rating,
         Sum(duration)                 AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;
-- Comment: Query for details for top 9 directors (based on number of movies) as above.  





