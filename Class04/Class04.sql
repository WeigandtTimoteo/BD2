USE sakila;


SELECT title, rental_rate, special_features
FROM film
WHERE rating = 'PG-13';

SELECT `length`
FROM film;

SELECT title, rental_rate, replacement_cost
FROM film
WHERE replacement_cost <= 24 AND replacement_cost >= 20;

SELECT f.title, c.`name`, f.rating
FROM film f, category c, film_category fc
WHERE special_features LIKE '%Behind the Scenes%' AND f.film_id = fc.film_id AND fc.category_id = c.category_id;

SELECT a.first_name, a.last_name, f.film_id, f.title
FROM actor a, film f, film_actor fa
WHERE a.actor_id = fa.actor_id AND fa.film_id = f.film_id AND f.title = 'ZOOLANDER FICTION';

SELECT a.address, ci.city, co.country
FROM store s, address a, city ci, country co
WHERE s.store_id = 1 AND s.address_id = a.address_id AND a.city_id = ci.city_id AND ci.country_id = co.country_id;

SELECT f2.title, f1.title, f1.rating 
  FROM film f1, film f2
WHERE f1.rating = f2.rating AND f1.film_id <> f2.film_id;

SELECT f.title, i.store_id, sta.first_name, sta.last_name
FROM film f, inventory i, staff sta, store sto
WHERE i.store_id = 2 AND i.film_id = f.film_id AND sto.manager_staff_id = sta.staff_id AND sto.store_id = i.store_id;