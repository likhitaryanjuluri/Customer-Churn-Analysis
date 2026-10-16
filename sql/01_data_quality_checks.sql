#CREATE DATABASE creates a database to store our project data.
CREATE DATABASE customer_churn_db;

#USE selects the database where subsequent tables will be created
USE customer_churn_db;

#Create the customer table
CREATE TABLE customers (
    customerID VARCHAR(20) PRIMARY KEY,
    gender VARCHAR(10),
    SeniorCitizen TINYINT,
    Partner VARCHAR(5),
    Dependents VARCHAR(5),
    tenure INT,
    PhoneService VARCHAR(5),
    MultipleLines VARCHAR(30),
    InternetService VARCHAR(30),
    OnlineSecurity VARCHAR(30),
    OnlineBackup VARCHAR(30),
    DeviceProtection VARCHAR(30),
    TechSupport VARCHAR(30),
    StreamingTV VARCHAR(30),
    StreamingMovies VARCHAR(30),
    Contract VARCHAR(30),
    PaperlessBilling VARCHAR(5),
    PaymentMethod VARCHAR(50),
    MonthlyCharges DECIMAL(10,2),
    TotalCharges DECIMAL(10,2),
    Churn VARCHAR(5)
);

SELECT COUNT(*) as total_customers 
FROM customers; 

SELECT * FROM customers LIMIT 10;

DESCRIBE customers;

#The customer IDs, contract types, monthly charges, and churn statuses
SELECT
    customerID,
    Contract,
    MonthlyCharges,
    Churn
FROM customers
LIMIT 10; 

#Filter churned customers

SELECT
    customerID,
    tenure,
    Contract,
    MonthlyCharges
FROM customers
WHERE Churn = 'Yes';

