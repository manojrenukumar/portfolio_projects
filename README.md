
# Covid Data Exploration project

The main objective of this project is to explore the data of covid globaly and an intention of using all my data exploration and SQL skills.
In this project, the exploration is about total deaths, total cases, total deaths, vaccinations per population of a country, continent etc.
Finally creating a view to act as an pipeline between tableau and Postgress SQL.

Here in this project, I have tried to explore as much as possible on the dataset and created to a view to help the visulaisation process in tableau later.

I have used python to clean a data a bit since the date column was a string datatype and for that i converted into datatime format and then changed the format based on the requirement for Postgress SQL.

## Acknowledgements

 - [information of CTE used in SQL](https://www.sqlshack.com/sql-server-common-table-expressions-cte/)
 - [Importing the data to postgressSQL](https://www.postgresqltutorial.com/import-csv-file-into-posgresql-table/)
 - [Covid Data set](https://ourworldindata.org/covid-deaths)

  
## Appendix

1. "like" keyword - used to match the pattern.
I have used it to select or filter the data based on country.

2. "copy" function - to copy the data from the csv file and insert into the postgress database.

3. Agggregated functions used: 
    a. Sum() - used to get the sum of all the values.
    b. max() - used to get the maximum value of the column.
    c. count() - used to count the values.

4. join() - Used to join two tables in a postgress database.

5. CTE - Common table expression which is a temporary named result set that can refer with in a Select, insert, update or delete Statement.
The CTE can also be used in view, like i have shown below.

6. Python Datetime package - used tit convert the date which was in string format to date format and also changed the format as required by the postgress datatype.

  
## Authors

- [@manojrenukumar](https://github.com/manojrenukumar)

  
## Badges

Add badges from somewhere like: [shields.io](https://shields.io/)

[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?)](https://github.com/tterb/atomic-design-ui/blob/master/LICENSEs)
[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)
[![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](http://www.gnu.org/licenses/agpl-3.0)

  
## Tech Stack

**Client:** PostgressSQL14, Tableau

**Server:** PostgressSQL14

  
## 🛠 Skills
Python, Database, SQL
  