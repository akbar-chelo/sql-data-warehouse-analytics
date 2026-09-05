# SQL Data Warehouse & Analytics

> An end-to-end SQL Server data warehouse and Power BI project that transforms CRM and ERP data into clear, trusted business insights.

<p align="center">
  <img src="06_screenshots/01_sales_performance_dashboard.png" alt="Sales Performance Dashboard" width="100%">
</p>

<p align="center">
  <strong>SQL Server</strong> · <strong>Data Warehousing</strong> · <strong>Power BI</strong> · <strong>DAX</strong> · <strong>Business Analytics</strong>
</p>

## What This Project Does

This project follows the complete analytics journey from raw CRM and ERP data to an interactive Power BI dashboard.

The data is loaded into a layered SQL Server warehouse, cleaned and validated, modeled into business-ready tables, analyzed with SQL, and presented through a sales-performance report.

```text
CRM + ERP Data
      ↓
Bronze: Raw Data
      ↓
Silver: Cleaned and Validated Data
      ↓
Gold: Business-Ready Model
      ↓
SQL Analytics and KPIs
      ↓
Power BI Dashboard
```

## Business Problem

Operational data is often spread across different systems and may contain missing values, inconsistent identifiers, invalid dates, and different formats. This makes reporting slow and difficult to trust.

This project creates one structured analytical foundation for understanding sales, customers, products, revenue, orders, and trends.

## Solution Architecture

| Layer | Purpose |
|---|---|
| **Bronze** | Store the original CRM and ERP data. |
| **Silver** | Clean, standardize, validate, and prepare the data. |
| **Gold** | Provide business-ready fact and dimension tables. |
| **Analytics** | Calculate KPIs, trends, rankings, and comparisons with SQL. |
| **Power BI** | Present the results through an interactive report. |

The Gold layer follows a star schema built around:

- `gold.dim_customers`
- `gold.dim_products`
- `gold.fact_sales`

![Power BI Data Model](06_screenshots/02_powerbi_data_model.png)

## Power BI Dashboard

The Power BI dashboard was created independently for this portfolio project. I designed the KPI cards, DAX measures, report layout, filters, charts, and visual storytelling.

### KPI Snapshot

| KPI | Current dashboard value |
|---|---:|
| **Total Revenue** | ₹29.36M |
| **Total Orders** | 28K |
| **Total Quantity** | 60K |
| **Average Order Value** | ₹1.06K |
| **Average Selling Price** | ₹486.04 |

The report also includes monthly revenue trends, revenue by product category, top products by revenue, revenue by country, yearly order analysis, and interactive filters.

## Skills Demonstrated

This project demonstrates practical experience with **SQL Server data warehousing, data cleaning, data quality validation, dimensional modeling, star schemas, SQL analytics, DAX measures, KPI design, and Power BI dashboard development**.

## Repository Structure

```text
SQL-Data-Warehouse-Analytics/
├── 01_datasets/          # CRM and ERP reference datasets
├── 02_scripts/           # Bronze, Silver, and Gold SQL scripts
├── 03_analytics/         # Business-focused SQL analysis
├── 04_powerbi/           # Power BI report and model files
├── 05_docs/              # Architecture and data-model documentation
├── 06_screenshots/       # Dashboard, model, and warehouse previews
├── .gitignore
└── README.md
```

## Explore the Project

| Area | Link |
|---|---|
| Warehouse scripts | [`02_scripts/`](02_scripts/) |
| SQL analytics | [`03_analytics/`](03_analytics/) |
| Power BI files | [`04_powerbi/`](04_powerbi/) |
| Architecture documentation | [`05_docs/architecture/`](05_docs/architecture/) |
| Data model documentation | [`05_docs/data_model/`](05_docs/data_model/) |
| Screenshots | [`06_screenshots/`](06_screenshots/) |

![SQL Server Warehouse](06_screenshots/03_sql_server_warehouse.png)

## Reference and Attribution

The data-engineering workflow was developed by following the learning path and implementation reference from [Data with Baraa](https://github.com/DataWithBaraa/sql-data-warehouse-project). This includes the Bronze–Silver–Gold approach, the general SQL Server pipeline structure, and the reference CRM/ERP datasets.

The **Power BI reporting layer was created independently** for this portfolio project. I personally designed the data model extension, KPI definitions, DAX measures, dashboard layout, visual selection, filters, and business-reporting experience.

> **Reference for the data-engineering workflow and datasets:** [Data Warehouse and Analytics Project — Data with Baraa](https://github.com/DataWithBaraa/sql-data-warehouse-project)

> **Original work in this repository:** Power BI dashboard design, KPI reporting, DAX measures, visual storytelling, documentation, and the presentation of business insights.

## Final Outcome

> **Raw data → reliable warehouse → reusable KPIs → interactive business insights**

This project demonstrates how data engineering and business intelligence can work together to create a clear, repeatable, and decision-ready analytics solution.

---

<p align="center">
  Built to turn operational data into business understanding.
</p>

## References

[1] [Data Warehouse and Analytics Project — Data with Baraa](https://github.com/DataWithBaraa/sql-data-warehouse-project)
