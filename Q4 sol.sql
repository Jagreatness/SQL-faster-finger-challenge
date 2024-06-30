--Running Total of Sales Over Time
--Write a query to retrieve daily sales volumes, then calculate a running total of sales over time, ordered by date.

SELECT
   order_date,
    quantity,
    SUM(quantity) OVER (ORDER BY order_date asc) AS running_total_sales
FROM
    sales
ORDER BY
    order_date;
