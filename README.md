# Decodelabs Sales Data Analysis

## About the Project

This is a beginner data analysis project I worked on using PostgreSQL and Power BI.

The goal was to clean the sales data, check the quality of the data, calculate basic statistics, find outliers, and use Power BI to look for trends and useful business insights.

## Tools Used

- PostgreSQL
- pgAdmin
- Power BI
- SQL

## What I Did

### 1. Data Cleaning

I cleaned the raw sales data in PostgreSQL.

I:
- Changed the data types
- Checked for duplicate orders
- Checked for missing values
- Checked for fake null values
- Kept a log of the steps I took

### 2. Statistical Analysis

I calculated:

- Mean
- Median
- Mode
- Count

I used these on the main numerical columns:

- Quantity
- UnitPrice
- ItemsInCart
- TotalPrice

### 3. Outlier Analysis

I used the IQR method to find possible outliers.

I checked:

- Quantity
- UnitPrice
- ItemsInCart
- TotalPrice

I found 8 outliers in the TotalPrice column.

After checking the records, they looked like valid orders, so I kept them in the data.

### 4. Power BI

I imported the cleaned data into Power BI.

I used Power BI to create:

- KPI cards
- Monthly sales trends
- Product analysis
- Order status analysis

## Key Insights

Key Insight 1: Monthly Revenue Peak, Low and Average
The monthly revenue average sits at 105.3k and while it peaks at 171k in June, the lowest months' revenue(September and November) aren't far from the average at 69k and 75k (102k lower than the peak month, June and 36.3k lower than the average)

Key Insight 2: Product Performance by Revenue
Chairs generated the highest revenue at 195.62k, while phones generated the lowest at 151.72k (43.9k lower than its highest counterpart, chairs)

## Project Files

- `decodelabs_project_2.sql` - SQL code used for cleaning and analysis
- `sales_data.csv` - sales dataset
- `decodelabs_project.pbix` - Power BI dashboard
- `screenshots` - dashboard screenshots

## Dashboard Preview
<img width="1366" height="768" alt="Screenshot (357)" src="https://github.com/user-attachments/assets/279de14f-381e-4cd5-aa43-7a695c212922" />

## What I Learned

This project helped me practice using SQL to clean and analyze data and Power BI to turn the results into simple charts and business insights.
