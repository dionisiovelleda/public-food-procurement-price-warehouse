SELECT COUNT(*)
FROM PUBLIC_FOOD_PROCUREMENT_WH.STAGING.stg_procurement_items;

SELECT
    is_kg_unit,
    has_non_kg_unit,
    has_missing_quantity,
    has_missing_unit_price,
    has_missing_supply_unit,
    is_possible_price_outlier,
    has_basket_context,
    is_comparable_for_kg_price_analysis,
    COUNT(*) AS ROW_COUNT
FROM PUBLIC_FOOD_PROCUREMENT_WH.STAGING.stg_procurement_items
GROUP BY
    is_kg_unit,
    has_non_kg_unit,
    has_missing_quantity,
    has_missing_unit_price,
    has_missing_supply_unit,
    is_possible_price_outlier,
    has_basket_context,
    is_comparable_for_kg_price_analysis
ORDER BY ROW_COUNT DESC;