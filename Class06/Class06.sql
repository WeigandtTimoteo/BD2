USE sakila;

SELECT a1.first_name, a1.last_name 
FROM actor a1
WHERE EXISTS (SELECT * 
                 FROM actor a2 
                WHERE a1.last_name = a2.last_name 
                  AND a1.actor_id <> a2.actor_id)
ORDER BY a1.last_name;

SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (SELECT fa.actor_id
					FROM film_actor fa);
                    
SELECT c.first_name, c.last_name
FROM customer c, rental r
WHERE c.customer_id = r.customer_id
GROUP BY c.customer_id
HAVING COUNT(r.customer_id) = 1;

SELECT c.first_name, c.last_name, COUNT(r.customer_id) AS 'num_rentas'
FROM customer c, rental r
WHERE c.customer_id = r.customer_id
GROUP BY c.customer_id
HAVING COUNT(r.customer_id) > 1;

SELECT a.first_name, a.last_name, f.title
FROM actor a, film f, film_actor fa
WHERE (a.actor_id = fa.actor_id AND fa.film_id = f.film_id AND f.title = 'BETRAYED REAR') OR (a.actor_id = fa.actor_id AND fa.film_id = f.film_id AND f.title = 'CATCH AMISTAD')
ORDER BY f.title;

SELECT a.first_name, a.last_name, f.title
FROM actor a, film f, film_actor fa
WHERE (a.actor_id = fa.actor_id AND fa.film_id = f.film_id AND f.title = 'BETRAYED REAR') AND a.actor_id NOT IN(a.actor_id = fa.actor_id AND fa.film_id = f.film_id AND f.title = 'CATCH AMISTAD')
ORDER BY f.title;

SELECT a.first_name, a.last_name, f.title
FROM actor a, film f, film_actor fa
WHERE (a.actor_id = fa.actor_id AND fa.film_id = f.film_id AND f.title = 'BETRAYED REAR') AND a.actor_id IN (
    SELECT fa2.actor_id
    FROM film_actor fa2, film f2
    WHERE fa2.film_id = f2.film_id AND f2.title = 'CATCH AMISTAD'
)
ORDER BY f.title;


SELECT a.first_name, a.last_name, f.title
FROM actor a, film f, film_actor fa
WHERE (a.actor_id = fa.actor_id AND fa.film_id = f.film_id AND f.title = 'BETRAYED REAR')
AND a.actor_id NOT IN (
    SELECT fa2.actor_id
    FROM film_actor fa2, film f2
    WHERE fa2.film_id = f2.film_id AND f2.title = 'CATCH AMISTAD'
)
ORDER BY f.title;