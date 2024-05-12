Select * 
From PortfolioProject1..Covid_Deaths
Where continent is not null
order by 3,4


--Select * 
--From PortfolioProject1..Covid_Vaccinations
--order by 3,4


-- Select Data we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject1..Covid_Deaths
order by 1,2

-- Total Cases vs Total Deaths in United States. Had to convert column to correct data type in order to properly display death percentage.
Select Location, date, total_cases, total_deaths,(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as Death_Percentage
From PortfolioProject1..Covid_Deaths
Where Location like '%states'
order by 1,2

-- Total Cases vs Population. Percentage of population that got Covid in United States.
Select Location, date, population, total_cases,(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))*100 as PercentPopulationInfected
From PortfolioProject1..Covid_Deaths
Where Location like '%states'
order by 1,2

-- Countries with highest infection rate compared to population.
Select Location, population, MAX(total_cases) as HighestInfectionCount,(CONVERT(float, MAX(total_cases)) / NULLIF(CONVERT(float, population), 0))*100 as PercentPopulationInfected
From PortfolioProject1..Covid_Deaths
Group by Location, population
order by PercentPopulationInfected desc

-- Countries with highest death count per population.
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject1..Covid_Deaths
Where continent is not null
Group by Location
order by TotalDeathCount desc


-- Total death count categorized by continent.
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject1..Covid_Deaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- Global numbers.
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast (new_deaths as int))/NULLIF(SUM(new_cases),0)*100 as DeathPercentage
From PortfolioProject1..Covid_Deaths
--Where Location like '%states'
where continent is not null
--Group by date
order by 1,2


-- Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject1..Covid_Deaths dea
Join PortfolioProject1..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Use CTE
With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject1..Covid_Deaths dea
Join PortfolioProject1..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- TEMP Table
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject1..Covid_Deaths dea
Join PortfolioProject1..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject1..Covid_Deaths dea
Join PortfolioProject1..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select * 
From PercentPopulationVaccinated