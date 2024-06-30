WITH InitialPurchase AS (
    SELECT
        c.customers_key, c.gender, c.city, c.country,
        DATE_PART('year', AGE(c.birthday)) AS age,
        MIN(s.order_date) AS initial_purchase_date
    FROM
        customers c
    JOIN
        sales s ON c.customers_key = s.customers_key
    GROUP BY
        c.customers_key, c.gender,  c.city,
		c.country, c.birthday
),
RepeatPurchase AS (
    SELECT
        ip.customers_key,
        MIN(s.order_date) AS repeat_purchase_date
    FROM
        sales s
    JOIN
        InitialPurchase ip ON s.customers_key = ip.customers_key
    WHERE
        s.order_date > ip.initial_purchase_date
        AND s.order_date <= ip.initial_purchase_date + INTERVAL '3 months'
    GROUP BY
        ip.customers_key
),
CustomerRetention AS (
    SELECT
        ip.customers_key, ip.gender, ip.city, ip.country, ip.age,
        CASE 
            WHEN rp.repeat_purchase_date IS NOT NULL THEN 1
            ELSE 0
        END AS retained
    FROM
        InitialPurchase ip
    LEFT JOIN
        RepeatPurchase rp ON ip.customers_key = rp.customers_key
)
SELECT
    gender, city, country,
    CASE 
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        WHEN age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS total_customers,
    SUM(retained) AS retained_customers,
    ROUND((SUM(retained) * 100.0 / COUNT(*)), 2) AS retention_rate
FROM
    CustomerRetention
GROUP BY
    gender, city, country, customerretention.age
ORDER BY
 gender, city, country;

--Trends and Patterns
--Retention Rate by Gender: Analyze the retention rate per genders.
--Retention Rate by Age Group: Identify which age groups have the highest and lowest retention rates.
--Retention Rate by Location: Shows which city or country have better customer retention.