-- creating view to store data for later visualization
CREATE VIEW percentpopuvacc AS
SELECT a1.continent,a1.[location],a1.[date], a1.population, a2.new_vaccinations, SUM(CONVERT(bigint, a2.new_vaccinations)) OVER (PARTITION BY a1.LOCATION order by a1.LOCATION, a1.DATE) rollingpplvac
FROM covid_death a1 JOIN covid_vacc a2 
ON a1.[location] = a2.[location] AND a1.[date]=a2.[date]
WHERE a1.continent IS NOT NULL
--order by 1, 2, 3

SELECT * FROM percentpopuvacc