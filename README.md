# Global Lessons from COVID-19: How HDI and Demographics Shaped the Pandemic's Impact
## SQL Methodology.

### 1. Data Acquisition.
Source:
The data was downloaded from [Our World in Data](https://ourworldindata.org/), a trusted source for COVID-19-related datasets.
<br>

### **2. Preprocessing in Excel**

1. The dataset was cleaned and split into two files for analysis:
   
   - **coviddeaths.csv**: Focused on data related to cases, deaths, and population.
   - **covidvaccinations.csv**: Included data on vaccination progress, testing rates, and human development index (HDI).
3. The split ensured better data organization and easier analysis in SQL.
  


## Visualizing The Impact
### **1.Global Infection Trends Across Continents.**
![Screenshot 2024-12-01 001407](https://github.com/user-attachments/assets/589a3b75-4a1a-4382-a27c-ee0f154ae073)
This line chart compares cumulative cases across continents over time, highlighting Europe and Asia as the most affected regions.

<br>

### **2. Comparing Infection and Fatality Rates by HDI Categories.**
![Screenshot 2024-12-12 164952](https://github.com/user-attachments/assets/f51cd23a-b28d-43d7-8b1b-f59a51617b5a)
Dual-axis line chart compares cumulative cases per 100,000 and fatalities per 100,000 across HDI categories over time.
<br>
* **Observations:**
  * **High infection and fatality rates :** Very high and high HDI countries experienced significantly higher cumulative cases and fatalities per 100,000 compared to medium and low HDI countries.
  * **Initial impact :** These countries saw sharp initial spikes in both cases and deaths, indicating the heavy early burden of the pandemic.

<br>

### **3. Relationship Between HDI and Cases.**
![Screenshot 2024-12-01 001609](https://github.com/user-attachments/assets/d33337ca-ed99-4fd4-a185-6aaae35d5e92)
This scatter plot reveals a strong correlation between HDI and total cases per million. Higher HDI countries, with better healthcare systems and testing infrastructure, reported more infections.
<br>
 * **X-Axis:** HDI
 * **Y-Axis:** Total Cases per Million
 * **Bubble Color:** HDI Categories

<br>

### **4. Testing Rates and HDI**
![Screenshot 2024-12-01 001709](https://github.com/user-attachments/assets/008fa47f-4f29-4da6-a489-15f26b61b989)
A **stacked bar chart** compares the percentage of total tests and cases per population across HDI categories.
<br>
* **Observations:**
  * Very high and high HDI countries have disproportionately higher testing rates, with total tests surpassing their population sizes due to multiple tests per individual.
  * Infection rates also peak in very high HDI countries, suggesting that effective testing captured a more accurate count of cases.
  * Low HDI countries report far lower rates of both testing and infections, possibly due to limited testing infrastructure and underreporting.

<br>
 
### **5. Fatality Rate by HDI and Population Demographics** 
**The following visuals focus on fatality trends:**
### 5.1 Fatality Rate Across Continents
![Screenshot 2024-12-01 001914](https://github.com/user-attachments/assets/f326be22-9511-4841-a386-31453d3fa07e)
An area chart shows fatality rate trends over time for each continent, revealing how continents managed fatalities during the pandemic’s progression.

<br>

### 5.2 Age Demographics and Fatality Rate
![Screenshot 2024-12-01 001759](https://github.com/user-attachments/assets/b0abcb31-e2bf-4469-b643-a772a2d0a312)
A clustered column chart compares the average fatality rate per 100k population with the percentage of the population aged 65+ for each HDI category.
* **Observation:**
  * Higher percentages of older populations correlate with higher fatalities per population.

<br>

### 5.3 Correlation Between HDI and Case Fatality Rate (CFR)
![Screenshot 2024-12-01 001729](https://github.com/user-attachments/assets/d8c8378f-dfd1-4a36-a684-68add9455808)
This scatter plot examines the relationship between HDI and case fatality rate (CFR), exploring whether HDI influences the proportion of fatalities among reported cases in different countries.
* **Observation:**
  * No significant relationship was observed between HDI and CFR.
  * Countries reported similar case fatality rates regardless of their HDI classification, suggesting other factors, like healthcare policies or the nature of the virus, played a more substantial role.

### **6. Life Expectancy and Fatalities** 
![Screenshot 2024-12-01 001844](https://github.com/user-attachments/assets/80445130-6f13-45ee-8559-9997b84779c8)
A bubble scatter plot explores the relationship between life expectancy and fatalities per population, with bubble size representing the percentage of the population aged 65+.
* **Observation:**
  * Developed countries, with high life expectancy and older populations, faced higher fatalities per population despite lower fatality rates per reported case.

<br>

## Dive Deeper with the Interactive Dashboard
Explore the full interactive COVID-19 analysis using our dashboard. This tool allows you to filter data by continent, country, and timeline to better understand the trends, test rates, and fatality statistics across various HDI categories.
### Key Features of the Dashboard
 * Interactive Filters: Filter by Continent, Country, and Timeline to view dynamic trends.
 * Top 10 Visualizations: Includes insights into the top 10 cases, deaths, CFR, and fatalities per population.
 * Geographic Analysis: Map visualizations showing patterns of infection and testing rates.
 * Matrix Analysis: Compare fatality rates, HDI levels, and demographic data, like the percentage of populations aged 65+.

### [Access the Interactive Dashboard Here](https://app.powerbi.com/view?r=eyJrIjoiNWU3YTkyYjEtOGUyOC00N2E4LWFjMzgtNzEwY2E3NmUxZGUxIiwidCI6IjBmNmY2NGI0LTgwNDEtNGU0MC1iYTEyLWRkYjRkN2QyNWM5ZSJ9)


Dashboard Preview :

![Screenshot 2024-12-10 172728](https://github.com/user-attachments/assets/e1dc3c75-9808-4b1d-ac31-e9f5b9822035)
![Screenshot 2024-12-10 172752](https://github.com/user-attachments/assets/59b9898e-9e46-4d16-80be-c9dd65f78c7d)


## Conclusion

1. **Infection and Fatality Rates:**
   - High and very high HDI countries experienced higher infection rates and fatalities per population compared to medium and low HDI countries.
   - These countries faced greater initial challenges during the pandemic due to their high population density, global connectivity, and larger proportions of older populations.

2. **Case Fatality Rate (CFR):**
   - Despite disparities in infection rates, the CFR remained consistent across all HDI categories, indicating that countries managed to maintain similar fatality proportions among reported cases.
   - The scatter plot analysis revealed no significant relationship between HDI and CFR, suggesting that other factors — such as healthcare policies, early interventions, or viral characteristics — played a larger role in determining outcomes.

3. Demographics and Fatalities:

   - Countries with higher life expectancy and larger percentages of populations aged 65+ faced higher fatalities per population.
   - This demographic factor is a critical driver of fatality rates in high HDI countries.
     
4. Testing and Reporting:

   - High HDI countries conducted more tests, which likely contributed to higher reported cases and provided better visibility into the pandemic’s spread.

The initial surge in numbers highlighted how contagious the COVID-19 disease was. Regardless of a country’s level of development, a pandemic of this nature can easily cause both short-term and long-term impacts on humanity. To prevent encountering such severe threats in the future, proper precautions and planning are essential.


## Note to Readers
The dataset used in this analysis was sourced from [Our World in Data](https://ourworldindata.org/), a globally recognized platform for open-access, high-quality data on COVID-19 and other critical global issues.
You can download the processed dataset used for this study directly from this [GitHub repository](https://github.com/rohithmx11/Covid/blob/main/Dataset/covid%20datasets.zip).
This analysis was conducted using SQL for querying and managing the dataset and Power BI for creating interactive visualizations. For a detailed breakdown of the methodology and tools used, please visit the dedicated [GitHub repository](https://github.com/rohithmx11/Covid/blob/main/SQL%20queries/Queries.sql).
