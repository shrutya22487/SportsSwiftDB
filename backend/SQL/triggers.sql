USE SportSwiftDB;
DELIMITER //

CREATE TRIGGER add_to_sale_stats_trigger
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO Sale_Stats (Quantity, Product_ID, Supplier_ID)
    VALUES (NEW.Quantity, NEW.Product_ID, NEW.Supplier_ID);
END;
//

DELIMITER ;

DELIMITER //

CREATE TRIGGER update_blocked_status
BEFORE UPDATE ON customer
FOR EACH ROW
BEGIN
    IF NEW.failed_attempts >= 3 THEN
        INSERT INTO check_blocked (customer_id, blocked) VALUES (NEW.Customer_ID, true);
    END IF;
END;
//

DELIMITER ;


