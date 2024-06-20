-- (Database-Schema)
# DROP DATABASE SportSwiftDB;
CREATE DATABASE IF NOT EXISTS SportSwiftDB;
USE SportSwiftDB;
# DROP TABLE customer;
# DROP TABLE sale_stats;
-- UTILITIY TABLES

CREATE TABLE IF NOT EXISTS Address (
    Address_ID INT NOT NULL AUTO_INCREMENT,
    Apt_Name VARCHAR(255) NOT NULL,
    Street VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    state VARCHAR(255) NOT NULL,
    Country VARCHAR(255) NOT NULL ,
    zip INT NOT NULL,
    PRIMARY KEY (Address_ID)
);

CREATE TABLE IF NOT EXISTS phone_number (
    phone_ID INT NOT NULL,
    num CHAR(15) NOT NULL
);

CREATE TABLE IF NOT EXISTS email (
    email_ID INT NOT NULL,
    em  VARCHAR(30) NOT NULL
);
-- ENTITY TABLES

CREATE TABLE IF NOT EXISTS Admin (
    Admin_ID INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(255) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    PRIMARY KEY (Admin_ID)
);

CREATE TABLE IF NOT EXISTS Supplier (
    Supplier_ID INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Address_ID INT NOT NULL,
    email_ID INT UNIQUE NOT NULL,
    phone_ID INT UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    PRIMARY KEY (Supplier_ID),
    FOREIGN KEY (Address_ID) REFERENCES address(Address_ID)
);
CREATE TABLE IF NOT EXISTS Product
(
    Product_ID  INT            NOT NULL AUTO_INCREMENT,
    Name        VARCHAR(255)   NOT NULL,
    Supplier_ID INT            NOT NULL,
    Quantity    INT            NOT NULL,
    Price       DECIMAL(10, 2) NOT NULL,
    Description TEXT           NOT NULL,
    PRIMARY KEY (Product_ID, Supplier_ID),
    FOREIGN KEY (Supplier_ID) REFERENCES supplier (Supplier_ID)
);

CREATE TABLE IF NOT EXISTS Customer (
    Customer_ID INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Address_ID INT NOT NULL,
    Age INT NOT NULL,
    phoneID INT UNIQUE NOT NULL,
    email_ID INT UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Wallet_ID INT NOT NULL,
    failed_attempts INT DEFAULT 0,
    PRIMARY KEY (Customer_ID),
    FOREIGN KEY (Address_ID) REFERENCES address(Address_ID)
);

CREATE TABLE IF NOT EXISTS Wallet (
    Wallet_ID INT NOT NULL AUTO_INCREMENT,
    Customer_ID INT NOT NULL,
    balance INT,
    upiID VARCHAR(255) NOT NULL,
    PRIMARY KEY (Wallet_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);
CREATE TABLE IF NOT EXISTS Bag
(
    Bag_ID     INT NOT NULL,
    Product_ID INT NOT NULL,
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);

CREATE TABLE IF NOT EXISTS Delivery_Agent (
    Delivery_agent_ID INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Address_ID INT NOT NULL,
    Availability BOOLEAN NOT NULL DEFAULT TRUE,
    phone_ID INT UNIQUE NOT NULL,
    email_ID INT UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    PRIMARY KEY (Delivery_agent_ID),
    FOREIGN KEY (Address_ID) REFERENCES address(Address_ID)
);
CREATE TABLE IF NOT EXISTS Orders (
    Customer_ID INT NOT NULL ,
    Product_ID INT NOT NULL ,
    Supplier_ID INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (Customer_ID, Product_ID,Supplier_ID),
    FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID),
    FOREIGN KEY (Product_ID) REFERENCES product(Product_ID),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
);

CREATE TABLE IF NOT EXISTS Product_Review (
    Product_Review_ID INT NOT NULL AUTO_INCREMENT,
    Review  TEXT,
    rating INT NOT NULL,
    CHECK (rating >= 1 AND rating <= 5),
    PRIMARY KEY (Product_Review_ID)
);

CREATE TABLE IF NOT EXISTS Delivery_Review (
    DR_ID INT NOT NULL AUTO_INCREMENT,
    Rating INT NOT NULL,
    Review TEXT,
    CHECK (Rating >= 1 AND Rating <= 5),
    PRIMARY KEY (DR_ID)
);

-- RELATIONSHIP TABLES

CREATE TABLE IF NOT EXISTS cart (
    Customer_ID INT NOT NULL ,
    Product_ID INT NOT NULL ,
    Supplier_ID INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (Customer_ID, Product_ID,Supplier_ID),
    FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID),
    FOREIGN KEY (Product_ID) REFERENCES product(Product_ID),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
);

# CREATE TABLE IF NOT EXISTS Order_relationship (
#     Order_ID INT NOT NULL,
#     Product_ID INT NOT NULL,
#     Customer_ID INT NOT NULL,
#     quantity INT NOT NULL,
#     PRIMARY KEY (Order_ID, Product_ID, Customer_ID),
#     FOREIGN KEY (Order_ID) REFERENCES orders(Order_ID),
#     FOREIGN KEY (Product_ID) REFERENCES product(Product_ID)
# );

CREATE TABLE IF NOT EXISTS Supplies
(
    Product_ID  INT NOT NULL,
    Supplier_ID INT NOT NULL,
    PRIMARY KEY (Product_ID, Supplier_ID),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
);

CREATE TABLE IF NOT EXISTS Sale_Stats
(
    Quantity INT NOT NULL,
    Product_ID INT NOT NULL,
    Supplier_ID INT NOT NULL,
    PRIMARY KEY (Product_ID, Supplier_ID),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
);
CREATE TABLE IF NOT EXISTS Delivered(
    Customer_ID INT NOT NULL,
    Delivery_Agent_ID INT NOT NULL,
    DR_ID INT NOT NULL,
    PRIMARY KEY (Customer_ID, Delivery_Agent_ID, DR_ID),
    FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID),
    FOREIGN KEY (Delivery_Agent_ID) REFERENCES Delivery_Agent(Delivery_agent_ID),
    FOREIGN KEY (DR_ID) REFERENCES Delivery_Review(DR_ID)
);
# CREATE TABLE IF NOT EXISTS Delivers(
#     Customer_ID INT NOT NULL,
#     Order_ID INT NOT NULL,
#     Delivery_Agent_ID INT NOT NULL,
#     PRIMARY KEY (Customer_ID, Order_ID, Delivery_Agent_ID),
#     FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID),
#     FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
#     FOREIGN KEY (Delivery_Agent_ID) REFERENCES Delivery_Agent(Delivery_agent_ID)
# );
CREATE TABLE IF NOT EXISTS check_blocked(
        Customer_ID INT NOT NULL,
        blocked BOOL NOT NULL DEFAULT FALSE,
        PRIMARY KEY (Customer_ID)
);





