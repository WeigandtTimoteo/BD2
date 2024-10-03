USE sakila;

CREATE VIEW list_of_costumers AS
	SELECT c.customer_id AS '#ID', 
    CONCAT(c.first_name, ' ', c.last_name) AS 'Nombre Completo', 
    CONCAT(adr.address, ' ', adr.address2) AS 'Addres', 
    adr.postal_code AS 'ZIP Code',  adr.phone AS 'Phone', 
    cit.city AS 'City',
    cou.country AS 'Country',
    CASE WHEN c.active = 1 THEN 'active' ELSE 'inactive' END AS 'Status',
    c.store_id AS 'Store #ID'
    FROM customer c
    INNER JOIN address adr ON c.address_id = adr.address_id
    INNER JOIN city cit ON adr.city_id = cit.city_id
    INNER JOIN country cou ON cit.country_id = cou.country_id
    ORDER BY c.customer_id ASC;
    
SELECT * FROM list_of_costumers;
DROP VIEW list_of_costumers;



CREATE VIEW film_details AS
	SELECT f.film_id AS '#ID',
    f.title AS 'Title',
    f.description AS 'Description',
    cat.name AS 'Category',
    f.replacement_cost AS 'Price',
    f.length AS 'Length',
    f.rating AS 'Rating',
    GROUP_CONCAT(a.first_name, ' ', a.last_name) AS 'Actors'
    FROM film f
    INNER JOIN film_category fc USING (film_id)
    INNER JOIN category cat USING (category_id)
    INNER JOIN film_actor fa ON f.film_id = fa.film_id
    INNER JOIN actor a ON fa.actor_id = a.actor_id
    GROUP BY f.film_id, cat.name;

SELECT * FROM film_details;
DROP VIEW film_details;



CREATE VIEW sales_by_film_category_consigna AS
	SELECT c.name AS 'Category', COUNT(r.rental_id) AS 'total rental'
    FROM category c
    INNER JOIN film_category fc USING (category_id)
    INNER JOIN inventory i USING (film_id)
    INNER JOIN rental r USING (inventory_id)
    GROUP BY c.name;

SELECT * FROM sales_by_film_category_consigna;
DROP VIEW sales_by_film_category_consigna;



CREATE VIEW actor_information AS 
	SELECT a.actor_id AS '#ID', 
    a.first_name AS 'First Name', a.last_name AS 'Last Name', 
    COUNT(f.film_id) AS 'Films acted on'
    FROM actor a
    INNER JOIN film_actor fa USING (actor_id)
    INNER JOIN film f USING (film_id)
    GROUP BY actor_id;

SELECT * FROM actor_information;
DROP VIEW actor_information;



SELECT * FROM actor_info;
/*
La vista "actor_info" selecciona información detallada sobre actores de la base de datos 
y las películas en las que han participado, organizadas por categorías de películas. 
Extrae el "actor_id", "first_name" y "last_name" de la tabla "actor", y utiliza la función 
GROUP_CONCAT para generar una lista de películas por cada categoría en la que un actor ha trabajado. 
Este listado se genera mediante una subconsulta que conecta las tablas 
"film_actor" y "film_category" para obtener las películas específicas de cada categoría 
en la que el actor ha participado.

La subconsulta utiliza una combinación de INNER JOIN entre las tablas 
"film_actor", "film_category" y "film", filtrando por el actor_id y el category_id. 
Esta subconsulta devuelve una lista de películas ordenadas alfabéticamente por título, 
que luego se concatenan para formar un string en formato "categoría: película1, película2, ..." 
con cada categoría separada por punto y coma.
*/



/*
Las "materialized views" son consultas almacenadas físicamente en una base de datos, 
lo que mejora el rendimiento en consultas complejas al evitar que se recalculen constantemente. 
Son útiles cuando los datos cambian con poca frecuencia y se necesita acceder rápidamente a ellos. 
Estas vistas se actualizan de manera programada o manual.

Existen en sistemas como **Oracle**, PostgreSQL, y SQL Server. 
Alternativas incluyen el uso de índices o caché de resultados, 
aunque estas no siempre son ideales para consultas muy complejas o grandes volúmenes de datos.
*/