# Netflix_SQL_Project
Answering business problems for Netflix using SQL

- [Project Overview](#project-overview)
- [Objectives](#objectives)
- [Dataset](#dataset)
- [Enviroment Setup](#enviroment_setup)
- [Business Problems and Solutions](#business_problems_and_Solutions)

### Project Overview
--- 
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset.

### Project Overview
---
The project seeks to collect data to gain insights into various business needs, including:

  * Analyzing the distribution of content types (comparing movies and TV shows).
  * Identifying the most common ratings for both movies and TV shows.
  * Compiling and evaluating content based on release years, countries, and durations.
  * Exploring and categorizing content according to specific criteria and keywords.

### Project Overview
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


    
