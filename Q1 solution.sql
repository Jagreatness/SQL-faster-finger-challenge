-- Year-over-Year Growth in Sales per category current year and previous year
WITH AnnualSales AS (
    SELECT 
        p.category, p.category_key,
        EXTRACT(YEAR FROM s.order_date) AS SalesYear,
        SUM(s.quantity * p.unit_price_usd) AS TotalSales
    FROM 
        sales s
    JOIN 
        products p ON s.product_key = p.product_key
    WHERE 
        EXTRACT(YEAR FROM s.order_date) IN (2020, 2021)
    GROUP BY 
        p.category_key, p.category, EXTRACT(YEAR FROM s.order_date)
),
SalesGrowth AS (
    SELECT
        category, category_key, SalesYear, TotalSales,
        LAG(TotalSales) OVER (PARTITION BY category ORDER BY SalesYear) AS PrevYearSales
    FROM 
        AnnualSales
)
SELECT 
    category_key, category, SalesYear, TotalSales, PrevYearSales,
    CASE 
        WHEN PrevYearSales IS NULL THEN NULL
        ELSE (TotalSales - PrevYearSales) * 100.0 / PrevYearSales 
    END AS YoYGrowthPercentage
FROM 
    SalesGrowth
ORDER BY 
    category_key, category, SalesYear;
