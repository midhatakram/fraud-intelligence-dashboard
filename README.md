# 💳 Credit Card Fraud Intelligence Dashboard

**SQL Server + Power BI | Transaction Risk Analysis & Fraud Detection**

---

## 📌 Executive Summary

This project analyzes **1,296,675 financial transactions** to identify fraud patterns, quantify financial exposure, and develop a **rule-based framework for prioritizing high-risk transactions**.

Using **SQL Server for data preparation and analysis** and **Power BI for visualization**, the analysis examines transaction behavior, risk signals, velocity, spending deviations, customer and card patterns, merchant categories, and geographic activity.

The analysis identified an overall fraud rate of **0.58%**, representing approximately **$3.99M in fraudulent transaction value**. The strongest finding was the compounding effect of behavioral risk signals: fraud rate increased from **0.11% with no risk signals to 88.16% when five signals were present**.

The final solution is a **four-page interactive Fraud Intelligence Dashboard** designed to support fraud monitoring, investigation prioritization, and data-driven decision-making.

---

## 🎯 Business Problem & Objectives

Fraud can be difficult to identify using transaction volume or individual indicators alone. A transaction may appear normal based on one metric but become significantly riskier when multiple unusual behaviors occur simultaneously.

### **Project Objectives**

* Identify behavioral patterns associated with fraudulent transactions.
* Quantify fraud rates and financial exposure.
* Develop a **transaction-level risk assessment framework**.
* Analyze transaction velocity, spending deviations, and historical behavior.
* Identify high-risk cards, customers, categories, merchants, and locations.
* Support investigation teams in prioritizing elevated-risk transactions.

---

## 📊 Data Overview

The public Kaggle dataset contains **1,296,675 simulated financial transactions** covering transaction, customer, merchant, and geographic behavior.

### **Key Attributes**

* Transaction and card identifiers
* Date, time, and transaction amount
* Merchant and transaction category
* Customer and geographic information
* Historical transaction behavior
* Fraud status

---

## 🧹 Data Preparation

**SQL Server** was used to clean, structure, and prepare the data for analysis.

### **Key Steps**

* Removed duplicate records
* Validated and standardized data
* Handled data quality issues
* Engineered transaction-level analytical features
* Created reusable SQL views for fraud analysis

The resulting dataset was used as the source for **Power BI reporting and dashboard development**.

---

## 🔬 Methodology & Risk Framework

The analysis evaluated fraud using multiple **transaction-level and behavioral indicators** rather than relying on a single metric.

### **Key Analytical Areas**

* Transaction velocity
* Previous transaction activity
* Time since previous transaction
* Historical spending behavior
* Amount deviation from historical patterns
* Transactions exceeding previous spending levels
* Time-based risk patterns

These indicators were combined into a **rule-based Fraud Risk Score**, with transactions classified into four tiers:

**Low Risk → Medium Risk → High Risk → Critical Risk**

---

## ⚠️ Risk Signals

A key objective was to determine whether multiple behavioral indicators could help differentiate higher-risk transactions.

The strongest pattern identified was that **fraud risk increased dramatically as multiple risk signals occurred simultaneously**.

### **Key Finding: Risk Signals Compound**

| **Risk Signals** | **Fraud Rate** |
| ---------------: | -------------: |
|                0 |      **0.11%** |
|                5 |     **88.16%** |

Fraud rate increased from **0.11% to 88.16%** when moving from transactions with zero risk signals to five simultaneous risk signals.

> **This suggests that evaluating behavioral signals collectively can provide stronger risk prioritization than relying on individual indicators alone.**

---

## 📈 Key Findings

### 🚨 Overall Fraud Exposure

* **Total Transactions:** 1,296,675
* **Overall Fraud Rate:** 0.58%
* **Fraudulent Transaction Value:** **$3.99M**

Although fraudulent transactions represented a small proportion of total volume, they resulted in significant financial exposure.

---

### ⚠️ Risk Tiers Strongly Differentiated Fraud

| **Risk Level** | **Transactions** | **Fraud Transactions** | **Fraud Rate** | **Fraud Value** |
| -------------- | ---------------: | ---------------------: | -------------: | --------------: |
| **Critical**   |            1,922 |                  1,008 |     **52.45%** |        $947.94K |
| **High**       |           65,156 |                  4,256 |      **6.53%** |      **$2.67M** |
| **Medium**     |          496,005 |                  1,895 |      **0.38%** |        $325.79K |
| **Low**        |          733,592 |                    347 |      **0.05%** |         $45.92K |

**Critical-risk transactions had the highest fraud rate**, while the **High-Risk segment contributed the largest fraudulent transaction value**.

---

### 🔥 Behavioral Risk Signals

Fraud rate increased from **0.11% → 88.16%** as the number of simultaneous risk signals increased from zero to five.

This was the **strongest relationship identified in the analysis**, highlighting the importance of evaluating behavioral anomalies collectively.

---

### 💳 Fraud Exposure Across Segments

The analysis identified differences in fraud exposure across:

* **Risk levels**
* **Cards**
* **Customer characteristics**
* **Job categories**
* **Transaction categories**
* **Merchants**
* **Geographic locations**

These patterns can help focus investigation resources on areas with disproportionately elevated fraud risk.

---

### 🛒 Category-Level Fraud Patterns

Higher fraud rates were observed in:

* `shopping_net`
* `misc_net`
* `grocery_pos`

These categories represent potential priority areas for additional monitoring and investigation.

---

## 📊 Power BI Dashboard

The final solution consists of **four interactive Power BI dashboard pages**, each focusing on a different aspect of fraud intelligence.

### **Page 1 — Fraud Intelligence Overview**

Provides executive-level visibility into:

* Total transactions
* Fraud transactions
* Fraud rate
* Fraud value
* Fraud trends
* Fraud by category
* Fraud patterns by time

### **Page 2 — Risk & Behavioral Signals**

Analyzes:

* Risk level distribution
* Fraud rate by risk level
* Number of risk signals
* Transaction velocity
* Amount deviation
* Time-based risk patterns

### **Page 3 — Card & Customer Risk**

Examines:

* Cards by risk level
* Fraud exposure
* Top cards by fraud transactions
* Fraud value by risk segment
* Job categories with higher fraud rates

### **Page 4 — Merchant, Category & Geographic Analysis**

Identifies fraud concentration across:

* Transaction categories
* Merchants
* Geographic locations
* Fraud value
* Fraud rate

---

## 💡 Recommendations

### **1. Prioritize Transactions With Multiple Risk Signals**

Transactions with several simultaneous behavioral risk indicators should be prioritized for investigation.

Transactions with **five risk signals reached an 88.16% fraud rate**, making combined signals a strong investigation-prioritization indicator.

### **2. Apply Tiered Investigation Workflows**

Use risk levels to allocate investigation resources according to risk severity:

* **Critical:** Immediate investigation or transaction review
* **High:** Prioritized monitoring and investigation
* **Medium:** Additional verification or monitoring
* **Low:** Standard monitoring

### **3. Monitor High-Risk Categories**

Give additional attention to categories such as:

* `shopping_net`
* `misc_net`
* `grocery_pos`

### **4. Combine Behavioral Indicators**

Evaluate **transaction velocity, spending deviation, historical behavior, and time-based patterns** collectively rather than relying on a single indicator.

### **5. Focus Resources on Elevated-Risk Segments**

Prioritize high-risk **cards, merchants, categories, and geographic areas** to improve investigation efficiency.

---

## ⚠️ Limitations

* The analysis is based on **historical labeled transaction data** and is not a production fraud detection system.
* The risk score is a **rule-based analytical framework**, not a machine-learning model.
* Risk thresholds require further validation before operational deployment.
* The analysis identifies **associations with fraud but does not establish causality**.
* Real-world fraud detection systems would require continuous validation and adaptation to changing fraud patterns.

---

## 🛠️ Tools & Technologies

### **SQL Server / SSMS**

* Data Cleaning & Preparation
* Feature Engineering
* Fraud & Risk Analysis
* Analytical SQL Views

### **Power BI**

* Data Modeling
* DAX Measures
* KPI Monitoring
* Interactive Visualizations
* Fraud Intelligence Dashboard Development

---

## 🏁 Conclusion

This project demonstrates how **SQL Server and Power BI** can transform transaction data into actionable fraud intelligence.

Rather than focusing only on overall fraud volume, the analysis examined **behavioral signals, transaction velocity, spending deviations, risk tiers, customer and card patterns, merchant categories, and geographic activity**.

The strongest finding was the sharp increase in fraud rate from **0.11% with no risk signals to 88.16% with five simultaneous signals**.

The resulting framework provides a structured approach for identifying and prioritizing elevated-risk transactions and demonstrates how **data analytics can support more informed fraud monitoring and investigation decisions**.

---

## 👤 Author

**Midhat Akram**

**Data Analyst | SQL | Power BI | Business Intelligence**

