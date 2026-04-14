# Telecommunication-Growth-Strategies-Customer-Lifetime-Value-Segmentation-Analysis

## Business Problem

Despite operating in a competitive telecommunications market with a large and diverse customer base, the company faces critical challenges:
- Customer engagement strategies remain broad and inefficient
= Revenue growth from existing customers is not fully optimized
- Average Revenue Per User (ARPU) expansion opportunities through personalization and bundling are underutilized
- Up-selling and cross-selling efforts lack clear targeting
- Rich customer data exists, but there is no structured segmentation framework to convert insights into action
  
The absence of a data-driven Customer Lifetime Value (CLV) segmentation model limits the company’s ability to identify high-value customers, prioritize opportunities, and maximize revenue potential.

## Project Objectives
- Implement CLV segmentation to drive strategic revenue growth through targeted upselling and cross-selling initiatives.
- Identify high-opportunity customer segments to personalize offerings, optimize marketing efforts, and maximize ARPU.
- Enhance customer satisfaction, loyalty, and competitive advantage for sustainable, long-term profitability.

## Why CLV Segmentation?
Customer Lifetime Value (CLV) segmentation is a data-driven strategy that involves categorizing customers into distinct groups based on their potential long-term value to a company. CLV enables to identify high-value customer segments, personalize upsell and cross-sell offers, optimize resource allocation, increase revenue, and strengthen long-term customer loyalty.

## Tool(s)
PostgreSQL

## Data Sourcing and Cleaning
The dataset was provided in CSV format and contains 7,043 customer records with 14 attributes, dated from July 2023. The data was imported into PostgreSQL to facilitate structured querying, data cleaning, and subsequent analysis. The dataset underwent a structured validation process to ensure data quality and reliability by checking missing/Null values, duplicate Records, and numeric validation and categorical validation.

## Exploratory Data Analysis 
The analysis systematically examines customer size & retention, segment-level churn exposure, revenue distribution, usage intensity patterns, customer longevity, demographic behaviour drivers. This gives the foundation for CLV modelling, Customer segmentation and Upsell & retention strategy development.

## CLV Segmentation Analysis 
The following steps were used to analyze Customer Lifetime Value (CLV) segmentation for active customers.
- Defined Active Revenue Base: Focused on non-churned customers and established ARPU baseline.
- Calculated Lifetime Value: Estimated historical CLV using Monthly Bill × Tenure.
- Built CLV Score: Weighted revenue, tenure, usage behaviour, and premium plan status into a unified value metric.
- Applied Percentile Segmentation: Classified customers into High Value, Medium Value, Low Value, and Churn Risk tiers based on score distribution.
- Profiled & Validated Segments: Assessed revenue contribution, tenure depth, service adoption, demographic mix, and plan distribution across tiers.

## Key Insights

### Exploratory Analysis Insights
- Customer & Churn Overview - Total customers: 7,043, Active customers: 4,272, Churned customers: 2,771 (~39% churn rate). Churn is significant and represents a major revenue risk.
  
  <img width="777" height="254" alt="image" src="https://github.com/user-attachments/assets/f20068ee-d9f4-45f2-a1f6-4425d4f6818f" />

- Churn Patterns by Plan - Basic plans (Prepaid & Postpaid) show the highest churn rates (67.22% and 56.23%). Premium plans demonstrate significantly lower churn (12.01% and 19.74%). Premium customers are substantially more stable and retained.
  
<img width="999" height="442" alt="image" src="https://github.com/user-attachments/assets/d64a9852-2564-4846-8147-2a0205dc79da" />

- Revenue Contribution - Total revenue: $1.05M. Premium plans generate higher total revenue ($628K) than Basic plans ($426K). Revenue concentration is stronger among Premium subscribers.

<img width="912" height="406" alt="image" src="https://github.com/user-attachments/assets/0dd3a20f-2e08-4fb3-9112-9d917671b6aa" />

- Usage Behaviour - Premium users have higher average call duration by plan level. Prepaid users show higher average data usage by plan type. Basic plans show lower engagement. Usage intensity varies by plan structure, indicating monetization opportunities.

<img width="685" height="373" alt="image" src="https://github.com/user-attachments/assets/23c21f9f-9c26-4844-886e-300a69476683" />

- Tenure Patterns - Premium customers average 32 months tenure. Basic customers average 17 months tenure. Premium customers remain nearly twice as long.

<img width="708" height="296" alt="image" src="https://github.com/user-attachments/assets/32c6067a-0d1d-486f-a71e-fdfaaca32994" />


### CLV Segmentation Analysis Insights
- Segment Distribution: The Medium Value segment represents the largest portion of customers (1,495), followed by equal-sized Low Value and Churn Risk segments (1,068 each), while the High Value segment is the smallest (641) but strategically significant.

<img width="425" height="306" alt="image" src="https://github.com/user-attachments/assets/5b847a00-1b25-4295-994e-78eed8680ce7" />

- Revenue Impact: Medium Value customers generate the highest total revenue, High Value customers contribute substantial revenue despite smaller size, and the Churn Risk segment produces less than half the revenue of the Low Value group.

<img width="1036" height="323" alt="image" src="https://github.com/user-attachments/assets/65925d40-04fe-4c35-85a8-d723f58a543f" />

- Spending & Retention: Average monthly spending and tenure decline progressively from High Value to Churn Risk customers, with High and Medium segments averaging approximately 32 months of tenure compared to about 15 months for Churn Risk.

<img width="759" height="327" alt="image" src="https://github.com/user-attachments/assets/f1c70a62-0b23-448a-a3d9-01b30d73f7fa" />

- Service Engagement: Medium Value customers exhibit the highest adoption of Tech Support and Multiple Lines, whereas Churn Risk customers show the lowest engagement levels.

<img width="950" height="348" alt="image" src="https://github.com/user-attachments/assets/d2a9d0b0-dc06-4163-819e-f2bb0798dcf6" />

- Plan Concentration: High Value customers are entirely on no prepaid plans, Medium and Low Value segments are largely Premium Prepaid, and Churn Risk customers are concentrated in Basic plan tiers

<img width="822" height="703" alt="image" src="https://github.com/user-attachments/assets/b38dbf0b-45ea-40c2-bcd0-7c6f2d42b6fe" />


## Recommendation - Cross-selling and Upselling Opportunities
- Cross-Sell: Tech Support to Senior Citizens - Identified 115 senior customers (Low Value / Churn Risk) without tech support. Opportunity to increase engagement and reduce churn through service bundling.

<img width="602" height="337" alt="image" src="https://github.com/user-attachments/assets/3fbf1c77-b995-4092-bb41-452f87b75a9c" />

- Cross-Sell: Multiple Lines for Family Households. Identified 376 Basic-plan customers with dependents or partners but no multiple lines. Household bundling presents scalable ARPU expansion potential.

<img width="687" height="328" alt="image" src="https://github.com/user-attachments/assets/1da4a14e-dd5e-4be6-a6f9-e0b6866be2a8" />

- Upsell: Premium Upgrade for Churn Risk Customers Identified 753 Basic-plan customers in Churn Risk segment. Discounted Premium migration may improve retention and increase tenure.

<img width="768" height="275" alt="image" src="https://github.com/user-attachments/assets/28ca2826-da49-489c-a707-bf3d94ed57a4" />

- Upsell: High & Medium Value Basic Customers - Identified 160 high-spending Basic customers eligible for Premium upgrade. Premium transition can extend tenure and maximize lifetime value.

<img width="688" height="327" alt="image" src="https://github.com/user-attachments/assets/9bd5bb8e-80dc-4e88-bac1-298581a0fd8a" />

- Operationalization - Stored procedures were developed to automate campaign targeting, enabling scalable and repeatable execution of data-driven marketing initiatives.
  
  <img width="624" height="295" alt="image" src="https://github.com/user-attachments/assets/3e6fbbf6-982f-4787-b8ce-83075af30886" />


