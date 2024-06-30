--Customer Lifetime Value
--Write a query to calculate the lifetime value of each customer based on the total amount they’ve spent.
	
	WITH customer_ltv AS (
	SELECT 
customers_key,
	 SUM(products.unit_price_usd) AS lifetime_value
FROM sales
	LEFT JOIN products ON products.product_key = sales.product_key
GROUP BY customers_key
	
)
	
SELECT
    c.customers_key,
    cl.lifetime_value
FROM
    customers c
JOIN
    customer_ltv cl ON c.customers_key = cl.customers_key
ORDER BY
    cl.lifetime_value DESC;