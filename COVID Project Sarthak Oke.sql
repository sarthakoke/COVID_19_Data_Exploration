SELECT * 
FROM PortfolioProject..CovidDeaths
Where location='India' and continent is not null
ORDER BY 3,4

SELECT *
FROM PortfolioProject..CovidVaccinations
Where location='India' and continent is not null
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

----TOTAL CASES vs TOTAL DEATHS (Likelihood of you dying if you contract Covid-19)

SELECT location, date, total_cases, total_deaths, (CAST(total_deaths AS float) / CAST(total_cases AS float))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
Where location='India'
and continent is not null
ORDER BY 1,2

----TOTAL CASES vs Population (What Percentage of Indians got Covid)
SELECT location, date, population, total_cases, (CAST(total_cases AS float) / CAST(population AS float))*100 AS AffectedPoulation
FROM PortfolioProject..CovidDeaths
Where location='India'
ORDER BY 1,2

----TOTAL CASES vs Population (What Percentage of Population over the world got Covid)
SELECT location, date, population, total_cases, (CAST(total_cases AS float) / CAST(population AS float))*100 AS AffectedPoulation
FROM PortfolioProject..CovidDeaths
--Where location='India'
ORDER BY 1,2

----Countries with highest infection rate compared to population
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location = '%india%'
Where continent is not null 
Group by Location, Population
order by PercentPopulationInfected desc

----Countries with Highest Death Count per Population
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location = '%india%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-------BREAKING DOWN BY CONTINENT------
----CONTINENTS with highest Death Count per Population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location = '%india%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc



---- BREAKING DOWN GLOBAL NUMBERS
SELECT SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--Where location='India'
where continent is not null
--group by date
ORDER BY 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations, SUM(CONVERT(bigint,vacc.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date) as TotalVaccineCount
, (SUM(CONVERT(bigint,vacc.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date))/death.population*100 as PercentagePopulationVaccinated
from PortfolioProject..CovidDeaths death
join PortfolioProject..CovidVaccinations vacc
	on death.date = vacc.date
	and death.location = vacc.location
where death.continent is not null 
--and death.location = 'India'
order by 2,3

--OR we can use CTE(Common Table expression)

with PopvsVacc (continent, location, date, population, new_vacc, TotalVaccinationCount)
as
(
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations, SUM(CONVERT(bigint,vacc.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date) as TotalVaccineCount
--, (SUM(CONVERT(bigint,vacc.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date))/death.population*100 as PercentagePopulationVaccinated
from PortfolioProject..CovidDeaths death
join PortfolioProject..CovidVaccinations vacc
	on death.date = vacc.date
	and death.location = vacc.location
where death.continent is not null 
--and death.location = 'India'
)
select *, (TotalVaccinationCount/population)*100 as PercentagePopulationVaccinated 
from PopvsVacc
order by 2,3


-- Using Temp Table to perform Calculation on Partition By in previous query
drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255), 
date datetime,
population numeric, 
new_vacc numeric, 
TotalVaccinationCount numeric
)

Insert into #PercentPopulationVaccinated
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations, SUM(CONVERT(bigint,vacc.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date) as TotalVaccineCount
--, (SUM(CONVERT(bigint,vacc.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date))/death.population*100 as PercentagePopulationVaccinated
from PortfolioProject..CovidDeaths death
join PortfolioProject..CovidVaccinations vacc
	on death.date = vacc.date
	and death.location = vacc.location
--where death.continent is not null 
--and death.location = 'India'

select *, (TotalVaccinationCount/population)*100 as PercentagePopulationVaccinated 
from #PercentPopulationVaccinated
order by 2,3

--Creating View to store data for Data Visualisation
create view PercentPopulationVaccinated as
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations, SUM(CONVERT(bigint,vacc.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date) as TotalVaccineCount
--, (SUM(CONVERT(bigint,vacc.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date))/death.population*100 as PercentagePopulationVaccinated
from PortfolioProject..CovidDeaths death
join PortfolioProject..CovidVaccinations vacc
	on death.date = vacc.date
	and death.location = vacc.location
--where death.continent is not null 
--and death.location = 'India'

select * from PercentPopulationVaccinated