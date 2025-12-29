# Gold Layer Data Catalog

## Overview

The Gold Layer contains **business-ready data** used for reporting, dashboards, and analysis.
It is built from the Silver layer and follows a **dimensional model**, using:

* **Dimension tables** for descriptive data
* **Fact tables** for measurable business events

## 1. gold.dim_customers
Stores cleaned and enriched customer information.
This table is mainly used to analyze customers by demographics and location.

| Column Name     | Data Type    | Description                                                       |
| --------------- | ------------ | ----------------------------------------------------------------- |
| customer_key    | INT          | Surrogate key used internally to uniquely identify each customer. |
| customer_id     | INT          | Original customer ID from the source system.                      |
| customer_number | NVARCHAR(50) | Business identifier used to reference customers.                  |
| first_name      | NVARCHAR(50) | Customer’s first name.                                            |
| last_name       | NVARCHAR(50) | Customer’s last name.                                             |
| country         | NVARCHAR(50) | Country where the customer lives.                                 |
| marital_status  | NVARCHAR(50) | Customer’s marital status (e.g. Married, Single).                 |
| gender          | NVARCHAR(50) | Customer’s gender (e.g. Male, Female, Unknown).                   |
| birthdate       | DATE         | Customer’s date of birth (YYYY-MM-DD).                            |
| create_date     | DATE         | Date when the customer record was created.                        |

## 2. gold.dim_products
Stores product details and classification information.
Used to analyze sales by product, category, and product line.

| Column Name          | Data Type    | Description                                             |
| -------------------- | ------------ | ------------------------------------------------------- |
| product_key          | INT          | Surrogate key used internally to identify each product. |
| product_id           | INT          | Original product ID from the source system.             |
| product_number       | NVARCHAR(50) | Business product code used for tracking and reporting.  |
| product_name         | NVARCHAR(50) | Name of the product.                                    |
| category_id          | NVARCHAR(50) | Identifier for the product category.                    |
| category             | NVARCHAR(50) | High-level product category (e.g. Bikes, Components).   |
| subcategory          | NVARCHAR(50) | Detailed classification within the category.            |
| maintenance_required | NVARCHAR(50) | Indicates whether the product requires maintenance.     |
| cost                 | INT          | Base cost of the product.                               |
| product_line         | NVARCHAR(50) | Product line or series (e.g. Road, Mountain).           |
| start_date           | DATE         | Date when the product became available.                 |

## 3. gold.fact_sales
Stores sales transactions at order line level.
This table is used to calculate revenue, quantities sold, and sales trends.

| Column Name   | Data Type    | Description                                         |
| ------------- | ------------ | --------------------------------------------------- |
| order_number  | NVARCHAR(50) | Unique identifier for each sales order.             |
| product_key   | INT          | References the related product in `dim_products`.   |
| customer_key  | INT          | References the related customer in `dim_customers`. |
| order_date    | DATE         | Date when the order was placed.                     |
| shipping_date | DATE         | Date when the order was shipped.                    |
| due_date      | DATE         | Date when payment is due.                           |
| sales_amount  | INT          | Total sales value for the order line.               |
| quantity      | INT          | Number of units sold.                               |
| price         | INT          | Price per unit.                                     |

  
