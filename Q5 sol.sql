--Lifetime value (LTV) of customers by country
--Write a query to calculate the lifetime value of each customer based on their country

WITH customer_ltv AS (
	SELECT 
customers_key,
	 SUM(products.unit_price_usd) AS lifetime_value
FROM sales
	LEFT JOIN products ON products.product_key = sales.product_key
GROUP BY customers_key
	),
	customers_country_ltv AS (	
SELECT
    c.customers_key,
    c.country,
    cl.lifetime_value
FROM
    customers c
JOIN
    customer_ltv cl ON c.customers_key = cl.customers_key
)	
	SELECT
    country,
    AVG(lifetime_value) AS average_ltv,
    RANK() OVER (ORDER BY AVG(lifetime_value) DESC) AS country_rank
FROM
    customers_country_ltv
GROUP BY
    country
ORDER BY
    country_rank;