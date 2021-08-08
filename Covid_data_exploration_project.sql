-- Here I have used Postgress SQL for Data Exploration project on Covid-19 Data.
-- Initially, I have break downed the data into two subparts as Covid deaths and Covid Vaccinations.
-- Then I have uploading the data into the data base by creating the table 
-- and inserting the data values into the database by using "COPY" Function. 
-- Creating table and copying the csv file date into the table for Covid deaths data

Create Table public.Covid_Deaths(

	iso_code text,
	continent text, 
	location text,
	date date,
	population double precision,
	total_cases decimal,
	new_cases decimal,
	new_cases_smoothed decimal,
	total_deaths decimal,
	new_deaths decimal,
	new_deaths_smoothed decimal,
	total_cases_per_million decimal,
	new_cases_per_million decimal,
	new_cases_smoothed_per_million decimal,
	total_deaths_per_million decimal,
	new_deaths_per_million decimal,
	new_deaths_smoothed_per_million decimal,
	reproduction_rate decimal,
	icu_patients decimal,
	icu_patients_per_million decimal,
	hosp_patients decimal,
	hosp_patients_per_million decimal,
	weekly_icu_admissions decimal,
	weekly_icu_admissions_per_million decimal,
	weekly_hosp_admissions decimal,
	weekly_hosp_admissions_per_million decimal
);

select * from public.Covid_Deaths;
-- Copying the data from the csv file.
copy public.Covid_Deaths from '/private/tmp/Data_covid_deaths.csv' with csv header;


-- Creating table and copying the csv file date into the table for Covid Vaccination data
Create table public.Covid_Vaccination(
	iso_code text,
	continent text,
	location text,
	date date,
	new_tests decimal,
	total_tests decimal,
	total_tests_per_thousand decimal,
	new_tests_per_thousand decimal,
	new_tests_smoothed decimal,
	new_tests_smoothed_per_thousand decimal,
	positive_rate decimal,
	tests_per_case decimal,
	tests_units text,
	total_vaccinations double precision,
	people_vaccinated double precision,
	people_fully_vaccinated double precision,
	new_vaccinations decimal,
	new_vaccinations_smoothed decimal,
	total_vaccinations_per_hundred decimal,
	people_vaccinated_per_hundred decimal,
	people_fully_vaccinated_per_hundred decimal,
	new_vaccinations_smoothed_per_million decimal,
	stringency_index decimal,
	population_density decimal,
	median_age decimal,
	aged_65_older decimal,
	aged_70_older decimal,
	gdp_per_capita decimal,
	extreme_poverty decimal,
	cardiovasc_death_rate decimal,
	diabetes_prevalence decimal,
	female_smokers decimal,
	male_smokers decimal,
	handwashing_facilities decimal,
	hospital_beds_per_thousand decimal,
	life_expectancy decimal,
	human_development_index decimal,
	excess_mortality decimal
);

-- Copying the data from the csv file.
copy public.Covid_Vaccination from '/private/tmp/Data_covid_vaccination.csv' with csv header;


-- COVID DEATHS DATA SET

-- Lokking at the created tables in the database.
select * from public.Covid_Deaths 
where continent is not null
order by 3,4;


select location,date,total_cases,total_deaths,new_cases,population 
from public.Covid_Deaths
where continent is not null
order by 1,2;


-- Looking at total cases vs total deaths 
-- shows the likilihood of dying if you contract covid in your country
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from public.Covid_Deaths
where location like '%States%'
and continent is not null
order by 1,2;


--- Looking at total cases vs population
-- shows what percentage of population got covid
select location,date,population,total_cases,(total_cases/population)*100 as percentagegotcovid
from public.Covid_Deaths
where location like '%States%'
and continent is not null
order by 1,2;

-- Looking at country has the highest infection rate  compared to population

select location,population,max(total_cases) as highestinfectioncount ,max((total_cases/population))*100 as percentagegotcovid
from public.Covid_Deaths
--where location like '%States%'   -- here I have tried to filter the data based on what country we want.
where continent is not null
group by population, location
order by percentagegotcovid desc;


-- looking at the country that had highest number of deaths per population
select location,max(total_deaths) as total_deaths_count 
from public.Covid_Deaths
--where location like '%States%'
where continent is not null
group by location
order by total_deaths_count desc;



-- showing continents with highest deaths count

select continent,max(total_deaths) as total_deaths_count 
from public.Covid_Deaths
--where location like '%States%'
where continent is not null
group by continent
order by total_deaths_count desc;

-- Global numbers
select date,sum(new_cases) as total_new_cases,sum(new_deaths) as total_new_deaths, sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from public.Covid_Deaths
-- where location like '%States%'
where continent is not null
group by date
order by 1,2;

-- agggregating  only for new cases and deaths
select sum(new_cases) as total_new_cases,sum(new_deaths) as total_new_deaths, sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from public.Covid_Deaths
-- where location like '%States%'
where continent is not null
-- group by date
order by 1,2;



-- VACCINATION DATA SET

-- Selecting the table
select * from public.Covid_Vaccination;

-- joining the two tables

select * 
from public.Covid_deaths as dea
join public.Covid_Vaccination as Vac
on dea.location = vac.location
and dea.date = vac.date;

-- Looking at total population vs Vaccination

select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from public.Covid_deaths as dea
join public.Covid_Vaccination as Vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;

-- USE CTE( Common table expression which is a temporary named result set that can refer with in a 
-- Select, insert, update or delete Statement.
-- The CTE can also be used in view, like i have shown below)

with popvsvac(continent,location, date, population,new_vaccinations,rollingpeoplevaccinated)
as 
(
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from public.Covid_deaths as dea
join public.Covid_Vaccination as Vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(rollingpeoplevaccinated/population) *100
from popvsvac;

-- Creat Table 
Drop Table if exists PercentagepopulationVaccinated
create Table PercentagepopulationVaccinated
(
 	continent text,
	location text,
	date date,
	population double precision,
	new_vaccinations decimal,
	rollingpeoplevaccinated decimal
	
);
-- Temp Table
insert into PercentagepopulationVaccinated
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from public.Covid_deaths as dea
join public.Covid_Vaccination as Vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null;

--order by 2,3
select *,(rollingpeoplevaccinated/population) *100
from PercentagepopulationVaccinated;


-- Creating view to store date for later Visualisation

create view percentagePopVac as 
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from public.Covid_deaths as dea
join public.Covid_Vaccination as Vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null;


select * from percentagePopVac;

