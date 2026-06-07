CREATE OR REPLACE VIEW public_food_procurement_wh.analytics.validate_analytics_layer AS

WITH staging_comparable_rows AS (
    SELECT
        COUNT(*) AS comparable_rows
    FROM public_food_procurement_wh.staging.stg_procurement_items
    WHERE is_comparable_for_kg_price_analysis = TRUE
    ),
monthly_mart_rows AS (
    SELECT
        SUM(row_count) AS monthly_rows
    FROM PUBLIC_FOOD_PROCUREMENT_WH.ANALYTICS.MART_MONTHLY_KG_PRICE_SUMMARY
    ),
supplier_mart_rows AS (
    SELECT
        SUM(row_count) AS supplier_rows
    FROM PUBLIC_FOOD_PROCUREMENT_WH.ANALYTICS.MART_SUPPLIER_KG_PRICE_SUMMARY
    ),
state_mart_rows AS (
    SELECT
        SUM(row_count) AS state_rows
    FROM PUBLIC_FOOD_PROCUREMENT_WH.ANALYTICS.MART_STATE_KG_PRICE_SUMMARY
    ),
monthly_mart AS (
    SELECT
        SUM(monthly_purchase) AS monthly_mart_sum
    FROM PUBLIC_FOOD_PROCUREMENT_WH.ANALYTICS.MART_MONTHLY_KG_PRICE_SUMMARY
    ),
supplier_mart AS (
    SELECT
        SUM(total_purchase_by_supplier) AS supplier_mart_sum
    FROM PUBLIC_FOOD_PROCUREMENT_WH.ANALYTICS.MART_SUPPLIER_KG_PRICE_SUMMARY
    ),
state_mart AS (
    SELECT
        SUM(total_purchase) AS state_mart_sum
    FROM PUBLIC_FOOD_PROCUREMENT_WH.ANALYTICS.MART_STATE_KG_PRICE_SUMMARY
    )


SELECT 
    comparable_rows,
    monthly_rows,
    supplier_rows,
    state_rows,
    
    monthly_mart_sum,
    supplier_mart_sum,
    state_mart_sum,

    CASE 
        WHEN comparable_rows = monthly_rows AND
             monthly_rows = supplier_rows AND
             supplier_rows = state_rows AND
             monthly_mart_sum = supplier_mart_sum AND
             supplier_mart_sum = state_mart_sum
        THEN TRUE
        ELSE FALSE
    END AS validation_passed
    
FROM staging_comparable_rows
CROSS JOIN monthly_mart_rows
CROSS JOIN supplier_mart_rows
CROSS JOIN state_mart_rows
CROSS JOIN monthly_mart
CROSS JOIN supplier_mart
CROSS JOIN state_mart;

