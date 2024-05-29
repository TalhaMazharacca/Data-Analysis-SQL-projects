create database PizzaHut;
use pizzahut;
CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);

CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);

-- Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id) AS Total_Order
FROM
    pizzahut.orders;
    
-- Calculate the total revenue generated from pizza sales. 
use pizzahut;
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS Total_Rrevenue_Generated
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;

-- Identify the highest-priced pizza.

SELECT 
    pizza_types.Name, pizzas.price AS Highest_Priced_Pizza
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY pizzas.price deSC
LIMIT 1;

-- Identify the most common pizza size ordered.
use pizzahut;
SELECT 
    pizzas.size, COUNT(order_details.order_details_id)
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY pizzas.size
LIMIT 1
;

-- List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_types.name, SUM(order_details.quantity) AS Quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pizza_types.category, SUM(order_details.quantity) AS Quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC
;

-- Determine the distribution of orders by hour of the day.

use pizzahut;
SELECT 
    HOUR(orders.order_time) AS Hours,
    COUNT(orders.order_id) AS order_count
FROM
    orders
GROUP BY HOUR(orders.order_time)
ORDER BY order_count DESC;

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS Quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC
;

-- Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    pizza_types.category, COUNT(pizza_types.name)
FROM
    pizza_types
GROUP BY pizza_types.category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    round(AVG(quantity))
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity)  as quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS Order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pizza_types.name,
    SUM((order_details.quantity * pizzas.price)) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC;

-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.category,
    round(SUM(order_details.quantity * pizzas.price) / (SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS Total_Rrevenue_Generated
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id)* 100,2) as revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
order by revenue desc;



    