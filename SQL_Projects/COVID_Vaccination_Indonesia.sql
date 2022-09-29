SELECT *
FROM [Portfolio Project].[dbo].Covid_Deaths

SELECT *
FROM [Portfolio Project].[dbo].Covid_vaccination

-- Data Overview / Selecting the data that we'll be using

SELECT Location, date, population, total_cases, new_cases, total_deaths
FROM [Portfolio Project].[dbo].Covid_Deaths
ORDER by 1,2

-- Looking at The Total Cases vs Total Deaths In Indonesia (Q : How to add "%" in each Death_Percentage)
-- Based on the data, we can conclude that the death percentage of COVID-19 In Indonesia is going down overtime

SELECT Location, date, population, total_cases, total_deaths,(total_deaths/total_cases)*100  as Death_Percentage
FROM [Portfolio Project].[dbo].Covid_Deaths
WHERE 
	location = 'Indonesia'
ORDER by 2

-- Looking at the Total Cases vs Population (Infection rate)

SELECT Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as Infection_rate
FROM [Portfolio Project].[dbo].Covid_Deaths
WHERE 
	location = 'Indonesia'
Group By Location, population
ORDER by Infection_rate DESC

-- Looking at Total Population vs Total Vaccnations AND Vaccination 

SELECT Death.continent, Death.location, Death.date, Death.population, vac.new_vaccinations, 
SUM(convert(BIGint, vac.new_vaccinations)) OVER (Partition by Death.location ORDER BY death.location, death.date) as Total_Vac_per_Day
FROM [Portfolio Project].[dbo].Covid_Deaths as Death
Join [Portfolio Project].[dbo].Covid_vaccination as vac
	ON Death.location = vac.location
	AND Death.date = vac.date
 WHERE Death.continent is not NULL AND Death.location = 'Indonesia'
 ORDER BY 2,3
