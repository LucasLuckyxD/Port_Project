SELECT *
FROM [Portfolio Project].[dbo].Covid_Deaths

SELECT *
FROM [Portfolio Project].[dbo].Covid_vaccination

-- Data Overview / Selecting the data that we'll be using

SELECT Location, date, population, total_cases, new_cases, total_deaths
FROM [Portfolio Project].[dbo].Covid_Deaths
ORDER by 1,2

-- Showing Countries with Highest Death Count / Population
SELECT Location, Population, (MAX(total_deaths)/population) as Death_rate
FROM [Portfolio Project].[dbo].Covid_Deaths
GROUP BY Location, Population
ORDER BY Death_rate DESC

-- Showing Continents with Highest Death Count
SELECT continent, MAX(cast(total_deaths as int)) as Death_rate
FROM [Portfolio Project].[dbo].Covid_Deaths
WHERE continent is not NULL
GROUP BY continent

-- Global Deaths Per Continent
SELECT continent, SUM(New_cases) as total_cases, sum(cast(new_deaths as int)) 
as totaldeaths, SUM(cast(New_deaths as int))/Sum(new_cases)*100 as death_percentage
FROM [Portfolio Project].[dbo].Covid_Deaths
WHERE continent is not NULL
GROUP BY continent
ORDER BY 1

Create view Global_Deaths as 
SELECT continent, SUM(New_cases) as total_cases, sum(cast(new_deaths as int)) 
as totaldeaths, SUM(cast(New_deaths as int))/Sum(new_cases)*100 as death_percentage
FROM [Portfolio Project].[dbo].Covid_Deaths
WHERE continent is not NULL
GROUP BY continent