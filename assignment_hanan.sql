-- hourly metrics
SELECT 
    DATE_TRUNC('hour', date) AS hour,
    COUNT(DISTINCT transaction_id) AS num_txns,  -- total txns
    COUNT(DISTINCT user_id) AS users,            -- unique users
    SUM(transaction_amount) AS amount            -- revenue
FROM 
    transactions
GROUP BY 
    hour
ORDER BY 
    hour;

-- busiest hour per day by $$$
WITH hourly AS (
    SELECT
        DATE(date) AS day,
        DATE_TRUNC('hour', date) AS hour,
        SUM(transaction_amount) AS amount
    FROM
        transactions 
    GROUP BY 
        day, hour
)
SELECT 
    day,
    hour,
    amount 
FROM 
    hourly h1
WHERE 
    (day, amount) IN (
        SELECT
            day,
            MAX(amount)
        FROM hourly
        GROUP BY day
    )
ORDER BY 
    day;