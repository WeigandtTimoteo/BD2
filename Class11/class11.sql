USE sakila;

SELECT title
FROM film
WHERE film_id NOT IN (
    SELECT film_id
    FROM inventory
);


SELECT f.title, i.inventory_id
FROM film f
INNER JOIN inventory i USING (film_id)
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;


SELECT c.first_name, c.last_name, s.store_id, f.title, r.rental_date, r.return_date
FROM customer c
INNER JOIN rental r USING (customer_id)
INNER JOIN inventory i USING (inventory_id)
INNER JOIN store s ON i.store_id = s.store_id
INNER JOIN film f USING (film_id)
WHERE r.return_date IS NOT NULL
ORDER BY s.store_id, c.last_name;


SELECT 
    CONCAT(ci.city, ', ', co.country) AS location,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    SUM(p.amount) AS total_sales
FROM store s
INNER JOIN address a ON s.address_id = a.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country co ON ci.country_id = co.country_id
INNER JOIN staff m ON s.manager_staff_id = m.staff_id
INNER JOIN inventory i ON s.store_id = i.store_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
INNER JOIN payment p ON r.rental_id = p.rental_id
GROUP BY ci.city, co.country, m.first_name, m.last_name
ORDER BY total_sales DESC;


SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY film_count DESC
LIMIT 1;