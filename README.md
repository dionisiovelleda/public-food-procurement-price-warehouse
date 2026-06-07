# Public Food Procurement Price Quality Mini-Warehouse

A Snowflake-based analytical mini-warehouse for analyzing Brazilian public procurement price records for a specific food item: **organic black beans**.

This project was built as a data engineering portfolio project focused on SQL, data quality, warehouse layering, analytical mart design, and validation.

---

## 1. Project Overview

This project implements a small analytical warehouse in Snowflake to analyze public procurement price records from Brazilian government purchasing data.

The analyzed item is:

`LEGUMINOSA, VARIEDADE: FEIJÃO PRETO, TIPO: TIPO 1, APRESENTAÇÃO: ORGÂNICA`

The goal is not to estimate the entire Brazilian food market or measure food waste directly. The goal is to build a reliable analytical layer from public procurement records by:

- loading raw CSV exports into Snowflake;
- profiling unit, price, and quantity quality issues;
- creating a staging layer with standardized types and quality flags;
- defining comparable records for KG-based analysis;
- building analytical marts by month, supplier, and state;
- validating consistency across the analytics layer.

---

## 2. Business Context

Food procurement data can reveal patterns in public purchasing behavior, price dispersion, supplier concentration, and regional differences.

However, procurement records often contain mixed units, inconsistent formats, missing values, and price outliers. Without a proper data quality layer, comparisons can become misleading.

This project focuses on a narrow but realistic analytical question:

> How can public procurement price records for a specific food item be transformed into a comparable analytical dataset?

The final warehouse supports analysis of:

- monthly purchase value and price behavior;
- supplier-level concentration and price variation;
- state-level procurement patterns;
- data quality limitations affecting comparability.

---

## 3. Dataset

### Source

The data was obtained from **Compras.gov / Pesquisa de Preços** CSV exports.

### Scope

- Country: Brazil
- Domain: public procurement
- Item: organic black beans
- Source format: CSV exports
- Raw records loaded: **1,000**
- Comparable KG records used in analytical marts: **342**
- Main analytical unit: **KG**
- Available period: **2022-07 to 2026-06**

### Main Item Description

```text
LEGUMINOSA, VARIEDADE: FEIJÃO PRETO, TIPO: TIPO 1, APRESENTAÇÃO: ORGÂNICA
```

---

## 4. Warehouse Architecture

The warehouse follows a simple three-layer structure:

```text
RAW
↓
STAGING
↓
ANALYTICS
```

### RAW Layer

The RAW layer stores the original procurement records loaded from CSV exports with minimal transformation.

Main purpose:

- preserve the source data;
- keep original text values;
- allow data profiling and traceability.

### STAGING Layer

The STAGING layer standardizes and prepares the raw data for analytics.

Transformations include:

- column renaming;
- date parsing;
- Brazilian numeric format conversion;
- quantity conversion;
- unit price conversion;
- supply unit standardization;
- data quality flag creation;
- comparable KG record classification.

### ANALYTICS Layer

The ANALYTICS layer contains business-facing marts designed for analysis.

Final marts:

- `mart_monthly_kg_price_summary`
- `mart_supplier_kg_price_summary`
- `mart_state_kg_price_summary`

---

## 5. Data Quality Rules

The project applies explicit data quality rules before building the analytical marts.

### Comparable KG Record Rule

A record is considered comparable for KG price analysis when:

- the supply unit is KG;
- unit price is available;
- purchase date is available;
- the unit price is not flagged as a possible high outlier.

Only records marked as comparable are used in the final analytical marts.

### Data Quality Flags

The staging layer includes flags such as:

| Flag | Purpose |
|---|---|
| `is_kg_unit` | Identifies records using KG as the supply unit |
| `has_non_kg_unit` | Identifies records using units other than KG |
| `has_missing_supply_unit` | Identifies records without supply unit information |
| `has_missing_quantity` | Identifies records with invalid or missing quantity |
| `has_missing_unit_price` | Identifies records with invalid or missing unit price |
| `is_possible_price_outlier` | Flags unusually high unit prices |
| `has_basket_context` | Flags records whose purchase object mentions basket-related context |
| `is_comparable_for_kg_price_analysis` | Final flag used by analytical marts |

### Price Outlier Rule

Records with unit price above the defined threshold are flagged as possible outliers and excluded from the main comparable KG analytical marts.

This prevents extreme values from distorting monthly, supplier, and state-level price analysis.

---

## 6. Analytical Marts

### 6.1 Monthly KG Price Summary

Table:

```text
PUBLIC_FOOD_PROCUREMENT_WH.ANALYTICS.MART_MONTHLY_KG_PRICE_SUMMARY
```

Purpose:

> Analyze monthly procurement behavior for comparable KG records.

Main metrics:

- purchase month;
- purchase year;
- row count;
- distinct suppliers;
- distinct states;
- total quantity in KG;
- total purchase value in BRL;
- minimum unit price;
- average unit price;
- median unit price;
- maximum unit price.

This mart answers questions such as:

- Which months had the highest total purchase value?
- Which months had the highest purchase volume?
- How did median unit price vary over time?
- Are high monthly purchase values driven by high prices or high quantities?

---

### 6.2 Supplier KG Price Summary

Table:

```text
PUBLIC_FOOD_PROCUREMENT_WH.ANALYTICS.MART_SUPPLIER_KG_PRICE_SUMMARY
```

Purpose:

> Analyze supplier-level concentration, volume, value, and price dispersion.

Main metrics:

- supplier name;
- row count;
- distinct purchase count;
- distinct state count;
- first purchase date;
- last purchase date;
- total quantity in KG;
- total purchase value in BRL;
- minimum unit price;
- average unit price;
- median unit price;
- maximum unit price;
- unit price range.

This mart answers questions such as:

- Which suppliers had the highest total purchase value?
- Which suppliers appeared most frequently?
- Which suppliers had the highest volume?
- Which suppliers showed the largest price dispersion?
- Are the largest suppliers large by frequency, volume, or value?

---

### 6.3 State KG Price Summary

Table:

```text
PUBLIC_FOOD_PROCUREMENT_WH.ANALYTICS.MART_STATE_KG_PRICE_SUMMARY
```

Purpose:

> Analyze procurement patterns by Brazilian state.

Main metrics:

- state;
- row count;
- distinct purchase count;
- distinct supplier count;
- distinct city count;
- first purchase date;
- last purchase date;
- total quantity in KG;
- total purchase value in BRL;
- minimum unit price;
- average unit price;
- median unit price;
- maximum unit price;
- unit price range.

This mart answers questions such as:

- Which states concentrated the highest purchase volume?
- Which states had the highest total purchase value?
- Which states had the highest median unit price?
- Which states had the most suppliers?
- Which states showed larger price dispersion?

---

## 7. Validation Results

The analytics layer was reconciled against the staging layer.

Validation result:

```text
staging comparable rows = 342
monthly mart rows       = 342
supplier mart rows      = 342
state mart rows         = 342
validation passed       = TRUE
```

This confirms that all analytical marts are based on the same comparable KG record population.

The validation also checks that row counts, total quantity, and total purchase value remain consistent across the marts.

---

## 8. Key Analytical Findings

### 8.1 Comparable Records

The raw dataset contains **1,000** procurement records.

After applying comparability rules, **342 KG-based records** were retained for the analytical marts.

This filtering step was necessary because the raw dataset includes multiple supply units, non-comparable package units, missing unit values, and possible price outliers.

### 8.2 Monthly Patterns

Some months show very high total purchase value. In several cases, this is driven by large purchased quantities rather than abnormal unit prices.

For this reason, monthly purchase value should be analyzed together with total quantity and median unit price.

### 8.3 Supplier Concentration

Supplier relevance should not be measured only by row count.

Some suppliers appear only once or twice but represent high total purchase value because of large-volume procurement records.

This means supplier analysis should consider:

- frequency;
- total volume;
- total purchase value;
- price dispersion.

### 8.4 Price Dispersion

Some suppliers and states show large differences between minimum and maximum unit prices.

Median unit price is a more robust price indicator than average unit price because a small number of high-price records can distort the average.

### 8.5 State-Level Patterns

State-level analysis shows differences in procurement volume, total purchase value, supplier count, and price behavior across UFs.

However, state comparisons should be interpreted carefully. Some states have few comparable records, so their median price may be based on a small sample.

---

## 9. Limitations

This project has intentional scope limitations:

- The dataset is a sample/export from Compras.gov, not a complete national market dataset.
- The project analyzes public procurement price records, not actual food waste.
- Only KG records are used for comparable price analysis.
- Non-KG units, missing-unit records, invalid prices, and high price outliers are excluded from the main analytical marts.
- Supplier aggregation is based on supplier name as available in the source data.
- No legal-entity normalization was applied, so supplier name variations may appear as separate suppliers.
- State-level comparisons should be interpreted as procurement pattern indicators, not definitive market price benchmarks.
- Median unit price is preferred over average price when discussing price levels, due to price dispersion.
- The project does not include orchestration, automated ingestion, or dashboarding.

---

## 10. Repository Structure

```text
public-food-procurement-price-warehouse/
│
├── README.md
├── project_brief.md
├── .gitignore
│
├── data/
│   └── ...
│
├── outputs/
│   ├── monthly_kg_price_summary_sample.csv
│   ├── supplier_kg_price_summary_sample.csv
│   └── state_kg_price_summary_sample.csv
│
└── sql/
    ├── 00_create_database_and_schemas.sql
    ├── 01_create_raw_table.sql
    ├── 02_load_raw_data.sql
    ├── 03_create_staging_view.sql
    ├── 04_validate_staging_view.sql
    ├── 05_create_monthly_kg_price_summary.sql
    ├── 06_create_supplier_kg_price_summary.sql
    ├── 07_create_state_kg_price_summary.sql
    ├── 08_validate_analytics_layer.sql
    └── 09_business_questions.sql
```

---

## 11. Main SQL Workflow

The SQL scripts follow the warehouse development flow:

```text
1. Create database and schemas
2. Create RAW table
3. Load CSV records into RAW
4. Profile and validate RAW data
5. Create STAGING view with conversions and quality flags
6. Validate STAGING layer
7. Create monthly analytical mart
8. Create supplier analytical mart
9. Create state analytical mart
10. Validate analytics layer
11. Run business question queries
```

---

## 12. Skills Demonstrated

This project demonstrates:

- Snowflake SQL;
- public CSV ingestion;
- analytical warehouse layering;
- RAW, STAGING, and ANALYTICS design;
- data profiling;
- Brazilian numeric format parsing;
- date parsing;
- data quality flagging;
- outlier handling;
- analytical mart design;
- cross-mart validation;
- business-question-driven SQL analysis;
- documentation of data limitations.

---

## 13. Possible Future Improvements

Future versions of this project could include:

- automated ingestion from public APIs or scheduled exports;
- supplier legal-entity normalization;
- richer product taxonomy normalization;
- integration with socioeconomic or food insecurity indicators;
- orchestration with Airflow, Dagster, or AWS Step Functions;
- data quality tests with dbt or Great Expectations;
- dashboarding with Power BI, Tableau, Streamlit, or Snowsight;
- migration of the pipeline to a cloud data lake architecture using AWS S3, Glue, and Athena.

---

## 14. Project Summary

This mini-warehouse transforms raw public procurement CSV exports into a validated analytical layer for KG-based price analysis.

The main contribution is not only the final analysis, but the data engineering workflow:

```text
raw public data
→ profiling
→ type conversion
→ quality flags
→ comparability rules
→ analytical marts
→ validation
→ documented limitations
```

The result is a small but realistic data engineering project focused on data quality, analytical modeling, and transparent SQL-based validation.
