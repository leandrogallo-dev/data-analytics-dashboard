# 📊 Data Analytics Dashboard - Gold Layer Project

[![SQL Server](https://img.shields.io/badge/SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)](https://www.microsoft.com/sql-server)
[![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=power-bi&logoColor=black)](https://powerbi.microsoft.com/)
[![Database Architecture](https://img.shields.io/badge/Architecture-Medallion_Gold-gold?style=for-the-badge)](https://learn.microsoft.com/en-us/azure/databricks/lakehouse/medallion)
![Business Intelligence](https://img.shields.io/badge/Business-Intelligence-purple?style=for-the-badge)
![GitHub](https://img.shields.io/badge/GitHub-Project-black?style=for-the-badge&logo=github)

## 📝 Project Description
This project showcases the end-to-end development of a Business Intelligence ecosystem, focused on the Gold Layer (Business Layer) architecture. By transforming raw transactional data into high-performance analytical views, I engineered a robust foundation for strategic decision-making. The project concludes with an interactive dashboard that translates complex SQL logic into actionable insights regarding sales growth, product lifecycles, and customer demographics.

> **View the final result:** > ![Dashboard Preview](dashboard/dashboard-preview.png)

---

## 🚀 Technical Features (SQL)
The engine of this project lies in the business logic implemented via SQL Server. Advanced views were created to automatic key metrics:
* **Year-Over-Year (YoY) Performance:** Utilization of window functions (LAG, OVER) to calculate annual growth per product.
* **Cumulative Analysis:** Implementation of Running Totals and Moving Averages to identify long-term sales trends.
* **Data Segmentation:** Dynamic classification of products by cost ranges and customers by geographic location.
* **Participation Metrics:** "Part-to-Whole" calculations to determine the revenue impact of each product category.

---

## 📂 View Structure (Gold Layer)
The main script generates the following logical tables:

| Vista | Propósito Analítico |
| :--- | :--- |
| `gold.cumulative_analysis` | Historical trends and monthly cumulative totals. |
| `gold.performance_analysis` | Comparison of current sales vs. average and previous year. |
| `gold.part_to_analysis` | Contribution percentage by product category. |
| `gold.data_segmentation` | Inventory grouping by cost ranges. |
| `gold.customers_country` | Demographic distribution of the customer base. |

---

## 📈 Dashboard Insights
Based on the integration of SQL views with the visualization tool:
1.  **Category Dominance:** Bikes accounted for 96.46% of total sales, identifying them as the primary business driver.
2.  **Temporary Growth:** A significant peak in sales and customer acquisition is observed between 2013 and 2014.
3.  **Cost Efficiency:** 37.29% of products sold fall within the "Below 100" range, suggesting high sales volume for entry-level products.
4.  **Global Distribution:** North America stands out as the market with the highest customer density.

---

## 🛠️ Installation and Usage
1. **Clone the repository:**
   ```bash
      git clone https://github.com/leandrogallo-dev/data-analytics-dashboard.git
   ```
   
---

# 📂 Repository Structure

```
sanoyfresco-sales-analytics
│
├── dashboard/ # dashboard from power BI
├── datasets/  # Dataset used for the analysis
├── scripts/   # SQL scripts with analytical queries
│
├── docs/      # Project documentation
│
├── README.md  # Project documentation
└── LICENSE
```

---

## 🛡️ License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.

---

# 👨‍💻 About Me

Hi! I'm **Leandro Gallo**, a **Systems Engineering student** from Argentina with a strong interest in:

- Data Engineering
- Data Analytics
- Backend Development
- Cybersecurity
- Software Development

I enjoy building **data pipelines, automation tools, and data-driven systems**, and I am currently developing projects to strengthen my skills in **data architecture, SQL development, and analytics**.

This repository is part of my **technical portfolio**, where I showcase projects related to:

- Data Warehousing
- ETL Pipelines
- Data Modeling
- Analytics

---

# 🔗 Connect With Me

📧 Email  
leandrogallo698@gmail.com

