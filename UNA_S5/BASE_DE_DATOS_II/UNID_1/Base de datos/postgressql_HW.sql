-- Active: 1727702261358@@127.0.0.1@5432
CREATE DATABASE recursividad;
\c recursividad;
CREATE TABLE ParentOf (
    parent TEXT,
    child TEXT
);

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




salidas esperadas 
Dave
Eve
Carol
Alice
Bob



SELECT a FROM Ancestor WHERE d = 'George';
INSERT INTO ParentOf VALUES ('George', 'Eve');
INSERT INTO ParentOf VALUES ('Frank', 'George');
INSERT INTO ParentOf VALUES ('Helen', 'Frank');
