# 🏢 CRM & ERP Data Warehouse — End-to-End SQL Project

A complete **Data Warehouse** built from scratch using **Medallion Architecture** (Bronze → Silver → Gold), integrating data from two source systems — a **CRM System** and an **ERP System** — into a clean **Star Schema** optimized for BI reporting and analytics.

---

## 📐 Data Architecture

![Data Architecture](Docs/DataArchitecture.png)

The project follows the **Medallion Architecture** consisting of three layers:

| Layer | Description | Object Type | Load Strategy |
|-------|-------------|-------------|---------------|
| **Bronze (Raw)** | Stores data exactly as it comes from the source systems | Table | Batch Processing / Full Load / Truncate & Insert |
| **Silver (Cleansed)** | Data is cleaned, deduplicated, and normalized | Table | Batch Processing / Full Load / Truncate & Insert |
| **Gold (Curated)** | Data is modeled into a Star Schema for reporting | Views | No Load — Views refresh on query |

---

## 📁 Repository Structure
```
crm-erp-data-warehouse/
│
├── Docs/
│   ├── DataArchitecture.png
│   ├── Star Schema.png
│   └── End-to-End_DWH_Documentation.pdf
│
└── scripts/
    ├── Bronze_layer/
    │   ├── BronzeLayerDDL.sql
    │   └── BronzeLayer_stored_proc.sql
    ├── Silver_layer/
    │   ├── SilverLayerDDL.sql
    │   └── SilverLayer_stored_proc.sql
    └── Gold_Layer/
        ├── GoldLayer.sql
        └── DataQuality.sql
```
---

## ⚙️ Bronze Layer — Raw Ingestion

| Item | Detail |
|------|--------|
| Source Files | `cust_info`, `prd_info`, `sales_details`, `CUST_AZ12`, `LOC_A101`, `PX_CAT_G1V2` |
| Technique | BULK INSERT within Stored Procedures — for rapid, efficient data loading |
| Outcome | Raw tables created with original schemas — no transformations applied |

---

## 🧹 Silver Layer — Transformation & Cleansing

| Transformation | Detail |
|----------------|--------|
| **Standardization — Gender** | `'F'`, `'FEMALE'` → `'Female'` |
| **Standardization — Marital Status** | `'S'`, `'M'` → `'Single'`, `'Married'` |
| **Standardization — Country Codes** | `'DE'` → `'Germany'`, `'US'` → `'United States'` |
| **Date Handling — Format** | Converted integer dates (e.g. `20230101`) to proper `DATE` format |
| **Date Handling — Invalid Dates** | Invalid / future birthdates set to `NULL` |
| **Deduplication** | `ROW_NUMBER()` keeps most recent record per customer based on `create_date` |
| **Logic Correction** | Recalculated missing or negative Sales Amount: `Quantity × Price` |

---

## 🗂️ Gold Layer — Star Schema

![Star Schema](Docs/Star%20Schema.png)

| Object | Type | Description |
|--------|------|-------------|
| `dim_customers` | Dimension | Enriched with ERP demographics (gender, marital status, birthdate, country) |
| `dim_products` | Dimension | Merged with categories. Filtered for active products only (`end_date IS NULL`) |
| `fact_sales` | Fact Table | Transactional data linked to all dimensions via Surrogate Keys |

---

## ✅ Data Quality & Validation

| # | Check | Description |
|---|-------|-------------|
| 1 | **Null Checks** | No Primary Keys or Surrogate Keys are null |
| 2 | **Referential Integrity** | Every sale links to a valid Customer and Product |
| 3 | **Business Logic** | Sales Amount is never negative |
| 4 | **Date Logic** | Product End Date is not earlier than Start Date |

---

## 🚀 How to Run

1. Run `scripts/Bronze_layer/BronzeLayerDDL.sql`
2. Run `scripts/Bronze_layer/BronzeLayer_stored_proc.sql`
3. Run `scripts/Silver_layer/SilverLayerDDL.sql`
4. Run `scripts/Silver_layer/SilverLayer_stored_proc.sql`
5. Run `scripts/Gold_Layer/GoldLayer.sql`
6. Run `scripts/Gold_Layer/DataQuality.sql`

---

## 📄 Documentation

Full project documentation is available in [`Docs/End-to-End_DWH_Documentation.pdf`](Docs/End-to-End_DWH_Documentation.pdf)
