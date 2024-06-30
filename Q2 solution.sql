SELECT gender, COUNT(*) AS order_count
FROM customers
GROUP BY gender;