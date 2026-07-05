


DROP TABLE IF EXISTS FINAL;

CREATE TABLE  FINAL(
    order_id VARCHAR(20) PRIMARY KEY,

    year INT,
    month INT,
    quarter VARCHAR(5),

    is_weekend_order VARCHAR(5),

    platform VARCHAR(20),
    country VARCHAR(50),

    customer_segment VARCHAR(30),
    customer_age_group VARCHAR(20),
    customer_gender VARCHAR(15),

    acquisition_channel VARCHAR(30),
    device_used VARCHAR(20),

    product_category VARCHAR(50),

    unit_price_usd NUMERIC(10,2),
    quantity_ordered INT,

    order_value_usd NUMERIC(12,2),
    discount_pct INT,
    discount_amount_usd NUMERIC(10,2),
    final_amount_usd NUMERIC(12,2),

    shipping_cost_usd NUMERIC(10,2),
    tax_amount_usd NUMERIC(10,2),
    total_paid_usd NUMERIC(12,2),

    payment_method VARCHAR(30),
    shipping_method VARCHAR(30),

    delivery_days INT,
    product_rating INT,

    review_submitted VARCHAR(5),
    returned VARCHAR(5),
    return_reason VARCHAR(50),

    customer_satisfaction VARCHAR(20),

    session_duration_minutes NUMERIC(6,2),
    pages_viewed INT,

    cart_abandoned_before VARCHAR(5),
    wishlist_used VARCHAR(5),
    coupon_used VARCHAR(5),
    subscription_member VARCHAR(5),

    repeat_purchase_count INT,
    loyalty_points INT
);

SELECT * FROM FINAL;
SELECT COUNT(*) FROM final;

---Basic Analysis
--Total Orders
SELECT COUNT(Order_id)
FROM FINAL;

--Total Revenue
SELECT SUM(final_amount_usd) AS Total_Revenue
FROM FINAL;

--Average Order Value
SELECT AVG(order_value_usd)
FROM FINAL;
--Average Discount
SELECT AVG(discount_amount_usd)
FROM FINAL;
--Average Delivery Time
SELECT AVG(delivery_days)
FROM FINAL;
--Total Tax Collected
SELECT SUM(tax_amount_usd)
FROM FINAL;

---Sales Analysis

--Revenue by Year
SELECT  Year, SUM(final_amount_usd
) AS Total_Revenue
FROM FINAL
GROUP BY YEAR
ORDER BY YEAR;
--Revenue by Month
SELECT  MONTH, SUM(final_amount_usd
) AS Total_Revenue
FROM FINAL
GROUP BY MONTH
ORDER BY MONTH;
--Revenue by Quarter
--Revenue by Product Category
SELECT  product_category
, SUM(final_amount_usd
) AS Total_Revenue
FROM FINAL
GROUP BY product_category
ORDER BY product_category;
--Revenue by Country
SELECT  Country, SUM(final_amount_usd
) AS Total_Revenue
FROM FINAL
GROUP BY product_categor
ORDER BY product_category;
--Revenue by Platform
SELECT  platform, SUM(final_amount_usd
) AS Total_Revenue
FROM FINAL
GROUP BY Platform
ORDER BY Platform;
---Customer Analysis
--Customer Segment Distribution
SELECT Customer_Segment, COUNT(*) AS Customer_Count
FROM FINAL
GROUP BY Customer_Segment
ORDER BY Customer_Count DE
--Revenue by Country
SELECT
    country,
    SUM(total_paid_usd) AS revenue
FROM FINAL
GROUP BY country
ORDER BY revenue DESC;
--Revenue by Category
SELECT
    product_category,
    SUM(total_paid_usd) AS revenue
FROM ecommerce_sales
GROUP BY product_category
ORDER BY revenue DESC;
--Revenue by Platform
SELECT
    platform,
    SUM(total_paid_usd) AS revenue
FROM ecommerce_sales
GROUP BY platform
ORDER BY revenue DESC;
--Revenue by Payment Method
SELECT
    payment_method,
    SUM(total_paid_usd) AS revenue
FROM ecommerce_sales
GROUP BY payment_method
ORDER BY revenue DESC;
--Revenue by Shipping Method
SELECT
    shipping_method,
    SUM(total_paid_usd) AS revenue
FROM ecommerce_sales
GROUP BY shipping_method
ORDER BY revenue DESC;
--Revenue by Acquisition Channel
SELECT
    acquisition_channel,
    SUM(total_paid_usd) AS revenue
FROM ecommerce_sales
GROUP BY acquisition_channel
ORDER BY revenue DESC;
--Top 10 Highest Spending Customers
SELECT order_id,
       total_paid_usd
FROM FINAL
ORDER BY total_paid_usd DESC
LIMIT 10;
-- Rank Product Categories by Revenue (RANK)
SELECT
    product_category,
    SUM(total_paid_usd) AS revenue,
    RANK() OVER(ORDER BY SUM(total_paid_usd) DESC) AS category_rank
FROM FINAL
GROUP BY product_category;
-- Dense Rank Countries by Sales
SELECT
    country,
    SUM(total_paid_usd) AS revenue,
    DENSE_RANK() OVER(ORDER BY SUM(total_paid_usd) DESC) AS rank
FROM FINAL
GROUP BY country;
-- Running Monthly Revenue
SELECT
    year,
    month,
    SUM(total_paid_usd) AS monthly_sales,

    SUM(SUM(total_paid_usd))
    OVER(ORDER BY year, month) AS running_total
FROM FINAL
GROUP BY year, month
ORDER BY year, month;
-- Previous Month Revenue (LAG)
WITH monthly_sales AS
(
SELECT
year,
month,
SUM(total_paid_usd) revenue
FROM FINAL
GROUP BY year,month
)

SELECT *,
LAG(revenue) OVER(ORDER BY year,month) previous_month
FROM monthly_sales;
-- Month-over-Month Growth %
WITH sales AS
(
SELECT
year,
month,
SUM(total_paid_usd) revenue
FROM FINAL
GROUP BY year,month
)

SELECT *,
ROUND(
(revenue-LAG(revenue) OVER(ORDER BY year,month))
/
LAG(revenue) OVER(ORDER BY year,month)
*100,2)
AS growth_percentage
FROM sales;
-- Revenue Contribution of Each Country
SELECT
country,
SUM(total_paid_usd) revenue,

ROUND(

SUM(total_paid_usd)

/

SUM(SUM(total_paid_usd)) OVER()

*100,2)

AS contribution
FROM FINAL
GROUP BY country;
-- Highest Revenue Category in Every Country
WITH cte AS
(
SELECT
country,
product_category,
SUM(total_paid_usd) revenue,

ROW_NUMBER()
OVER(PARTITION BY country ORDER BY SUM(total_paid_usd) DESC) rn

FROM FINAL

GROUP BY country,product_category
)

SELECT *
FROM cte
WHERE rn=1;
-- Average Order Value by Platform
SELECT
platform,
ROUND(AVG(total_paid_usd),2)
FROM FINAL
GROUP BY platform;
-- Customer Satisfaction Classification
SELECT

customer_satisfaction,

CASE

WHEN customer_satisfaction='Excellent'
THEN 'Happy'

WHEN customer_satisfaction='Good'
THEN 'Satisfied'

ELSE 'Needs Improvement'

END AS category

FROM FINAL;
 Return Rate by Category
SELECT

product_category,

ROUND(

100.0*

SUM(CASE WHEN returned='Yes' THEN 1 ELSE 0 END)

/

COUNT(*)

,2)

AS return_rate

FROM FINAL

GROUP BY product_category;
-- Platform with Highest Average Rating
SELECT
platform,
ROUND(AVG(product_rating),2) rating
FROM FINAL
GROUP BY platform
ORDER BY rating DESC;
-- Top 5 Countries by Revenue
SELECT

country,

SUM(total_paid_usd) revenue

FROM FINAL

GROUP BY country

ORDER BY revenue DESC

LIMIT 5;
-- Most Preferred Payment Method
SELECT

payment_method,

COUNT(*) total_orders

FROM FINAL

GROUP BY payment_method

ORDER BY total_orders DESC;
-- Repeat Customers Spending More Than Average
SELECT *

FROM FINAL

WHERE repeat_purchase_count>

(

SELECT AVG(repeat_purchase_count)

FROM FINAL

);
-- Customers Receiving Highest Discount
SELECT *

FROM FINAL

ORDER BY discount_amount_usd DESC

LIMIT 10;
-- Average Delivery Time by Shipping Method
SELECT

shipping_method,

ROUND(AVG(delivery_days),2)

FROM FINAL

GROUP BY shipping_method;
-- Best Acquisition Channel
SELECT

acquisition_channel,

SUM(total_paid_usd) revenue

FROM ecommerce_sales

GROUP BY acquisition_channel

ORDER BY revenue DESC;
-- Revenue by Quarter
SELECT

quarter,

SUM(total_paid_usd)

FROM FINAL

GROUP BY quarter

ORDER BY quarter;
-- Revenue by Customer Segment
SELECT

customer_segment,

SUM(total_paid_usd)

FROM FINAL

GROUP BY customer_segment

ORDER BY SUM(total_paid_usd) DESC;
-- Create a Sales View
CREATE VIEW sales_summary AS

SELECT

country,

SUM(total_paid_usd) revenue,

COUNT(*) orders,

AVG(total_paid_usd) avg_order

FROM FINAL

GROUP BY country;
-- Top Product Category in Each Platform
WITH cte AS

(

SELECT

platform,

product_category,

SUM(total_paid_usd) revenue,

ROW_NUMBER()

OVER(PARTITION BY platform ORDER BY SUM(total_paid_usd) DESC)

rn

FROM FINAL

GROUP BY platform,product_category

)

SELECT *

FROM cte

WHERE rn=1;
-- Customers Above Overall Average Spending
SELECT *

FROM FINAL

WHERE total_paid_usd >

(

SELECT AVG(total_paid_usd)

FROM FINAL

);
-- NTILE Analysis (Customer Spending Quartiles)
SELECT

order_id,

total_paid_usd,

NTILE(4)

OVER(ORDER BY total_paid_usd DESC)

AS spending_quartile

FROM FINAL;
--Find the Highest Order in Each Country
SELECT *

FROM

(

SELECT *,

ROW_NUMBER()

OVER(PARTITION BY country ORDER BY total_paid_usd DESC)

rn

FROM FINAL

)t

WHERE rn=1;