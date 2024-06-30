	SELECT 
    c.customers_key,
	c.name,
		s.store_key,
	p.product_key,
	s.quantity,
	unit_price_usd,
    ROUND(SUM(s.quantity * p.unit_price_usd), 2) AS total_order_price

FROM sales s
LEFT JOIN products p ON s.product_key = p.product_key
LEFT JOIN customers c ON s.customers_key = c.customers_key
		

GROUP BY
   c.customers_key, s.store_key,
	p.product_key, unit_price_usd,
	s.quantity,c.name
		
ORDER BY total_order_price DESC

