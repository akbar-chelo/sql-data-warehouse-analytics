# SQL Data Warehouse & Analytics

> An end-to-end analytics solution that transforms raw CRM and ERP data into a reliable SQL Server warehouse, reusable business metrics, and an interactive Power BI dashboard.

[![SQL Server](https://img.shields.io/badge/SQL%20Server-Data%20Warehouse-CC2927?logo=microsoftsqlserver&logoColor=white)](https://www.microsoft.com/sql-server) [![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/) [![Git](https://img.shields.io/badge/Git-Version%20Control-F05032?logo=git&logoColor=white)](https://git-scm.com/)

## Executive Summary

Operational data is often spread across multiple systems, stored in inconsistent formats, and difficult to use for trustworthy reporting. This project addresses that challenge by building a complete analytics workflow—from source ingestion and data quality validation to dimensional modeling, SQL analysis, and Power BI reporting.

The result is a structured, reusable analytical foundation that helps stakeholders move from raw records to consistent KPIs and business insights.

## The Business Problem

CRM and ERP data can contain inconsistent customer and product identifiers, missing values, invalid dates, duplicate records, and conflicting business attributes. Without a controlled data pipeline, every report risks using different definitions, manual corrections, or unreliable calculations.

This project solves that problem by separating raw ingestion, data preparation, business modeling, and reporting into clearly defined layers.

## The Solution

The solution integrates CRM and ERP CSV sources into a SQL Server data warehouse using a **Bronze–Silver–Gold architecture**:

| Layer | Purpose | Outcome |
|---|---|---|
| **Bronze** | Preserve source data in its original form | Traceable raw landing layer |
| **Silver** | Clean, standardize, validate, and reconcile records | Consistent and analysis-ready data |
| **Gold** | Expose business-ready dimensions and facts | Reusable analytical model |
| **Analytics** | Answer business questions with SQL | Actionable performance insights |
| **Power BI** | Present KPIs and trends interactively | Decision-ready reporting experience |

## End-to-End Workflow

```text
CRM + ERP CSV Files
        ↓
Bronze: Raw Ingestion
        ↓
Silver: Cleaning, Standardization & Validation
        ↓
Gold: Dimensional Model and Business Views
        ↓
SQL Analytics: KPIs, Trends and Comparisons
        ↓
Power BI: DAX Measures, Filters and Visual Reporting
        ↓
Business Insights
```

## Architecture

```text
┌──────────────────────┐
│   CRM + ERP Sources  │
│       CSV Files      │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Bronze Layer         │
│ Raw source tables    │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Silver Layer         │
│ Cleaned and validated│
│ business data        │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Gold Layer           │
│ Dimensions and facts │
│ for analysis         │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ SQL Analytics        │
│ KPIs and performance │
│ analysis             │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Power BI             │
│ Interactive dashboard│
└──────────────────────┘
```

## Data Modeling

The Gold layer uses a star-schema design to separate measurable business events from descriptive context:

```text
                 ┌───────────────────┐
                 │   dim_customers   │
                 └─────────┬─────────┘
                           │
                           │
┌──────────────────┐       │       ┌──────────────────┐
│   dim_products   │───────┼───────│    fact_sales    │
└──────────────────┘       │       └──────────────────┘
                           │
                    Business Analysis
```

Core Gold objects include:

- `gold.dim_customers`
- `gold.dim_products`
- `gold.fact_sales`

The Power BI model extends the warehouse with a date dimension and a dedicated measures table for reporting and DAX calculations.

## Data Quality Approach

Data quality is addressed before information reaches the reporting layer. The workflow profiles source data, applies standardized transformation rules, and validates key business fields.

| Quality area | Example checks |
|---|---|
| Completeness | NULL values and missing business attributes |
| Uniqueness | Duplicate records and identifier consistency |
| Validity | Date ranges, sales dates, prices, and quantities |
| Standardization | Text, gender, country, and customer identifiers |
| Reconciliation | CRM and ERP attributes that describe the same entity |

## Business Questions Answered

The SQL analytics layer is designed to answer questions such as:

- How is revenue changing over time?
- Which products and categories contribute the most revenue?
- Which customers generate the highest value?
- How do order volume and quantity sold change by period?
- What are the month-over-month and year-over-year trends?
- Which countries, products, or customer segments require attention?

## Power BI Reporting

The dashboard converts the analytical model into an interactive reporting experience.

| Report area | Included analysis |
|---|---|
| Executive KPIs | Total revenue, total orders, total quantity, average order value, and average selling price |
| Sales trends | Monthly revenue and yearly order performance |
| Product performance | Revenue by category and top products by revenue |
| Geographic analysis | Revenue by country |
| Exploration | Filters for year, month, product category, product name, and customer |

> Dashboard screenshots and the Power BI project are available in [`06_screenshots/`](06_screenshots/) and [`04_powerbi/`](04_powerbi/).

## Repository Structure

```text
SQL-Data-Warehouse-Analytics/
├── 01_datasets/          # CRM and ERP source data
├── 02_scripts/           # Bronze, Silver, and Gold SQL scripts
├── 03_analytics/         # Business-focused SQL analysis
├── 04_powerbi/           # Power BI report and model assets
├── 05_docs/              # Architecture, catalog, and data-model documentation
├── 06_screenshots/       # Dashboard and project visuals
├── .gitignore
└── README.md
```

## Technology Stack

| Technology | Role in the project |
|---|---|
| **SQL Server** | Warehouse layers, transformations, views, joins, CTEs, window functions, and analytics |
| **Power BI** | Dimensional modeling, DAX measures, KPI design, filters, and dashboard development |
| **CSV** | CRM and ERP source data |
| **VS Code** | SQL development and repository organization |
| **Git & GitHub** | Version control and project documentation |

## Skills Demonstrated

**Data warehousing:** Bronze–Silver–Gold architecture, CRM and ERP integration, data profiling, cleansing, standardization, dimensional modeling, star schemas, fact tables, and dimension tables.

**SQL development:** DDL and DML, joins, CTEs, aggregations, window functions, date analysis, views, validation logic, and business-oriented queries.

**Business intelligence:** KPI development, revenue analysis, customer analysis, product analysis, time-series comparisons, DAX measures, slicers, and interactive dashboards.

**Engineering practice:** Layered design, traceable transformations, reusable analytical objects, structured documentation, and Git-based repository management.

## Recruiter Quick View

| What you want to review | Where to look |
|---|---|
| Overall architecture | [`05_docs/architecture/`](05_docs/architecture/) |
| Data model | [`05_docs/data_model/`](05_docs/data_model/) |
| Warehouse implementation | [`02_scripts/`](02_scripts/) |
| Business analysis queries | [`03_analytics/`](03_analytics/) |
| Dashboard and reporting assets | [`04_powerbi/`](04_powerbi/) |
| Visual project evidence | [`06_screenshots/`](06_screenshots/) |

## Project Value

This project demonstrates more than dashboard creation. It shows the complete analytical lifecycle:

> **Ingest → Clean → Validate → Model → Analyze → Visualize → Communicate**

The key value is the separation of responsibilities. Raw data remains traceable, transformation logic is organized by layer, the Gold model is reusable, and Power BI consumes a consistent analytical foundation instead of performing uncontrolled cleanup inside the report.

## Documentation

Additional project documentation is organized in [`05_docs/`](05_docs/), including the architecture, data catalog, and data-model materials.

## Author

Built as a portfolio project to demonstrate practical capability in **SQL Server data warehousing, analytics engineering, and Power BI business intelligence**.

---

<p align="center">
  <strong>From fragmented operational data to trusted business insight.</strong>
</p>

<!-- Updated for recruiter-focused presentation: problem → solution → implementation → insight. -->
