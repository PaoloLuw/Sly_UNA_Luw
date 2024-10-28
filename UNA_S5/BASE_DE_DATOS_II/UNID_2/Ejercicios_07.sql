-- Active: 1726693191808@@127.0.0.1@3306
use Index_07;

CREATE TABLE Movies(
    id_movies INT PRIMARY KEY,
    title VARCHAR(50),
    genre VARCHAR(20),
    year DATE,
    length INT,
    studio_Name VARCHAR(20),
    producerN INT
);
CREATE TABLE StarsIn(
    id_stars_in INT PRIMARY KEY,
    movieTitle VARCHAR(20),
    movieYear DATE,
    startName VARCHAR(20)
);
CREATE TABLE MovieExec(
    id_movie_exec INT PRIMARY KEY,
    name VARCHAR(20),
    address VARCHAR(20),
    certN INT,
    netWorth DECIMAL(20)
);
CREATE TABLE Studio(
    id_studio INT PRIMARY KEY,
    name VARCHAR(20),
    address VARCHAR(20),
    presN INT
);


CREATE INDEX INX_1 on Movies(studio_Name);
CREATE INDEX INX_2 on MovieExec(address);
CREATE INDEX INX_3 on Movies(genre, length);

--- with WHERE ----
Explain select * FROM Movies WHERE studio_Name = '';
Explain select * FROM MovieExec WHERE address = '';
Explain select *, length FROM Movies WHERE genre = '' AND length = 0;

--- without WHERE ----
Explain select studio_Name FROM Movies;
Explain select address FROM MovieExec;
Explain select genre, length FROM Movies;


DESCRIBE MOVIES;




use sakila;
EXPLAIN select * from actor where actor_id<5;

EXPLAIN select a.actor_id, i.actor_id from actor a join actor_info i on a.actor_id=i.actor_id;

------ EJERCICIO 10 ---------
---CUSTOMER DATA
--city
EXPLAIN SELECT * FROM city WHERE country_id = 1;
--address
EXPLAIN SELECT * FROM address WHERE city_id = 1;

--customer
EXPLAIN SELECT * FROM customer WHERE store_id = 1;
EXPLAIN SELECT * FROM customer WHERE address_id = 1;
EXPLAIN SELECT * FROM customer WHERE last_name = 'Smith';
---BUSINESS
--staff
EXPLAIN SELECT * FROM staff WHERE store_id = 1;
EXPLAIN SELECT * FROM staff WHERE address_id = 1;

--store
EXPLAIN SELECT * FROM store WHERE manager_staff_id = 1;
EXPLAIN SELECT * FROM store WHERE address_id = 1;

--payment
EXPLAIN SELECT * FROM payment WHERE staff_id = 1;
EXPLAIN SELECT * FROM payment WHERE customer_id = 1;
EXPLAIN SELECT * FROM payment WHERE rental_id = 1;

--rental
EXPLAIN SELECT * FROM rental WHERE inventory_id = 1;
EXPLAIN SELECT * FROM rental WHERE customer_id = 1;
EXPLAIN SELECT * FROM rental WHERE staff_id = 1;

---INVENTORY


------ EJERCICIO 11 ---------

------ EJERCICIO 12 ---------

------ EJERCICIO 13 ---------

------ EJERCICIO 14 ---------