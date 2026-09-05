# 🚀 SQL Data Warehouse & Analytics

```{=html}
<p align="center">
```
`<b>`{=html}End-to-End SQL Server Data Warehouse + Analytics + Power
BI`</b>`{=html}`<br>`{=html} `<i>`{=html}From raw CRM & ERP data to
business-ready insights`</i>`{=html}
```{=html}
</p>
```

------------------------------------------------------------------------

## 📌 Project Overview

This project demonstrates how raw **CRM and ERP CSV data** can be
transformed into a structured, analytics-ready data warehouse and then
converted into business insights.

The solution follows a layered architecture:

**Source Data → Bronze → Silver → Gold → SQL Analytics → Power BI →
Business Insights**

The project was built to demonstrate practical skills in **SQL Server,
data warehousing, ETL, data quality, dimensional modeling, analytical
SQL, and Power BI reporting**.

> 🎯 **Portfolio Goal:** Show the complete journey from raw data to
> decision-ready analytics---not just a dashboard.

------------------------------------------------------------------------

## 🏗️ Architecture

``` text
┌─────────────────┐
│   CRM + ERP     │
│    CSV Files    │
└────────┬────────┘
         ↓
┌─────────────────┐
│  01 BRONZE      │
│ Raw / As-Is     │
└────────┬────────┘
         ↓
┌─────────────────┐
│  02 SILVER      │
│ Cleaned &       │
│ Standardized    │
└────────┬────────┘
         ↓
┌─────────────────┐
│  03 GOLD        │
│ Business-Ready  │
│ SQL Views       │
└────────┬────────┘
         ↓
┌─────────────────┐
│ SQL ANALYTICS   │
│ KPIs & Insights │
└────────┬────────┘
         ↓
┌─────────────────┐
│    POWER BI     │
│ Dashboards      │
└────────┬────────┘
         ↓
┌─────────────────┐
│ BUSINESS        │
│ INSIGHTS        │
└─────────────────┘
```

📁 Detailed architecture and data-model diagrams are available in
[`05_docs/`](05_docs/).

------------------------------------------------------------------------

## 🎯 Business Problem

Organizations often have data distributed across different operational
systems. Raw files may contain:

-   Missing or invalid values
-   Inconsistent formats
-   Duplicate or conflicting customer information
-   Invalid dates
-   Inconsistent country and gender values
-   Sales and pricing issues
-   Data that is difficult to analyze directly

The objective of this project is to build a reliable analytical
foundation that converts this raw data into **clean, standardized,
business-ready information**.

------------------------------------------------------------------------

## 💡 Key Objectives

-   Build an end-to-end SQL Server data warehouse
-   Integrate CRM and ERP source data
-   Separate raw, cleaned, and business-ready layers
-   Apply data cleansing and standardization rules
-   Perform data profiling and quality checks
-   Create a Gold-layer dimensional model
-   Build reusable analytical SQL queries
-   Connect the Gold layer to Power BI
-   Create an executive-style sales dashboard
-   Convert data into actionable business insights

------------------------------------------------------------------------

## 🗂️ Repository Structure

``` text
SQL-Data-Warehouse-Analytics/
│
├── 01_datasets/
│   ├── source_crm/
│   └── source_erp/
│
├── 02_scripts/
│   ├── bronze/
│   ├── silver/
│   └── gold/
│
├── 03_analytics/
│
├── 04_powerbi/
│
├── 05_docs/
│   ├── architecture/
│   ├── data_catalog/
│   └── data_model/
│
├── 06_screenshots/
│
├── .gitignore
└── README.md
```

------------------------------------------------------------------------

## 🔄 Data Warehouse Layers

```{=html}
<details>
```
```{=html}
<summary>
```
`<b>`{=html}🥉 Bronze Layer --- Raw Data`</b>`{=html}
```{=html}
</summary>
```
The Bronze layer stores source data in its raw/as-is form.

### Purpose

-   Ingest source files
-   Preserve original information
-   Provide a reliable raw-data landing layer
-   Avoid business transformations at ingestion

### Source systems

**CRM** - Customer information - Product information - Sales information

**ERP** - Customer demographic information - Customer location
information - Product category information

```{=html}
</details>
```
```{=html}
<details>
```
```{=html}
<summary>
```
`<b>`{=html}🥈 Silver Layer --- Cleaned Data`</b>`{=html}
```{=html}
</summary>
```
The Silver layer transforms raw data into cleaner and standardized
datasets.

### Key transformations

-   Trimming and standardizing text
-   Handling NULL and invalid values
-   Standardizing gender values
-   Standardizing country values
-   Validating birth dates
-   Cleaning customer identifiers
-   Converting invalid sales dates to NULL
-   Correcting inconsistent sales and price values
-   Applying business/data-quality rules

### Silver tables

``` text
silver.crm_cust_info
silver.crm_prd_info
silver.crm_sales_details
silver.erp_cust_az12
silver.erp_loc_a101
silver.erp_px_cat_g1v2
```

📖 See the Silver Data Catalog in
[`05_docs/data_catalog/`](05_docs/data_catalog/).

```{=html}
</details>
```
```{=html}
<details>
```
```{=html}
<summary>
```
`<b>`{=html}🥇 Gold Layer --- Business Ready`</b>`{=html}
```{=html}
</summary>
```
The Gold layer provides analytics-ready SQL views designed for reporting
and business analysis.

### Gold views

``` text
gold.dim_customers
gold.dim_products
gold.fact_sales
```

The model follows a **star-schema approach**, with dimensions providing
descriptive context and the sales fact providing measurable business
activity.

> ℹ️ `dim_dates` and the measures table are Power BI-side analytical
> objects, not Gold SQL warehouse views.

📖 See the Gold Data Catalog and Data Model documentation in
[`05_docs/`](05_docs/).

```{=html}
</details>
```

------------------------------------------------------------------------

## ⭐ Data Model

The Gold model is centered around:

``` text
              ┌──────────────────┐
              │  dim_customers   │
              └────────┬─────────┘
                       │
                       │
┌──────────────────┐   │   ┌──────────────────┐
│  dim_products    │───┼───│    fact_sales    │
└──────────────────┘   │   └──────────────────┘
                       │
                       └──── Analytics
```

The Power BI model additionally uses a date dimension and a dedicated
measures table for reporting.

📐 Detailed model diagram: [`05_docs/data_model/`](05_docs/data_model/)

------------------------------------------------------------------------

## 📊 SQL Analytics

The analytical layer answers business questions using SQL Server.

### Sales Analysis

-   Revenue performance
-   Order volume
-   Quantity sold
-   Average order value
-   Product/category performance
-   Yearly and monthly trends

### Customer Analysis

-   Customer contribution to revenue
-   Customer segmentation analysis
-   Customer activity patterns
-   Demographic analysis

### Product Analysis

-   Top-performing products
-   Product revenue contribution
-   Quantity performance
-   Product/category comparisons

### Time-Series Analysis

-   Monthly revenue trends
-   Year-over-year comparisons
-   Month-over-month growth
-   Previous-period comparisons
-   Trend analysis

📁 SQL analysis queries: [`03_analytics/`](03_analytics/)

------------------------------------------------------------------------

## 📈 Power BI Dashboard

The Power BI reporting layer converts the Gold model and analytical
measures into an interactive dashboard.

### Sales Performance Dashboard

Current dashboard KPIs include:

  KPI                        Purpose
  -------------------------- -------------------------
  💰 Total Revenue           Overall sales value
  🛒 Total Orders            Number of sales orders
  📦 Total Quantity          Units sold
  🧾 Average Order Value     Average value per order
  🏷️ Average Selling Price   Average selling price

### Visual analysis

-   Monthly Revenue Trend
-   Revenue by Product Category
-   Top 10 Products by Revenue
-   Revenue by Country
-   Orders by Year
-   Interactive slicers for year, month, product category, product name,
    and customer

📁 Power BI file: [`04_powerbi/`](04_powerbi/)

🖼️ Dashboard screenshots: [`06_screenshots/`](06_screenshots/)

------------------------------------------------------------------------

## 🧹 Data Quality & Profiling

Data quality was considered throughout the warehouse process.

The project includes profiling across the CRM and ERP Silver-layer
datasets to understand:

-   Row counts
-   NULL values
-   Duplicate records
-   Invalid values
-   Data distributions
-   Date ranges
-   Key-column quality

The Silver layer then applies transformation and standardization rules
before the data reaches the Gold layer.

------------------------------------------------------------------------

## 🛠️ Tools & Technologies

  -----------------------------------------------------------------------
  Tool                                Usage
  ----------------------------------- -----------------------------------
  🗄️ **SQL Server**                   Data warehouse, transformations,
                                      views and analytics

  💻 **VS Code**                      SQL development, project
                                      organization and Git workflow

  📊 **Power BI**                     Data modeling, DAX, KPIs and
                                      dashboards

  📁 **CSV**                          CRM and ERP source data

  🔀 **Git & GitHub**                 Version control and portfolio
                                      repository

  📝 **Markdown**                     Project documentation
  -----------------------------------------------------------------------

------------------------------------------------------------------------

## 📚 Documentation

  --------------------------------------------------------------------------------------
  Documentation                       Location
  ----------------------------------- --------------------------------------------------
  Architecture                        [`05_docs/architecture/`](05_docs/architecture/)

  Data Model                          [`05_docs/data_model/`](05_docs/data_model/)

  Bronze Data Catalog                 [`05_docs/data_catalog/`](05_docs/data_catalog/)

  Silver Data Catalog                 [`05_docs/data_catalog/`](05_docs/data_catalog/)

  Gold Data Catalog                   [`05_docs/data_catalog/`](05_docs/data_catalog/)
  --------------------------------------------------------------------------------------

------------------------------------------------------------------------

## 🔍 What This Project Demonstrates

### SQL & Data Engineering

-   SQL Server
-   Database schemas
-   DDL and DML
-   ETL-style transformations
-   Views
-   Data cleansing
-   Data validation
-   Data profiling
-   CTEs
-   Window functions
-   Aggregations
-   Date/time analysis
-   Business logic

### Data Warehousing

-   Bronze / Silver / Gold architecture
-   CRM + ERP integration
-   Dimensional modeling
-   Fact and dimension concepts
-   Star schema
-   Analytics-ready data structures

### Business Analytics

-   KPI development
-   Revenue analysis
-   Customer analysis
-   Product analysis
-   Trend analysis
-   MoM and YoY analysis
-   Business-oriented SQL questions

### Power BI

-   Data modeling
-   DAX measures
-   KPI cards
-   Interactive slicers
-   Trend analysis
-   Category/product analysis
-   Executive dashboard design

### Professional Workflow

-   Git version control
-   GitHub repository management
-   Technical documentation
-   Data cataloging
-   Portfolio presentation

------------------------------------------------------------------------

## 🧭 Project Flow

``` text
RAW DATA
   ↓
Understand the data
   ↓
BRONZE
   ↓
Profile & inspect
   ↓
SILVER
   ↓
Clean + standardize + validate
   ↓
GOLD
   ↓
Model for analytics
   ↓
SQL ANALYTICS
   ↓
Find patterns + KPIs
   ↓
POWER BI
   ↓
Visualize
   ↓
BUSINESS INSIGHTS
```

------------------------------------------------------------------------

## 👨‍💻 About the Project

This is a portfolio project created to demonstrate practical application
of **SQL Server Data Warehousing, Analytics, and Power BI**.

The project structure is inspired by common industry data-warehouse
practices and learning resources, while the implementation,
transformations, analytics, documentation, and reporting are developed
as part of this portfolio project.

------------------------------------------------------------------------

## ⭐ Why This Project Matters

A dashboard alone shows the final presentation.

This project shows the **entire analytical lifecycle**:

> **Source → Engineer → Clean → Model → Analyze → Visualize → Decide**

That is the key value of this portfolio project.

------------------------------------------------------------------------

## 📬 Recruiter Quick View

**Looking for evidence of practical skills? Start here:**

1.  🏗️ [`05_docs/architecture/`](05_docs/architecture/) --- Understand
    the architecture
2.  ⭐ [`05_docs/data_model/`](05_docs/data_model/) --- See the
    analytical model
3.  🗄️ [`02_scripts/`](02_scripts/) --- Review warehouse development
4.  🔎 [`03_analytics/`](03_analytics/) --- Review business SQL
5.  📊 [`04_powerbi/`](04_powerbi/) --- Open the reporting layer
6.  🖼️ [`06_screenshots/`](06_screenshots/) --- See the final output

------------------------------------------------------------------------

```{=html}
<p align="center">
```
`<b>`{=html}Built to learn. Built to analyze. Built to make data
useful.`</b>`{=html}
```{=html}
</p>
```
