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

#### SQL Query: Extracting and Organizing Relevant Columns
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

#### SQL Query: Cumulative COVID-19 Cases by Continent Over Time
```sql
SELECT
    continent,
    date,
    SUM(new_cases) OVER (PARTITION BY continent ORDER BY date) AS continents_cumulative_case
FROM
    coviddeaths;

```
Screenshot of the SQL Output
