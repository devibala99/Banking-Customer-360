-- Banking Customer 360 Analytics
-- SQL Integration and Business Analysis
-- Database: SQLite (data/banking_customer360.db)

-- 0. Indexes (speed up joins)
CREATE INDEX IF NOT EXISTS idx_accounts_customer ON accounts(customer_id);
CREATE INDEX IF NOT EXISTS idx_transactions_customer ON transactions(customer_id);
CREATE INDEX IF NOT EXISTS idx_loans_customer ON loans(customer_id);
CREATE INDEX IF NOT EXISTS idx_service_customer ON customer_service(customer_id);

-- 1. Customer 360 table (one row per customer)
DROP TABLE IF EXISTS customer_360_sql;
CREATE TABLE customer_360_sql AS
WITH account_summary AS (
    SELECT
        customer_id,
        COUNT(DISTINCT account_id) AS sql_account_count,
        SUM(balance) AS sql_total_balance,
        AVG(balance) AS sql_avg_balance,
        COUNT(DISTINCT account_type) AS sql_product_holding_count
    FROM accounts
    GROUP BY customer_id
),

transaction_summary AS (
    SELECT
        customer_id,
        COUNT(transaction_id) AS sql_total_transactions,
        SUM(amount) AS sql_total_transaction_value,
        AVG(amount) AS sql_avg_transaction_value
    FROM transactions
    GROUP BY customer_id
),

loan_summary AS (
    SELECT
        customer_id,
        COUNT(DISTINCT loan_id) AS sql_loan_count,
        SUM(loan_amount) AS sql_total_loan_amount,
        AVG(interest_rate) AS sql_avg_interest_rate
    FROM loans
    GROUP BY customer_id
),

service_summary AS (
    SELECT
        customer_id,
        COUNT(interaction_id) AS sql_service_interactions,
        AVG(resolution_days) AS sql_avg_resolution_days
    FROM customer_service
    GROUP BY customer_id
)

SELECT
    c.customer_id,
    c.annual_income,

    COALESCE(a.sql_account_count, 0) AS sql_account_count,
    COALESCE(a.sql_total_balance, 0) AS sql_total_balance,
    COALESCE(a.sql_avg_balance, 0) AS sql_avg_balance,
    COALESCE(a.sql_product_holding_count, 0) AS sql_product_holding_count,

    COALESCE(t.sql_total_transactions, 0) AS sql_total_transactions,
    COALESCE(t.sql_total_transaction_value, 0) AS sql_total_transaction_value,
    COALESCE(t.sql_avg_transaction_value, 0) AS sql_avg_transaction_value,

    COALESCE(l.sql_loan_count, 0) AS sql_loan_count,
    COALESCE(l.sql_total_loan_amount, 0) AS sql_total_loan_amount,
    COALESCE(l.sql_avg_interest_rate, 0) AS sql_avg_interest_rate,

    COALESCE(s.sql_service_interactions, 0) AS sql_service_interactions,
    COALESCE(s.sql_avg_resolution_days, 0) AS sql_avg_resolution_days,

    CASE
        WHEN c.annual_income > 0
        THEN COALESCE(l.sql_total_loan_amount, 0) / c.annual_income
        ELSE 0
    END AS sql_loan_to_income_ratio

FROM customers c

LEFT JOIN account_summary a
    ON c.customer_id = a.customer_id

LEFT JOIN transaction_summary t
    ON c.customer_id = t.customer_id

LEFT JOIN loan_summary l
    ON c.customer_id = l.customer_id

LEFT JOIN service_summary s
    ON c.customer_id = s.customer_id;

-- 2. KPI summary (includes loan penetration)
SELECT
    COUNT(*) AS total_customers,

    ROUND(SUM(sql_total_balance), 2)
        AS total_customer_balance,

    ROUND(AVG(sql_total_balance), 2)
        AS average_customer_balance,

    SUM(sql_total_transactions)
        AS total_transactions,

    ROUND(SUM(sql_total_transaction_value), 2)
        AS total_transaction_value,

    ROUND(SUM(sql_total_loan_amount), 2)
        AS total_loan_amount,

    ROUND(AVG(sql_product_holding_count), 2)
        AS average_products,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN sql_loan_count > 0 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS loan_penetration_pct

FROM customer_360_sql;

-- 3. Product holding
SELECT
    sql_product_holding_count AS products_held,
    COUNT(*) AS customers,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS customer_percentage
FROM customer_360_sql
GROUP BY sql_product_holding_count
ORDER BY products_held;

-- 4. Channel preference
SELECT
    channel,
    COUNT(*) AS transactions,
    ROUND(SUM(amount), 2) AS total_value,
    ROUND(AVG(amount), 2) AS average_value
FROM transactions
GROUP BY channel
ORDER BY transactions DESC;

-- 5. Monthly transaction trend
SELECT
    strftime('%Y-%m', transaction_date) AS month,
    COUNT(*) AS transactions,
    ROUND(SUM(amount), 2) AS total_value,
    ROUND(AVG(amount), 2) AS average_value
FROM transactions
WHERE transaction_date IS NOT NULL
GROUP BY month
ORDER BY month;
