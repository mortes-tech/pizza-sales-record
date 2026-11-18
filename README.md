# 🍕 Pizza Sales Record Dashboard

A Power BI dashboard that turns raw pizza sales data into simple KPIs and charts, so a business can quickly see **how much it sells, when it sells, and what sells best**.

- **Tool:** Power BI (`pizza_sale_record_dashboard.pbix`)
- **Data source:** `pizza_sales` table, queried with SQL Server (T-SQL)

---
<a href="https://github.com/user-attachments/assets/bcfdda87-f70b-42e7-968f-4882f3fe49b4">
  <img width="1611" height="852" alt="Screenshot 2026-11-19 004754" src="https://github.com/user-attachments/assets/bcfdda87-f70b-42e7-968f-4882f3fe49b4" />
</a>

## 📊 KPIs

| KPI | What it means | Value |
|---|---|---|
| **Total Revenue** | Sum of the total price of all pizza orders | ≈ $817,860 |
| **Average Order Value** | Average money spent per order (Total Revenue ÷ Total Orders) | $38.31 |
| **Total Pizzas Sold** | Sum of the quantity of all pizzas sold | 49,574 |
| **Total Orders** | Number of orders placed | 21,350 |
| **Avg. Pizzas per Order** | Pizzas sold ÷ orders | 2.32 |

> Total Revenue is calculated as Average Order Value × Total Orders.

---

## 📈 Charts

### 1. Daily Trend for Total Orders (Bar chart)
Shows how many orders come in on each day of the week, so you can spot busy and slow days.

![Daily trend](images/daily_trend.png)

**Insight:** Friday is the busiest day (3,538 orders). Sunday is the slowest (2,624).

### 2. Monthly Trend for Total Orders (Area/Line chart)
Shows how order volume changes across the year and helps find peak periods. *(The same chart can be switched to an hourly view to find peak hours of the day.)*

![Monthly trend](images/monthly_trend.png)

**Insight:** July is the peak month (1,935 orders). October is the lowest (1,646).

### 3. Percentage of Sales by Pizza Category (Donut chart)
Shows how much each category (Classic, Supreme, Veggie, Chicken) contributes to sales.

![Sales by category](images/sales_by_category.png)

**Insight:** Classic leads at 26.7%, but all four categories are close.

### 4. Percentage of Sales by Pizza Size (Donut chart)
Shows which pizza sizes bring in the most sales.

![Sales by size](images/sales_by_size.png)

**Insight:** Large (L) pizzas bring the most sales, followed by Medium and Small. XL and XXL are very small.

### 5. Top 5 Best Sellers (Bar charts)
Shows the 5 best-selling pizzas by revenue, quantity and number of orders.

![Top 5 best sellers](images/top5_bestsellers.png)

**Insight:** The Thai Chicken Pizza earns the most revenue, while The Classic Deluxe Pizza sells the most units and appears in the most orders.

---

## 🧾 SQL Queries

<details>
<summary>KPI queries</summary>

```sql
-- Total Revenue
SELECT SUM(total_price) AS total_revenue FROM pizza_sales;

-- Average Order Value
SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_order_value FROM pizza_sales;

-- Total Pizzas Sold
SELECT SUM(quantity) AS Total_pizza_sold FROM pizza_sales;

-- Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_order FROM pizza_sales;

-- Average Pizzas per Order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) /
       CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2)) AS Avg_pizzas_per_order
FROM pizza_sales;
```
</details>

<details>
<summary>Chart queries</summary>

```sql
-- Daily trend
SELECT DATENAME(DW, order_date) AS order_day, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales GROUP BY DATENAME(DW, order_date);

-- Monthly trend
SELECT DATENAME(MONTH, order_date) AS Month_Name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales GROUP BY DATENAME(MONTH, order_date) ORDER BY Total_Orders DESC;

-- Sales % by category (January shown; remove the WHERE to see the full year)
SELECT pizza_category, SUM(total_price) AS Total_sales,
       SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales WHERE MONTH(order_date) = 1) AS Total_revenue
FROM pizza_sales WHERE MONTH(order_date) = 1 GROUP BY pizza_category;

-- Sales % by size (Q1 shown; remove the WHERE to see the full year)
SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_sales,
       CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS Total_revenue
FROM pizza_sales WHERE DATEPART(quarter, order_date) = 1
GROUP BY pizza_size ORDER BY Total_revenue DESC;

-- Top 5 by revenue
SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales GROUP BY pizza_name ORDER BY Total_Revenue DESC;

-- Top 5 by quantity
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Quantity
FROM pizza_sales GROUP BY pizza_name ORDER BY Total_Quantity DESC;

-- Top 5 by total orders
SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Order
FROM pizza_sales GROUP BY pizza_name ORDER BY Total_Order DESC;
```
</details>

---

## ✅ Why It Is Useful
- See business performance at a glance.
- Plan staff and stock for busy days and months.
- Know which pizzas to promote and which sizes and categories sell best.
- Make decisions from data instead of guesses.
