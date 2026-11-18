SELECT * FROM pizza_sales

--kpi
--Total revenue
SELECT SUM(total_price) as total_revenue from pizza_sales
--Average order value
SELECT SUM(total_price) / COUNT(DISTINCT order_id) as Avg_oder_value FROM pizza_sales
--Total pizza sales
SELECT SUM(quantity) AS Total_pizza_sold from pizza_sales
--Total order
SELECT COUNT(DISTINCT order_id) as Total_order from pizza_sales
--Average pizza per order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2)) as Avg_pizzas_per_order 
from pizza_sales

--Chart query
--Daily trend for total order
SELECT DATENAME(DW, order_date) as order_day, COUNT(DISTINCT order_id) as Total_Order
from pizza_sales
GROUP BY DATENAME(DW, order_date)
--Hourly trend for total order
SELECT DATENAME(MONTH, order_date) as Month_Name, COUNT(DISTINCT order_id) as Total_Orders
from pizza_sales
GROUP BY DATENAME(MONTH, order_date)
ORDER BY Total_Orders DESC
--percentage of sales by pizza category
SELECT pizza_category,sum(total_price) as Total_sales, sum(total_price) * 100 / (SELECT sum(total_price) from pizza_sales WHERE MONTH(order_date) = 1) as Total_revenue
from pizza_sales
WHERE MONTH(order_date) = 1
GROUP BY pizza_category
--percentage of sale by pizza size
SELECT pizza_size,CAST(sum(total_price)AS DECIMAL(10,2)) as Total_sales, CAST(sum(total_price) * 100 / (SELECT sum(total_price) from pizza_sales)AS DECIMAL(10,2)) as Total_revenue
from pizza_sales
WHERE DATEPART(quarter, order_date) = 1
GROUP BY pizza_size
ORDER BY Total_revenue DESC
--Top 5 best seller by revenue
SELECT Top 5 pizza_name, SUM(total_price) as Total_Revenue FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
--quantity
SELECT Top 5 pizza_name, SUM(quantity) as Total_Quantity FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity DESC
--Total order
SELECT Top 5 pizza_name, COUNT(DISTINCT order_id) as Total_Order 
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Order DESC