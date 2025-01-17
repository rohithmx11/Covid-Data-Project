# Global Lessons from COVID-19: How HDI and Demographics Shaped the Pandemic's Impact

## SQL Methodology

### **1. Data Acquisition**
**Source**  
The data was downloaded from [Our World in Data](https://ourworldindata.org/), a trusted source for COVID-19-related datasets.

---

### **2. Preprocessing in Excel**
1. The dataset was cleaned and split into two files for analysis:

   - **coviddeaths.csv**: Focused on data related to cases, deaths, and population.
   - **covidvaccinations.csv**: Included data on vaccination progress, testing rates, and human development index (HDI).

3. The split ensured better data organization and easier analysis in SQL.

---

### **3. Data Import into SQL Server**
- The cleaned CSV files were imported into SQL Server using the **Import and Export Data Wizard**.
   - This tool allows seamless import of CSV files directly into SQL tables.
   - The process ensures proper data type mapping and eliminates manual table creation errors.
- The imported tables were named:
   - **coviddeaths**
   - **covidvaccinations**

---

### **4. Data Understanding**
**Datasets Used:**
   - **coviddeaths**: Contains data on COVID-19 cases, deaths, and population by location and date.
   - **Key Columns:** `location`, `date`, `total_cases`, `total_deaths`, `population`
   
```sql
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'coviddeaths'
      AND TABLE_SCHEMA = 'dbo';
```
![Image](https://github.com/user-attachments/assets/553495de-235a-4278-9a13-8705b14a8c58)


   - **covidvaccinations**: Contains data on vaccination progress, testing rates, and HDI by location and date.
   - **Key Columns:** `location`, `date`, `total_tests`, `human_development_index`, `aged_65_older`
```sql
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'covidvaccinations'
      AND TABLE_SCHEMA = 'dbo';
```
![Image](https://github.com/user-attachments/assets/90e8d834-a860-43f6-995f-6f86c96110b3)



---

### **5. Data Analysis**
#### Filtering Relevant Data
Extracted essential columns such as `total_cases`, `total_deaths`, `population`, `total_tests`, and `human_development_index`.

### 5.1. SQL Query: Extracting and Organizing Relevant Columns
```sql
SELECT 
	[location],
	[date],
	total_cases,
	new_cases,
	total_deaths,
	[population]
FROM coviddeaths
ORDER BY 1,2;
```
Screenshot of the SQL Output

![Image](https://github.com/user-attachments/assets/99fad622-5250-4556-8f25-ed390c6f5532)

### 5.2. SQL Query: Cumulative COVID-19 Cases by Continent Over Time
To analyze the cumulative COVID-19 cases by continent over time, we used a window function to calculate the running total of new cases for each continent, ordered by date. This helps in visualizing the growth of cases over time for different regions.
```sql
SELECT
    continent,
    date,
    SUM(new_cases) OVER (PARTITION BY continent ORDER BY date) AS continents_cumulative_case
FROM
    coviddeaths;

```
Screenshot of the SQL Output

![Image](https://github.com/user-attachments/assets/f554129c-80ae-4119-a488-3e8952b147af) 

### 5.3. SQL Query: COVID-19 Case Fatality and Population Impact by HDI Classification.
This query calculates various metrics related to COVID-19 impact, such as the case fatality rate, fatality rate per 100k population, and cumulative cases per 100k, based on the Human Development Index (HDI) classification. The HDI classification helps in categorizing regions into different levels of human development to understand how development levels influence the pandemic’s severity.

```sql
select t1.date,t1.[Classification of HDI],round(sum(t2.total_deaths)/sum(t2.total_cases)*100,2) as fatality_case,
round(sum(t2.total_deaths)/sum(distinct population)*100,4) as fatality_population,
ROUND(SUM(t2.total_cases) / SUM(t2.population) * 100000, 2) as cumulative_cases_per_100k,
round(sum(t2.total_deaths)/sum(distinct population)*100000,4) as fatality_rate_per_100k_population
from(
select location,date,human_development_index,
	case when human_development_index > 0.800 then 'Very high human development'
		 when human_development_index between 0.700 and 0.799 then 'High human development'
		 when human_development_index between 0.550 and 0.699 then 'Medium human development'
		 when human_development_index < 0.550 then 'Low human development'
		 end as 'Classification of HDI'
from covidvaccinations)t1
join
(
select continent,location,date,total_cases,total_deaths,population
from coviddeaths)t2
on t1.location = t2.location and t1.date = t2.date
where t1.[Classification of HDI] is not null
group by t1.date,t1.[Classification of HDI]
order by t1.date 
```

Screenshot of the SQL Output

![Image](https://github.com/user-attachments/assets/39c81602-43c8-45f0-b445-0aeb7681a9a8)

### 5.4. SQL Query: COVID-19 Cases Per Million and HDI Classification
This query compares the total COVID-19 cases per million population for each location (continent and country) and integrates it with demographic factors such as Human Development Index (HDI) and Population Density. The analysis also classifies locations based on their HDI to understand the relationship between development levels and the spread of COVID-19.

```sql
select t1.continent,t1.location,t1.total_cases_per_million,t2.human_development_index,t2.population_density,
	case when human_development_index > 0.800 then 'Very high human development'
		 when human_development_index between 0.700 and 0.799 then 'High human development'
		 when human_development_index between 0.550 and 0.699 then 'Medium human development'
		 when human_development_index < 0.550 then 'Low human development'
		 end as 'Classification of HDI'
from(
select continent,location,max(total_cases_per_million) total_cases_per_million
from coviddeaths
where YEAR(date) <= 2022
group by continent,location)t1
join
(select distinct continent,location,human_development_index,population_density
from covidvaccinations
where YEAR(date) <= 2022)
t2 
on t1.location = t2.location
where t2.human_development_index is not null
```
Screenshot of the SQL Output

![Image](https://github.com/user-attachments/assets/8141ba93-434d-4bbf-8cf1-fdc0dac6f637)

### 5.5.Testing and Case Rates per Population by HDI Classification
This query calculates the testing rate and case rate per population based on Human Development Index (HDI) classification. It provides an overview of how testing and case rates varied across different levels of human development, offering insights into the global response to the pandemic relative to population size.

```sql
select [Classification of HDI],SUM(total_tests) * 1.0 / SUM(population) AS tests_per_population,
    SUM(total_cases) * 1.0 / SUM(population) AS cases_per_population
from(
select t1.location,t1.total_tests,t1.human_development_index,t2.total_cases,t2.population,
	case when human_development_index > 0.800 then 'Very high human development'
		 when human_development_index between 0.700 and 0.799 then 'High human development'
		 when human_development_index between 0.550 and 0.699 then 'Medium human development'
		 when human_development_index < 0.550 then 'Low human development'
		 end as 'Classification of HDI'
from(
select location,MAX(total_tests) total_tests, max(human_development_index)human_development_index
from covidvaccinations
where YEAR(date) < 2023
group by location)t1
join
(
select location, MAX(total_cases) total_cases ,max(population) as population
from coviddeaths 
where YEAR(date) < 2023
group by location)t2
on t1.location = t2.location)t3
where [Classification of HDI] is not null
group by [Classification of HDI]
```
Screenshot of the SQL Output

![Image](https://github.com/user-attachments/assets/0958eb43-03d3-4bcd-9a87-b5e1c9134327)

### 5.6. Fatality Rate by Continent Over Time
This query calculates the fatality rate for each continent over time by comparing the total deaths to total cases. The result helps in understanding how the pandemic's impact, in terms of fatality, varied by continent at different points in time.
```sql
SELECT 
    continent,
    date, 
    SUM(total_deaths) / SUM(total_cases) * 100 AS continent_fatality_rate
FROM 
    coviddeaths
GROUP BY 
    continent, date;

```

Screenshot of the SQL Output

![Image](https://github.com/user-attachments/assets/600f2d41-4ae6-49d3-bdb5-8cdd5f83617b)

### 5.7. Average Fatality Rate and Percentage of Population Aged 65+ by HDI Classification
This query calculates the average fatality rate per 100k people and the average percentage of the population aged 65 and older for each Human Development Index (HDI) classification. 
It helps understand how the age distribution of populations and the severity of COVID-19 (in terms of fatality rate) vary across different levels of human development.
```sql
select [Classification of HDI],AVG(aged_65_older)avg_percent_aged_65_plus,
	AVG(fatality_per_100k) avg_fatality_per_100k
from(
select distinct t1.location,human_development_index,aged_65_older,fatality_per_100k,
	case when human_development_index > 0.800 then 'Very high human development'
		 when human_development_index between 0.700 and 0.799 then 'High human development'
		 when human_development_index between 0.550 and 0.699 then 'Medium human development'
		 when human_development_index < 0.550 then 'Low human development'
		 end as 'Classification of HDI'
from covidvaccinations as t1
join
(
select location,max(total_deaths)/max(population)*100000 as fatality_per_100k
from coviddeaths
group by location)t2
on t1.location = t2.location)t3
where t3.[Classification of HDI] is not null
group by [Classification of HDI]
```

Screenshot of the SQL Output

![Image](https://github.com/user-attachments/assets/0b525bce-2c30-4eac-aa66-7830df88c017)

### 5.8.  Comprehensive COVID-19 Data Analysis by Location
This query combines various COVID-19-related metrics with demographic and developmental data, 
offering a comprehensive view of how different factors correlate with pandemic outcomes across locations.

```sql
SELECT 
    t1.continent,
    t1.location,
    population,
    t1.fatality_rate,
    fatality_per_100k,
    t2.human_development_index,
    t2.population_density,
    "Classification of HDI",
    life_expectancy,
    aged_65_older,
    (population * aged_65_older / 100) AS aged_65_population
FROM
    (
        SELECT 
            continent,
            location,
            ROUND((SUM(total_deaths) / SUM(total_cases)) * 100, 3) AS fatality_rate,
            MAX(total_deaths) / MAX(population) * 100000 AS fatality_per_100k,
            MAX(population) AS population
        FROM 
            coviddeaths
        GROUP BY 
            continent, location
    ) t1
LEFT JOIN
    (
        SELECT DISTINCT 
            location,
            population_density,
            human_development_index,
            CASE 
                WHEN human_development_index > 0.800 THEN 'Very high'
                WHEN human_development_index BETWEEN 0.700 AND 0.799 THEN 'High'
                WHEN human_development_index BETWEEN 0.550 AND 0.699 THEN 'Medium'
                WHEN human_development_index < 0.550 THEN 'Low'
            END AS "Classification of HDI",
            life_expectancy,
            aged_65_older
        FROM 
            covidvaccinations
    ) t2
ON 
    t1.location = t2.location;
```

![Image](https://github.com/user-attachments/assets/ba73e18c-c193-481d-92c8-e767a2890275)


### 6. Conclusion of Methodology
This methodology section provided a comprehensive walkthrough of the SQL queries and analytical steps used to explore COVID-19 data. Each query was designed to extract meaningful insights into the pandemic's impact across regions, leveraging demographic, health, and socio-economic indicators.

By integrating datasets from coviddeaths and covidvaccinations, we analyzed key metrics such as fatality rates, cumulative cases, human development classifications, and population demographics. These analyses aim to highlight disparities, trends, and correlations that could inform data-driven decision-making.

In the next sections, we will delve into the results of these queries, interpret the findings, and discuss their implications in the broader context of public health and policy-making.

For a detailed discussion of the findings, visualizations, and interpretations, please visit the blog post:
[Global Lessons from COVID-19: Insights from Data Analysis](https://rohithmx11.github.io/RohithAnalysis.github.io/covid.html)


