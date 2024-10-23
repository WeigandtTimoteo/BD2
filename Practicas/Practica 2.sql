USE VIVERO_FENIX;

-- Query 1
CREATE VIEW customer_plant_purchases AS
	SELECT c.cod_cliente AS '#ID',
		CONCAT(c.nombre, ' ', c.apellido) AS 'Nombre del cliente',
		COUNT(f.nro_factura) AS 'Cantidad de facturas',
		COUNT(DISTINCT p.cod_planta) AS 'Cantidad de plantas distintas',
		(SELECT p.descripcion 
		FROM PLANTAS p 
		INNER JOIN DETALLES_FACTURAS df2 USING (cod_planta)
		INNER JOIN FACTURAS f2 USING (nro_factura)
		WHERE f2.cod_cliente = c.cod_cliente
		GROUP BY p.cod_planta
		ORDER BY SUM(df2.cantidad) DESC
		LIMIT 1) AS 'Planta mas comprada'
		
	FROM CLIENTES c
	INNER JOIN FACTURAS f USING (cod_cliente)
	INNER JOIN DETALLES_FACTURAS df USING (nro_factura)
	INNER JOIN PLANTAS p USING (cod_planta)
	GROUP BY c.cod_cliente;

DROP VIEW customer_plant_purchases;
SELECT * FROM customer_plant_purchases;


-- Query 2
DELIMITER //
CREATE PROCEDURE clientes_by_tipo_planta(IN tipo_planta VARCHAR(100), OUT listaClientes TEXT)
	BEGIN
		DECLARE finished INT DEFAULT 0;
        DECLARE clientes VARCHAR(255) DEFAULT "";
		
		DECLARE clientes_cursor CURSOR FOR
			SELECT CONCAT(c.nombre, ' ', c.apellido, ': ', SUM(df.cantidad))
            FROM CLIENTES c
            INNER JOIN FACTURAS f USING (cod_cliente)
            INNER JOIN DETALLES_FACTURAS df USING (nro_factura)
            INNER JOIN PLANTAS p USING (cod_planta)
            INNER JOIN TIPOS_PLANTAS tp USING (cod_tipo_planta)
            WHERE tp.cod_tipo_planta = tipo_planta OR tp.nombre = tipo_planta
            GROUP BY c.nombre, c.apellido;
		
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
        
        SET listaClientes = " ";
        
        OPEN clientes_cursor;
        
        create_clientes_list: LOOP
			FETCH clientes_cursor INTO clientes;
            
            IF finished = 1 THEN
				LEAVE create_clientes_list;
			END IF;
            
            SET listaClientes = CONCAT(clientes, ', ', listaClientes);
		END LOOP create_clientes_list;
        
        CLOSE clientes_cursor;
    END //
DELIMITER ;

DROP PROCEDURE clientes_by_tipo_planta;
CALL clientes_by_tipo_planta(1, @Lista);
SELECT @Lista;