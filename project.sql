SELECT * FROM covid_death

SELECT [location], [date] total_cases, new_cases, total_cases, population
  FROM covid_death
  ORDER BY 1, 2

SELECT [location], [date] total_cases, total_cases,total_deaths, population, (total_deaths/total_cases)*100 DeathPercentage, (total_cases/population)*100 TotalCasePercentage
  FROM covid_death
  where [location] like '%states'
  ORDER BY 1, 2


SELECT [location], MAX(total_cases) HighestInfectionCount, population, MAX(total_cases)/population*100 TotalCasePercentage
  FROM covid_death
  GROUP BY population, [location]
  ORDER BY TotalCasePercentage DESC

SELECT [location], MAX(total_deaths) HighesDeathCount
  FROM covid_death
  WHERE continent is NOT NULL
  GROUP BY [location]
  ORDER BY HighesDeathCount DESC

SELECT [continent], MAX(total_deaths) HighesDeathCount
  FROM covid_death
  WHERE continent is NOT NULL
  GROUP BY [continent]
  ORDER BY HighesDeathCount DESC

SELECT SUM(new_cases), SUM(new_deaths), (SUM(new_deaths)/NULLIF(SUM(new_cases),0))*100 DeathPercentage
  FROM covid_death
  where 
  --[location] like '%states' AND 
  continent is NOT NULL
  --GROUP BY [date]
  ORDER BY 1, 2

-- with cte
WITH PopvsVac (continent,location,date,population,new_vaccinations,rollingpplvac)
AS
(
SELECT a1.continent,a1.[location],a1.[date], a1.population, a2.new_vaccinations, SUM(CONVERT(bigint, a2.new_vaccinations)) OVER (PARTITION BY a1.LOCATION order by a1.LOCATION, a1.DATE) rollingpplvac
FROM covid_death a1 JOIN covid_vacc a2 
ON a1.[location] = a2.[location] AND a1.[date]=a2.[date]
WHERE a1.continent IS NOT NULL
--order by 1, 2, 3
)
SELECT *, (rollingpplvac/population)*100 rollingpplvacPercentage
FROM PopvsVac

--temp table
DROP table if exists #test
CREATE TABLE #test 
(
    Continent VARCHAR(255),
    Location VARCHAR(255),
    date DATETIME,
    population NUMERIC,
    new_vaccinations NUMERIC,
    rollingpplvac NUMERIC
)

INSERT into #test
SELECT a1.continent,a1.[location],a1.[date], a1.population, a2.new_vaccinations, SUM(CONVERT(bigint, a2.new_vaccinations)) OVER (PARTITION BY a1.LOCATION order by a1.LOCATION, a1.DATE) rollingpplvac
FROM covid_death a1 JOIN covid_vacc a2 
ON a1.[location] = a2.[location] AND a1.[date]=a2.[date]
WHERE a1.continent IS NOT NULL
--order by 1, 2, 3

SELECT *, (rollingpplvac/population)*100 rollingpplvacPercentage FROM #test

-- creating view to store data for later visualization
CREATE VIEW percentpopuvacc AS
SELECT a1.continent,a1.[location],a1.[date], a1.population, a2.new_vaccinations, SUM(CONVERT(bigint, a2.new_vaccinations)) OVER (PARTITION BY a1.LOCATION order by a1.LOCATION, a1.DATE) rollingpplvac
FROM covid_death a1 JOIN covid_vacc a2 
ON a1.[location] = a2.[location] AND a1.[date]=a2.[date]
WHERE a1.continent IS NOT NULL
--order by 1, 2, 3

SELECT * FROM percentpopuvacc