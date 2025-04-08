
# 🦠 COVID-19 Portfolio Project

## 📌 Overview

This project is a comprehensive data exploration and analysis of the global COVID-19 pandemic. Using publicly available datasets on COVID-19 deaths and vaccinations, this analysis uncovers insights about infection rates, vaccination trends, and mortality statistics. The project demonstrates proficiency in SQL through advanced querying techniques and prepares datasets for visualizations in Tableau.

> 💾 Tools Used: Microsoft Excel, SQL Server Management Studio (SSMS), Tableau

---

## 🎯 Objective

Analyze the impact of COVID-19 across countries and continents by exploring key indicators such as:
- Total cases and deaths
- Infection and death rates per population
- Vaccination progress across the globe

The ultimate goal is to prepare the cleaned and transformed data for visualization and provide actionable insights.

---

## 📁 Files Included

- `CovidDeaths.xlsx` – Dataset containing global COVID-19 death records
- `CovidVaccinations.xlsx` – Dataset containing global vaccination data
- `Data Exploration.sql` – SQL script for cleaning and exploratory analysis
- `Query For Tableau Visualization.sql` – SQL queries optimized for Tableau visualizations

---

## 🧹 Data Preparation

1. **Excel Cleaning**:
   - Removed nulls, inconsistent formatting, and unnecessary columns.
   - Ensured date formats were consistent across files.

2. **SQL Transformation**:
   - Imported cleaned Excel files into SQL Server.
   - Removed entries with `null` continent values.
   - Filtered data to include only realistic values (e.g., population > 0, valid numeric conversions).
   - Calculated new metrics like:
     - Death Percentage
     - Infection Percentage
     - Rolling Vaccination Totals
     - Population Vaccination Rates

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

- **Global Stats**: ~775M total cases and 7M+ deaths, resulting in ~0.91% global death rate.
- **Continent Analysis**: Europe recorded the highest total deaths, followed by South America and Asia.
- **Country Trends**:
  - Highest infected %: Australia (44.52%), UK (36.75%), US (30.88%)
  - Lowest infected %: India (1.8%), China (6.5%)
- **Vaccination Progress**:
  - Rolling vaccinations analyzed over time using window functions and CTEs.

---

## 📊 Tableau Dashboard

A dynamic Tableau dashboard was created to visualize the insights derived from SQL analysis.

### 🔗 [View Interactive Dashboard](https://public.tableau.com/app/profile/sarthak.oke/viz/COVID-19Dashboard_17120260468050/Dashboard1)

### Dashboard Preview:

![image](https://github.com/user-attachments/assets/0dd49c9a-de04-4616-9fd7-e5e531e84fa1)


**Included Visuals**:
- Global summary table (cases, deaths, death %)
- Bar chart of deaths by continent
- World map showing infection % per country
- Time-series line chart of infection rate trends by country

---

## 🚀 How to Use This Project

1. **Install Requirements**:
   - Microsoft SQL Server Management Studio (SSMS)
   - Microsoft Excel or Google Sheets

2. **Steps**:
   - Download and clean the two `.xlsx` datasets.
   - Import the cleaned data into SQL Server.
   - Run the queries from `Data Exploration.sql` for insight extraction.
   - Use `Query For Tableau Visualization.sql` to prep for visualization.
   - Optional: Import data into Tableau for advanced visualization.

---

## 🧾 Example SQL Logic

```sql
-- % Population Infected
SELECT Location, date, Population, total_cases, 
       (total_cases / Population) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;
```

```sql
-- Vaccination CTE
WITH PopvsVac AS (
  SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
         SUM(CONVERT(int, vac.new_vaccinations)) OVER (
           PARTITION BY dea.Location ORDER BY dea.date
         ) AS RollingPeopleVaccinated
  FROM PortfolioProject..CovidDeaths dea
  JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location AND dea.date = vac.date
  WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated / population) * 100 AS PercentVaccinated
FROM PopvsVac;
```

---

## 🚧 Limitations

- Data depends on accuracy of reporting countries
- Not all locations report vaccinations or deaths equally
- Datasets may have missing or delayed entries

---

## 📎 References

- [Our World In Data – COVID-19 Datasets](https://ourworldindata.org/coronavirus)
- [SQL Server Documentation](https://learn.microsoft.com/en-us/sql/)

---
