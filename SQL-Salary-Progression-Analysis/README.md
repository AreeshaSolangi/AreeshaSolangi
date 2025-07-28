# SQL Salary Progression Analysis

## Project Description
This project focuses on analyzing employee salary changes and promotions to understand career progression trends.  
The dataset includes employee details, salary history, and promotion indicators.

---

## Data Import
I first imported raw Excel files into MySQL, which allowed me to run structured queries and perform deeper analysis:
- **[Employee Data](https://github.com/AreeshaSolangi/AreeshaSolangi/blob/main/SQL-Salary-Progression-Analysis/employee.xlsx)** 
- **[Salary History](https://github.com/AreeshaSolangi/AreeshaSolangi/blob/main/SQL-Salary-Progression-Analysis/salary_history.xlsx)** 
---

## SQL Queries
SQL queries were written using **CTEs** and **window functions** to:  
- Identify each employee's latest salary  
- Count promotions  
- Calculate maximum salary hike percentage  
- Flag employees with no salary decrease  
- Measure average months between salary changes  
- Rank employees based on overall salary growth  

View full SQL script here:  
- **[Salary_Analysis.sql](https://github.com/AreeshaSolangi/AreeshaSolangi/blob/main/SQL-Salary-Progression-Analysis/Salary_Analysis.sql)**

---

## Output & Insights
The SQL queries produce a summarized employee performance report, including:  
- **latest_sal** → Latest salary recorded  
- **promotion_count** → Number of promotions  
- **max_hike_percentage** → Highest percentage hike in a single change  
- **never_decreased_sal** → Whether salary ever decreased (YES/NO)  
- **avg_month_diff** → Average months between salary changes  
- **growth_rank** → Ranking based on salary progression  

Sample output file:  
- **[Employee Performance Result Report](https://github.com/AreeshaSolangi/AreeshaSolangi/blob/main/SQL-Salary-Progression-Analysis/employee_performance_result_report.csv)**

---

## Tools Used
- **MySQL** → For complex querying and analysis  
- **Excel** → For data import/export and initial cleaning


