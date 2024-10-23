USE Northwind;

-- Usé Northwind 2

-- 1) 
CREATE VIEW order_annual_inform AS
	SELECT s.ShipperName AS 'Shipper', 
		cat.CategoryName AS 'Category',
		COUNT(o.OrderID) AS 'Total Ordenes',
		SUM(od.Quantity) AS 'Total Productos',
		CONCAT('$', SUM(od.Quantity * p.Price)) AS 'Total Recaudado',
        #No hay precios viejos asi que no se pueden poner el recaudado con precios actuales
		MAX(o.OrderDate) AS 'Orden mas reciente',
		MIN(o.OrderDate) AS 'Orden mas vieja'
		
	FROM Orders o

	INNER JOIN Shippers s USING (ShipperID)

	INNER JOIN OrderDetails od USING (OrderID)
	INNER JOIN Products p USING (ProductID)
	INNER JOIN Categories cat USING (CategoryID)
	#Iria el WHERE que compare los precios actales y viejos para ver si la diferencia es mayor a $4000
	WHERE o.OrderDate LIKE CONCAT('%', (SELECT YEAR(o2.OrderDate) FROM Orders o2 ORDER BY o2.OrderDate DESC LIMIT 1), '%')
	GROUP BY s.ShipperName, cat.CategoryName
    ;


DROP VIEW order_annual_inform;
SELECT * FROM order_annual_inform;

SELECT * FROM Orders;


-- 2)
DELIMITER //
CREATE PROCEDURE supplier_by_city(IN city VARCHAR(255), OUT listaSuppliers TEXT)
	BEGIN
		#Se utiliza suppliers a falta de una ciudad vinculada a empleados
		DECLARE finished INT DEFAULT 0;
        DECLARE supplier TEXT DEFAULT "";
		
        DECLARE suppliers_cursor CURSOR FOR
			SELECT CONCAT(s.SupplierName, ' ', s.ContactName)
            FROM Suppliers s
            WHERE s.City = city;
    
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
        
        SET listaSuppliers = " ";
        
        OPEN suppliers_cursor;
        
			create_shippers_list: LOOP
				FETCH suppliers_cursor INTO supplier;
                
                IF finished = 1 THEN
					LEAVE create_shippers_list;
				END IF;
                
                SET listaSuppliers = CONCAT(supplier, '; ' , listaSuppliers);
			END LOOP create_shippers_list;
            
		CLOSE suppliers_cursor;
    END //

DELIMITER ;

DROP PROCEDURE supplier_by_city;
CALL supplier_by_city('Londona',@List);
SELECT @List;

-- 3)
ALTER TABLE Orders ADD COLUMN lastModification DATE;
ALTER TABLE Orders ADD COLUMN lastModifierUser TEXT;

CREATE TRIGGER before_orders_update BEFORE UPDATE ON Orders FOR EACH ROW SET NEW.lastModification = NOW(), NEW.lastModifierUser = USER();
CREATE TRIGGER before_orders_insert BEFORE INSERT ON Orders FOR EACH ROW SET NEW.lastModification = NOW(), NEW.lastModifierUser = USER();

DELIMITER //
#Se utiliza ShipperID a falta de OrderStatus
CREATE TRIGGER before_ordersShipperID_update BEFORE UPDATE ON Orders FOR EACH ROW 
	IF Orders.ShipperID = 1 THEN 
		SET NEW.OrderDate = NOW(); 
	END IF; //
DELIMITER ;



-- 4)
/*
Un indice es una forma de anclar una columna de una tabla para que gracias a esto siempre se mantenga cargada.
Normalmente se utiliza para agilizar request de uso constante, ya que al ser solicitada todo el tiempo la tabla,
es mas trabajo para el servidor cargarla en repetidas ocasiones que mantenerla  cargada todo el tiempo.
La carga de las columnas con indice se realiza al prender la base de datos, lo cual conlleva a una demora al iniciarse.
*/