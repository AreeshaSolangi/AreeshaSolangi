
# 📊 Bank Customer Churn Analysis

## 🔍 Project Overview
This project dives into **why bank customers leave** and what patterns can help predict churn. Using a Kaggle dataset, I explored customer demographics and behaviors — such as age, geography, product usage, and complaint history — to uncover key churn drivers.

I used **SQL** to find trends and **Power BI** to turn those insights into a clear, interactive dashboard.

---

## 📁 Dataset
- **Source:** [Kaggle - Churn for Bank Customers](https://www.kaggle.com/datasets/mathchi/churn-for-bank-customers)  
- **Size:** 10,000 customers  
- **Key Features:** RowNumber, CustomerId, Surname, CreditScore, Geography, Gender, Age, Age Group, Tenure, Balance, NumOfProducts, HasCrCard, IsActiveMember, EstimatedSalary, Exited, Complain, Satisfaction_Score, CardType, PointEarned.


---

## 🧪 Tools & Technologies
- **MySQL** → Writing and running advanced SQL queries for analysis  
- **Power BI** → Building interactive dashboards to visualize churn patterns  
- **Excel** → Quick preprocessing (e.g., creating age groups)

---

## 🛠️ Process
1. Cleaned and prepared the dataset  
2. Created custom **age group** categories for better segmentation  
3. Imported the data into Power BI for exploration  
4. Wrote SQL queries to detect patterns and correlations between churn and customer attributes  

📜 **SQL Script:** [CustomerChurnAnalysis.sql](https://github.com/AreeshaSolangi/AreeshaSolangi/blob/main/Bank_Customer_Churn_Analysis/CustomerChurnAnalysis.sql)  
📊 **Power BI Dashboard:** [Dashboard PBIX File](https://github.com/AreeshaSolangi/AreeshaSolangi/blob/main/Bank_Customer_Churn_Analysis/Bank%20Customer%20Churn%20Dashboard.pbix)

---

## 📈 Key Insights
- Out of 10,000 customers, the churn rate was 20%.

- Customers aged 35–54 made up 12% of total churn. I thought this might be linked to approaching retirement and changing financial priorities.

- A huge 99.51% of churned customers had filed a complaint. I didn’t have enough data to confirm why, but this likely points to poor service quality and customers who complain tend to leave.

- 32% of churned customers were from Germany, making it the highest-churn geography.

- Among inactive customers in the 55–64 age group, churn was extremely high at 92.20%.

- There was a clear negative correlation between the number of products a customer had and their churn rate. Customers with more products were less likely to leave.

- I also checked other factors to make sure the high churn rate wasn’t solely due to complaints, but multiple factors still played a role

---

## 📌 Conclusion
This analysis shows that churn is **multi-factorial** — while complaints dominate the picture, age, geography, and engagement (products owned) also matter.

Organizations can reduce churn by:  
- Improving service quality and addressing complaints faster  
- Targeting high-risk age groups with retention offers  
- Increasing product engagement to strengthen customer loyalty

