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
GROUP BY type
```





