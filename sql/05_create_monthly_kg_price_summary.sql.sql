CREATE OR REPLACE TABLE PUBLIC_FOOD_PROCUREMENT_WH.ANALYTICS.mart_monthly_kg_price_summary AS

SELECT
    MONTH(purchase_date) AS purchase_month,
    YEAR(purchase_date) AS purchase_year,
    COUNT(*) AS row_count,
    COUNT(DISTINCT SUPPLIER_NAME) AS distinct_supplier,
    COUNT(DISTINCT STATE) AS distinct_state,
    SUM(quantity) AS total_quantity_kg,
    SUM(quantity * unit_price_brl) AS monthly_purchase,
    MIN(UNIT_PRICE_BRL) AS MIN_MONTHLY_PRICE,
    AVG(UNIT_PRICE_BRL) AS AVG_MONTHLY_PRICE,
    MEDIAN(UNIT_PRICE_BRL) AS MEDIAN_MONTHLY_PRICE,
    MAX(UNIT_PRICE_BRL) AS MAX_MONTHLY_PRICE
FROM public_food_procurement_wh.staging.stg_procurement_items
WHERE is_comparable_for_kg_price_analysis = TRUE
GROUP BY purchase_year, purchase_month
ORDER BY purchase_year, purchase_month;
    



