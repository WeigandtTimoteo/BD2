USE sakila;


SELECT address_id 
FROM address 
WHERE city_id IN (SELECT city_id FROM city WHERE country_id = (SELECT country_id FROM country WHERE country = 'United States'))
ORDER BY address_id DESC 
LIMIT 1;

INSERT INTO customer (store_id, first_name, last_name, email, address_id, active, create_date)
VALUES (1, 'John', 'Doe', 'john.doe@example.com', 599, 1, NOW());




SET @film_title = 'FILM_TITLE';

SELECT i.inventory_id 
FROM inventory i
INNER JOIN film f ON i.film_id = f.film_id
WHERE f.title = @film_title
ORDER BY i.inventory_id DESC 
LIMIT 1;

SELECT staff_id 
FROM staff 
WHERE store_id = 2
ORDER BY staff_id ASC 
LIMIT 1;


SET @film_title = 'FILM_TITLE';

SET @inventory_id = (
    SELECT i.inventory_id 
    FROM inventory i
    INNER JOIN film f ON i.film_id = f.film_id
    WHERE f.title = @film_title
    ORDER BY i.inventory_id DESC 
    LIMIT 1
);

SET @staff_id = (
    SELECT staff_id 
    FROM staff 
    WHERE store_id = 2
    ORDER BY staff_id ASC 
    LIMIT 1
);

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES (NOW(), @inventory_id, 1, DATE_ADD(NOW(), INTERVAL 3 DAY), @staff_id);




SET SQL_SAFE_UPDATES = 0;

UPDATE film
SET release_year = 2001
WHERE rating = 'G';

UPDATE film
SET release_year = 2002
WHERE rating = 'PG';

UPDATE film
SET release_year = 2003
WHERE rating = 'PG-13';

UPDATE film
SET release_year = 2004
WHERE rating = 'R';

UPDATE film
SET release_year = 2005
WHERE rating = 'NC-17';

SET SQL_SAFE_UPDATES = 1;



SELECT rental_id
FROM rental
WHERE return_date IS NULL
ORDER BY rental_date DESC
LIMIT 1;

UPDATE rental
SET return_date = NOW()
WHERE rental_id = 11739;




DELETE r FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE i.film_id = 1;

DELETE FROM inventory WHERE film_id = 1;

DELETE FROM film_actor WHERE film_id = 1;

DELETE FROM film_category WHERE film_id = 1;

DELETE FROM film WHERE film_id = 1;




SET @available_inventory_id := (
    SELECT i.inventory_id
    FROM inventory i
    LEFT JOIN rental r ON i.inventory_id = r.inventory_id AND r.return_date IS NULL
    WHERE i.store_id = 1 AND r.inventory_id IS NULL
    LIMIT 1
);

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES (NOW(), @available_inventory_id, 1, NULL, 1);

INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (1, 1, LAST_INSERT_ID(), 4.99, NOW());
