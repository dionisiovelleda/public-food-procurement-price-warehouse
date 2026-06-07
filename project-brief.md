# Project Brief — Public Food Procurement Price Quality Mini-Warehouse

## What is the project?

This project is a small analytical data warehouse built in **Snowflake** to analyze Brazilian public procurement price records.

The analyzed item is:

```text
LEGUMINOSA, VARIEDADE: FEIJÃO PRETO, TIPO: TIPO 1, APRESENTAÇÃO: ORGÂNICA
```

The project transforms raw CSV exports from Compras.gov into a validated analytical layer for KG-based price analysis.

---

## What problem does it solve?

Public procurement datasets are not always directly comparable.

In this dataset, the main issues included:

- mixed supply units;
- KG and non-KG records;
- Brazilian numeric formats;
- possible unit price outliers;
- missing supply unit values;
- supplier name variations.

The project addresses these issues by creating a data quality and comparability layer before analysis.

The central question is:

> How can raw public procurement records be transformed into a comparable dataset for KG-based price analysis?

---

## What is the scope?

The MVP has a narrow and intentional scope:

| Item | Scope |
|---|---|
| Source | Compras.gov / Pesquisa de Preços |
| Country | Brazil |
| Product | Organic black beans |
| Raw records | 1,000 |
| Comparable KG records | 342 |
| Period | 2022-07 to 2026-06 |
| Platform | Snowflake |
| Main language | SQL |

Out of scope:

- measuring actual food waste;
- creating an official price benchmark;
- normalizing supplier legal entities;
- building a dashboard;
- automating ingestion;
- orchestrating the pipeline.

---

## What is the architecture?

The warehouse follows a three-layer architecture:

```text
RAW
↓
STAGING
↓
ANALYTICS
```

### RAW

Stores the original records loaded from CSV exports.

### STAGING

Standardizes and qualifies the data:

- date conversion;
- Brazilian numeric format conversion;
- quantity and unit price standardization;
- data quality flags;
- comparable KG record classification.

### ANALYTICS

Contains the final analytical marts:

- `mart_monthly_kg_price_summary`
- `mart_supplier_kg_price_summary`
- `mart_state_kg_price_summary`

All marts use only records where:

```text
is_comparable_for_kg_price_analysis = TRUE
```

---

## What are the deliverables?

The main project deliverables are:

| Deliverable | Description |
|---|---|
| SQL pipeline | Snowflake scripts from RAW to ANALYTICS |
| Staging view | View with conversions, standardization, and quality flags |
| Monthly mart | Monthly analysis of KG volume, purchase value, and unit price |
| Supplier mart | Supplier-level analysis of purchase value and price dispersion |
| State mart | State-level analysis of volume, value, and median unit price |
| Validation script | Reconciliation between staging and analytical marts |
| Output samples | Sample CSV exports from the final marts |
| README | Full project documentation |
| Project brief | Short executive/technical project summary |

Validated result:

```text
staging comparable rows = 342
monthly mart rows       = 342
supplier mart rows      = 342
state mart rows         = 342
validation passed       = TRUE
```
