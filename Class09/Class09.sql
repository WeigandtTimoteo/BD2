USE sakila;

SELECT country.country_id, country.country, COUNT(city.city_id) AS city_count
FROM country
LEFT JOIN city ON country.country_id = city.country_id
GROUP BY country.country_id, country.country
ORDER BY country.country, country.country_id;




SELECT country.country_id, country.country, COUNT(city.city_id) AS city_count
FROM country
LEFT JOIN city ON country.country_id = city.country_id
GROUP BY country.country_id, country.country
HAVING COUNT(city.city_id) > 10
ORDER BY city_count DESC;



SELECT c.first_name, c.last_name, a.address,
       COUNT(r.rental_id) AS total_films_rented,
       SUM(p.amount) AS total_money_spent
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
LEFT JOIN address a ON c.address_id = a.address_id
GROUP BY c.customer_id, c.first_name, c.last_name, a.address
ORDER BY total_money_spent DESC;




SELECT category.name AS category_name, AVG(film.length) AS average_duration
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category_name
ORDER BY average_duration DESC;



SELECT film.rating, COUNT(payment.amount) AS sales
FROM film
LEFT JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
LEFT JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY film.rating
ORDER BY sales DESC;