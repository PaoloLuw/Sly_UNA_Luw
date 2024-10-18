-- Active: 1726693191808@@127.0.0.1@3306

USE big_university;
------ Problema 1 --------

DELIMITER //
CREATE FUNCTION DEPT_COUNT(deptName VARCHAR(20))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE instructor_count INT;
  SELECT COUNT(*) INTO instructor_count
  FROM instructor
  WHERE dept_name = deptName;
  
  RETURN instructor_count;
END //
DELIMITER ;
DROP FUNCTION DEPT_COUNT;

SELECT dept_name, DEPT_COUNT(dept_name)
FROM department
WHERE dept_name LIKE 'A%';



------ Problema 2 --------

DROP FUNCTION course_count;


DELIMITER //
CREATE FUNCTION course_count(student_id VARCHAR(5))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE num_courses INT;

    SELECT COUNT(*)
    INTO num_courses
    FROM takes
    WHERE ID = student_id;

    RETURN num_courses;
END//
DELIMITER ;

SELECT s.dept_name, s.name, course_count(s.ID) AS nro_cursos
FROM student s
WHERE s.dept_name LIKE '%Sci%'
AND s.name LIKE 'S%'
HAVING nro_cursos = 13;

------ Problema 3 --------

DELIMITER //
CREATE FUNCTION time_sum(slot_id VARCHAR(4))
    RETURNS TIME 
    READS SQL DATA
    BEGIN
        DECLARE total_time TIME;
        SELECT SEC_TO_TIME(SUM(TIME_TO_SEC(TIMEDIFF(end_time, start_time))))
        INTO total_time
        FROM time_slot
        WHERE time_slot_id = slot_id;
        RETURN total_time;
    END //
DELIMITER ;

SELECT s.building, ts.day, SEC_TO_TIME(SUM(TIME_TO_SEC(TIMEDIFF(ts.end_time, ts.start_time)))) AS total_time
FROM section s
JOIN time_slot ts ON s.time_slot_id = ts.time_slot_id
WHERE s.building = 'Taylor'
AND ts.day = 'M'
GROUP BY s.building, ts.day;


------ Problema 4 --------
drop procedure proc_getCoursesOf;
DELIMITER //

CREATE PROCEDURE proc_getCoursesOf(
    IN person_id VARCHAR(5),
    IN person_type INT
)
BEGIN
    IF person_type = 1 THEN
        SELECT t.course_id, t.sec_id, t.semester, t.year
        FROM takes t
        WHERE t.ID = person_id;
    
    ELSEIF person_type = 2 THEN
        SELECT te.course_id, te.sec_id, te.semester, te.year
        FROM teaches te
        WHERE te.ID = person_id;
    ELSE
        SELECT 'Entrada no valida.' AS ErrorMessage;
    END IF;
    
END //
DELIMITER ;

CALL proc_getCoursesOf(1000, 1);
CALL proc_getCoursesOf(3199, 2);



------ Problema 5 --------



DELIMITER //

CREATE FUNCTION grade_to_number(grade VARCHAR(2))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE numeric_value INT;
    CASE grade
        WHEN 'A+' THEN SET numeric_value = 10;
        WHEN 'A'  THEN SET numeric_value = 9;
        WHEN 'A-' THEN SET numeric_value = 8;
        WHEN 'B+' THEN SET numeric_value = 7;
        WHEN 'B'  THEN SET numeric_value = 7;
        WHEN 'B-' THEN SET numeric_value = 7;
        WHEN 'C+' THEN SET numeric_value = 5;
        WHEN 'C'  THEN SET numeric_value = 5;
        WHEN 'C-' THEN SET numeric_value = 5;
        WHEN 'D+' THEN SET numeric_value = 3;
        WHEN 'D'  THEN SET numeric_value = 3;
        WHEN 'D-' THEN SET numeric_value = 3;
        WHEN 'E+' THEN SET numeric_value = 2;
        WHEN 'E'  THEN SET numeric_value = 2;
        WHEN 'E-' THEN SET numeric_value = 2;
        WHEN 'F+' THEN SET numeric_value = 1;
        WHEN 'F'  THEN SET numeric_value = 1;
        WHEN 'F-' THEN SET numeric_value = 1;
        ELSE SET numeric_value = NULL;  -- Manejo de casos no reconocidos
    END CASE;
    RETURN numeric_value;
END //

DELIMITER ;


DROP PROCEDURE proc_getRankingCourse;
DELIMITER //

CREATE PROCEDURE proc_getRankingCourse(
    IN course_id VARCHAR(8),
    IN year_taken INT
)
BEGIN
    SELECT s.name, t.grade, grade_to_number(t.grade) AS numeric_grade
    FROM takes t
    JOIN student s ON t.ID = s.ID
    WHERE t.course_id = course_id
      AND t.year = year_taken
      AND t.grade IS NOT NULL
    ORDER BY numeric_grade DESC;
END //

DELIMITER ;


CALL proc_getRankingCourse("239", 2006);


------ Problema 6 --------

DELIMITER //

CREATE TRIGGER budget_updated
AFTER UPDATE ON instructor
FOR EACH ROW
BEGIN
    DECLARE salary_increase DECIMAL(8,2);
    
    IF NEW.salary > OLD.salary THEN
        SET salary_increase = (NEW.salary - OLD.salary) / OLD.salary;
        UPDATE department
        SET budget = budget + (budget * salary_increase)
        WHERE dept_name = NEW.dept_name;
    END IF;
END //

DELIMITER ;
SELECT budget FROM department WHERE dept_name = 'Astronomy';---ANTES 617253.94
UPDATE instructor SET salary = 89070.08 WHERE ID = 43779;
SELECT budget FROM department WHERE dept_name = 'Astronomy';

SELECT budget FROM department WHERE dept_name = 'Accounting';--441840.92
UPDATE instructor SET salary = 30000 WHERE ID = 14365;
SELECT budget FROM department WHERE dept_name = 'Accounting';


------ Problema 7 --------

----RESUELTO EN EL GESTOR DE BASE DE DATOS POSTGRES

------ Problema 8 --------



WITH StudentGrades AS (
    SELECT s.name, t.grade
    FROM takes t
    JOIN student s ON t.ID = s.ID
    WHERE t.course_id = '200'
      AND t.year = 2002
      AND s.name LIKE 'C%'
)
SELECT 
    DENSE_RANK() OVER (ORDER BY grade DESC) AS rank_nota,
    name,
    grade AS nota
FROM StudentGrades;



------ Problema 9 --------
TRUNCATE TABLE auditoria;


CREATE TABLE auditoria (
    table_name VARCHAR(50),
    id_eliminado VARCHAR(10),
    fecha DATE,
    hora TIME,
    usuario VARCHAR(50)
);


INSERT INTO student (ID, name, dept_name, tot_cred)
VALUES ('99999', 'Paolo Luna', 'Comp. Sci.', 100);
INSERT INTO instructor (ID, name, dept_name, salary)
VALUES ('99998', 'Ana Sly', 'Comp. Sci.', 75000);



DELIMITER //

CREATE TRIGGER after_student_delete
AFTER DELETE ON student
FOR EACH ROW
BEGIN
    INSERT INTO auditoria (table_name, id_eliminado, fecha, hora, usuario)
    VALUES ('student', OLD.ID, CURDATE(), CURTIME(), USER());
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER after_instructor_delete
AFTER DELETE ON instructor
FOR EACH ROW
BEGIN
    INSERT INTO auditoria (table_name, id_eliminado, fecha, hora, usuario)
    VALUES ('instructor', OLD.ID, CURDATE(), CURTIME(), USER());
END //

DELIMITER ;



DELETE FROM student WHERE ID = '99999';
DELETE FROM instructor WHERE ID = '99998';

SELECT * FROM auditoria ;


------ Problema 10 --------

SELECT H.name
FROM Highschooler H
JOIN Likes L ON H.ID = L.ID2
WHERE L.ID1 = 1510;
