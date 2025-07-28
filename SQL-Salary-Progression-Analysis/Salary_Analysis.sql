USE practice;
WITH cte as (
SELECT e.employee_id,change_date,name,salary,promotion,
row_number() OVER(PARTITION BY employee_id ORDER BY change_date DESC) as sal_desc,
LAG(salary) OVER(PARTITION BY employee_id ORDER BY change_date) as prev_sal,
LAG(change_date) OVER(PARTITION BY employee_id ORDER BY change_date) as prev_date,
row_number() OVER(PARTITION BY name ORDER BY change_date) as start_date,
ROW_NUMBER() OVER (PARTITION BY name ORDER BY change_date DESC) as end_date
 FROM employees as e
join salary_history as s
ON e.employee_id=s.employee_id
),
-- org start
latest_salary AS(
SELECT employee_id,name,salary FROM cte
WHERE sal_desc=1),
-- org end
-- ord start
promotion_count AS(
SELECT employee_id,name, sum(CASE WHEN promotion ='YES' THEN 1 ELSE 0 END) as promotion_count FROM cte
GROUP BY employee_id,name)
, -- org end
hike_pct AS(
SELECT employee_id,name,change_date,   (salary-prev_sal)/prev_sal*100 as pct FROM cte
WHERE prev_sal IS NOT NULL
AND salary>prev_sal),
hike_pct_org1 AS(
SELECT *,dense_rank() OVER(partition by employee_id ORDER BY pct DESC) as hike_pct FROM hike_pct),
-- org start
hike_pct_org AS (
SELECT employee_id,name,pct FROM  hike_pct_org1 WHERE hike_pct=1),
-- org end
dec_sal AS(
SELECT employee_id FROM cte WHERE salary<prev_sal),
-- start
never_decreased_sal AS(
SELECT  DISTINCT employee_id,name, 'YES' never_decreased  FROM cte WHERE employee_id NOT IN (select employee_id FROM dec_sal )),
-- end
-- start
avg_month_between_sal_changes AS(
SELECT employee_id,name,AVG(timestampdiff(MONTH,prev_date,change_date)) as month_diff FROM cte
WHERE prev_date IS NOT NULL
GROUP BY employee_id,name),
growth AS(
SELECT employee_id,name, MAX(CASE WHEN start_date=1 THEN salary END) as start_sal, 
MAX(CASE WHEN end_date=1 THEN salary END) as latest_sal,
min(change_date) as joined 
FROM cte
group by employee_id,name),
growth_pct AS(
SELECT employee_id,name,joined, (latest_sal-start_sal)/start_sal*100 as growth FROM growth),
-- start
rank_growth_pct AS(
SELECT employee_id,name,dense_rank() OVER(ORDER BY growth DESC,joined asc) as growth FROM growth_pct)

SELECT ls.employee_id,salary as latest_sal,
promotion_count,
round(pct,2) as max_hike_percetage,
never_decreased as never_decreased_sal,
month_diff as avg_month_diff,
growth rank_by_growth 
FROM  latest_salary as ls
JOIN promotion_count AS p ON ls.employee_id=p.employee_id
JOIN  hike_pct_org mhp ON p.employee_id=mhp.employee_id 
JOIN  never_decreased_sal nds ON mhp.employee_id=nds.employee_id 
JOIN avg_month_between_sal_changes avgm ON nds.employee_id=avgm.employee_id
JOIN rank_growth_pct rbg ON avgm.employee_id=rbg.employee_id;
