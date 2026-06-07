--CREATE OR REPLACE TABLE PUBLIC_FOOD_PROCUREMENT_WH.ANALYTICS.mart_state_kg_price_summary AS

SELECT
    STATE AS state,
    COUNT(*) AS row_count,
    COUNT(DISTINCT PURCHASE_ID) AS distinct_purchase_count,
    COUNT(DISTINCT SUPPLIER_NAME) AS distinct_supplier_count,
    COUNT(DISTINCT CITY_NAME) AS distinct_city_count,
    MIN(purchase_date) AS first_purchase_date,
    MAX(purchase_date) AS last_purchase_date,
    SUM(quantity) AS total_quantity_kg,
    SUM(quantity * unit_price_brl) AS total_purchase,
    MIN(UNIT_PRICE_BRL) AS min_unit_price,
    AVG(UNIT_PRICE_BRL) AS avg_unit_price,
    MEDIAN(UNIT_PRICE_BRL) AS median_unit_price,
    MAX(UNIT_PRICE_BRL) AS max_unit_price,
    MAX_UNIT_PRICE - MIN_UNIT_PRICE AS unit_price_range_brl,
    CONCAT(MIN_UNIT_PRICE, ' - ', MAX_UNIT_PRICE) AS unit_price_range_label
FROM public_food_procurement_wh.staging.stg_procurement_items
WHERE is_comparable_for_kg_price_analysis = TRUE
GROUP BY state
ORDER BY total_purchase DESC;