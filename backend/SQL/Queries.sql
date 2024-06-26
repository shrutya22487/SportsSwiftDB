Use sportswiftdb;
-- Shrutya Queries
SELECT * FROM sportswiftdb.customer;
-- this query finds out the details of the orders that a particular person has placed
SELECT C.Customer_ID, C.Name, o.Delivery_date, b.Product_ID
FROM Customer C
         JOIN orders o on C.Customer_ID = o.Customer_ID
         JOIN bag b on b.Bag_ID = o.bag_ID
ORDER BY Customer_ID;

-- display the top 5 delivery agents with respect to rating

SELECT distinct DA_avg.Name, DA_avg.average_rating
FROM (SELECT delivery_agent.Name, avg(delivery_review.Rating) as average_rating
      FROM delivery_agent
               JOIN delivered ON delivery_agent.Delivery_agent_ID = delivered.Delivery_Agent_ID
               JOIN delivery_review ON delivered.DR_ID = delivery_review.DR_ID
      GROUP BY delivery_agent.Name) as DA_avg

WHERE 5 <= (SELECT count(distinct d2.average_rating)
            FROM (SELECT delivery_agent.Name, avg(delivery_review.Rating) as average_rating
                  FROM delivery_agent
                           JOIN delivered ON delivery_agent.Delivery_agent_ID = delivered.Delivery_Agent_ID
                           JOIN delivery_review ON delivered.DR_ID = delivery_review.DR_ID
                  GROUP BY delivery_agent.Name) as d2
            WHERE DA_avg.average_rating <= d2.average_rating)
order by DA_avg.average_rating desc;

-- this query finds all the suppliers who do not sell any products
SELECT supplier.Supplier_ID, supplier.Name
from supplier
WHERE NOT EXISTS(SELECT *
                 FROM product
                 where product.Supplier_ID = supplier.Supplier_ID);



-- Udbhav_Queries
# Added one insert command to increase the diversity of queries as asked
INSERT INTO cart VALUES (12, 5, 3,1);

#This query finds out the total revenue and total quantity sold per product for a supplier (sales statistics)
SELECT Product.Name, SUM(Order_relationship.quantity) AS total_quantity_sold, SUM(Order_relationship.quantity * Product.Price) AS total_revenue
FROM product
INNER JOIN Order_relationship ON Product.Product_ID = Order_relationship.Product_ID
INNER JOIN Orders ON Order_relationship.Order_ID = Orders.Order_ID
WHERE Product.Supplier_ID  = 1
GROUP BY Product.Name;

-- Naman Queries

-- This query is used to search through the product catalog for the name of the product( for eg, if we search for bats, it displays all the available bats)
SELECT Name
FROM Product
WHERE Name LIKE '%bat%'
GROUP BY Name;

-- Query to update the customer's address ( uses UPDATE)
update Address
SET Apt_name= 'Saphir Apartments',
Street= 'Dalal Street',
City='New Delhi',
State='Delhi',
Country='India',
zip='110046'
WHERE Address_ID = (SELECT Address_ID FROM customer WHERE Customer_ID = 2);
Select * from address;
-- Queries used while placing an order
  -- Find out an available delivery agent
select Delivery_agent_ID, Name
    from Delivery_Agent
    WHERE availability = TRUE
    ORDER BY Delivery_agent_ID ;

  -- Inserted two records to showcase the working of the below query
    Insert Into Bag Values(9,4);
    Insert Into Bag Values(9,5);
  -- To Find the quantity of Different products in the Bag while ordering
    Select Product_ID,count(Product_ID)
    from Bag
    Where Bag_ID=9
    Group By Product_ID;

-- Yogesh's Queries
-- This SQL query retrieves the order ID, customer name, and delivery agent name for all delivered orders by joining the Orders, Delivers, Customer, and Delivery_Agent tables based on their respective IDs.
SELECT
    o.Order_ID,
    c.Name AS Customer_Name,
    da.Name AS Delivery_Agent_Name
FROM
    Orders o
INNER JOIN
    Delivers d ON o.Order_ID = d.Order_ID
INNER JOIN
    Customer c ON d.Customer_ID = c.Customer_ID
INNER JOIN
    Delivery_Agent da ON d.Delivery_Agent_ID = da.Delivery_agent_ID
ORDER BY Order_ID;

-- This query deletes a product from a customer’s cart
DELETE FROM cart WHERE Customer_ID = 4 AND Product_ID = 5 AND Supplier_ID = 8;
select * from cart;
select * from customer natural join email;

select * from product;
SELECT * FROM cart INNER JOIN Product ON cart.Product_ID = Product.Product_ID WHERE Customer_ID  = 1;
select * from sale_stats;
select *
from orders;

select * from check_blocked;
SELECT blocked FROM email JOIN sportswiftdb.customer c on email.email_ID = c.email_ID JOIN check_blocked ON c.Customer_ID =check_blocked.Customer_ID;

