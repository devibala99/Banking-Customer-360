# Banking Customer 360 Analytics

## Project Overview

This project builds a unified **Customer 360 view** for banking customers by combining customer, account, transaction, loan, and customer service data.

The analysis focuses on customer behavior, financial value, product usage, engagement, loan exposure, and business opportunities.

---

## Objectives

* Build a unified Customer 360 dataset
* Clean and integrate relational banking data
* Analyze customer transactions and financial behavior
* Analyze transaction trends, seasonality, and channel preferences
* Segment customers based on business characteristics
* Identify important business insights
* Prepare business-ready data and dashboards

---

## Project Workflow

1. Data Discovery
2. Data Cleaning
3. SQL Integration and Analysis
4. Data Integration
5. Customer 360 Creation
6. Customer Segmentation
7. Business Analysis
8. Dashboard Preparation

---

## Customer Segments

The project identified four customer segments:

* **Core Banking Customers**
* **High-Service Customers**
* **High-Value Loan Customers**
* **Low Engagement Customers**

---

## Key Business Findings

* **Core Banking Customers** are the largest segment, representing **45.90%** of customers.
* **Core Banking Customers** hold **58.58%** of total customer balance.
* **High-Value Loan Customers** represent only **8.20%** of customers but hold **65.81%** of total loan exposure.
* **Low Engagement Customers** represent **22.56%** of customers but contribute only **0.03%** of total customer balance.
* **Core Banking Customers** generate **58.95%** of total transaction value.
* **Mobile** is the dominant transaction channel.
* Transaction activity remains relatively consistent throughout the year, with July showing the highest average transaction value.

---

## Key Recommendations

### Core Banking Customers

Focus on customer retention, cross-selling, and increasing product adoption.

### High-Value Loan Customers

Prioritize loan relationship management, credit monitoring, and targeted financial products.

### Low Engagement Customers

Use targeted engagement campaigns and digital banking activation to increase customer activity.

### High-Service Customers

Improve service efficiency and encourage greater adoption of digital self-service channels.

---

## Project Outputs

### Final Datasets

* `data/final/customer_360.csv`
* `data/final/customer_360_segmented.csv`

### SQL

* `sql/customer_360_queries.sql`

### Analysis Outputs

* `outputs/exports/kpi_summary.csv`
* `outputs/exports/segment_summary.csv`
* `outputs/exports/business_analysis.xlsx`
* `outputs/exports/sql_kpis.csv`
* `outputs/exports/sql_monthly_trend.csv`
* `outputs/exports/sql_channel_preference.csv`
* `outputs/exports/sql_product_holding.csv`

### Dashboard Data

* `outputs/exports/dashboard_data.csv`
* `outputs/exports/dashboard_kpis.csv`

### Dashboard

* `dashboard/Banking_Customer360_Dashboard.xlsx`

### Visualization Outputs

* `outputs/figures/customer_distribution.png`
* `outputs/figures/loan_exposure.png`
* `outputs/figures/transaction_value.png`
* `outputs/figures/customer_balance.png`

---

## Tools Used

* **Python**
* **Pandas**
* **NumPy**
* **Matplotlib**
* **SQL / SQLite**
* **Jupyter Notebook**
* **Excel**
* **VS Code**
* **Git / GitHub**

---

## Project Structure

```text
Banking_Customer-360/
│
├── dashboard/
│   └── Banking_Customer360_Dashboard.xlsx
│
├── data/
│   ├── raw/
│   ├── processed/
│   └── final/
│
├── notebooks/
│
├── outputs/
│   ├── figures/
│   ├── reports/
│   └── exports/
│
├── sql/
│   └── customer_360_queries.sql
│
├── .gitignore
├── README.md
└── requirements.txt
```

---

## Conclusion

This project demonstrates an end-to-end banking analytics workflow, from raw relational data through data cleaning, SQL analysis, Customer 360 integration, customer segmentation, business analysis, and dashboard reporting.

The resulting analysis provides a consolidated view of customer value, engagement, transaction behavior, and loan exposure to support data-driven banking decisions.
