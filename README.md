# Netflix movies and TV shows data analysis using SQL

[Netflix_logo](https://github.com/aryasunshine5/Netflix_SQL_project/blob/main/logo.png)

## Objective 
Analyze the distribution of content types (movies vs TV shows).
Identify the most common ratings for movies and TV shows.
List and analyze content based on release years, countries, and durations.
Explore and categorize content based on specific criteria and keywords.

## Dataset
The data for this project is sourced from the Kaggle dataset:
[dataset link](https://github.com/aryasunshine5/Netflix_SQL_project/blob/main/netflix_titles.csv)
(https://github.com/aryasunshine5/Netflix_SQL_project/blob/main/netflix_titles.xlsx)

## Schema
```sql
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
	);
```

 ## Business problems and their solutions
 
### 1.Count the Number of Movies vs TV Shows

```sql
SELECT type, COUNT (*) as total_content
FROM netflix
GROUP BY type;
```
**Objective:**To determine the distribution of content on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
SELECT type, rating, ranking FROM
	(
	SELECT type, rating, 
	COUNT(*),
	RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) as Ranking
	FROM netflix
	GROUP BY type, rating
	) as t1
WHERE ranking=1
--ORDER BY 1, 3 DESC;
```
**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * 
FROM netflix	
WHERE type = 'Movie' AND release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix
```sql
SELECT 
	UNNEST (STRING_TO_ARRAY (country, ',')) as new_country,
	COUNT (show_id)
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT type, title, duration 
FROM netflix
WHERE type = 'Movie' AND duration = (SELECT MAX (duration) FROM netflix);
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years
```sql
SELECT *
	FROM netflix
WHERE TO_DATE (date_added, 'Month DD, YYYY') >= current_date - interval '5 years';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT *
FROM netflix 
WHERE type = 'TV Show' AND SPLIT_PART (duration, ' ', 1) :: numeric > 5;
```
--SELECT *, SPLIT_PART (duration, ' ', 1) as seasons FROM netflix

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
		UNNEST (STRING_TO_ARRAY (listed_in, ',')) as genre, 
		COUNT (show_id) as total_content
FROM netflix
GROUP BY 1;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix.

```sql
SELECT 
	EXTRACT (year FROM TO_DATE (date_added, 'Month DD,YYYY')) as Year, COUNT (*) as total_content,
	ROUND 
	(COUNT(*) :: numeric / (SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100 
	,2)
	as avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1;
```
**Objective:** Calculate the average number of content released in India.

### 11. List All Movies that are Documentaries

```sql
SELECT *
FROM netflix
WHERE type = 'Movie'
AND listed_in ILIKE '%Documentaries%';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT COUNT(*) FROM netflix
	WHERE casts ILIKE '%Salman Khan%' 
	AND type = 'Movie'
	AND release_year > EXTRACT (year FROM CURRENT_DATE) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India.

```sql
SELECT UNNEST (STRING_TO_ARRAY (casts, ',')) as actors, COUNT (show_id) as total_movies
FROM netflix 
WHERE type = 'Movie' AND country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
GROUP BY 1;
```
**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help in informed decision-making.

##End of Project
