use portfolio_project;

select *
from Covid_Deaths;

select *
from Covid_Vaccinations;

select location, date, population,total_cases,total_deaths
from Covid_Deaths
order by 1,2;

-- Looking at total_cases vs total_deaths

select location, date,total_cases,total_deaths
,(total_deaths/total_cases)*100 as Death_percentage
from Covid_Deaths
where location like '%India%' and continent is not null
order by 1,2;

-- Looking at total_cases vs population for a specific country

select location, date,population, total_cases
,(total_cases/population)*100 as Percentage_of_cases
from Covid_Deaths
where location like '%India%' and continent is not null
order by 1,2;

-- Looking at countries with highest infection rate compared to population

select location, population, max(total_cases) as highest_infected_cases,
max(total_cases/population)*100 as Percentage_of_cases
from Covid_Deaths
where continent is not null
group by location, population
order by Percentage_of_cases desc;

-- Showing countries with highest death count per population

select location, population, max(cast(total_deaths as int)) as death_count
from Covid_Deaths
where continent is not null
group by location, population
order by death_count desc;

-- LET'S break things down by continent

select continent, max(cast(total_deaths as int)) as death_count
from Covid_Deaths
where continent is not null
group by continent
order by death_count desc;

-- Looking at Total Population vs Total Vaccinations

select continent, max(cast(total_deaths as int)) as death_count
from Covid_Deaths
where continent is not null
group by continent
order by death_count desc;


-- Looking for Total Vaccination VS Population

select cd.continent, cd.location, cd.date
,cd.population, cv.total_vaccinations,
sum(convert(bigint,cv.total_vaccinations)) over(partition by cd.location order by cd.location, cd.date) 
as rolling_total_vaccinations  
from Covid_Deaths cd
join Covid_Vaccinations cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null
order by 2,3;

-- Use CTE

with PopVsVac as 
( select cd.continent as Continent, cd.location as Location, cd.date as Date
,cd.population as Population, cv.total_vaccinations as Total_Vaccinations,
sum(convert(bigint,cv.total_vaccinations)) over(partition by cd.location order by cd.location, cd.date) 
as Rolling_total_vaccinations  
from Covid_Deaths cd
join Covid_Vaccinations cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null
)
select *, (Rolling_total_vaccinations/Population)*100 as Rolling_Percentage
from PopvsVac;

-- Create View to store data for later visualizations

Create View Population_Vaccinated as
select cd.continent as Continent, cd.location as Location, cd.date as Date
,cd.population as Population, cv.total_vaccinations as Total_Vaccinations,
sum(convert(bigint,cv.total_vaccinations)) over(partition by cd.location order by cd.location, cd.date) 
as Rolling_total_vaccinations  
from Covid_Deaths cd
join Covid_Vaccinations cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null

select * 
from Population_Vaccinated








