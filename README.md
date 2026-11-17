# Banking Customer 360 Analytics

## Project Overview
This project builds a unified Customer 360 view for banking customers by combining customer, account, transaction, loan and customer service data.
The analysis covers customer value, product usage, loan exposure, service load and customer segmentation, and ends in an Excel dashboard for business users.

## Business Objectives
- Build one Customer 360 table (one row per customer)
- Clean and integrate five relational tables
- Calculate KPIs: average balance, total transactions, loan-to-income ratio, product holding count
- Analyze transaction trends, seasonality and channel preference
- Segment customers with K-Means clustering
- Identify high-value customers, cross-sell opportunities and risk signals
- Present results in an Excel dashboard

## Dataset
Synthetic banking dataset (`data/raw/banking_customer360_synthetic.xlsx`)

| Table | Rows |
|---|---|
| Customers | 5,000 |
| Accounts | 7,500 |
| Transactions | 100,000 |
| Loans | 2,500 |
| Customer Service | 10,000 |

## Project Workflow
1. `01_data_discovery`: explore tables, columns, data types
2. `02_data_cleaning`: standardize names, dates, remove duplicates, save to `data/processed`
3. `03_data_integration`: build Customer 360 in Python; all metrics aggregated by `customer_id`
4. `03a_sql_integration`: load tables into SQLite and build the Customer 360 with SQL (CTEs and joins), KPIs, channel and monthly trends
5. `04_eda`: customer distribution and transaction analysis
6. `05_customer_segmentation`: K-Means segmentation (see Colab note below)
7. `06_business_analysis`: segment KPIs, insights, recommendations
8. `07_dashboard_preparation`: dashboard data and chart exports

## Segmentation Method
- Algorithm: K-Means, k = 4 (random_state = 42)
- 12 features: annual income, credit score, total balance, account count, total transactions, total transaction value, products number, total loan amount, loan-to-income ratio, service interactions, complaint count, recency days
- Features scaled with StandardScaler
- k chosen by elbow method and silhouette score (k = 2 to 8)

## Customer Segments

| Segment | Customers | Share of balance | Share of loan exposure | Share of transaction value |
|---|---|---|---|---|
| Core Banking Customers | 2,218 (44.36%) | 21.86% | 15.53% | 43.87% |
| High-Balance Customers | 1,090 (21.80%) | 54.22% | 13.87% | 22.02% |
| High-Service Customers | 1,242 (24.84%) | 15.71% | 10.84% | 24.98% |
| High-Value Loan Customers (high loan exposure, credit-risk watchlist) | 450 (9.00%) | 8.22% | 59.76% | 9.12% |

## Key Business Findings
- Total customers 5,000, total balance 429.68M, total loan amount 945.53M, total transaction value 29.63M.
- Loan penetration is 39.24%. Active customer rate is 72.88% (active customer = at least one active account).
- High-Balance Customers are 21.80% of customers but hold 54.22% of total balance.
- High-Value Loan Customers are 9.00% of customers but hold 59.76% of total loan exposure.
- High-Service Customers raise 46.2% of all complaints and show the highest churn flag rate in the data (30%, versus 14% to 21% in other segments).
- Core Banking Customers are the largest segment (44.36%) with about 1.25 products per customer: the main cross-sell pool.
- Mobile is the dominant channel (40,086 transactions). July has the highest average transaction value (300.09).

## Key Recommendations
- **High-Balance:** retention offers and relationship-manager coverage; losing this group costs the most balance.
- **High-Value Loan:** credit monitoring, repayment-status tracking and exposure limits.
- **High-Service:** fix complaint resolution first, then retention offers and digital self-service.
- **Core Banking:** cross-sell a second product.

## Data Quality Notes
- 1,122 customers (22.4%) have no account record, and 22,593 transactions (22.6%) reference an account ID that does not exist. All customer metrics are therefore aggregated directly by `customer_id`, so no customer or transaction is lost.
- `complaint_count` equals `total_service_interactions` for every customer, so one signal was counted twice in the clustering.
- Transaction counts and recency are very similar across segments (about 20 transactions each), so segments separate mainly on balance, loans and service.
- Data is synthetic: total loans exceed total balances, which would be unusual in a real bank.

## Scope Note
The optional churn prediction model was not included. The dataset contains an observed `churn` flag, which is used only for describing segments.

## How to Run

> **Note: notebook 05 must be run in Google Colab.** On the author's work laptop a security policy (Windows Application Control) blocks scikit-learn's K-Means library file, so notebook 05 cannot run locally. All other notebooks ran locally.

Run order: 01, 02, 03, 03a, 04, then 05 in Colab, then 06, 07.

**Running notebook 05 in Colab**
1. Open colab.research.google.com and upload `notebooks/05_customer_segmentation.ipynb`.
2. Upload `data/final/customer_360.csv` to the Colab file panel.
3. In the first cell change the path to `Path("customer_360.csv")`, and in the save cell to `Path("customer_360_segmented.csv")`.
4. Run all cells, download `customer_360_segmented.csv` and place it in `data/final/`.
5. Change the two paths back to `../data/final/...` before committing the notebook.

**Local setup (all other notebooks)**
```
python -m venv banking360_env
banking360_env\Scripts\activate
pip install -r requirements.txt
```

## Project Outputs

**Final datasets**
- `data/final/customer_360.csv`
- `data/final/customer_360_segmented.csv`
- `data/final/customer_360_sql.csv`

**SQL**
- `sql/customer_360_queries.sql`: indexes, Customer 360 table, KPI summary, product holding, channel preference, monthly trend

**Analysis exports (`outputs/exports/`)**
- `kpi_summary.csv`, `segment_summary.csv`, `business_analysis.xlsx`
- `sql_kpis.csv`, `sql_monthly_trend.csv`, `sql_channel_preference.csv`, `sql_product_holding.csv`
- `dashboard_data.csv`, `dashboard_kpis.csv`

**Dashboard**
- `dashboard/Banking_Customer360_Dashboard.xlsx`

**Figures (`outputs/figures/`)**
- `customer_distribution.png`, `customer_balance.png`, `loan_exposure.png`, `transaction_value.png`

## Tools Used
Python (Pandas, NumPy, Matplotlib, Seaborn, scikit-learn), SQL (SQLite), Jupyter Notebook, Google Colab (notebook 05), Excel, VS Code, Git and GitHub.

## Project Structure
```
Banking-Customer-360/
├── dashboard/
│   └── Banking_Customer360_Dashboard.xlsx
├── data/
│   ├── raw/
│   ├── processed/
│   ├── final/
│   └── banking_customer360.db
├── notebooks/
├── outputs/
│   ├── exports/
│   ├── figures/
│   └── reports/
├── sql/
│   └── customer_360_queries.sql
├── .gitignore
├── README.md
└── requirements.txt
```
