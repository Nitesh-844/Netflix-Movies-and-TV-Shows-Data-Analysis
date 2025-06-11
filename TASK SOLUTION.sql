--Business Problems & Solutions

--Q1. Count the number of Movies vs TV Shows
`SQL`
SELECT 
	TYPE,COUNT(*) FROM netflix 
	GROUP BY 1 
	ORDER BY 1;
``

--Q2. Find the most common rating for movies and TV shows

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

--Q3. List all movies released in a specific year (e.g., 2020)

SELECT 
	 *
FROM NETFLIX
WHERE 
type = 'Movie'
AND
release_year = 2020;

--Q4. Find the top 5 countries with the most content on Netflix
select 
	unnest(STRING_TO_ARRAY(country, ', ')),
	count(*)
from netflix
group by 1
order by 2 desc
limit 5;



--Q5. Identify the longest movie


select
	*
from netflix
where duration is not null
order by split_part(duration,' ',1)::int desc
limit 1;



--Q6. Find content added in the last 5 years

select * 
from netflix
where TO_DATE(date_added,'Month DD,YYYY') >= current_date - interval '5 years')
order by TO_DATE(date_added,'Month DD,YYYY')  desc;

select current_date - interval '5 year'


--Q7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select 
	title,
	type,
	count(*)
from netflix
where director like '%Rajiv Chilaka%'
group by 1,2
order by 1;

select * FROM NETFLIX;
--Q8. List all TV shows with more than 5 seasons

select 
	* 
from netflix
where 
type = 'TV Show'
and
split_part(duration, '',1) > '5 seasons';

select * from netflix;

--Q9. Count the number of content items in each genre

select 
	unnest(STRING_TO_ARRAY(listed_in, ', ')),
	count(show_id) as total_content 
from netflix 
group by 1 
order by 1 asc;



--Q10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!

select 
	Extract(year from  TO_DATE(date_added,'Month DD,YYYY')) as year,
	count(*),
	round(count(*)::numeric/(select count(*)from netflix where country = 'India')::numeric * 100 ,2) as avg_content_per_year
from netflix
where country = 'India'
group by 1;



--Q11. List all movies that are documentaries
select * FROM NETFLIX
WHERE 
listed_in LIKE '%Documentaries%';

--Q12. Find all content without a director

select
	* 
from netflix
where
director   IS NULL;

--Q13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select *
from netflix
where casts ilike '%Salman Khan%'
and
release_year > Extract(year from current_date)-10;


--Q14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select 
	unnest(STRING_TO_ARRAY(casts, ', ')) as actors,
	count(*) as total_content
from netflix
where country like '%India'
group by 1
order by 2 Desc
limit 10;

select * from netflix;
--Q15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
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