CREATE OR REPLACE TABLE PUBLIC_FOOD_PROCUREMENT_WH.ANALYTICS.mart_supplier_kg_price_summary AS

SELECT
    SUPPLIER_NAME AS supplier_name,
    COUNT(*) AS row_count,
    COUNT(DISTINCT PURCHASE_ID) AS distinct_purchase_supplier,
    COUNT(DISTINCT STATE) AS distinct_state,
    MIN(purchase_date) AS first_purchase_date,
    MAX(purchase_date) AS last_purchase_date,
    SUM(quantity) AS total_quantity_kg_by_supplier,
    SUM(quantity * unit_price_brl) AS total_purchase_by_supplier,
    MIN(UNIT_PRICE_BRL) AS min_price,
    AVG(UNIT_PRICE_BRL) AS avg_price,
    MEDIAN(UNIT_PRICE_BRL) AS median_price,
    MAX(UNIT_PRICE_BRL) AS max_price,
    MAX_PRICE - MIN_PRICE AS price_range_brl,
    CONCAT(MIN_PRICE, ' - ', MAX_PRICE) AS price_range_label
FROM public_food_procurement_wh.staging.stg_procurement_items
WHERE is_comparable_for_kg_price_analysis = TRUE
GROUP BY supplier_name
ORDER BY total_purchase_by_supplier DESC;