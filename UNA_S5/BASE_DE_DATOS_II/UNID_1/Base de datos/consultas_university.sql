-- Active: 1725235843069@@127.0.0.1@2702

CREATE DATABASE universitysql;
USE universitysql;


--- ejercicio 8 -----
SELECT 
    ID,
    CASE semester
        WHEN 'Fall' THEN 'Otoño'
        WHEN 'Spring' THEN 'Primavera'
        WHEN 'Summer' THEN 'Verano'
        WHEN 'Winter' THEN 'Invierno'
        ELSE semester
    END AS semestre
FROM 
    teaches
WHERE 
    year = 2009;




DELIMITER //
CREATE FUNCTION time_sum(time_slot_id_param VARCHAR(4))
RETURNS TIME
DETERMINISTIC
BEGIN
    DECLARE total_time TIME;
    -- Calcular la suma total del tiempo
    SELECT SEC_TO_TIME(SUM(TIME_TO_SEC(TIMEDIFF(end_time, start_time))))
    INTO total_time
    FROM time_slot
    WHERE time_slot_id = time_slot_id_param;

    RETURN total_time;
END //
DELIMITER ;

DROP FUNCTION IF EXISTS time_sum;




--- showing all table from university -----
SELECT * FROM department;
SELECT * FROM classroom;
SELECT * FROM time_slot;
SELECT * FROM instructor;
SELECT * FROM student;
SELECT * FROM advisor;
SELECT * FROM course;
SELECT * FROM prereq;
SELECT * FROM section;
SELECT * FROM takes;
SELECT * FROM teaches;
--------------------------------------------------------------------------------------------------------
DELIMITER //
create procedure name_procedure(IN parametro_1 int, PUT paramentr0_2 int) -- si es de entrada
    begin

    end //
DELIMITER;

declare variable_name;
call name_procedure (12, @variable_name);
select @variable_name;
drop procedure name_procedure;

--- necesita ser llamado explicitamente-----------------------------------------------------------------



create procedure name_procedure(OUT parametro_1 int) -- si es de entrada


------------------------------------------------- all ejercicios-----------------------------------------------------------------

    #ejercicio 1
    DELIMITER //
    create function dept_count(dept_name varchar(20))
        returns int
        DETERMINISTIC
        BEGIN
            declare d_count int; set d_count=0;
            select count(*) into d_count from instructor where instructor.dept_name=dept_name;
        return d_count;
    end//
    DELIMITER;    
    
    select dept_name,budget from department where dept_count(dept_name)>2;



#ejercicio 2
DELIMITER //
create function budget_level(budget decimal(12,2))
returns varchar(20)
    DETERMINISTIC
    BEGIN
        declare budgetlevel VARCHAR(20);
        IF budget<60000 THEN
            set budgetlevel='PLATINUM';
        elseif (budget>=60000 and budget<=90000) THEN
            set budgetlevel='SILVER';
        elseif budget>90000 THEN
            set budgetlevel = 'GOLD';
        end if;
    return budgetlevel;
end//
DELIMITER ;

select dept_name, budget_level(budget)
from department;


SELECT dept_name, budget 
FROM department 
WHERE Binary budget_level(budget) LIKE 'GOLD';


                    #ejercicio3 
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
        ELSE SET numeric_value = NULL;  -- Maneja el caso de calificaciones no reconocidas
    END CASE;
    RETURN numeric_value;
END//
DELIMITER ;
SELECT ID, sum(grade_to_number(grade)) as Nota 
from takes GROUP BY ID;

#ejercicio 4
SELECT 
    time_slot_id AS ID, 
    start_time, 
    end_time
FROM 
    time_slot
WHERE 
    HOUR(TIMEDIFF(end_time, start_time)) >= 2;

                        #ejercicio 5
DELIMITER //
CREATE FUNCTION fecha()
RETURNS VARCHAR(5)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE instructor_id VARCHAR(5);
    
    SELECT 
        i.ID INTO instructor_id
    FROM 
        instructor i
    INNER JOIN 
        teaches t ON i.ID = t.ID
    WHERE 
        (YEAR(CURDATE()) - t.year) = 14
    LIMIT 1; --para qie solo nos muestre un resultado
    
    RETURN instructor_id;
END//
DELIMITER ;
SELECT DISTINCT
    i.ID AS instructor_id,
    i.name AS instructor_name,
    (YEAR(CURDATE()) - t.year) AS years_of_service
FROM 
    instructor i
INNER JOIN 
    teaches t ON i.ID = t.ID
WHERE 
    (YEAR(CURDATE()) - t.year) = 14;


            #ejercico 6

SELECT 
    ID AS student_id,  -- 
    name,
    tot_cred AS credits,  -- 
    IF(tot_cred > 50, 'becado', 'no becado') AS status
FROM 
    student
WHERE 
    dept_name = 'Comp. Sci.';


        #ejercico 7

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

SELECT 
    s.ID AS student_id,
    s.name AS student_name,
    course_count(s.ID) AS number_of_courses
FROM 
    student s
WHERE 
    s.dept_name = 'Physics';



            --- ejercicio 8 -----
SELECT 
    ID,
    CASE semester
        WHEN 'Fall' THEN 'Otoño'
        WHEN 'Spring' THEN 'Primavera'
        WHEN 'Summer' THEN 'Verano'
        WHEN 'Winter' THEN 'Invierno'
        ELSE semester
    END AS semestre
FROM 
    teaches
WHERE 
    year = 2009;



--- ejercicio 9 ----->
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


INSERT INTO time_slot (time_slot_id, day, start_time, end_time) 
VALUES ("H", "M", "10:00:00", "10:50:00");

SELECT 
    course_id,
    time_sum(time_slot_id) AS total_time
FROM 
    section
WHERE 
    year = 2009;