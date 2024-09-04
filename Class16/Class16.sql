USE sakila;

CREATE TABLE `employees` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
);

insert  into `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) values 
(1002,'Murphy','Diane','x5800','dmurphy@classicmodelcars.com','1',NULL,'President'),
(1056,'Patterson','Mary','x4611','mpatterso@classicmodelcars.com','1',1002,'VP Sales'),
(1076,'Firrelli','Jeff','x9273','jfirrelli@classicmodelcars.com','1',1002,'VP Marketing');


INSERT INTO `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) VALUES
(1911,'Pepe','Perez','x1456',NULL,'1','1002','VP Sales');
#Da error 1048 porque la columna correoElectronico no puede ser null



UPDATE employees SET employeeNumber = employeeNumber - 20;
#La columna employeeNumber baja sus valores por 20 en todas las filas

UPDATE employees SET employeeNumber = employeeNumber + 20;
#Vuelve a la normalidad



ALTER TABLE employees ADD COLUMN age INT(3) CHECK (age >= 16 AND age <= 70);

/*
film_actor actúa como una tabla intermedia que conecta film y actor, 
creando una relación de muchos a muchos entre películas y actores. 
La integridad referencial se mantiene mediante claves foráneas que apuntan a film_id en film y actor_id en actor. 
Estas claves garantizan que no se pueda eliminar un film o actor que esté referenciado en film_actor sin primero 
eliminar las entradas correspondientes en film_actor.
*/



ALTER TABLE employees ADD COLUMN lastUpdate DATETIME, ADD COLUMN lastSQLUser VARCHAR(100);
CREATE TRIGGER before_updating_employees BEFORE UPDATE ON employees FOR EACH ROW SET NEW.lastUpdate = NOW(), NEW.lastSQLUser = USER();



/*
ins_film: Inserta un nuevo registro en film_text cada vez que se inserta un registro en film.
upd_film: Actualiza el registro en film_text correspondiente cuando se actualiza un registro en film.
del_film: Elimina el registro en film_text correspondiente cuando se elimina un registro en film.
Estos triggers aseguran que film_text se mantenga sincronizado con los cambios en la tabla film.
*/


/*
Función: Este trigger se ejecuta después de insertar un nuevo registro en la tabla film. 
Inserta automáticamente los datos correspondientes (film_id, title, y description) en la tabla film_text.
*/
/*
CREATE TRIGGER `ins_film` 
AFTER INSERT ON `film` 
FOR EACH ROW 
BEGIN
    INSERT INTO film_text (film_id, title, description)
    VALUES (NEW.film_id, NEW.title, NEW.description);
END;
*/

/*
Función: Este trigger se ejecuta después de actualizar un registro en la tabla film. 
Si se cambian el título, la descripción o el film_id, actualiza los valores correspondientes en film_text.
*/
/*
CREATE TRIGGER `upd_film` 
AFTER UPDATE ON `film` 
FOR EACH ROW 
BEGIN
    IF (OLD.title != NEW.title) 
    OR (OLD.description != NEW.description) 
    OR (OLD.film_id != NEW.film_id) THEN
        UPDATE film_text
        SET title = NEW.title,
            description = NEW.description,
            film_id = NEW.film_id
        WHERE film_id = OLD.film_id;
    END IF;
END;
*/
/*
Función: Este trigger se ejecuta después de eliminar un registro en la tabla film. 
Elimina el registro correspondiente en film_text para mantener la consistencia.
*/
/*
CREATE TRIGGER `del_film` 
AFTER DELETE ON `film` 
FOR EACH ROW 
BEGIN
    DELETE FROM film_text 
    WHERE film_id = OLD.film_id;
END;
*/
/*
Estos triggers aseguran que la tabla film_text siempre refleje los cambios que ocurren en la tabla film. 
Así, cuando se inserta, actualiza o elimina una película, los cambios se aplican automáticamente a film_text, 
manteniendo la integridad y consistencia de los datos.
*/