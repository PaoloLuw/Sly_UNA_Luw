-- Active: 1726693191808@@127.0.0.1@3306


---------EJERCICIO 1-----------
--a)
SELECT RANK() OVER (ORDER BY AGE) AS rank_age,
 first_name,
 age,
 gender
FROM person;
--b)
SELECT RANK() OVER (PARTITION BY gender ORDER BY age) AS 'Partido por gender',
 first_name,
 age,
 gender
FROM person;
--c)

    Delete from person where first_name= 'Mabel';
    Delete from person where first_name= 'Peter';


---------EJERCICIO 2-----------
--a)
	INSERT INTO person VALUES (9, 'Mabel', 18, 'F');
    SELECT RANK() OVER (ORDER BY AGE) AS rank_age,
    first_name,
    age,
    gender
    FROM person;--lo que pasa es que los empata y asi se eliminan
--b) 
	INSERT INTO person VALUES (10, 'Peter', 22, 'M');

	select 
		rank() over(partition by gender order by age) as rank_age,
		first_name, 
		age,
		gender
	from person;
--c)
    SELECT 
        DENSE_RANK() OVER (ORDER BY age) AS rank_age,
        first_name,
        age,
        gender
    FROM person;
--d)
	SELECT 
	    DENSE_RANK() OVER (partition by gender ORDER BY age) AS rank_age,
	    first_name,
	    age,
	    gender
	FROM person;
---------EJERCICIO 3-----------
--a)
SELECT
    NTILE(3) OVER (ORDER BY GPA DESC) AS tercio,
    name,
    GPA
FROM student_grade;

--b)
SELECT
    NTILE(5) OVER (ORDER BY GPA) AS quinto,
    name,
    GPA
FROM student_grade;

---------EJERCICIO 4-----------

select * -- algo asi como un join
from Sales F, Store S, Item I, Customer C
where F.storeID = S.storeID 
	and F.itemID = I.itemID 
	and F.custID = C.custID;
    -----60 TUPLAS Y 15 COLUMNAS
---------EJERCICIO 5-----------

SELECT 
    S.city, 
    I.color, 
    C.cName, 
    F.price
FROM 
    Sales F, 
    Store S, 
    Item I, 
    Customer C
WHERE 
    F.storeID = S.storeID 
    AND F.itemID = I.itemID 
    AND F.custID = C.custID
    AND S.state = 'CA' 
    AND I.category = 'Tshirt' 
    AND C.age < 22 
    AND F.price< 25;

--Muestre la consulta y el resultado para: “Ventas en la ciudad de Seattle de color rojo”

SELECT 
    S.city, 
    I.color, 
    C.cName, 
    F.price
FROM 
    Sales F, 
    Store S, 
    Item I, 
    Customer C
WHERE 
    F.storeID = S.storeID 
    AND F.itemID = I.itemID 
    AND F.custID = C.custID
    AND S.city = 'Seattle' 
    AND I.color = 'red';

--Muestre la consulta y el resultado para: “Ventas en el condado de King realizadas a 
--mujeres cuyo precio no haya excedido los 50 dólares”

SELECT 
    S.city, 
    I.color, 
    C.cName, 
    F.price
FROM 
    Sales F, 
    Store S, 
    Item I, 
    Customer C
WHERE 
    F.storeID = S.storeID 
    AND F.itemID = I.itemID 
    AND F.custID = C.custID
    AND S.county = 'King' 
    AND C.gender = 'F' 
    AND F.price <= 50;


---------EJERCICIO 6-----------

SELECT 
    storeID, custID, SUM(price) AS total_sales
FROM 
    Sales
GROUP BY storeID, custID;

--1)
SELECT 
    itemID, 
    SUM(price) AS total_sales
FROM 
    Sales
GROUP BY 
    itemID;

--2)
SELECT 
    custID, 
    AVG(price) AS average_sales
FROM 
    Sales
GROUP BY 
    custID;


---------EJERCICIO 7-----------
SELECT 
    F.storeID, 
    F.itemID, 
    F.custID, 
    SUM(F.price) AS total_sales
FROM 
    Sales F
JOIN 
    Store S ON F.storeID = S.storeID
WHERE 
    S.state = 'WA'
GROUP BY 
    F.storeID, 
    F.itemID, 
    F.custID;

--1)
SELECT 
    F.storeID, 
    F.itemID, 
    F.custID, 
    SUM(F.price) AS total_sales
FROM 
    Sales F
JOIN 
    Store S ON F.storeID = S.storeID
JOIN 
    Item I ON F.itemID = I.itemID
WHERE 
    S.state = 'WA' 
    AND I.category = 'Jacket'
GROUP BY 
    F.storeID, 
    F.itemID, 
    F.custID;

--2)
SELECT 
    F.storeID, 
    F.itemID, 
    F.custID, 
    SUM(F.price) AS total_sales
FROM 
    Sales F
JOIN 
    Store S ON F.storeID = S.storeID
JOIN 
    Customer C ON F.custID = C.custID
WHERE 
    S.state = 'WA' 
    AND C.gender = 'M'  -- Considerando que 'M' representa masculino
GROUP BY 
    F.storeID, 
    F.itemID, 
    F.custID;

---------EJERCICIO 8-----------
SELECT 
    storeID, 
    itemID, 
    custID, 
    SUM(price) AS total_sales
FROM 
    Sales
GROUP BY 
    storeID, 
    itemID, 
    custID WITH ROLLUP
UNION ALL
SELECT
    storeID, 
    itemID, 
    custID, 
    SUM(price) AS total_sales
FROM 
    Sales
GROUP BY 
    itemID, 
    custID, 
    storeID WITH ROLLUP
UNION ALL
SELECT 
    storeID, 
    itemID, 
    custID, 
    SUM(price) AS total_sales
FROM 
    Sales
GROUP BY 
    custID, 
    storeID, 
    itemID WITH ROLLUP;


CREATE TABLE cubo (
    storeID CHAR(6),
    itemID CHAR(6),
    custID CHAR(6),
    total_sales DECIMAL(10, 2)
);


---INSERTANDO INTO CUBO
INSERT INTO cubo (storeID, itemID, custID, total_sales)
SELECT 
    storeID, 
    itemID, 
    custID, 
    SUM(price) AS total_sales
FROM 
    Sales
GROUP BY 
    storeID, 
    itemID, 
    custID WITH ROLLUP
UNION ALL
SELECT 
    storeID, 
    itemID, 
    custID, 
    SUM(price) AS total_sales
FROM 
    Sales
GROUP BY 
    itemID, 
    custID, 
    storeID WITH ROLLUP
UNION ALL
SELECT 
    storeID, 
    itemID, 
    custID, 
    SUM(price) AS total_sales
FROM 
    Sales
GROUP BY 
    custID, 
    storeID, 
    itemID WITH ROLLUP;

---------EJERCICIO 9-----------


SELECT 
    C.* 
FROM 
    cubo C
JOIN 
    Store S ON C.storeID = S.storeID
JOIN 
    Item I ON C.itemID = I.itemID
WHERE 
    S.state = 'CA' 
    AND I.color = 'blue' 
    AND C.custID IS NOT NULL;

--1)
SELECT 
    SUM(C.total_sales) AS total_sales
FROM 
    cubo C
JOIN 
    Store S ON C.storeID = S.storeID
JOIN 
    Item I ON C.itemID = I.itemID
WHERE 
    S.state = 'CA' 
    AND I.color = 'blue' 
    AND C.custID IS NOT NULL;

--2)
SELECT 
    AVG(C.total_sales) AS average_sales
FROM 
    cubo C
JOIN 
    Store S ON C.storeID = S.storeID
JOIN 
    Item I ON C.itemID = I.itemID
JOIN 
    Customer Cu ON C.custID = Cu.custID
WHERE 
    I.category = 'Tshirt' 
    AND Cu.age < 30;

---------EJERCICIO 10-----------
SELECT state, county, city, SUM(price)
FROM Sales F, Store S
WHERE F.storeID = S.storeID
GROUP BY state, county, city WITH ROLLUP;


---OPERACIONES OLTP (ONLINE TRANSACTION PROSUCTILON)
---OPERACIONES OLAP (ONLINE ANALITINC PRODUCTION)