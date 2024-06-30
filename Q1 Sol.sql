WITH sales_new_data AS (SELECT stores.store_key, stores.square_meters,sum(sales.quantity) AS sales_volume
FROM stores
LEFT JOIN sales ON stores.store_key = sales.store_key
WHERE sales.store_key is NOT NULL
GROUP BY stores.square_meters,stores.store_key 
	ORDER BY square_meters DESC
)	
SELECT
	DISTINCT CORR(sales_new_data.square_meters,sales_new_data.sales_volume) OVER () AS correlation_coefficient
FROM sales_new_data;