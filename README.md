# Data Warehouse Sales Analytics - Customer & Product Reports

This repository contains SQL scripts to create views in the gold schema that generate detailed reports on customers and products based on sales data. These views help analyze customer behavior, product performance, and overall store health. Apart from that, the repository also contains part-to-whole analysis, data segmentation, cumulative sales analysis, and sales performance analysis.

## Views Overview
**1. gold.customer_report**
This view aggregates and summarizes key information about each customer’s purchasing behavior and store engagement.

Key Features:

- Customer details: customer key, number, name, and age.

- Purchase metrics: total orders, total sales amount, total quantity bought, total distinct products purchased.

- Engagement timeline: latest purchase date, total months visited.

- Customer segmentation:

    - VIP: customers with 12+ months visiting and over $5000 total spending.

    - Long-term Customer: 12+ months visiting but ≤ $5000 spending.

    - New Customer: less than 12 months visiting.

Additional insights:

- Months since last purchase

- Average order value.

- Average monthly spending.

**2. gold.product_report**
This view provides a comprehensive summary of each product’s sales performance and customer reach.

Key Features:

- Product details: product key, name, category, subcategory, and cost.

- Sales timeline: first and last sale dates, total months the product was sold.

- Performance metrics:

    - Total orders containing the product.

    - Total customers who bought the product.

    - Total sales amount and quantity sold.

    - Average selling price per unit.

    - Average monthly sales.

- Product performance categories:

    - High-Performer: total sales > $50,000.

    - Mid-Performer: total sales between $10,000 and $50,000.

    - Low-Performer: total sales < $10,000.
