-- 15 Business Problems

-- 1. Count the number of Movies vs TV Shows
Select 
	type,
	count(show_id) as count

From netflix_db

Group By type


--2. Find the most common rating for movies and TV shows

Select 
	type,
	rating
From
(
Select 
	type,
	rating,
	count(*) as count,
	rank() over(partition by type order by count(*) DESC) as ranking

From netflix_db

Group by type, rating
) as table1

Where ranking =1

-- 3. List all movies released in 2020)

Select 
	type,
	title,
	release_year

From netflix_db

Where release_year =2020 AND type ='Movie'

--4. Find the top 5 countries with the most content on Netflix

Select 
	TOP 5 country,
	count(*) as count
From 
(
-- splitting country column by comma delimiter

Select
	title,
	y.value as country


From netflix_db

Cross apply string_split(country,',')y
) as table_2

Group by country

Order by count(*) DESC


--5. Identify the longest movie

SELECT 
	*

FROM netflix_db

Where type = 'Movie' 
	and 
	duration = (SELECT MAX(duration) from netflix_db)


--6. Find content added in the last 5 years

SELECT 
	*,
	-- Extracted year date_added column
	YEAR(Convert(varchar, date_added, 100)) as ConvertedDate

FROM netflix_db

WHERE YEAR(Convert(varchar, date_added, 100)) = 2021
	or YEAR(Convert(varchar, date_added, 100)) = 2020
	or YEAR(Convert(varchar, date_added, 100)) = 2019
	or YEAR(Convert(varchar, date_added, 100)) = 2018

Order by YEAR(Convert(varchar, date_added, 100)) DESC

	
-- 7. Find all the movies/TV shows by director 'Steven Spielberg'!

SELECT 
	*
FROM netflix_db

Where director Like '%Steven Spielberg%'


-- 8. List all TV shows with more than 5 seasons

Select
	title,
	duration

From netflix_db

Where type = 'TV show'
	and
	left(duration,1) >= 5

Order by left(duration,1) DESC


-- 9. Count the number of content items in each genre

Select 
	genre,
	count(*) as count
FROM
(
-- Seperating genres out
SELECT 
	type,
	title,
	y.value as genre


From netflix_db

Cross apply string_split(listed_in,',')y
) as table3

GROUP BY genre

Order By count(*) DESC


--10.Find each year and the average numbers of date added in USA on netflix. 
--return top 5 year with highest avg content release!


SELECT 
	YEAR(Convert(varchar, date_added, 100)) as ConvertedDateRelease,
	count(*) as yearly_count,
	round(
	(count(*) +.0)  / (select (count(*)+.0) from netflix_db where country = 'United States')*100
	,2) as avg_content_per_year


FROM netflix_db
Where country = 'United States'

Group By YEAR(Convert(varchar, date_added, 100))


-- 11. List all movies that are documentaries
Select 
	type,
	title,
	director,
	country,
	listed_in,
	duration

From netflix_db

Where type = 'Movie' 
	AND 
	listed_in LIKE '%Documentaries%'


--12. Find all content without a director

SELECT * FROM netflix_db

WHERE director is NULL

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years

SELECT * 

FROM netflix_db

Where cast LIKE '%Salman Khan%'
	AND release_year >= 2015


--14. Find the top 10 actors who have appeared in the highest number of movies produced in United States.

SELECT 
	 top 10 cast,
	count(*) as number_of_movies

FROM 
(
SELECT 
	type,
	title,
	y.value as cast,
	country


From netflix_db

Cross apply string_split(cast,',')y

Where country LIKE '%United States%'

) as table4

GROUP BY cast 

Order by count(*) desc 


--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

WITH new_table
AS
(

SELECT 
*, 
	CASE 
	WHEN description LIKE '%kill%' OR
		description LIKE '%violence%' THEN 'Bad_Content'
	ELSE'Good_Content'
	END category

FROM netflix_db
)

SELECT 
	category,
	count(*) as total_content
FROM new_table

GROUP BY category
	



