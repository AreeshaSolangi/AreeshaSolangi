CREATE DATABASE bank_customer_churn;
SELECT COUNT(*) FROM bank_customer_churn.bank_customer_churn_rawdataset;
USE bank_customer_churn;
ALTER TABLE bank_customer_churn.bank_customer_churn_rawdataset
ADD COLUMN age_group varchar(10);

UPDATE bank_customer_churn.bank_customer_churn_rawdataset
SET age_group =
CASE WHEN age<=24 THEN "18-24"
     WHEN age<=34   THEN "25-34"
     WHEN age<=44   THEN "35-44"
     WHEN age<=54   THEN "45-54"
     WHEN age<=64   THEN "55-64"
     WHEN age<=74   THEN "65-74"
      ELSE "75+" END
;
SET SQL_SAFE_UPDATES=0;

SELECT * FROM bank_customer_churn.bank_customer_churn_rawdataset;
SELECT ROUND(COUNT(Exited)/(SELECT COUNT(*) FROM bank_customer_churn_rawdataset)*100,2) AS churnRate FROM bank_customer_churn.bank_customer_churn_rawdataset
WHERE exited=1;

-- How many customers are from each country?
SELECT Geography,COUNT(DISTINCT CustomerId) as customer_count FROM bank_customer_churn.bank_customer_churn_rawdataset
GROUP BY Geography;


-- What is the total number of customers who have exited the bank?
SELECT COUNT(Exited) AS churned_customers  FROM bank_customer_churn.bank_customer_churn_rawdataset
WHERE Exited=1;

-- What is the average balance for customers in each geography?
SELECT Geography, Avg(Balance) avg_balance  FROM bank_customer_churn.bank_customer_churn_rawdataset
GROUP BY Geography;

-- How many active members are there by gender?
SELECT Gender, count(IsActiveMember) as ActiveMembers FROM bank_customer_churn.bank_customer_churn_rawdataset
WHERE IsActiveMember=1
GROUP BY Gender;

-- Who are the top 5 customers with the highest credit scores?
SELECT Min(CustomerId) as customerID,CreditScore FROM (SELECT CustomerId, CreditScore, dense_rank() OVER ( ORDER BY CreditScore DESC) as `rank` FROM bank_customer_churn.bank_customer_churn_rawdataset)AS SUB
WHERE `rank`<=5
Group by CreditScore
;

-- Among customers who churned, how many had a satisfaction score greater than 3?

SELECT  COUNT(Exited) as Churned_Customers  FROM bank_customer_churn.bank_customer_churn_rawdataset
WHERE Exited=1 AND Satisfaction_Score>3
;

-- How many customers have more than one product and a balance over 50,000?
SELECT COUNT(CustomerId) as customers  FROM bank_customer_churn.bank_customer_churn_rawdataset
WHERE NumOfProducts>1 AND Balance>50000;

-- What is the churn rate (percentage of customers who exited) in each country?
SELECT Count(Exited)/(SELECT COUNT(*) FROM bank_customer_churn.bank_customer_churn_rawdataset)*100 as churnRatePct  FROM bank_customer_churn.bank_customer_churn_rawdataset
WHERE Exited=1;

-- What is the average tenure for customers who exited versus those who stayed?
SELECT Exited,avg(Tenure) as tenure  FROM bank_customer_churn.bank_customer_churn_rawdataset
GROUP BY Exited;

-- What is the average points earned by different card types?
SELECT CardType ,AVG(PointEarned) as avg_points FROM bank_customer_churn.bank_customer_churn_rawdataset
Group By CardType;

-- Who is the customer with the highest points earned?
SELECT CustomerId,Surname,PointEarned  FROM bank_customer_churn.bank_customer_churn_rawdataset
ORDER BY PointEarned DESC
LIMIT 1;

-- How many customers have complained?
SELECT COUNT(CustomerId) AS customers  FROM bank_customer_churn.bank_customer_churn_rawdataset
WHERE Complain=1;

-- What is the average credit score for customers who are active members?
SELECT IsActiveMember,AVG(CreditScore) as creditscore  FROM bank_customer_churn.bank_customer_churn_rawdataset
GROUP BY IsActiveMember;

-- Which gender has a higher churn rate?
SELECT Gender,Count(Exited)/(SELECT COUNT(*) FROM bank_customer_churn.bank_customer_churn_rawdataset)*100 as churnRatePct
  FROM bank_customer_churn.bank_customer_churn_rawdataset
  GROUP BY Gender;
  
-- What is the distribution of customers by number of products owned?
SELECT NumOfProducts, count(CustomerId)  FROM bank_customer_churn.bank_customer_churn_rawdataset
Group by NumOfProducts
ORDER BY COUNT(CustomerId) DESC;

-- How many customers do not have a credit card?
SELECT COUNT(CustomerId)  FROM bank_customer_churn.bank_customer_churn_rawdataset
WHERE HasCrCard=1;

-- What is the average estimated salary of customers who have exited?
SELECT FORMAT(AVG(EstimatedSalary),0)  FROM bank_customer_churn.bank_customer_churn_rawdataset
WHERE Exited=1;

-- How many customers have a zero balance?
 SELECT COUNT(CustomerId)  FROM bank_customer_churn.bank_customer_churn_rawdataset
 WHERE Balance=0;

-- Which country has the highest number of active members?
SELECT Geography,COUNT( distinct CustomerId)  FROM bank_customer_churn.bank_customer_churn_rawdataset
WHERE IsActiveMember=1
GROUP BY Geography
ORDER BY COUNT(CustomerId) DESC;

-- ADVANCED LEVEL

-- Which geography has the highest churn rate and what is the difference compared to the lowest churn region?
WITH cte AS(
SELECT Geography,count(customerId)/(SELECT COUNT(CustomerId) FROM bank_customer_churn.bank_customer_churn_rawdataset )*100 as churnRate
 FROM bank_customer_churn.bank_customer_churn_rawdataset
WHERE Exited=1
GROUP BY Geography)
SELECT *,
(SELECT Max(churnRate)- Min(churnRate)  FROM cte) difference FROM cte;




-- Do customers with higher credit scores churn less compared to those with lower scores?
SELECT CASE 
WHEN creditScore<400 THEN "Low"
Else "High" 
END Score,
COUNT(CASE WHEN exited=1 THEN 1 END)*100/COUNT(*)  as churnRate
 FROM bank_customer_churn.bank_customer_churn_rawdataset
Group BY Score;



-- What is the churn rate by number of products owned, and does having more products reduce churn?
SELECT NumOfProducts, COUNT(CASE WHEN exited=1 THEN 1 END) *100/ COUNT(*) AS churnRate FROM bank_customer_churn.bank_customer_churn_rawdataset
GROUP BY NumOfProducts
ORDER BY churnRate DESC;

-- Among customers with high balances (e.g., > average balance), what percentage still churned?
SELECT COUNT(CASE WHEN exited=1 THEN 1 END) *100/ COUNT(*) AS churnRate FROM bank_customer_churn.bank_customer_churn_rawdataset
WHERE balance> (SELECT avg(balance) FROM bank_customer_churn.bank_customer_churn_rawdataset);

SELECT COUNT(CASE WHEN exited=1 THEN 1 END) *100/ COUNT(*) AS churnRate FROM bank_customer_churn.bank_customer_churn_rawdataset
WHERE balance< (SELECT avg(balance) FROM bank_customer_churn.bank_customer_churn_rawdataset);

-- Do customers who complained churn at a higher rate than those who did not?
SELECT complain, COUNT(CASE WHEN exited=1 THEN 1 END) *100/ COUNT(*) AS churnRate FROM bank_customer_churn.bank_customer_churn_rawdataset
GROUP BY complain;


-- Which age group has the highest churn percentage?
SELECT CASE 
WHEN age<=24 THEN "18-24"
WHEN age<=34 THEN "25-34"
WHEN age<=44 THEN "35-44"
WHEN age<=54 THEN "45-54"
WHEN age<=64 THEN "55-64"
WHEN age<=74 THEN "65-74"
ELSE  "75+"
END as agee,
COUNT(CASE WHEN exited=1 THEN 1 END) *100/ COUNT(*) AS churnRate 
 FROM bank_customer_churn.bank_customer_churn_rawdataset
 GROUP BY agee
 ORDER BY churnRate DESC;

-- Which 10 customers with the highest estimated salaries have churned?
SELECT CustomerId, Surname,EstimatedSalary,exited FROM bank_customer_churn.bank_customer_churn_rawdataset
WHERE exited=1
ORDER BY estimatedsalary DESC
LIMIT 10;
-- What is the average tenure of churned vs. retained customers?
SELECT exited , avg(tenure) FROM bank_customer_churn.bank_customer_churn_rawdataset
GROUP BY exited;

-- Among churned customers, how many had a credit card, and how many didn’t?-- 
SELECT COUNT(exited) as churned_customers, 
COUNT(CASE WHEN hascrcard=1 THEN 1 END) as hadcard,
COUNT(CASE WHEN hascrcard=0 THEN 1 END) as NotHadCard
  FROM bank_customer_churn.bank_customer_churn_rawdataset
WHERE exited =1
GROUP BY exited;

-- How many churned customers had a credit card, and does having a credit card reduce churn?
SELECT hascrcard, count(*) totalCustomers, count(case WHEn exited =1 then 1 end ) as churn,
count(case WHEn exited =1 then 1 end )/count(*)*100 as chrunRate
 FROM bank_customer_churn.bank_customer_churn_rawdataset
GROUP BY hascrcard;

-- What is the churn rate of active vs inactive members?
SELECT isactiveMember,COUNT(CASE WHEN exited=1 THEN 1 END) *100/ COUNT(*) AS churnRate  FROM bank_customer_churn.bank_customer_churn_rawdataset
GROUP BY isactivemember;

-- What is the average number of products owned by churned vs. retained customers?
SELECT exited, avg(numofproducts) FROM bank_customer_churn.bank_customer_churn_rawdataset
GROUP BY exited;

-- Are there any branches/regions where churn is above 25%?

SELECT Geography, COUNT(CASE WHEN exited=1 THEN 1 END)/COUNT(*) *100 as churnRate FROM bank_customer_churn.bank_customer_churn_rawdataset
GROUP BY Geography
HAVING COUNT(CASE WHEN exited=1 THEN 1 END)/COUNT(*) *100>25;

-- Which customers are at high risk based on multiple factors (e.g., low credit score, high balance, low products)?
WITH cte AS(SELECT CustomerId, Surname,
CASE WHEN creditScore<=400 THEN "LOW" END as low_creditscore,
CASE WHEN balance>150000 THEN "High_Blance" END as high_balance,
CASE WHEN Numofproducts=1 THEN "1" END as low_product
FROM bank_customer_churn.bank_customer_churn_rawdataset)
SELECT * FROM cte
WHERE low_creditscore="LOW" AND high_balance="High_Blance" AND low_product="1"; 
