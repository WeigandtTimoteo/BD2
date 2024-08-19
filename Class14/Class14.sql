USE sakila;

SELECT CONCAT(c.first_name, ' ', c.last_name) AS 'Full Name', 
       a.address AS 'Address', 
       ci.city AS 'City'
FROM customer c
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Argentina';



SELECT f.title AS 'Film Title', 
       l.name AS 'Language',
       CASE f.rating
           WHEN 'G' THEN '(General Audiences) – All ages admitted'
           WHEN 'PG' THEN '(Parental Guidance Suggested) – Some material may not be suitable for children'
           WHEN 'PG-13' THEN '(Parents Strongly Cautioned) – Some material may be inappropriate for children under 13'
           WHEN 'R' THEN '(Restricted) – Under 17 requires accompanying parent or adult guardian'
           WHEN 'NC-17' THEN '(Adults Only) – No one 17 and under admitted'
           ELSE 'Not Rated'
       END AS 'Rating Description'
FROM film f
INNER JOIN language l ON f.language_id = l.language_id;



SELECT f.title AS 'Film Title', f.release_year AS 'Release Year'
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
INNER JOIN actor a ON fa.actor_id = a.actor_id
WHERE CONCAT(a.first_name, ' ', a.last_name) LIKE CONCAT('%', TRIM('actor_name'), '%'); #Ingresa el nombre en 'actor_name'



SELECT f.title AS 'Film Title', 
       CONCAT(c.first_name, ' ', c.last_name) AS 'Customer Name',
       CASE 
           WHEN r.return_date IS NOT NULL THEN 'Yes'
           ELSE 'No'
       END AS 'Returned'
FROM rental r
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id
INNER JOIN customer c ON r.customer_id = c.customer_id
WHERE MONTH(r.rental_date) IN (5, 6);




# CAST y CONVERT son funciones en SQL que permiten convertir un valor de un tipo de dato a otro. 
# Aunque ambos logran lo mismo, CAST es parte del estándar SQL, 
# mientras que CONVERT es específico de MySQL y otros sistemas.

# CAST es más estándar y claro:
# CONVERT permite especificar un formato en conversiones de datos de fecha:

# Ejemplos:
SELECT CAST(film_id AS CHAR) FROM film;

SELECT CONVERT('12345', DECIMAL(10,2)) AS decimal_value;




# NVL: No está disponible en MySQL. En otros sistemas, reemplaza un valor nulo con otro.
# ISNULL: Reemplaza un valor nulo con otro en MySQL.
# IFNULL: Similar a ISNULL, pero funciona con expresiones.
# COALESCE: Devuelve el primer valor no nulo de una lista de expresiones.

#Ejemplo con Sakila:
SELECT COALESCE(NULL, 'Sin valor', 'Otro valor') AS resultado;