SELECT products.product_key, products.product_name
FROM products
LEFT JOIN sales ON products.product_key = sales.product_key
WHERE sales.product_key is NULL;