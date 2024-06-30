WITH customer_behavior AS(SELECT 
	sales.customers_key,
	sales.quantity,
	sum (sales.quantity) as total_order,
    ROUND(sales.quantity * products.unit_price_usd,2) AS total_amount_usd
	
FROM sales
LEFT JOIN products ON sales.product_key = products.product_key
LEFT JOIN customers ON sales.customers_key=customers.customers_key 
GROUP BY sales.customers_key,sales.quantity,products.unit_price_usd
),
customer_segments AS (
SELECT 
    c.customers_key, 
	c.state,
	c.gender,
	cb.total_amount_usd,
	cb.total_order,
	CASE
            WHEN cb.total_amount_usd < 1000 THEN 'Low Spender'
            WHEN cb.total_amount_usd BETWEEN 1000 AND 15000 THEN 'Medium Spender'
            ELSE 'High Spender'
        END AS spend_segment,
	
	        -- Segment customers based on number of orders
       
	CASE
            WHEN cb.total_order < 2 THEN 'Infrequent Order'
            WHEN cb.total_order BETWEEN 2 AND 7 THEN 'Regular Order'
            ELSE 'Frequent Order'
        END AS order_segment 
    FROM
        customers c
JOIN
        customer_behavior cb ON c.customers_key = cb.customers_key 
	)
	SELECT
    cs.state,
    cs.gender,
    cs.spend_segment,
    cs.order_segment,
    COUNT(cs.customers_key) AS customer_count,
    ROUND(AVG(total_amount_usd),2) AS average_spend,
    ROUND(AVG(total_order),2) AS average_orders
FROM
    customer_segments cs
GROUP BY
    cs.state,cs.gender, cs.spend_segment, cs.order_segment
ORDER BY
    cs.state,cs.gender, cs.spend_segment, cs.order_segment;