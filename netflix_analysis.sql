SELECT COUNT(*)FROM netflix_titles;
SELECT *
FROM netflix_titles
LIMIT 10;
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'netflix_titles'
ORDER BY ordinal_position;


--total movies and tv shows
select type,
count(*) as total_titles
from netflix_titles
group by type
order by total_titles desc;

--total content by release year
select release_year,
count(*) as total_titles
from netflix_titles
where release_year is not null
group by release_year
order by release_year;

--top 10 genres
select TRIM(genre) as genre,
count(*) as total_titles
from netflix_titles,
lateral unnest(string_to_array(listed_in, ',')) as genre
where listed_in <> 'unknown'
group by TRIM(genre)
order by total_titles desc
limit 10;

--top 10 countries by content
select TRIM(country_name) as country,
count(*) as total_titles
from netflix_titles,
lateral unnest(string_to_array(country, ',')) as country_name
where country<> 'unknown'
group by TRIM(country_name)
order by total_titles desc
limit 10;

--content added each year
select year_added,
count(*) as total_titles_added
from netflix_titles
where year_added is not null
group by year_added
order by year_added;

--content rating distribution
select rating,
count(*) as total_titles
from netflix_titles
where rating is not null
and rating<> 'unknown'
group by rating
order by total_titles desc;

--movies duration analysis
select cast(
nullif(
regexp_replace(duration, '[^0-9]', '', 'g'),
''
) as integer
)as duration_minutes,
count(*) as total_movies
from netflix_titles
where type ='movies'
and duration ~ '^[0-9]+ min$'
group by duration
order by duration_minutes;

--dashboard KPI query
select count(*) as total_titles,
count(*) filter(
where type= 'movies'
)
as total_movies,
count(*) filter(
where type= 'tv shows'
)as total_tv_shows,
count(distinct country)filter(
where country is not null
and country <> 'unknown'
) as country_entries
from netflix_titles;

