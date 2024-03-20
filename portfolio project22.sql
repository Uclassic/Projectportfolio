SELECT *
FROM PortfolioProject..CovidDeathscsv
ORDER BY 3, 4


SELECT *
FROM PortfolioProject..CovidDeathscsv


SELECT *
FROM PortfolioProject..CovidVaccinationscsv
ORDER BY 3,4

--select date that we are goimg to be using


SELECT Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeathscsv
ORDER BY 1, 2

--Looking at total cases vs Total deaths

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
FROM PortfolioProject..CovidDeathscsv
Where location like '%states%'
order by 1, 2

--looking at Total cases vs Population
--shows what percentage of population got covid

SELECT Location, date, population, total_cases, (total_cases/ population)*100 as DeathPercentage
FROM PortfolioProject..CovidDeathscsv
where location like '%state%'
order by 1, 2


--looking at countries with Highest infection rate compared to population

SELECT Location, date, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/ population))*100 as
  PercentagePopulationInfected
FROM PortfolioProject..CovidDeathscsv
--where location like '%state%'
Group BY location, population
order by 1, 2

--show countries with highest death count per population

select continent, MAX(total_deaths) AS TotalDeathCount
from PortfolioProject..CovidDeathscsv
where continent is not null
GROUP BY continent
order by TotalDeathCount desc


--LET'S BREAK THINGS DOWN BY CONTINENT

select location, MAX(total_deaths) AS TotalDeathCount
from PortfolioProject..CovidDeathscsv
where continent is not null
GROUP BY location
order by TotalDeathCount desc


--showing the continent with death count per population

select continent, MAX(total_deaths) AS TotalDeathCount
from PortfolioProject..CovidDeathscsv
where continent is not null
GROUP BY continent
order by TotalDeathCount desc

--global numbers

SELECT SUM(new_cases)as total_cases, SUM(new_deaths)as total_deaths, SUM(new_deaths/new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeathscsv
--Where location like '%states%'
where continent is not null
--GROUP BY date
order by 1, 2


--select*
--from PortfolioProject..CovidVaccinationscsv

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated )as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--, RollingPeopleVaccinated
FROM PortfolioProject..CovidDeathscsv dea
  Join PortfolioProject..CovidVaccinationscsv vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)
select*
from PopvsVac



--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated )as

--temp table

DROP TABLE if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

insert into  #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--, RollingPeopleVaccinated
FROM PortfolioProject..CovidDeathscsv dea
  Join PortfolioProject..CovidVaccinationscsv vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3

select *, (RollingPeopleVaccinated/Population)*100
from  #PercentPopulationVaccinated





(



--creating views to store data fr later visualisation

CREATE VIEW PercentagePopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--, RollingPeopleVaccinated
FROM PortfolioProject..CovidDeathscsv dea
  Join PortfolioProject..CovidVaccinationscsv vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3

select *
from PercentagePopulationVaccinated

CREATE VIEW DeathPercentage as
SELECT SUM(new_cases)as total_cases, SUM(new_deaths)as total_deaths, SUM(new_deaths/new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeathscsv
--Where location like '%states%'
where continent is not null
--GROUP BY date
--order by 1, 2

CREATE VIEW  TotalDeathCount as
select continent, MAX(total_deaths) AS TotalDeathCount
from PortfolioProject..CovidDeathscsv
where continent is not null
GROUP BY continent
--order by TotalDeathCount desc

