use sportswiftdb;

INSERT INTO Address VALUES (1, 'New Adarsh Apartments', 'saheed marg street','Dwarka','Delhi','India','110046');
INSERT INTO Address VALUES (2, 'Green Heights', 'Gandhi Road', 'Kolkata', 'West Bengal', 'India', '700001');
INSERT INTO Address VALUES (3, 'Sapphire Towers', 'Rajaji Nagar', 'Bangalore', 'Karnataka', 'India', '560010');
INSERT INTO Address VALUES (4, 'Golden Enclave', 'Viman Nagar', 'Pune', 'Maharashtra', 'India', '411014');
INSERT INTO Address VALUES (5, 'Royal Residency', 'Anna Salai', 'Chennai', 'Tamil Nadu', 'India', '600002');
INSERT INTO Address VALUES (6, 'Emerald Gardens', 'Jubilee Hills', 'Hyderabad', 'Telangana', 'India', '500033');
INSERT INTO Address VALUES (7, 'Silver Springs', 'Model Town', 'Jaipur', 'Rajasthan', 'India', '302018');
INSERT INTO Address VALUES (8, 'Pearl Paradise', 'Civil Lines', 'Lucknow', 'Uttar Pradesh', 'India', '226001');
INSERT INTO Address VALUES (9, 'Amber Acres', 'Sector 45', 'Gurgaon', 'Haryana', 'India', '122003');
INSERT INTO Address VALUES (10, 'Topaz Towers', 'Vijay Nagar', 'Indore', 'Madhya Pradesh', 'India', '452010');

-- PHONE_NUMBER

INSERT INTO phone_number VALUES(1,'9818009629');
INSERT INTO phone_number VALUES(2, '9876543210');
INSERT INTO phone_number VALUES(3, '9823456789');
INSERT INTO phone_number VALUES(4, '9654321098');

-- Email id
INSERT INTO email VALUES(1,'abcd1@gmail.com');
INSERT INTO email VALUES(2, 'abcd2@gmail.com');
INSERT INTO email VALUES(3, 'abcd3@gmail.com');
INSERT INTO email VALUES(4, 'abcd4@gmail.com');
INSERT INTO email VALUES(5, 'abcd5@gmail.com');
INSERT INTO email VALUES(6, 'emily.brown@gmail.com');
INSERT INTO email VALUES(7, 'david.wilson@example.com');
INSERT INTO email VALUES(8, 'olivia.wright@hotmail.com');
INSERT INTO email VALUES(9, 'james.miller@yahoo.com');
INSERT INTO email VALUES(10, 'ava.davis@gmail.com');
INSERT INTO email VALUES(11, 'michael.hill@example.com');
INSERT INTO email VALUES(12, 'susan.johnson@yahoo.com');


-- ENTITY TABLES

-- Admin

INSERT INTO Admin Values(1,'Naman','naman@2004');
INSERT INTO Admin VALUES(2, 'Shrutya', 'shrutya@123');
INSERT INTO Admin VALUES(3, 'Udbhav', 'udbhav@456');
INSERT INTO Admin VALUES(4, 'Yogesh', 'yogesh@789');


-- Supplier
INSERT INTO Supplier VALUES (1, 'Ashlen', 1, 3, 1, 'abcd');
INSERT INTO Supplier VALUES (2, 'Shruti', 2, 4, 2, 'abcd');
INSERT INTO Supplier VALUES (3, 'Yogesh', 4, 5, 6, 'abcd');

-- Product

INSERT INTO Product Values(1,'Cricket Bats',1,55,1500,'product1.jpeg');
INSERT INTO Product VALUES(2, 'Shuttlecocks', 2, 45, 100, 'product2.jpeg');
INSERT INTO Product VALUES(3, 'Racquets', 3, 30, 500, 'product3.jpeg');
INSERT INTO Product VALUES(4, 'Tennis Racquets', 3, 30, 600, 'tennis.jpeg');


-- Customer

INSERT INTO Customer VALUES(1, 'Naman', 1, 1, 1, 1, 'abcd', 1, 0);
INSERT INTO Customer VALUES(2, 'Amit', 2, 2, 2, 2, 'abcd', 2, 0);
