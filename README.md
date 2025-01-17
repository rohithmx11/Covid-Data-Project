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

2. The split ensured better data organization and easier analysis in SQL.

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
   - **covidvaccinations**: Contains data on vaccination progress, testing rates, and HDI by location and date.

**Key Columns:**
   - **coviddeaths**: `location`, `date`, `total_cases`, `total_deaths`, `population`
   - **covidvaccinations**: `location`, `date`, `total_tests`, `human_development_index`, `aged_65_older`

---

### **5. Data Cleaning and Preprocessing**
#### Filtering Relevant Data
Extracted essential columns such as `total_cases`, `total_deaths`, `population`, `total_tests`, and `human_development_index`.

#### 5.1. SQL Query: Extracting and Organizing Relevant Columns
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

#### 5.2. SQL Query: Cumulative COVID-19 Cases by Continent Over Time
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

#### 5.3. SQL Query: COVID-19 Case Fatality and Population Impact by HDI Classification.
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

#### 5.4. SQL Query: COVID-19 Cases Per Million and HDI Classification
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
