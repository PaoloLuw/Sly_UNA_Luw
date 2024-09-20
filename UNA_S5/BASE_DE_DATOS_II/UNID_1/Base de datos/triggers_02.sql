-- Active: 1726693191808@@127.0.0.1@3306


INSERT INTO Highschooler (ID, name, grade) VALUES
(3000, 'Ronald', 10),
(3001, 'Miguel', 11),
(3002, 'Diego', 12),
(3003, 'Roger', 9),
(3004, 'Sebastian', 10);
delete from Highschooler where id = 3000;
delete from Highschooler where id = 3001;
delete from Highschooler where id = 3002;
delete from Highschooler where id = 3003;
delete from Highschooler where id = 3004;


USE redsocial;
delete from __ where id = ;
SELECT * FROM Highschooler;
SELECT * FROM Friend;
SELECT * FROM Likes;
DESCRIBE Highschooler;


--------------- EJERCICIOS 01 --------------------
DROP TRIGGER IF EXISTS after_insert_highschooler;

DELIMITER //

CREATE TRIGGER after_insert_highschooler
AFTER INSERT ON Highschooler
FOR EACH ROW
BEGIN
    IF NEW.name = 'Friendly' THEN
        INSERT INTO Likes (ID1, ID2)
        SELECT NEW.ID, h.ID
        FROM Highschooler h
        WHERE h.grade = NEW.grade AND h.ID != NEW.ID;
    END IF;
END; //

//

DELIMITER ;

INSERT INTO Highschooler (ID, name, grade) VALUES (2000, 'Friendly', 9);
SELECT * FROM Likes;


--------------- EJERCICIOS 02 --------------------
DROP TRIGGER IF EXISTS manage_grade;
DELIMITER //

CREATE TRIGGER manage_grade
BEFORE INSERT ON Highschooler
FOR EACH ROW
BEGIN
    IF NEW.grade IS NULL THEN
        SET NEW.grade = 9;

    ELSEIF NEW.grade < 9 OR NEW.grade > 12 THEN
        SET NEW.grade = NULL;
    END IF;
END; //

INSERT INTO Highschooler (ID, name, grade) VALUES (2002, 'Ralph', NULL);
INSERT INTO Highschooler (ID, name, grade) VALUES (2003, 'Oskar', 7);
INSERT INTO Highschooler (ID, name, grade) VALUES (2004, 'Anna', 10);
INSERT INTO Highschooler (ID, name, grade) VALUES (2005, 'Tom', 13); 

delete from Highschooler where id = xxxx;

SELECT * FROM Highschooler;

DELIMITER ;


--------------- EJERCICIOS 03 --------------------
DROP TRIGGER IF EXISTS after_delete_highschooler;

DELIMITER //

CREATE TRIGGER after_delete_highschooler
AFTER DELETE ON Highschooler
FOR EACH ROW
BEGIN
    DELETE FROM Likes WHERE ID1 = OLD.ID OR ID2 = OLD.ID;
END; //


DELETE FROM Highschooler WHERE ID = 2000;
SELECT * FROM Likes;


DELIMITER ;


--------------- EJERCICIOS 04 --------------------
DROP TRIGGER IF EXISTS after_update_likes;

DELIMITER //

CREATE TRIGGER after_update_likes
AFTER UPDATE ON Likes
FOR EACH ROW
BEGIN
    IF OLD.ID2 != NEW.ID2 THEN

        DELETE FROM Friend
        WHERE (ID1 = OLD.ID2 AND ID2 = NEW.ID2) OR (ID1 = NEW.ID2 AND ID2 = OLD.ID2);
    END IF;
END; //

DELIMITER ;
-- Likes
INSERT INTO Likes (ID1, ID2) VALUES (3002, 3001); ---Miguel LE GUSTA Ronald
INSERT INTO Friend (ID1, ID2) VALUES (3001, 3003);---Ronald and Roger
INSERT INTO Friend (ID1, ID2) VALUES (3003, 3001);---Roger and Ronald
SELECT * FROM Likes;
SELECT * FROM Friend;
DELETE FROM LIKES WHERE ID1 = 3002; 


UPDATE Likes SET ID2 = 3003 WHERE ID1 = 3002; -- Miguel ahora le gusta Roger


--------------- EJERCICIOS 05 --------------------
CREATE TRIGGER simetriaI 
AFTER INSERT ON Friend 
FOR EACH ROW 
BEGIN 
    INSERT INTO Friend VALUES (NEW.id2, NEW.id1); 
END;
CREATE TRIGGER simetriaD 
AFTER DELETE ON Friend 
FOR EACH ROW 
BEGIN 
    DELETE FROM Friend WHERE id1 = OLD.id2 AND id2 = OLD.id1; 
END;

INSERT INTO Friend (ID1, ID2) VALUES (3001, 3003);---Ronald and Roger

DROP TRIGGER simetriaI;
DROP TRIGGER simetriaD;

---El error que estás encontrando se debe a la restricción de MySQL que impide que un disparador 
---modifique la misma tabla que lo invocó. En tu caso, al intentar insertar en la tabla Friend, 
---el disparador simetriaI intenta insertar nuevamente en la misma tabla, lo que provoca este conflicto.

SELECT * FROM Friend;

--------------- EJERCICIOS 06 --------------------
DROP PROCEDURE IF EXISTS AddFriend;
DROP PROCEDURE IF EXISTS RemoveFriend;

DELIMITER //

CREATE PROCEDURE AddFriend(IN id1 INT, IN id2 INT)
BEGIN
    INSERT INTO Friend (ID1, ID2) VALUES (id1, id2);
    INSERT INTO Friend (ID1, ID2) VALUES (id2, id1);
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE RemoveFriend(IN id_1 INT, IN id_2 INT)
BEGIN
    DELETE FROM Friend WHERE ID1 = id_1 AND ID2 = id_2;
    DELETE FROM Friend WHERE ID1 = id_2 AND ID2 = id_1;
END //

DELIMITER ;
CALL AddFriend(3001, 3003);
CALL RemoveFriend(3001, 3003);
SELECT * FROM Friend;


--------------- EJERCICIOS 07 --------------------
DROP PROCEDURE IF EXISTS actualizarGrade;

DELIMITER //

CREATE PROCEDURE actualizarGrade(IN id_estudiante INT, IN nuevo_grado INT)
BEGIN
    DECLARE grado_actual INT;

    SELECT grade INTO grado_actual FROM Highschooler WHERE ID = id_estudiante;

    UPDATE Highschooler SET grade = nuevo_grado WHERE ID = id_estudiante;

    UPDATE Highschooler 
    SET grade = grade + 1
    WHERE ID IN (
        SELECT ID2 FROM Friend WHERE ID1 = id_estudiante
    );
END //
    --- AND grade = grado_actual;

DELIMITER ;
CALL actualizarGrade(1689, 10);
SELECT * FROM Highschooler;


--------------- EJERCICIOS 08 --------------------
CREATE TABLE historialLikes (
    id1 INT,
    id2 INT,
    fecha DATE,
    hora TIME,
    usuario VARCHAR(255)
);


DELIMITER //

CREATE TRIGGER historialEliminacionLikes 
AFTER DELETE ON Likes 
FOR EACH ROW 
BEGIN
    INSERT INTO historialLikes (id1, id2, fecha, hora, usuario)
    VALUES (OLD.ID1, OLD.ID2, CURDATE(), CURTIME(), CURRENT_USER());
END //

DELIMITER ;


DELETE FROM Likes WHERE ID1 = 1641 AND ID2 = 1468;

SELECT * FROM  historialLikes;