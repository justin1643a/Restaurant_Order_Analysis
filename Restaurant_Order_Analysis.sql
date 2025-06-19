-- Set default database

USE restaurant_db;

-- Find the number of items on the menu

SELECT 
COUNT(*)
FROM menu_items;

-- What are the least and most expensive items on the menu?

SELECT *
FROM menu_items
ORDER BY price DESC; -- Most expensive

SELECT *
FROM menu_items
ORDER BY price ASC; -- Least expensive

-- How many Italian dishes are on the menu? 

SELECT
COUNT(*)
FROM menu_items
WHERE category = 'italian';


-- What are the least and most expensive Italian dishes on the menu?

SELECT
item_name,
price
FROM menu_items
WHERE category = 'italian'
ORDER BY price DESC;

-- How many dishes are in each category? 

SELECT 
category,
COUNT(menu_item_id) AS number_of_dishes
FROM menu_items
GROUP BY category;

-- What is the average dish price within each category?

SELECT 
category,
AVG(price) as average_dish_price
FROM menu_items
GROUP BY category;

-- View the order_details table. What is the date range of the table?

SELECT 
MIN(order_date),
MAX(order_date)
FROM order_details;

-- How many orders were made within this date range? How many items were ordered within this date range?

SELECT 
COUNT(distinct order_id) AS count_of_orders
FROM order_details;

-- Which orders had the most number of items?

SELECT 
order_id,
COUNT(item_id) AS number_of_items
FROM order_details
GROUP by order_id
ORDER BY number_of_items DESC;

/* How many orders had more than 12 items?
 Using sub query to define statement as a table comes up with the count */

SELECT COUNT(*) 
FROM
	(SELECT  -- Using () to wrap query enables statement to be used as a table reference
	order_id,
	COUNT(item_id) AS number_of_items
	FROM order_details
	GROUP by order_id
	HAVING number_of_items > 12) AS num_orders;
    

-- Combine the menu_items and order_details tables into a single table
/*
od = order_details 
mi = menu_items
*/ 

SELECT *
FROM order_details od -- using transactional table as main reference. Use od as alias to shorten queries
LEFT JOIN menu_items mi  -- Use mi as alias to shorten queries
	ON menu_item_id = item_id;
    

-- What were the least and most ordered items? What categories were they in?
-- order_details_id	= Unique ID of an item in an order

SELECT 
item_name,
COUNT(order_details_id) AS ordered_items -- Count of (Unique ID of an item in an order) 
FROM order_details od 
LEFT JOIN menu_items mi 
	ON menu_item_id = item_id
GROUP by item_name;

-- What were the top 5 orders that spent the most money?

SELECT 
order_id,
SUM(price) AS total_dollars
FROM order_details od 
LEFT JOIN menu_items mi 
	ON menu_item_id = item_id
GROUP BY order_id
ORDER BY total_dollars DESC
LIMIT 5;

-- View the details of the highest spend order. Which specific items were purchased?

SELECT 
* -- look at all data to gain more insights not just item_name and order_id. Here you can see category data as well
FROM order_details od 
LEFT JOIN menu_items mi 
	ON menu_item_id = item_id
WHERE order_id = 440;



-- View the details of the top 5 highest spend orders
/* use order_id's from top 5 on previous query
top 5 order_id = 440, 2075, 1957, 330, 2675 */

SELECT * 
FROM order_details od 
LEFT JOIN menu_items mi 
	ON menu_item_id = item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
