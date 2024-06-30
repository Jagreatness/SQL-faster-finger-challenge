WITH ProductSales AS (SELECT  DISTINCT sales.store_key,
		sales.product_key,
		products.category_key,
        SUM(sales.quantity) AS total_quantity_sold,
        SUM(sales.quantity * products.unit_price_usd) AS total_sales,
        SUM(sales.quantity * (products.unit_price_usd - products.unit_cost_usd)) AS total_profit
    FROM
        products
	JOIN sales ON products.product_key = sales.product_key

    GROUP BY
		sales.product_key,
		sales.store_key,
        products.category_key
),
RankedProducts AS (
    SELECT
        store_key,
        category_key,
        product_key,
        total_quantity_sold,
        total_sales,
        total_profit,
        RANK() OVER (PARTITION BY store_key, category_key ORDER BY total_sales DESC) AS sales_rank
    FROM
        ProductSales 
),

OptimalProductAssortment AS (
    SELECT
        store_key,
        category_key,
        STRING_AGG(product_key::TEXT, ',') AS product_assortment,
        SUM(total_quantity_sold) AS total_quantity_sold
    FROM
        RankedProducts
    WHERE
        sales_rank <= 5  --  Top 5 products
    GROUP BY
        store_KEY,
        category_key
)

SELECT
    store_key,
    category_key,
    product_assortment,
    total_quantity_sold
FROM
    OptimalProductAssortment
ORDER BY
    store_key,
    category_key;