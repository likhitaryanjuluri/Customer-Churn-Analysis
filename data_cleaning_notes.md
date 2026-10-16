# Customer Churn Analysis — Data Cleaning Notes

## Dataset
Telco Customer Churn

## Cleaning steps performed
1. Loaded the original CSV into a Pandas DataFrame.
2. Inspected the dataset dimensions, column names, data types, and missing values.
3. Checked duplicate rows and duplicate customer IDs.
4. Converted `TotalCharges` from text to numeric, coercing invalid values to missing values.
5. Investigated records with missing `TotalCharges` and checked their tenure.
6. Removed records with missing `TotalCharges` after validating the data quality issue.
7. Removed surrounding whitespace from text columns.
8. Rechecked missing values, duplicates, and data types.
9. Exported the cleaned dataset to `data/processed/customer_churn_cleaned.csv`.

## Important considerations
- The original dataset was preserved.
- Missing values were investigated before removal.
- Categorical values were not arbitrarily recoded.
- The cleaned dataset will be used for exploratory analysis and reporting.

## Results
Record the actual row count, column count, number of removed records, and remaining data quality issues after running the notebook.