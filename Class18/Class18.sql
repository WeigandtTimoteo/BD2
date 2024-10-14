USE sakila;

DELIMITER //
CREATE PROCEDURE copies_of_a_film(film VARCHAR(100), store INT)
	BEGIN
		SELECT f.title AS 'Title', SUM(i.inventory_id) AS 'Number of copies', s.store_id AS 'Store'
		FROM film f
		INNER JOIN inventory i USING (film_id)
		INNER JOIN store s USING (store_id)
		WHERE i.store_id = store AND (f.film_id = film OR f.title = film)
		GROUP BY f.title, s.store_id;
	END //
DELIMITER ;

CALL copies_of_a_film("ADAPTATION HOLES", 2);
DROP PROCEDURE copies_of_a_film;





DELIMITER //
	CREATE PROCEDURE customers_of_a_country(IN countryNameOrID VARCHAR(50), OUT customerList VARCHAR(5000))
    BEGIN
		DECLARE finished INT DEFAULT 0;
        DECLARE customerInfo VARCHAR(100) DEFAULT "";
    
		DECLARE customer_cursor CURSOR FOR
			SELECT CONCAT(c.first_name, ' ', c.last_name) FROM customer c INNER JOIN address a USING (address_id) 
            INNER JOIN city ci USING (city_id) INNER JOIN country co USING (country_id) WHERE co.country_id = countryNameOrID OR co.country = countryNameOrID;
		
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
		
        SET customerList = "";
        
        OPEN customer_cursor;
        
        get_customer_info: LOOP
			FETCH customer_cursor INTO customerInfo;
            
            IF finished = 1 THEN
				LEAVE get_customer_info;
			END IF;
            
            SET customerList = CONCAT(customerInfo, '; ', customerList);
		END LOOP get_customer_info;
        
        CLOSE customer_cursor;
	END //
DELIMITER ;

DROP PROCEDURE customers_of_a_country;
CALL customers_of_a_country(2, @List);
SELECT @List;




/*
La función inventory_in_stock verifica si un artículo específico está disponible en el inventario. 
Toma un inventory_id como parámetro y primero busca alquileres relacionados. Si no hay alquileres, 
devuelve TRUE, lo que indica que el artículo está disponible. Si encuentra alquileres, 
revisa si alguna devolución está pendiente (con return_date en NULL). Si todos los alquileres han sido devueltos, 
devuelve TRUE, de lo contrario, FALSE.
El procedimiento film_in_stock recibe p_film_id (película) y p_store_id (tienda), 
y cuenta cuántas copias de esa película están disponibles para alquilar en esa tienda. 
Utiliza la función inventory_in_stock para determinar la disponibilidad y almacena el total en p_film_count. 
De este modo, muestra cuántas copias de la película están en stock.
*/