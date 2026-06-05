<img width="157" height="81" alt="image" src="https://github.com/user-attachments/assets/c5af61d1-599c-4a15-987d-e1e6f7447aae" /># Public Food Procurement Price Quality Mini-Warehouse

## 1. Project Overview

This mini-project analyzes price variation in Brazilian public procurement records for a specific food item: **processed black beans, cooked and vacuum-packed**.

The goal is not to explain the full Brazilian food market. The goal is to practice a small but realistic data engineering workflow using public procurement data: ingesting raw data, profiling quality issues, creating a staging layer, building analytical marts, and answering business questions with SQL.

## 2. Business Context

Food procurement is a relevant public-sector topic because governments and public institutions regularly buy food for schools, hospitals, social programs, and other public services.

Even within a small sample, unit prices can vary significantly across suppliers, locations, dates, and purchase contexts. A structured data warehouse can help identify price dispersion, possible outliers, and records that deserve further review.

## 3. Dataset

**Source file:** `dados_consulta.csv`

**Probable source:** Compras.gov.br / Pesquisa de Preços / Dados Abertos

**Rows:** 49

**Columns:** 37

**Item analyzed:** Processed black beans, cooked and vacuum-packed

**Original item description:**

`LEGUMINOSA PROCESSADA, TIPO: FEIJÃO PRETO, PREPARO: COZIDA, APRESENTAÇÃO: À VÁCUO`

**Available period:** 2022-03-21 to 2026-04-24

**States represented:** AL, AM, PA, PB, PE, PR, RJ, RO, RR, RS, SC, SP, TO

## 4. Table Grain

Each row appears to represent one public procurement item associated with:

- a purchase ID;
- an item ID;
- a supplier;
- a public agency / UASG;
- a municipality and state;
- a purchase date;
- a supplied quantity;
- a unit of supply;
- a unit price.

Proposed grain:

> One row per procurement item, supplier, buyer agency, location, purchase date, supplied quantity, and unit price.

## 5. Main Columns

The most relevant columns for the MVP are:

- `ID Compra`
- `ID Item`
- `Descrição do Item`
- `Cód. Catálogo`
- `Unidade Fornecimento`
- `Sigla Unid. Fornecimento`
- `Quantidade`
- `Preço Unitário (R$)`
- `Fornecedor`
- `Cód. UASG`
- `UASG`
- `Município`
- `UF`
- `Órgão`
- `Data da Compra`
- `Modalidade`
- `Objeto da Compra`
- `Descrição Detalhada`

## 6. Initial Data Profiling Notes

Initial inspection identified the following points:

- Numeric fields use Brazilian decimal commas, such as `6,68`, `118,00`, and `0,00`.
- The main unit of supply is `KG`, with 47 records.
- There are 2 records using `G`, which creates unit inconsistency.
- The minimum unit price is R$ 3.48.
- The median unit price is R$ 8.45.
- The maximum unit price is R$ 231.03.
- The maximum unit price is far above the median and should be flagged as a potential outlier.
- `Unidade Medida` and `Sigla Unidade Medida` appear to be fully null in this sample.
- `Descrição Detalhada` has some missing values.
- Supplier, agency, municipality, and organization names may require standardization in a larger version of the project.

## 7. Data Quality Decisions for the MVP

For the first version, the project will use simple and transparent rules:

1. Load all original columns into the RAW layer without transformation.
2. Convert numeric fields only in the STAGING layer.
3. Convert date fields only in the STAGING layer.
4. Keep the original item description for traceability.
5. Create a normalized item description field for analysis.
6. Keep records with `KG` in the main analytical mart.
7. Flag records with other units instead of deleting them from staging.
8. Flag potential price outliers instead of deleting them automatically.
9. Preserve the original Excel serial date value in the RAW layer.
10. Convert the Excel serial date into a proper DATE field only in the STAGING layer.

## 8. Proposed Warehouse Structure

```text
PUBLIC_FOOD_PROCUREMENT_WH

RAW
└── raw_procurement_items

STAGING
└── stg_procurement_items

ANALYTICS
├── mart_item_price_by_month
└── mart_supplier_price_variation
