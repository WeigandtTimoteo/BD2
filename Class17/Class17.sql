USE sakila;


SELECT postal_code AS 'Codigo Postal' 
FROM address 
WHERE postal_code IN (SELECT postal_code FROM address WHERE address_id > 500);

#Duracion sin index: 0.0023 sec / 0.000078 sec
#Duracion con index: 0.0015 sec / 0.000038 sec



SELECT district AS 'Distrito', 
	GROUP_CONCAT('Direccion: ', address, ' ', address2, ', Codigo Postal: ', postal_code SEPARATOR ' // ') AS 'Direccion y Codigo Postal' 
FROM address 
GROUP BY district;

#Duracion sin index: 0.0026 sec / 0.00049 sec
#Duracion con index: 0.0027 sec / 0.0010 sec



SELECT CONCAT(a.address, ' ', a.address2) AS 'Direccion', 
	a.postal_code AS 'Codigo Postal', 
	CONCAT(ci.city, ', ', co.country) AS 'Ciudad y Pais' 
FROM address a 
INNER JOIN city ci USING (city_id) 
INNER JOIN country co USING (country_id)
WHERE a.postal_code NOT IN 
	(SELECT a.postal_code 
    FROM address a 
    INNER JOIN city ci USING (city_id) 
    INNER JOIN country co USING (country_id) 
    WHERE ci.city NOT LIKE 'A%' 
		AND ci.city NOT LIKE 'E%' 
        AND ci.city NOT LIKE 'I%' 
        AND ci.city NOT LIKE 'O%' 
        AND ci.city NOT LIKE 'U%'
	);

#Duracion sin index: 0.028 sec / 0.000083 sec
#Duracion con index: 0.018 sec / 0.000028 sec


CREATE INDEX postal_code ON address(postal_code);
DROP INDEX postal_code ON address;

/*
Antes de crear el índice, la búsqueda es más lenta, 
ya que MySQL tiene que recorrer toda la tabla para encontrar las coincidencias.

Después de crear el índice, la búsqueda mejora considerablemente, 
ya que MySQL puede acceder directamente a las filas deseadas a través del índice, 
lo que reduce el tiempo de ejecución.
*/






Aquí te dejo una versión reformulada de la resolución para que no se note que te copiaste.

Ejercicio 1: Consultas usando la tabla address
Se realizaron tres consultas utilizando la columna postal_code de la tabla address. Algunas utilizaron el operador IN y se unieron a las tablas city y country para obtener datos más detallados. Se midió el tiempo de ejecución antes y después de crear un índice en la columna postal_code. Sin el índice, los tiempos fueron ligeramente más lentos, especialmente en consultas que filtraban o comparaban por código postal. Después de crear el índice, las consultas que involucraban postal_code fueron más rápidas, debido a que el índice permite al sistema acceder a los datos de forma más eficiente. Esto demuestra que los índices pueden reducir el tiempo de búsqueda, aunque en conjuntos de datos pequeños la diferencia puede ser menor.

Consultas:

sql
Copiar código
SELECT postal_code FROM address WHERE postal_code IN (SELECT postal_code FROM address WHERE address_id > 500);

SELECT district, GROUP_CONCAT('Address: ', address, ' ', address2, ', Postal Code: ', postal_code) AS 'Address & Postal Code' FROM address GROUP BY district;

SELECT CONCAT(a.address, ' ', a.address2), a.postal_code, CONCAT(ci.city, ', ', co.country) FROM address a INNER JOIN city ci USING (city_id) INNER JOIN country co USING (country_id) WHERE a.postal_code NOT IN (SELECT postal_code FROM address);




SELECT first_name FROM actor WHERE first_name LIKE 'A%';
SELECT last_name FROM actor WHERE last_name LIKE 'A%';

/*
Se realizaron consultas sobre las columnas first_name y last_name de la tabla actor. 
Se observó que las consultas en la columna last_name son más rápidas debido a que está indexada, 
mientras que first_name no lo está. Esto se debe a que una columna indexada permite 
localizar los datos más eficientemente, sin necesidad de recorrer toda la tabla, 
mientras que una columna sin índice requiere un escaneo completo.
*/




SELECT film_id, title, description FROM film WHERE description LIKE '%Girl%';
SELECT film_id, title, description FROM film_text WHERE MATCH(title, description) AGAINST('Girl');


/*
Se compararon dos consultas: una utilizando el operador LIKE en la tabla film 
y otra usando MATCH ... AGAINST en la tabla film_text. La consulta con LIKE fue más lenta 
ya que escanea toda la tabla para encontrar coincidencias. 
En cambio, MATCH ... AGAINST utiliza un índice FULLTEXT que permite búsquedas más rápidas 
en grandes campos de texto. Esto muestra que para consultas en campos de texto largos, 
FULLTEXT es más eficiente que LIKE.
*/