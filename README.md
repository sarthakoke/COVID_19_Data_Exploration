
# 🦠 COVID-19 Portfolio Project

## 📌 Overview

This project presents an in-depth analysis of the COVID-19 pandemic using real-world data from global sources. It combines **data cleaning, SQL-based exploration, and visualization in Tableau** to derive key insights on infection trends, vaccination progress, and mortality rates across countries and continents.

> 💾 Tools Used: Microsoft Excel, SQL Server Management Studio (SSMS), Tableau

---

## 🎯 Objective

To uncover insights from the COVID-19 datasets using SQL queries and translate those findings into powerful visualizations. This includes:
- Understanding total cases, deaths, and infection rates
- Calculating death percentages and affected population shares
- Analyzing vaccination rollout across locations and time
- Preparing and structuring data for dynamic Tableau visualizations
The ultimate goal is to prepare the cleaned and transformed data for visualization and provide actionable insights.
---

## 📁 Files Included

- `CovidDeaths.xlsx` – Dataset containing global COVID-19 death records
- `CovidVaccinations.xlsx` – Dataset containing global vaccination data
- `Data Exploration.sql` – SQL script with optimized queries and calculations
- `Query For Tableau Visualization.sql` – SQL queries tailored for Tableau input

---

## 🧹 Data Preparation and Processing

1. **Initial Cleaning in Excel**:
   - Verified structure and removed unnecessary columns
   - Standardized date formats and null value handling

2. **SQL Transformation & Analysis**:
   - Imported both Excel files into SQL Server
   - Used **window functions**, **CTEs**, **views**, and **temp tables**
   - Created fields such as:
     - `DeathPercentage = (total_deaths / total_cases) * 100`
     - `AffectedPopulation = (total_cases / population) * 100`
     - `PercentagePopulationVaccinated` using rolling SUM() window logic

---

## 🧠 Skills Demonstrated

- Joins and Subqueries
- CTEs (Common Table Expressions)
- Window Functions (`OVER`, `PARTITION BY`)
- Temporary Tables
- Aggregate Functions (`SUM`, `AVG`, `MAX`)
- View Creation for Tableau Integration
- Data Type Conversion & Cleaning

---

## 🔍 Key Insights

- 🌍 **Global Totals**:  
  - **Total Cases**: 774M+  
  - **Total Deaths**: 7M+  
  - **Death Rate**: ~0.91%

- 📊 **Highest Deaths by Continent**: Europe, South America, Asia

- 💉 **Vaccination Trends**:
  - Used advanced SQL window functions to calculate cumulative vaccinations by date
  - Created a rolling view of `% of population vaccinated`

- 🔎 **Infection Insights**:
  - Australia (44.52%) showed the highest percentage of infected population
  - India (1.8%) and China (6.5%) remained among the lowest

---

## 📊 Tableau Dashboard

📌 [Interactive Dashboard Link](https://public.tableau.com/app/profile/sarthak.oke/viz/COVID-19Dashboard_17120260468050/Dashboard1)

### Dashboard Highlights:
- Total global cases, deaths, and death rate
- Bar chart of deaths by continent
- Choropleth map showing infected population % by country
- Line chart showing infection rate trends by major countries

![image](https://github.com/user-attachments/assets/0dd49c9a-de04-4616-9fd7-e5e531e84fa1)

---

## 🛠️ Technologies and Skills Used

- **Microsoft Excel** – Initial data preparation
- **SQL Server Management Studio (SSMS)** – Complex querying and transformation
- **SQL Features**:
  - Joins, Window Functions, Temp Tables, Views, CTEs, Type Conversion
- **Tableau** – Data visualization and storyboarding

---

## 🧾 Example SQL Snippets

```sql
-- Global death percentage
SELECT SUM(new_cases) AS TotalCases,
       SUM(new_deaths) AS TotalDeaths,
       SUM(new_deaths)*100.0/SUM(new_cases) AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL;
```

```sql
-- Cumulative vaccinations by country
WITH PopvsVacc AS (
  SELECT death.continent, death.location, death.date, death.population,
         vacc.new_vaccinations,
         SUM(CONVERT(bigint, vacc.new_vaccinations)) OVER (
           PARTITION BY death.location ORDER BY death.date
         ) AS TotalVaccinationCount
  FROM PortfolioProject..CovidDeaths death
  JOIN PortfolioProject..CovidVaccinations vacc
    ON death.location = vacc.location AND death.date = vacc.date
  WHERE death.continent IS NOT NULL
)
SELECT *, (TotalVaccinationCount/population)*100 AS PercentagePopulationVaccinated
FROM PopvsVacc;
```

---

## 🚧 Limitations

- Real-world data may be inconsistently reported by countries
- Missing values and reporting delays in certain regions
- No demographic segmentation (e.g., age, gender)

---

## 📎 References

- [Our World In Data – COVID-19 Dataset](https://ourworldindata.org/coronavirus)
- [Microsoft SQL Server Docs](https://learn.microsoft.com/en-us/sql/)

---
