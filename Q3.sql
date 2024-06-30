--Ranking Stores by Sales Volume
--Write a query to calculate the total sales volume for each store, then rank stores based on their sales volume

SELECT
    store_key,
    SUM(quantity) AS total_sales_volume,
    RANK() OVER (ORDER BY SUM(quantity) DESC) AS sales_rank
FROM
    sales
GROUP BY
    store_key
ORDER BY
    sales_rank;
