# Netflix_SQL_Project
Answering business problems for Netflix using SQL

- [Project Overview](#project-overview)
- [Objectives](#objectives)
- [Dataset](#dataset)
- [Enviroment Setup](#enviroment_setup)
- [Business Problems and Solutions](#business_problems_and_solutions)
- [Conclusion](#conclusion)

### Project Overview
--- 
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset.

### Objectives
---
The project seeks to collect data to gain insights into various business needs, including:

  * Analyzing the distribution of content types (comparing movies and TV shows).
  * Identifying the most common ratings for both movies and TV shows.
  * Compiling and evaluating content based on release years, countries, and durations.
  * Exploring and categorizing content according to specific criteria and keywords.

### Dataset
---
The data for this project is sourced from the Kaggle dataset:

  * Dataset: https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download

### Enviroment Setup
---
Dataset was exported to Excel and loaded into SQL Management Server. The following columns were created:

-- Netflix Project Data Table Creation

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
    
    SELECT count(*) as total_content 
    
    FROM netflix_db

### Business Problems and Solutions
---
#### 1. Count the Number of Movies vs TV Shows

    Select 
	    type,
	    count(show_id) as count
    From netflix_db
    Group By type
    
Objective: Determine the distribution of content types on Netflix.

#### 2. Find the most common rating for movies and TV shows
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
 
Objective: Identify the most frequently occurring rating for each type of content.

#### 3. List all movies released in 2020
	Select 
		type,
		title,
		release_year	
	From netflix_db
	Where release_year =2020 AND type ='Movie'

Objective: Retrieve all movies released in a specific year.

#### 4. Find the top 5 countries with the most content on Netflix
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

Objective: Identify the top 5 countries with the highest number of content items.

#### 5. Identify the longest movie
	SELECT 
	*
	FROM netflix_db	
	Where type = 'Movie' 
		and 
		duration = (SELECT MAX(duration) from netflix_db)
  
Objective: Find the movie with the longest duration.

#### 6. Find content added in the last 5 years
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

Objective: Retrieve content added to Netflix in the last 5 years.

#### 7. Find all the movies/TV shows by director 'Steven Spielberg'
	SELECT 
	*
	FROM netflix_db	
	Where director Like '%Steven Spielberg%'

Objective: List all content directed by 'Steven Spielberg'.

 #### 8. List all TV shows with more than 5 seasons
 	Select
	title,
	duration

	From netflix_db	
	Where type = 'TV show'
		and
		left(duration,1) >= 5	
	Order by left(duration,1) DESC

Objective: Identify TV shows with more than 5 seasons.

 #### 9. Count the number of content items in each genre
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

Objective: Count the number of content items in each genre.

 #### 10.Find each year and the average numbers of content added in USA on netflix. Return top 5 year with highest avg content release
 	SELECT 
	YEAR(Convert(varchar, date_added, 100)) as ConvertedDateRelease,
	count(*) as yearly_count,
	round(
	(count(*) +.0)  / (select (count(*)+.0) from netflix_db where country = 'United States')*100
	,2) as avg_content_per_year

	FROM netflix_db
	Where country = 'United States'
	Group By YEAR(Convert(varchar, date_added, 100))

Objective: Calculate and rank years by the average number of content releases in the US.

 #### 11. List all movies that are documentaries
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
  
Objective: Retrieve all movies classified as documentaries.

 #### 12. Find all content without a director
 	
	SELECT * FROM netflix_db	
	WHERE director is NULL

Objective: List content that does not have a director.

 #### 13. Find how many movies actor 'Salman Khan' appeared in last 10 years
 	SELECT * 

	FROM netflix_db	
	Where cast LIKE '%Salman Khan%'
		AND release_year >= 2015

Objective: Count the number of movies featuring 'Salman Khan' in the last 10 years.

 #### 14. Find the top 10 actors who have appeared in the highest number of movies produced in United States.
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

Objective: Identify the top 10 actors with the most appearances in American-produced movies.

 #### 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
 
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

Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

### Conclusion
--- 
This analysis offers an overview of Netflix's content, aiding in the development of content strategy and decision-making. This project displays the ability to extract valuable insights to make business decisions using SQL.
    
