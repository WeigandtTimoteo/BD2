CREATE USER data_analyst@'%' IDENTIFIED BY 'secret';


GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'%';


CREATE TABLE IF NOT EXISTS prueba( id_prueba int auto_increment primary key, nombre VARCHAR(255));
/*
ERROR 1142 (42000): CREATE command denied to user 'data_analyst'@'localhost' for table 'prueba'
*/


UPDATE film SET title='La salchicha naranja' WHERE film_id = 420;



REVOKE UPDATE ON sakila.* FROM data_analyst;


/*
ERROR 1142 (42000): UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'
*/