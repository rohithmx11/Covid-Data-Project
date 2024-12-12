SELECT * 
FROM coviddeaths
order by 3,4;


SELECT *
FROM covidvaccinations
order by 3,4


--Selecting data which is going to use


SELECT [location],[date],total_cases,new_cases,total_deaths,[population]
FROM coviddeaths
ORDER BY 1,2


-- Looking at Total Cases vs Total Deaths

SELECT [location],[date],total_cases,total_deaths,[population],(total_deaths/total_cases)*100 as Death_Percentage
FROM coviddeaths
where total_cases > 0 and location = 'India'
ORDER BY 1,2


-- Looking at Total Cases vs Population
-- Shows what percentage of population got covid

SELECT [location],[date],[population],total_cases,cast((total_cases/[population])*100 as decimal(18,10)) as PercentagePopulationinfected
FROM coviddeaths
--where location = 'India'
ORDER BY 1,2


-- Looking at Countries with Highest infection rate compared to population

SELECT [location],[population],MAX(total_cases) as HighestInfectionCount,
MAX(CAST((total_cases/[population])*100 AS decimal(18,10))) as PercentagePopulationinfected
FROM coviddeaths
--where location = 'India'
GROUP BY [population],[location]
ORDER BY 4 DESC


--Showing Countries with highest death count per population


SELECT [location],[population],MAX(total_deaths) as TotalDeathcount 
FROM coviddeaths
--where location = 'India'
GROUP BY [population],[location]
ORDER BY 3 DESC


-- Breaking down things by Continent

-- Continent with highest death count per population

SELECT continent,sum(new_deaths) as TotalDeathcount 
FROM coviddeaths
--where location = 'India'
GROUP BY continent
ORDER BY TotalDeathcount DESC


-- Cumulative COVID-19 Cases by Continent Over Time

SELECT
	continent,
	date,
	SUM(new_cases)over(partition by continent order by date) as continents_cumulative_case
FROM
	coviddeaths;

-- Cumulative Cases and Deaths per 100k Population in HDI categories

SELECT 
	t1.[date],
	t1.[Classification of HDI],
	ROUND(sum(t2.total_deaths)/SUM(t2.total_cases)*100,2) AS fatality_case,
	ROUND(sum(t2.total_deaths)/SUM(distinct population)*100,4) AS fatality_population,
	ROUND(SUM(t2.total_cases) / SUM(t2.population) * 100000, 2) AS cumulative_cases_per_100k,
	ROUND(sum(t2.total_deaths)/SUM(distinct population)*100000,4) AS fatality_rate_per_100k_population
from(
SELECT [location],[date],human_development_index,
	CASE WHEN human_development_index > 0.800 THEN 'Very high human development'
		 WHEN human_development_index between 0.700 and 0.799 THEN 'High human development'
		 WHEN human_development_index between 0.550 and 0.699 THEN 'Medium human development'
		 WHEN human_development_index < 0.550 THEN 'Low human development'
		 END AS 'Classification of HDI'
FROM covidvaccinations) AS t1
JOIN
(
SELECT continent,[location],[date],total_cases,total_deaths,[population]
FROM coviddeaths) AS t2
ON t1.[location] = t2.[location] and t1.[date] = t2.[date]
GROUP BY t1.[date],t1.[Classification of HDI];


--Total test and cumulative cases across different HDI


WITH tests_per_countries AS
(
SELECT 
	[location],
	MAX(total_tests) AS total_tests,
	human_development_index
FROM covidvaccinations
WHERE YEAR([date])< 2023
GROUP BY [location],human_development_index),
tests_cases_per_countries AS
(
SELECT ts.[location],
	MAX(ts.total_tests)AS total_tests,
	MAX(ts.human_development_index) AS hdi,
	MAX(dea.total_cases)AS total_cases,
	MAX(population) AS 'population',
	CASE WHEN MAX(human_development_index) > 0.800 THEN 'Very high human development'
		 WHEN MAX(human_development_index) BETWEEN 0.700 AND 0.799 THEN 'High human development'
		 WHEN MAX(human_development_index) BETWEEN 0.550 AND 0.699 THEN 'Medium human development'
		 WHEN MAX(human_development_index) < 0.550 THEN 'Low human development'
		 END AS 'Classification of HDI'
FROM tests_per_countries AS ts
join
coviddeaths AS dea 
ON ts.[location] = dea.[location]
WHERE YEAR(dea.[date]) < 2023
GROUP BY  ts.[location])
SELECT 
	[Classification of HDI],
	round(SUM(total_tests)/sum([population])*1,3) AS tests_per_population,
	ROUND(SUM(total_cases)/SUM([population]) * 1,5) AS cases_per_population
FROM tests_cases_per_countries
WHERE [Classification of HDI] is not null
GROUP BY [Classification of HDI]


-- Average Percentage of Population Aged 65+ and Fatality Rate per 100k by HDI Classification


SELECT 
    [Classification of HDI],
    AVG(aged_65_older) AS avg_percent_aged_65_plus,
    AVG(fatality_per_100k) AS avg_fatality_per_100k
FROM (
    SELECT DISTINCT 
        t1.location,
        human_development_index,
        aged_65_older,
        fatality_per_100k,
        CASE 
            WHEN human_development_index > 0.800 THEN 'Very high human development'
            WHEN human_development_index BETWEEN 0.700 AND 0.799 THEN 'High human development'
            WHEN human_development_index BETWEEN 0.550 AND 0.699 THEN 'Medium human development'
            WHEN human_development_index < 0.550 THEN 'Low human development'
        END AS [Classification of HDI]
    FROM 
        covidvaccinations AS t1
    JOIN (
        SELECT 
            location,
            MAX(total_deaths) / MAX(population) * 100000 AS fatality_per_100k
        FROM 
            coviddeaths
        GROUP BY [location]
    ) t2
    ON t1.location = t2.location
) t3
WHERE [Classification of HDI] IS NOT NULL
GROUP BY [Classification of HDI];




-- Global Numbers

SELECT SUM(new_cases)AS Total_Cases,SUM(new_deaths) AS Total_Deaths,
SUM(new_deaths)/SUM(new_cases)*100 AS Death_percentage
FROM coviddeaths
ORDER BY 1,2
