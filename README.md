# Transaction Analytics Dashboard

**A comprehensive data analytics project leveraging SQL Server and Power BI to analyze transaction data, uncover behavioral patterns, and drive revenue insights.**

![Power BI Dashboard Preview](https://via.placeholder.com/800x400?text=Power+BI+Dashboard+Preview)  
*(Replace with actual dashboard screenshot in your repo)*

## Overview

This project demonstrates end-to-end data analytics capabilities by performing deep-dive analysis on transaction data using SQL Server and building an interactive Power BI dashboard. The goal was to transform raw transaction records into actionable business insights focused on overview metrics, customer transaction behavior, and revenue & fee performance.

Key deliverables:
- Advanced SQL queries for data exploration and preparation
- Interactive Power BI dashboard with **3 pages**: Overview, Transaction Behavior, and Revenue & Fee
- Professional PDF report and PowerPoint presentation for stakeholders

---

## Dataset

- **Source**: SQL Server database
- **Main Table**: `Transactions` (and related dimension tables)
- **Time Period**: Jan 2023 – May 2025
- **Key Columns**:
  - Transaction ID, TransactionDate, Amount, Fee, Customer ID, Transaction Type, Channel, ProductCategory, etc.

*Dataset is not included in this repository due to privacy/compliance reasons.*

---

## Tools Used

| Tool              | Purpose                              |
|-------------------|--------------------------------------|
| SQL Server        | Data querying, cleaning & analysis   |
| Power BI Desktop  | Dashboard development & visualization|
| Microsoft PowerPoint | Stakeholder presentation          |
| Excel / Word      | Supporting report                    |

---

## Project Steps

1. **Data Exploration & Deep Dive**
   - Connected to SQL Server
   - Wrote complex SQL queries (CTE, Window functions, Aggregations, Joins)
   - Analyzed transaction volume, trends, customer segmentation, and fee structures

2. **Data Modeling in Power BI**
   - Imported and transformed data using Power Query
   - Created a star schema data model with fact and dimension tables
   - Added DAX measures for key metrics (e.g., Total Revenue, Avg Transaction Value, Fee Ratio)

3. **Dashboard Development**
   - Built 3 interactive pages
   - Implemented slicers, drill-through, bookmarks, and tooltips

4. **Reporting & Presentation**
   - Compiled detailed insights into a professional PDF report
   - Created a concise PowerPoint presentation for executive review

---

## Key Insights

- **Overview**: Monthly transaction volume grew by X% YoY with peak activity in Q4.
- **Transaction Behavior**: Mobile channel dominates (XX% of volume). High-value customers show distinct patterns.
- **Revenue & Fee**: Fee optimization opportunity identified — reducing certain fees could increase volume by estimated Y%.
- Identified top-performing categories and underutilized customer segments.

*(Specific insights will be listed in the full report and dashboard.)*

---

## Dashboard Pages

### 1. Overview
- KPI cards (Total Revenue, Total Transactions, Active Customers, Avg Fee %)
- Trend charts (Monthly/Quarterly)
- Geographic or Channel distribution

### 2. Transaction Behavior
- Customer segmentation
- Behavioral patterns by time, channel, and type
- Cohort analysis and retention metrics

### 3. Revenue and Fee
- Revenue breakdown and trends
- Fee analysis and impact
- Profitability by segment/category

**Interactive features**: Cross-filtering, drill-down, dynamic date slicers.

---

## Results & Deliverables

- Fully interactive Power BI `.pbix` file
- SQL script folder with all analytical queries
- Comprehensive PDF report (20+ pages)
- Executive PowerPoint presentation (15 slides)
- Clear documentation of methodology and findings

**Business Impact**: Provided stakeholders with data-driven recommendations to optimize fees, improve customer experience, and increase revenue.

---

## How to Run / Reproduce

### Prerequisites
- SQL Server access (or restored backup)
- Power BI Desktop (latest version)
- Microsoft Office (for report & PPT)

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/transaction-analytics.git
