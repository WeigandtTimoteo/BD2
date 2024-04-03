CREATE DATABASE imdb;
USE imdb;

CREATE TABLE film (
    film_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    release_year INT
);

CREATE TABLE actor (
    actor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255)
);

CREATE TABLE film_actor (
    actor_id INT,
    film_id INT,
    PRIMARY KEY (actor_id, film_id);
);



ALTER TABLE film ADD COLUMN last_update DATE;
ALTER TABLE actor ADD COLUMN last_update DATE;



ALTER TABLE film_actor
ADD FOREIGN KEY (actor_id) REFERENCES actor(actor_id),
ADD FOREIGN KEY (film_id) REFERENCES film(film_id);



INSERT INTO actor (first_name, last_name, last_update) VALUES
('Owen', 'Wilson', NOW()), -- Cars
('Harrison', 'Ford', NOW()), -- Star Wars
('Dan', 'Povenmire', NOW()), -- Phineas y Ferb la pelicula
('Thomas', 'Sangster', NOW()); -- Phineas y Ferb la pelicula

INSERT INTO film (title, description, release_year, last_update) VALUES
('Cars', 'Un auto de carreras llamado Rayo McQueen se desvía en Radiator Springs, donde descubre el verdadero significado de la amistad y la familia.', 2006, NOW()),
('Star Wars: Episode IV', 'Luke Skywalker se une a un Caballero Jedi, un piloto engreído, un wookie y dos androides para salvar la galaxia de la estación de batalla destructora de mundos del Imperio, mientras intenta también rescatar a la princesa Leia de Darth Vader.', 1977, NOW()),
('Phineas y Ferb la pelicula', 'Phineas y Ferb descubren que Perry es un agente secreto, y todos quedan atrapados en una dimensión alternativa donde Doofenschmirtz es el gobernante del Área de los Tres Estados.', 2011, NOW());


INSERT INTO film_actor (actor_id, film_id) VALUES
(1, 1), -- Owen Wilson en Cars
(2, 2), -- Harrison Ford en Star Wars
(3, 3), -- Dan Povenmire en Phineas y Ferb la pelicula
(4, 3); -- Thomas Sangster en Phineas y Ferb la pelicula