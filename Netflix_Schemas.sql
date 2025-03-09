-- Netflix Project Data Table Creation

DROP TABLE IF EXISTS netflix;
Create Table netflix
(
	show_id  VARCHAR(6),
	type  VARCHAR(10),
	title VARCHAR(250),
	director VARCHAR(550),
	casts VARCHAR(1050),
	COUNTRY VARCHAR(550),
	date_added VARCHAR(55),
	release_year INT,
	rating varchar(15),
	duration VARCHAR(15),
	listed_in VARCHAR(250),
	description VARCHAR(550)
);

SELECT count(*) as total_content 

FROM netflix_db