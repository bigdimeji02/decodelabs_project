# Decodelabs Internship Project - Oladimeji Ogbede

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

## Key Insights

Key Insight 1: Monthly Revenue Peak, Low and Average
The monthly revenue average sits at 105.3k and while it peaks at 171k in June, the lowest months' revenue(September and November) aren't far from the average at 69k and 75k (102k lower than the peak month, June and 36.3k lower than the average)

Key Insight 2: Product Performance by Revenue
Chairs generated the highest revenue at 195.62k, while phones generated the lowest at 151.72k (43.9k lower than its highest counterpart, chairs)

## Project Files
[link to google drive - https://drive.google.com/drive/folders/1kKZUcFoCJFh83EWTKED_52EaXFVZoNoZ?usp=drive_link](https://drive.google.com/drive/folders/1X4H-Bn_7luWxzfNz1vcm4qqDaPRkXX3e?usp=drive_link)

- `decodelabs_project_2.sql` - SQL code used for cleaning and analysis
- `Dataset for Data Analytics - Sheet1.csv` - sales dataset
- `decodelabs_project.pbix` - Power BI dashboard
- `Screenshot (357).png` - dashboard screenshots
- `decodelabs.pdf` - instructions pdf

## Dashboard Preview
<img width="1366" height="768" alt="Screenshot (357)" src="https://github.com/user-attachments/assets/279de14f-381e-4cd5-aa43-7a695c212922" />

## What I Learned

Most of the work in this project was familiar to me before the internship. However, I learned a few new things while working through this project.

### IQR and Outliers

I learned how the **IQR (Interquartile Range)** can be used to find possible outliers in a dataset.

The formula is:

**IQR = Q3 - Q1**

We then use the IQR to calculate the lower and upper boundaries:

* Lower boundary = Q1 - 1.5 × IQR
* Upper boundary = Q3 + 1.5 × IQR

Values outside these boundaries can be flagged as possible outliers.

### `percentile_cont`

I also learned about `percentile_cont`.

The **`cont` means continuous**. It treats the data as a continuous distribution, so the result does not always have to be one of the actual values in the dataset.

It can be used to calculate the median, but it is also useful for finding other percentiles, such as:

* 80th percentile
* 90th percentile
* 95th percentile

### Using a CTE to Find Outliers

One of the new things I learned was how to use a **CTE (Common Table Expression)** to connect different parts of our analysis.

Before this project, I could calculate quartiles, but I did not know how to take those results and use them in another query.

We created a CTE that used the quartile results to calculate the lower and upper boundaries. We then used those boundaries to check the data for possible outliers.

This helped me understand how the result of one part of a SQL analysis can be used in another part of the query.

### `CROSS JOIN`

I learned that a `CROSS JOIN` does not need specific columns to match.

It creates every possible combination of rows between two tables.

In our case, we used it to make the calculated boundaries available to every row so we could check each row against those boundaries.

I still need to learn more about `CROSS JOIN` to fully understand all of its uses.

### Debugging the Query

Our CTE query did not work as expected.

Instead of guessing where the problem was, we broke the query into smaller checks.

We used `SELECT COUNT()` and checked the **minimum and maximum values** of the columns.

We used these results to cross-check the `0` returned by our outlier query.

This helped me understand why breaking a large query into smaller parts can make debugging easier.

### Inspecting the Outliers

We eventually found possible outliers in the **`TotalPrice`** column.

I learned that finding an outlier does not automatically mean that the value is wrong.

The next step is to inspect the values and validate them before deciding what to do with them.
