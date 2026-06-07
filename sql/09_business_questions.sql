--Which months had the highest total purchase value?
SELECT
    PURCHASE_MONTH AS purchase_month,
    MAX(MONTHLY_PURCHASE) AS highest_purchase_month,
FROM PUBLIC_FOOD_PROCUREMENT_WH.ANALYTICS.MART_MONTHLY_KG_PRICE_SUMMARY
GROUP BY PURCHASE_MONTH
ORDER BY highest_purchase_month DESC
LIMIT 5;

--Which months had the highest median unit price?
SELECT 
    PURCHASE_MONTH AS purchase_month,
    MAX(MEDIAN_MONTHLY_PRICE) AS highest_median_price
FROM PUBLIC_FOOD_PROCUREMENT_WH.ANALYTICS.MART_MONTHLY_KG_PRICE_SUMMARY
GROUP BY PURCHASE_MONTH
ORDER BY highest_median_price DESC
LIMIT 5;

--Which suppliers had the highest total purchase value?
SELECT
    SUPPLIER_NAME AS supplier_name,
    MAX(total_purchase_by_supplier) AS highest_total_price
FROM PUBLIC_FOOD_PROCUREMENT_WH.ANALYTICS.MART_SUPPLIER_KG_PRICE_SUMMARY
GROUP BY SUPPLIER_NAME
ORDER BY highest_total_price DESC
LIMIT 5;

--Which suppliers had the highest price dispersion?
SELECT
    SUPPLIER_NAME AS supplier_name,
    MAX(PRICE_RANGE_BRL) AS highest_price_dispersion,
    PRICE_RANGE_LABEL
FROM PUBLIC_FOOD_PROCUREMENT_WH.ANALYTICS.MART_SUPPLIER_KG_PRICE_SUMMARY
GROUP BY SUPPLIER_NAME, PRICE_RANGE_LABEL
ORDER BY highest_price_dispersion DESC
LIMIT 5;

--Which states concentrated the highest purchase volume?
SELECT
    STATE AS state,
    MAX(TOTAL_QUANTITY_KG) AS highest_purchase_volume
FROM PUBLIC_FOOD_PROCUREMENT_WH.ANALYTICS.MART_STATE_KG_PRICE_SUMMARY
GROUP BY STATE
ORDER BY highest_purchase_volume DESC
LIMIT 10;

--Which states had the highest median unit price, considering only states with enough records?
SELECT 
    STATE AS state,
    MAX(MEDIAN_UNIT_PRICE) AS highest_median_unit_price
FROM PUBLIC_FOOD_PROCUREMENT_WH.ANALYTICS.MART_STATE_KG_PRICE_SUMMARY
WHERE ROW_COUNT >= 10
GROUP BY STATE
ORDER BY highest_median_unit_price DESC
LIMIT 10;
