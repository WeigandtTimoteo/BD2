USE VIVERO_FENIX;

CREATE VIEW category_sales_summary AS
	SELECT tp.nombre AS 'Nombre de la categoria',
		SUM(df.cantidad) AS 'Cantidad total vendida',
		SUM(df.cantidad * p.precio) AS 'Ingresos totales generados',
		MIN(f.fecha) AS 'Primera factura emitida',
		MAX(f.fecha) AS 'Ultima factura emitida'

	FROM TIPOS_PLANTAS tp
	INNER JOIN PLANTAS p USING (cod_tipo_planta)
	INNER JOIN DETALLES_FACTURAS df USING (cod_planta)
	INNER JOIN FACTURAS f ON df.nro_factura = f.nro_factura
	GROUP BY tp.nombre;

DROP VIEW category_sales_summary;
SELECT * FROM category_sales_summary;



DELIMITER //
CREATE PROCEDURE plantas_mas_vendidas_por_periodo(IN fechaInicio DATE, IN fechaFin DATE, OUT listaPlantas TEXT)
	BEGIN
		DECLARE finished INT DEFAULT 0;
        DECLARE planta TEXT DEFAULT "";
        
        DECLARE plantas_vendidas_cursor CURSOR FOR
			SELECT CONCAT('Planta: ', p.descripcion,'- Cantidad: ',
				SUM(df.cantidad), '- Total: ',
                SUM(df.cantidad * p.precio))
			FROM PLANTAS p
            INNER JOIN DETALLES_FACTURAS df USING (cod_planta)
            INNER JOIN FACTURAS f USING (nro_factura)
            WHERE f.fecha BETWEEN fechaInicio AND fechaFin
            GROUP BY p.descripcion
            ORDER BY SUM(df.cantidad * p.precio) DESC
            LIMIT 3;
            
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
        
        SET listaPlantas = " ";
        
		OPEN plantas_vendidas_cursor;
        
			plantas_vendidas_list: LOOP
				FETCH plantas_vendidas_cursor INTO planta;
                
                IF finished = 1 THEN
					LEAVE plantas_vendidas_list;
				END IF;
                
                SET listaPlantas = CONCAT(planta, '; ', listaPlantas);
			END LOOP plantas_vendidas_list;
		CLOSE plantas_vendidas_cursor;
    END //
    DELIMITER ;
    
    DROP PROCEDURE plantas_mas_vendidas_por_periodo;
    CALL plantas_mas_vendidas_por_periodo('2015-03-15', '2015-03-16', @Lista);
    SELECT @Lista;



ALTER TABLE FACTURAS ADD COLUMN lastInvoiceUpdate DATETIME;

CREATE TRIGGER after_facturas_update BEFORE UPDATE ON FACTURAS FOR EACH ROW SET NEW.lastInvoiceUpdate = NOW();


SELECT * FROM FACTURAS;
UPDATE FACTURAS SET FECHA = NOW() WHERE nro_factura = 1;