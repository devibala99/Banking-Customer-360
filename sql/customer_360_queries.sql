
-- Banking Customer 360 Analytics
-- SQL Integration and Business Analysis

-- 1. Customer 360 aggregation

WITH account_summary AS (
    SELECT
        customer_id,
        COUNT(DISTINCT account_id) AS account_count,
        SUM(balance) AS total_balance,
        AVG(balance) AS average_balance,
        COUNT(DISTINCT account_type) AS products_held
    FROM accounts
    GROUP BY customer_id
),

transaction_summary AS (
    SELECT
        customer_id,
        COUNT(transaction_id) AS total_transactions,
        SUM(amount) AS total_transaction_value,
        AVG(amount) AS average_transaction_value
    FROM transactions
    GROUP BY customer_id
),

loan_summary AS (
    SELECT
        customer_id,
        COUNT(DISTINCT loan_id) AS loan_count,
        SUM(loan_amount) AS total_loan_amount,
        AVG(interest_rate) AS average_interest_rate
    FROM loans
    GROUP BY customer_id
),

service_summary AS (
    SELECT
        customer_id,
        COUNT(interaction_id) AS service_interactions,
        AVG(resolution_days) AS average_resolution_days
    FROM customer_service
    GROUP BY customer_id
)

SELECT
    c.customer_id,
    c.annual_income,

    COALESCE(a.account_count, 0) AS account_count,
    COALESCE(a.total_balance, 0) AS total_balance,
    COALESCE(a.average_balance, 0) AS average_balance,
    COALESCE(a.products_held, 0) AS products_held,

    COALESCE(t.total_transactions, 0) AS total_transactions,
    COALESCE(t.total_transaction_value, 0) AS total_transaction_value,
    COALESCE(t.average_transaction_value, 0) AS average_transaction_value,

    COALESCE(l.loan_count, 0) AS loan_count,
    COALESCE(l.total_loan_amount, 0) AS total_loan_amount,
    COALESCE(l.average_interest_rate, 0) AS average_interest_rate,

    COALESCE(s.service_interactions, 0) AS service_interactions,
    COALESCE(s.average_resolution_days, 0) AS average_resolution_days

FROM customers c
LEFT JOIN account_summary a
    ON c.customer_id = a.customer_id
LEFT JOIN transaction_summary t
    ON c.customer_id = t.customer_id
LEFT JOIN loan_summary l
    ON c.customer_id = l.customer_id
LEFT JOIN service_summary s
    ON c.customer_id = s.customer_id;


-- 2. Channel analysis

SELECT
    channel,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_value,
    ROUND(AVG(amount), 2) AS average_value
FROM transactions
GROUP BY channel
ORDER BY transaction_count DESC;


-- 3. Monthly transaction trend

SELECT
    strftime('%Y-%m', transaction_date) AS month,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_value
FROM transactions
GROUP BY month
ORDER BY month;


-- 4. Product holding analysis

SELECT
    COUNT(DISTINCT account_type) AS products_held,
    COUNT(DISTINCT customer_id) AS customers
FROM accounts
GROUP BY customer_id
ORDER BY products_held;


-- 5. Loan customer penetration

SELECT
    COUNT(*) AS total_customers,
    SUM(
        CASE
            WHEN loan_count > 0 THEN 1
            ELSE 0
        END
    ) AS loan_customers,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN loan_count > 0 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS loan_penetration_pct
FROM (
    SELECT
        customer_id,
        COUNT(loan_id) AS loan_count
    FROM loans
    GROUP BY customer_id
) loan_summary;
