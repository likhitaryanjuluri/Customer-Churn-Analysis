#Calculate the overall churn rate 

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM customers;

#Calculate churn by contract type 

SELECT
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM customers
GROUP BY Contract
ORDER BY churn_rate_percentage DESC;


#Calculate average charges by churn status
SELECT
    Churn,
    COUNT(*) AS customer_count,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
    ROUND(AVG(TotalCharges), 2) AS avg_total_charges,
    ROUND(AVG(tenure), 2) AS avg_tenure_months
FROM customers
GROUP BY Churn;


#Find contract groups with churn rates above 20% 
SELECT
    Contract,
    COUNT(*) AS total_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM customers
GROUP BY Contract
HAVING
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 1.0
    / COUNT(*) > 0.20;


#Create tenure segments 
SELECT
    customerID,
    tenure,
    CASE
        WHEN tenure <= 6 THEN 'New Customer'
        WHEN tenure <= 24 THEN 'Developing Customer'
        WHEN tenure <= 48 THEN 'Established Customer'
        ELSE 'Long-Term Customer'
    END AS tenure_segment,
    Churn
FROM customers
LIMIT 20;


#Compare churn rates across tenure segments 

SELECT
    CASE
        WHEN tenure <= 6 THEN '1. New Customer'
        WHEN tenure <= 24 THEN '2. Developing Customer'
        WHEN tenure <= 48 THEN '3. Established Customer'
        ELSE '4. Long-Term Customer'
    END AS tenure_segment,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM customers
GROUP BY
    CASE
        WHEN tenure <= 6 THEN '1. New Customer'
        WHEN tenure <= 24 THEN '2. Developing Customer'
        WHEN tenure <= 48 THEN '3. Established Customer'
        ELSE '4. Long-Term Customer'
    END
ORDER BY tenure_segment;


#summary table showing total customers, churned customers, and churn rate.

WITH churn_summary AS (
    SELECT
        Contract,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
            AS churned_customers
    FROM customers
    GROUP BY Contract
)
SELECT
    Contract,
    total_customers,
    churned_customers,
    ROUND(
        100.0 * churned_customers / total_customers,
        2
    ) AS churn_rate_percentage
FROM churn_summary
ORDER BY churn_rate_percentage DESC;



#Rank contract types by churn rate 

WITH contract_metrics AS (
    SELECT
        Contract,
        COUNT(*) AS total_customers,
        AVG(CASE WHEN Churn = 'Yes' THEN 1.0 ELSE 0.0 END)
            AS churn_rate
    FROM customers
    GROUP BY Contract
)
SELECT
    Contract,
    total_customers,
    ROUND(churn_rate * 100, 2) AS churn_rate_percentage,
    RANK() OVER (
        ORDER BY churn_rate DESC
    ) AS churn_rank
FROM contract_metrics;






#Compare a customer's charges with the overall average 

SELECT
    customerID,
    MonthlyCharges,
    ROUND(
        AVG(MonthlyCharges) OVER (),
        2
    ) AS overall_average_monthly_charges,
    ROUND(
        MonthlyCharges - AVG(MonthlyCharges) OVER (),
        2
    ) AS difference_from_average
FROM customers
LIMIT 20; 



#Rank customers by tenure within each contract type

SELECT
    customerID,
    Contract,
    tenure,
    ROW_NUMBER() OVER (
        PARTITION BY Contract
        ORDER BY tenure DESC, customerID
    ) AS tenure_rank
FROM customers;






#Which payment methods have the highest churn rates?

SELECT
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        AVG(CASE WHEN Churn = 'Yes' THEN 1.0 ELSE 0.0 END) * 100,
        2
    ) AS churn_rate_percentage,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges
FROM customers
GROUP BY PaymentMethod
ORDER BY churn_rate_percentage DESC; 



#Analyze technical support and online security 

SELECT
    TechSupport,
    OnlineSecurity,
    COUNT(*) AS total_customers,
    ROUND(
        AVG(CASE WHEN Churn = 'Yes' THEN 1.0 ELSE 0.0 END) * 100,
        2
    ) AS churn_rate_percentage
FROM customers
WHERE InternetService <> 'No'
GROUP BY TechSupport, OnlineSecurity
HAVING COUNT(*) >= 30
ORDER BY churn_rate_percentage DESC;







#Identify customers for a retention campaign

SELECT
    customerID,
    tenure,
    Contract,
    MonthlyCharges,
    TechSupport,
    OnlineSecurity,
    Churn,
    CASE
        WHEN Churn = 'Yes' THEN 'Already Churned'
        WHEN tenure <= 6
             AND Contract = 'Month-to-month'
            THEN 'Priority: New Monthly Customer'
        WHEN Contract = 'Month-to-month'
             AND TechSupport = 'No'
            THEN 'Review: Monthly Customer Without Support'
        ELSE 'Other'
    END AS retention_segment
FROM customers
WHERE Churn = 'Yes'
   OR (
       tenure <= 6
       AND Contract = 'Month-to-month'
   )
   OR (
       Contract = 'Month-to-month'
       AND TechSupport = 'No'
   )
ORDER BY tenure ASC, MonthlyCharges DESC;
