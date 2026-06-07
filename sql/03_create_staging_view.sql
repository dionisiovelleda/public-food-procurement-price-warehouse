--CREATE OR REPLACE VIEW PUBLIC_FOOD_PROCUREMENT_WH.STAGING.stg_procurement_items AS
WITH base AS (
    SELECT
        ID_COMPRA AS purchase_id,
        ID_ITEM AS item_id,
        DESC_DO_ITEM AS item_description,
        COD_CATALOGO AS catalog_code,
        UNIDADE_FORNECIMENTO AS supply_unit,
        SIGLA_UNID_FORNECIMENTO AS supply_unit_abbreviation,
        QUANTIDADE AS quantity_raw,
        TRY_TO_DECIMAL(REPLACE(REPLACE(QUANTIDADE, '.', ''), ',', '.'), 10, 2) AS quantity,
        PRECO_UNITARIO AS unit_price_brl_raw,
        TRY_TO_DECIMAL(REPLACE(REPLACE(PRECO_UNITARIO, '.', ''), ',', '.'), 10, 2) AS unit_price_brl,
        FORNECEDOR AS supplier_name,
        COD_UASG AS uasg_code,
        UASG AS uasg_name,
        MUNICIPIO AS city_name,
        UF as state,
        ORGAO AS organization_name,
        DATA_DA_COMPRA AS purchase_date_raw,
        TRY_TO_DATE(DATA_DA_COMPRA) AS purchase_date,
        MODALIDADE as modality,
        OBJETO_DA_COMPRA AS purchase_object,
        DESCRICAO_DETALHADA as detailed_description
       
    FROM PUBLIC_FOOD_PROCUREMENT_WH.RAW.RAW_PROCUREMENT_ITEMS
    ),
    
flags AS (
    SELECT base.*,
    CASE
        WHEN TRIM(UPPER(supply_unit_abbreviation)) = 'KG' THEN TRUE
        ELSE FALSE
    END AS is_kg_unit,
    CASE
        WHEN TRIM(UPPER(supply_unit_abbreviation)) <> 'KG' THEN TRUE
        ELSE FALSE
    END AS has_non_kg_unit,
    CASE
        WHEN quantity IS NULL THEN TRUE
        ELSE FALSE
    END AS has_missing_quantity,
    CASE
        WHEN unit_price_brl IS NULL THEN TRUE
        ELSE FALSE
    END AS has_missing_unit_price,
    CASE
        WHEN SUPPLY_UNIT IS NULL OR SUPPLY_UNIT = '' THEN TRUE
        ELSE FALSE
    END AS has_missing_supply_unit,
    CASE
        WHEN unit_price_brl > 100 THEN TRUE
        ELSE FALSE
    END AS is_possible_price_outlier,
    CASE
        WHEN UPPER(purchase_object) LIKE '%CESTA%' THEN TRUE
        ELSE FALSE
    END AS has_basket_context
    FROM base
    ),
    
final AS (
    SELECT 
    flags.*,
    CASE
        WHEN is_kg_unit AND NOT has_missing_unit_price AND NOT is_possible_price_outlier AND purchase_date IS NOT NULL THEN TRUE
        ELSE FALSE
    END AS is_comparable_for_kg_price_analysis
    FROM flags
    )
    
SELECT *
FROM final;
