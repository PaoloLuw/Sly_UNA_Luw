CREATE DATABASE recursividad;


select * from ParentOf;

-----------------Ejercicio N1---------------------
CREATE TABLE ParentOf (
    parent TEXT,
    child TEXT
);
TRUNCATE TABLE ParentOf;

INSERT INTO ParentOf VALUES ('Alice', 'Carol');
INSERT INTO ParentOf VALUES ('Bob', 'Carol');
INSERT INTO ParentOf VALUES ('Carol', 'Dave');
INSERT INTO ParentOf VALUES ('Carol', 'George');
INSERT INTO ParentOf VALUES ('Dave', 'Mary');
INSERT INTO ParentOf VALUES ('Eve', 'Mary');


WITH RECURSIVE Ancestor(a, d) AS (
    SELECT parent AS a, child AS d FROM ParentOf
    UNION
    SELECT Ancestor.a, ParentOf.child AS d
    FROM Ancestor, ParentOf
    WHERE Ancestor.d = ParentOf.parent
)
SELECT a FROM Ancestor WHERE d = 'Mary';

---//salidas esperadas 
---//Dave
---//Eve
---//Carol
---//Alice
---//Bob
---Alice y Bob son los padres de Carol.
---Carol es la madre de Dave y George.
---Dave y Eve son los padres de Mary.

INSERT INTO ParentOf VALUES ('Carol', 'Eve');
---INSERT INTO ParentOf VALUES ('Diego', 'George');
---INSERT INTO ParentOf VALUES ('Helen', 'Diego');
delete from ParentOf where child = 'Eve';




-----------------Ejercicio N2---------------------
----a)
CREATE TABLE Employee (
    ID int,
    salary int
);

CREATE TABLE Manager (
    mID int,
    eID int
);

CREATE TABLE Project (
    name text,
    mgrID int
);


----b)
INSERT INTO Employee VALUES (123, 100);
INSERT INTO Employee VALUES (234, 90);
INSERT INTO Employee VALUES (345, 80);
INSERT INTO Employee VALUES (456, 70);
INSERT INTO Employee VALUES (567, 60);

INSERT INTO Manager VALUES (123, 234);
INSERT INTO Manager VALUES (234, 345);
INSERT INTO Manager VALUES (234, 456);
INSERT INTO Manager VALUES (345, 567);

INSERT INTO Project VALUES ('X', 123);




-----c) Consulta recursiva para obtener el costo total del proyecto X
WITH RECURSIVE Superior AS (
    SELECT * FROM Manager
    UNION
    SELECT S.mID, M.eID 
    FROM Superior S, Manager M
    WHERE S.eID = M.mID
)
SELECT SUM(salary) 
FROM Employee 
WHERE ID IN (
    SELECT mgrID FROM Project WHERE name = 'X'
    UNION
    SELECT eID FROM Project, Superior
    WHERE Project.name = 'X' AND Project.mgrID = Superior.mID
);


-----d)
---i
INSERT INTO Project VALUES ('Y', 234);

WITH RECURSIVE Superior AS (
    SELECT * FROM Manager
    UNION
    SELECT S.mID, M.eID 
    FROM Superior S, Manager M
    WHERE S.eID = M.mID
)
SELECT SUM(salary) 
FROM Employee 
WHERE ID IN (
    SELECT mgrID FROM Project WHERE name = 'Y'
    UNION
    SELECT eID FROM Project, Superior
    WHERE Project.name = 'Y' AND Project.mgrID = Superior.mID
);

---ii
INSERT INTO Project VALUES ('Z', 345);

WITH RECURSIVE Superior AS (
    SELECT * FROM Manager
    UNION
    SELECT S.mID, M.eID 
    FROM Superior S, Manager M
    WHERE S.eID = M.mID
)
SELECT SUM(salary) 
FROM Employee 
WHERE ID IN (
    SELECT mgrID FROM Project WHERE name = 'Z'
    UNION
    SELECT eID FROM Project, Superior
    WHERE Project.name = 'Z' AND Project.mgrID = Superior.mID
);



---iii
---- Gerente General
INSERT INTO Employee VALUES (10, 150); 
---- Subgerente 
INSERT INTO Employee VALUES (20, 100);
---- Subgerente
INSERT INTO Employee VALUES (30, 100);
---- Asistente   
INSERT INTO Employee VALUES (21, 60);
---- Asistente    
INSERT INTO Employee VALUES (22, 60); 
---- Abogado   
INSERT INTO Employee VALUES (31, 80);   
---- Traductor 
INSERT INTO Employee VALUES (32, 40);   




---- Gerente General -> Subgerente 20
INSERT INTO Manager VALUES (10, 20);   
---- Gerente General -> Subgerente 30
INSERT INTO Manager VALUES (10, 30);    
---- Subgerente 20 -> Asistente 21
INSERT INTO Manager VALUES (20, 21);   
---- Subgerente 20 -> Asistente 22
INSERT INTO Manager VALUES (20, 22); 
---- Subgerente 30 -> Abogado 31   
INSERT INTO Manager VALUES (30, 31); 
---- Abogado 31 -> Traductor 32   
INSERT INTO Manager VALUES (31, 32);    

INSERT INTO Project VALUES ('W', 10);-- El proyecto 'W'

WITH RECURSIVE Superior AS (
    SELECT * FROM Manager
    UNION
    SELECT S.mID, M.eID 
    FROM Superior S, Manager M
    WHERE S.eID = M.mID
)
SELECT SUM(salary) 
FROM Employee 
WHERE ID IN (
    SELECT mgrID FROM Project WHERE name = 'W'
    UNION
    SELECT eID FROM Project, Superior
    WHERE Project.name = 'W' AND Project.mgrID = Superior.mID
);


-----------------Ejercicio N3---------------------

----a)
CREATE TABLE Flight (
    orig TEXT,   -- Origen
    dest TEXT,   -- Destino
    airline TEXT,  -- Aerolínea que opera el "vuelo"
    cost INT
);

----b)
INSERT INTO Flight VALUES ('A', 'ORD', 'United', 200);
INSERT INTO Flight VALUES ('ORD', 'B', 'American', 100);
INSERT INTO Flight VALUES ('A', 'PHX', 'Southwest', 25);
INSERT INTO Flight VALUES ('PHX', 'LAS', 'Southwest', 30);
INSERT INTO Flight VALUES ('LAS', 'CMH', 'Frontier', 60);
INSERT INTO Flight VALUES ('CMH', 'B', 'Frontier', 60);
INSERT INTO Flight VALUES ('A', 'B', 'JetBlue', 195);

----c)
WITH RECURSIVE Route(orig, dest, total) AS (
    SELECT orig, dest, cost AS total FROM Flight
    UNION
    SELECT R.orig, F.dest, cost+total AS total
    FROM Route R, Flight F
    WHERE R.dest = F.orig
)
SELECT * FROM Route
WHERE orig = 'A' AND dest = 'B';


----d)
--i)
WITH RECURSIVE Route(orig, dest, total) AS (
    SELECT orig, dest, cost AS total FROM Flight
    UNION
    SELECT R.orig, F.dest, cost+total AS total
    FROM Route R, Flight F
    WHERE R.dest = F.orig
)
SELECT * FROM Route
WHERE orig = 'A' AND dest = 'B';

--ii)
WITH RECURSIVE Route(orig, dest, total) AS (
    SELECT orig, dest, cost AS total FROM Flight
    UNION
    SELECT R.orig, F.dest, cost+total AS total
    FROM Route R, Flight F
    WHERE R.dest = F.orig
)
SELECT * FROM Route
WHERE orig = 'A' AND dest = 'B'
ORDER BY total ASC
LIMIT 1;

--iii)

WITH RECURSIVE Route(orig, dest, total) AS (
    SELECT orig, dest, cost AS total FROM Flight
    UNION
    SELECT R.orig, F.dest, cost+total AS total
    FROM Route R, Flight F
    WHERE R.dest = F.orig
)
SELECT * FROM Route
WHERE orig = 'A' AND dest = 'B'
ORDER BY total DESC
LIMIT 1;


-----------------Ejercicio N4---------------------
----a)
INSERT INTO Flight VALUES ('CMH', 'PHX', 'Frontier', 80);
delete from fligth where orig='CMH' AND dest='PHX';

select * from flight;
----b)no funciona y por q
WITH RECURSIVE Route(orig, dest, total) AS (
    SELECT orig, dest, cost AS total FROM Flight
    UNION
    SELECT R.orig, F.dest, cost + total AS total
    FROM Route R, Flight F
    WHERE R.dest = F.orig
)
SELECT * FROM Route
WHERE orig = 'A' AND dest = 'B';

----c)no funciona y por q
WITH RECURSIVE Route(orig, dest, total) AS (
    SELECT orig, dest, cost AS total FROM Flight
    UNION
    SELECT R.orig, F.dest, cost + total AS total
    FROM Route R, Flight F
    WHERE R.dest = F.orig AND cost + total < ALL (
        SELECT total FROM Route R2
        WHERE R2.orig = R.orig AND R2.dest = F.dest
    )
)
SELECT * FROM Route
WHERE orig = 'A' AND dest = 'B';

----d)¿Qué sucede al ejecutar las secciones ‘Solución 3.1’ y ‘Solución 3.2’?

---solucion 3.1
WITH RECURSIVE Route(orig, dest, total) AS (
    
    SELECT orig, dest, cost AS total FROM Flight
    UNION
    SELECT R.orig, F.dest, cost+total AS total
    FROM Route R, Flight F
    WHERE R.dest = F.orig
)
SELECT * FROM Route
WHERE orig = 'A' AND dest = 'B' LIMIT 20;

---solucion 3.2
WITH RECURSIVE Route(orig, dest, total) AS (
    SELECT orig, dest, cost AS total FROM Flight
    UNION
    SELECT R.orig, F.dest, cost+total AS total
    FROM Route R, Flight F
    WHERE R.dest = F.orig
)
SELECT MIN(total) FROM Route
WHERE orig = 'A' AND dest = 'B' LIMIT 20;
----e) ‘Solución 4.1’, ‘Solución 4.2’ y ‘Solución 4.3’, por cada una de ellas responda: public
---¿Funciona?, ¿Por qué funciona, indique específicamente?

---solucion 4.1
WITH RECURSIVE Route(orig, dest, total, length) AS (
    SELECT orig, dest, cost AS total, 1 FROM Flight
    UNION
    SELECT R.orig, F.dest, cost+total AS total, R.length+1 AS length
    FROM Route R, Flight F
    WHERE R.length < 10 AND R.dest = F.orig
)
SELECT * FROM Route
WHERE orig = 'A' AND dest = 'B';

---solucion 4.2
WITH RECURSIVE Route(orig, dest, total, length) AS (
    SELECT orig, dest, cost AS total, 1 FROM Flight
    UNION
    SELECT R.orig, F.dest, cost+total AS total, R.length+1 AS length
    FROM Route R, Flight F
    WHERE R.length < 10 AND R.dest = F.orig
)
SELECT MIN(total) FROM Route
WHERE orig = 'A' AND dest = 'B';

---solucion 4.3
WITH RECURSIVE Route(orig, dest, total, length) AS (
    SELECT orig, dest, cost AS total, 1 FROM Flight
    UNION
    SELECT R.orig, F.dest, cost+total AS total, R.length+1 AS length
    FROM Route R, Flight F
    WHERE R.length < 100000 AND R.dest = F.orig
)
SELECT MIN(total) FROM Route
WHERE orig = 'A' AND dest = 'B';
