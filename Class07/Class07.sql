USE sakila;

SELECT title, rating
FROM film
WHERE length = (SELECT MIN(length) FROM film);



SELECT title
FROM film
WHERE (
    SELECT COUNT(*)
    FROM film
    WHERE length = (
        SELECT MIN(length)
        FROM film
    )
) = 1
LIMIT 1;






#Query with ALL
SELECT c.first_name AS 'Nombre', c.last_name AS 'Apellido', a1.address AS 'Dirección Cliente', a2.address AS 'Dirección Tienda', p.amount AS 'Cantidad', f.title AS 'Película'
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
INNER JOIN rental r ON p.rental_id = r.rental_id
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN store s ON i.store_id = s.store_id
INNER JOIN address a2 ON s.address_id = a2.address_id
INNER JOIN film f ON i.film_id = f.film_id
INNER JOIN address a1 ON c.address_id = a1.address_id
WHERE p.amount <= ALL (SELECT p2.amount FROM customer c2 INNER JOIN payment p2 ON c2.customer_id = p2.customer_id WHERE c.customer_id = c2.customer_id)
ORDER BY c.first_name;

#Query with ANY
SELECT c.first_name AS 'Nombre', c.last_name AS 'Apellido', a1.address AS 'Dirección Cliente', a2.address AS 'Dirección Tienda', p.amount AS 'Cantidad', f.title AS 'Película'
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
INNER JOIN rental r ON p.rental_id = r.rental_id
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN store s ON i.store_id = s.store_id
INNER JOIN address a2 ON s.address_id = a2.address_id
INNER JOIN film f ON i.film_id = f.film_id
INNER JOIN address a1 ON c.address_id = a1.address_id
WHERE p.amount = ANY (SELECT MIN(p2.amount) FROM customer c2 INNER JOIN payment p2 ON c2.customer_id = p2.customer_id WHERE c.customer_id = c2.customer_id)
ORDER BY c.first_name;



SELECT c.customer_id, c.first_name, c.last_name, c.address_id, a.address,
       MIN(p.amount) AS lowest_payment,
       MAX(p.amount) AS highest_payment
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
JOIN address a ON c.address_id = a.address_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.address_id, a.address;