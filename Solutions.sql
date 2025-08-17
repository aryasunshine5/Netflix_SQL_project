--Project Netflix 
--Create table Netflix
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix 
	(
	show_id	VARCHAR (10) PRIMARY KEY,
	type VARCHAR (10),	
	title VARCHAR(150),	
	director VARCHAR(250),	
	casts VARCHAR (1000),
	country	VARCHAR (150),
	date_added VARCHAR (50),
	release_year INT,
	rating VARCHAR (10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(300)
	)

SELECT COUNT (*) FROM netflix;

SELECT DISTINCT (type) FROM netflix;

--Q.1 Count the number of Movies vs TV Shows

SELECT type, COUNT (*) as total_content
FROM netflix
GROUP BY type

--Q.2 Find the most common rating for movies and TV shows

SELECT type, rating, ranking FROM
	(
	SELECT type, rating, 
	COUNT(*),
	RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) as Ranking
	FROM netflix
	GROUP BY type, rating
	) as t1
WHERE ranking=1
--ORDER BY 1, 3 DESC

--Q.3 List all movies released in a specific year (e.g., 2020)

SELECT * 
FROM netflix	
WHERE type = 'Movie' AND release_year = 2020

--Q.4 Find the top 5 countries with the most content on Netflix

SELECT 
	UNNEST (STRING_TO_ARRAY (country, ',')) as new_country,
	COUNT (show_id)
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q.5 Identify the longest movie

SELECT type, title, duration 
FROM netflix
WHERE type = 'Movie' AND duration = (SELECT MAX (duration) FROM netflix)

--Q.6 Find content added in the last 5 years

SELECT *
	FROM netflix
WHERE TO_DATE (date_added, 'Month DD, YYYY') >= current_date - interval '5 years'

--Q.7 Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'

--Q.8 List all TV shows with more than 5 seasons

SELECT *
FROM netflix 
WHERE type = 'TV Show' AND SPLIT_PART (duration, ' ', 1) :: numeric > 5

--SELECT *, SPLIT_PART (duration, ' ', 1) as seasons FROM netflix

--Q.9 Count the number of content items in each genre

SELECT 
		UNNEST (STRING_TO_ARRAY (listed_in, ',')) as genre, 
		COUNT (show_id) as total_content
FROM netflix
GROUP BY 1

--Q.10 Find each year and the average numbers of content release in India on netflix.

SELECT 
	EXTRACT (year FROM TO_DATE (date_added, 'Month DD,YYYY')) as Year, COUNT (*) as total_content,
	ROUND 
	(COUNT(*) :: numeric / (SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100 
	,2)
	as avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1

--Q.11 List all movies that are documentaries

SELECT *
FROM netflix
WHERE type = 'Movie'
AND listed_in ILIKE '%Documentaries%'

--Q.12 Find all content without a director

SELECT * 
FROM netflix
WHERE director IS NULL

--Q.13 Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT COUNT(*) FROM netflix
	WHERE casts ILIKE '%Salman Khan%' 
	AND type = 'Movie'
	AND release_year > EXTRACT (year FROM CURRENT_DATE) - 10

--Q.14 Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT UNNEST (STRING_TO_ARRAY (casts, ',')) as actors, COUNT (show_id) as total_movies
FROM netflix 
WHERE type = 'Movie' AND country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

--Q.15 Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. 
--Label content containing these keywords as 'Bad' and all other content as 'Good'. 
--Count how many items fall into each category.

WITH t1
AS 
	(SELECT *,
		CASE 
			WHEN 
			description ILIKE '%kill%'
			OR 
			description ILIKE '%violence%' THEN 'bad_content'
			ELSE 'good_content'
		END category
	FROM netflix)

SELECT category, COUNT(*) as total_items FROM t1
GROUP BY 1

--End of project