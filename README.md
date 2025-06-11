# Netflix-Movies-and-TV-Shows-Data-Analysis
# Netflix Movies and TV Shows Data Analysis using SQL

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Project Structure

### Database Setup

- **Database Creation**: Created a database named `library_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE netflix_db;

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

###Business Problems & Solutions

##Q1. Count the number of Movies vs TV Shows

```SQL
SELECT 
	TYPE,COUNT(*) FROM netflix 
	GROUP BY 1 
	ORDER BY 1;
```
**Objective:** Determine the distribution of content types on Netflix.

##Q2. Find the most common rating for movies and TV shows
```sql

SELECT
	TYPE,
	RATING
FROM
 ( 
	SELECT 
		TYPE,
		RATING, 
		COUNT(*),
		rank() over(partition by type order by count(*) desc) as ranking
	FROM NETFLIX
	GROUP BY 1,2
  ) AS T1
  WHERE 
  RANKING = 1
	;
**Objective:** Identify the most frequently occurring rating for each type of content.

```
##Q3. List all movies released in a specific year (e.g., 2020)

```sql

SELECT 
	 *
FROM NETFLIX
WHERE 
type = 'Movie'
AND
release_year = 2020;

```
**Objective:** Retrieve all movies released in a specific year.

##Q4. Find the top 5 countries with the most content on Netflix

```sql

select 
	unnest(STRING_TO_ARRAY(country, ', ')),
	count(*)
from netflix
group by 1
order by 2 desc
limit 5;

```
**Objective:** Identify the top 5 countries with the highest number of content items.

##Q5. Identify the longest movie

```sql

select
	*
from netflix
where duration is not null
order by split_part(duration,' ',1)::int desc
limit 1;

```
**Objective:** Find the movie with the longest duration.

##Q6. Find content added in the last 5 years

```sql

select * 
from netflix
where TO_DATE(date_added,'Month DD,YYYY') >= current_date - interval '5 years')
order by TO_DATE(date_added,'Month DD,YYYY')  desc;

select current_date - interval '5 year'

```
**Objective:** Retrieve content added to Netflix in the last 5 years.

##Q7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

```sql

select 
	title,
	type,
	count(*)
from netflix
where director like '%Rajiv Chilaka%'
group by 1,2
order by 1;

select * FROM NETFLIX;

```
**Objective:** List all content directed by 'Rajiv Chilaka'.

##Q8. List all TV shows with more than 5 seasons

```sql

select 
	* 
from netflix
where 
type = 'TV Show'
and
split_part(duration, '',1) > '5 seasons';

select * from netflix;

```
**Objective:** Identify TV shows with more than 5 seasons.

##Q9. Count the number of content items in each genre

```sql

select 
	unnest(STRING_TO_ARRAY(listed_in, ', ')),
	count(show_id) as total_content 
from netflix 
group by 1 
order by 1 asc;

```

**Objective:** Count the number of content items in each genre.

##Q10.Find each year and the average numbers of content release in India on netflix. 
##return top 5 year with highest avg content release!

```sql

select 
	Extract(year from  TO_DATE(date_added,'Month DD,YYYY')) as year,
	count(*),
	round(count(*)::numeric/(select count(*)from netflix where country = 'India')::numeric * 100 ,2) as avg_content_per_year
from netflix
where country = 'India'
group by 1;

```
**Objective:** Calculate and rank years by the average number of content releases by India.

##Q11. List all movies that are documentaries

```sql

select * FROM NETFLIX
WHERE 
listed_in LIKE '%Documentaries%';

```
**Objective:** Retrieve all movies classified as documentaries.

##Q12. Find all content without a director

```sql

select
	* 
from netflix
where
director   IS NULL;

```
**Objective:** List content that does not have a director.

##Q13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
```sql
select *
from netflix
where casts ilike '%Salman Khan%'
and
release_year > Extract(year from current_date)-10;

```
**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

##Q14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

```sql

select 
	unnest(STRING_TO_ARRAY(casts, ', ')) as actors,
	count(*) as total_content
from netflix
where country like '%India'
group by 1
order by 2 Desc
limit 10;

select * from netflix;

```
**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

##Q15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

```sql

WITH New_Table
AS
(
SELECT
	*,
	CASE
	WHEN 
		description ilike '%Kill%'OR
		description ilike'%Violence%' then 'BED_CONTENT'
	    ELSE 'GOOD_CONTENT'
	 END AS category
	from netflix
)
select category,
count(*) as Total_Contant
from New_Table
group by 1;

```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - Nitesh Kumar Sharma

This project showcases SQL skills essential for database management and analysis.
 
##Thank you for your interest in this project!
