SELECT SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--Where location='India'
where continent is not null
--group by date
ORDER BY 1,2


--SELECT SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location='India'
--where location = 'World'
----Group By date
--order by 1,2
--CTRL + SHIFT+ C to copy all table elements

Select location, SUM(new_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International', 'Upper middle income', 'High income', 'Lower middle income', 'Low income')
Group by location
order by TotalDeathCount desc

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location = '%india%'
Where continent is not null 
Group by Location, Population
order by PercentPopulationInfected desc

Select Location, Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location = '%india%'
Where continent is not null 
Group by Location, Population, date
order by PercentPopulationInfected desc