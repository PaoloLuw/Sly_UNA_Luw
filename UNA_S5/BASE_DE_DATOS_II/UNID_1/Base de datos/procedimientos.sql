-- Active: 1725235843069@@127.0.0.1@2702

USE universitysql;

------- ejercicio 1 ----------
DELIMITER //
create procedure proc_dept_count (IN dept_name varchar(20), OUT d_count int)
begin
select count(*) into d_count from instructor where instructor.dept_name=dept_name;
end//
DELIMITER;

call proc_dept_count('Comp. Sci.',@dcount);
select @dcount;

call proc_dept_count('Finance.',@dcount);
select @dcount;
------- ejercicio 2 ----------
DELIMITER //
create procedure proc_crearDepartamento(
IN dept_name VARCHAR(20),
IN idInstructor VARCHAR(5),
IN nameInstructor Varchar(20)
)
begin
declare salario Decimal(8,2);
    select min(salary) into salario from instructor;
    insert INTO department values(dept_name, 'Watson', 50000.00);
    insert INTO instructor values(idInstructor, nameInstructor, dept_name, salario);
end//
DELIMITER;

drop procedure proc_crearDepartamento;
CALL proc_crearDepartamento('Medicine', '20201', 'Gardy');
CALL proc_crearDepartamento('Education', '30301', 'Laydi');

select * from department where dept_name ='Medicine';
select * from department where dept_name ='Education';
SELECT * FROM instructor WHERE id = '20201';
SELECT * FROM instructor WHERE id = '30301';


------- ejercicio 3 ----------

DELIMITER //
create procedure proc_addCursoDepartamento(
IN dept_name VARCHAR(20),
IN id_curso VARCHAR(8),
IN nom_curso VARCHAR(50),
IN creditos decimal(2,0)
)
begin
declare existeDept boolean;
select count(*)>0 into existeDept from department d where d.dept_name=dept_name; if 
existeDept then
    insert into course values(id_curso,nom_curso, dept_name, creditos);
end if; 
end//
DELIMITER;


call proc_addCursoDepartamento('Medicine', 'MED-101', 'Anatomy', 3)

call proc_addCursoDepartamento('Nursing', 'MED-102', 'Anatomy', 3)

call proc_addCursoDepartamento('Medicine', 'MED-103', 'Math', 3)

call proc_addCursoDepartamento('Medicine', 'MED-104', 'Biology', 3)

call proc_addCursoDepartamento('Medicine', 'MED-105', 'Laboratory I', 2)

call proc_addCursoDepartamento('Medicine', 'MED-106', 'Chemestry', 4)


select * from course where dept_name = 'Medicine';
select * from course where dept_name = 'Nursing';

-------- ejercicio 4 --------------------


CREATE PROCEDURE proc_addEstudianteDepartamento(
    IN dept_name VARCHAR(20),
    IN nom_estudiante VARCHAR(20)
)
BEGIN
    DECLARE new_id INT;
    
    SELECT COUNT(*) INTO new_id FROM student;

    SET new_id = 60000 + new_id + 1;

    INSERT INTO student (ID, name, dept_name, tot_cred)
    VALUES (CAST(new_id AS CHAR(5)), nom_estudiante, dept_name, 12);
END //

DELIMITER ;

CALL proc_addEstudianteDepartamento('Medicine', 'Fernando');
CALL proc_addEstudianteDepartamento('Medicine', 'Betsy');
CALL proc_addEstudianteDepartamento('Medicine', 'Sandy');
SELECT * FROM student WHERE dept_name = 'Medicine';

-------- ejercicio 5 --------------------
DROP PROCEDURE IF EXISTS proc_estadisticasDepartamento;

DELIMITER //

CREATE PROCEDURE proc_estadisticasDepartamento(
    IN dept_name VARCHAR(20),
    OUT num_cursos INT,
    OUT num_instructores INT,
    OUT num_estudiantes INT
)
BEGIN
    SELECT COUNT(*) INTO num_cursos
    FROM course s
    WHERE s.dept_name = dept_name;

    SELECT COUNT(*) INTO num_instructores
    FROM instructor t
    WHERE t.dept_name = dept_name;

    SELECT COUNT(*) INTO num_estudiantes
    FROM student v
    WHERE v.dept_name = dept_name;
END //

DELIMITER ;


CALL proc_estadisticasDepartamento('Comp. Sci.', @n_cursos, @n_instructores, @n_estudiantes);
select 'Com. Sci', @n_cursos, @n_instructores, @n_estudiantes;
SELECT @n_cursos AS n_cursos, @n_instructores AS n_instructores, @n_estudiantes AS n_estudiantes;

CALL proc_estadisticasDepartamento('Finance', @n_cursos, @n_instructores, @n_estudiantes);
select 'Finance', @n_cursos, @n_instructores, @n_estudiantes;


DELIMITER ;

-------- ejercicio 6 --------------------
DELIMITER //

CREATE PROCEDURE proc_getCoursesOfStudent(
    IN id_student VARCHAR(5)
)
BEGIN
    SELECT c.course_id, c.title
    FROM course c
    WHERE c.course_id IN (
        SELECT t.course_id
        FROM takes t
        WHERE t.ID = id_student
    );
END //

DELIMITER ;
CALL proc_getCoursesOfStudent('98988');
CALL proc_getCoursesOfStudent('12345');

-------- ejercicio 7 --------------------
DELIMITER //

CREATE PROCEDURE proc_getAsesoradosOf(
    IN id_instructor VARCHAR(5)
)
BEGIN
    SELECT s.ID, s.name
    FROM student s
    INNER JOIN advisor a ON s.ID = a.s_ID
    WHERE a.i_ID = id_instructor;
END //

DELIMITER ;

CALL proc_getAsesoradosOf('22222');
CALL proc_getAsesoradosOf('10101');

-------- ejercicio 8 --------------------

DROP PROCEDURE IF EXISTS proc_getRankingCourse;

DELIMITER //

CREATE PROCEDURE proc_getRankingCourse(
    IN course_id VARCHAR(8),     
    IN matriculation_year INT    
)
BEGIN
    SELECT 
        s.name AS student_name,
        t.grade AS letter_grade,
        CASE t.grade
            WHEN 'A' THEN 9
            WHEN 'B' THEN 8
            WHEN 'C' THEN 5
            WHEN 'F' THEN 1
            WHEN 'A-' THEN 8
            WHEN 'B-' THEN 8
            WHEN 'C-' THEN 5
            WHEN 'F-' THEN 1
            ELSE 0
        END AS numeric_grade
    FROM 
        takes t
    JOIN 
        student s ON t.ID = s.ID
    WHERE 
        t.course_id = course_id
        AND t.year = matriculation_year
    ORDER BY 
        numeric_grade DESC;
END //

DELIMITER ;


CALL proc_getRankingCourse('CS-101', 2009);
CALL proc_getRankingCourse('CS-315', 2010);

-------- ejercicio 9 --------------------DELIMITER //
DROP PROCEDURE IF EXISTS proc_getStatsCourse;

DELIMITER //

CREATE PROCEDURE proc_getStatsCourse(
    IN course_id VARCHAR(8),
    IN matriculation_year INT
)
BEGIN
    SELECT 
        AVG(CASE grade
            WHEN 'A' THEN 9
            WHEN 'B' THEN 7
            WHEN 'C' THEN 5
            WHEN 'F' THEN 1
            WHEN 'A-' THEN 8
            WHEN 'B-' THEN 7
            WHEN 'C-' THEN 5
            WHEN 'F-' THEN 1
            WHEN 'A+' THEN 9
            WHEN 'B+' THEN 7
            WHEN 'C+' THEN 5
            WHEN 'F+' THEN 1
            ELSE 0
        END) AS Prom,
        MAX(CASE grade
            WHEN 'A' THEN 9
            WHEN 'B' THEN 7
            WHEN 'C' THEN 5
            WHEN 'F' THEN 1
            WHEN 'A-' THEN 8
            WHEN 'B-' THEN 7
            WHEN 'C-' THEN 5
            WHEN 'F-' THEN 1
            WHEN 'A+' THEN 9
            WHEN 'B+' THEN 7
            WHEN 'C+' THEN 5
            WHEN 'F+' THEN 1
            ELSE 0
        END) AS mayor,
        MIN(CASE grade
            WHEN 'A' THEN 9
            WHEN 'B' THEN 7
            WHEN 'C' THEN 5
            WHEN 'F' THEN 1
            WHEN 'A-' THEN 8
            WHEN 'B-' THEN 7
            WHEN 'C-' THEN 5
            WHEN 'F-' THEN 1
            WHEN 'A+' THEN 9
            WHEN 'B+' THEN 7
            WHEN 'C+' THEN 5
            WHEN 'F+' THEN 1
            ELSE 0
        END) AS menor
    FROM 
        takes p
    WHERE 
        p.course_id = course_id
        AND p.year = matriculation_year;
END //

DELIMITER ;


CALL proc_getStatsCourse('CS-101', 2009);
CALL proc_getStatsCourse('CS-315', 2010);

-------- ejercicio 10 (prueva) --------------------DELIMITER //
DROP PROCEDURE IF EXISTS proc_getNameMaxMin;

DELIMITER $$

CREATE PROCEDURE proc_getNameMaxMin(
    IN courseID VARCHAR(8),
    IN courseYear DECIMAL(4,0)
)
BEGIN
    -- Seleccionar los estudiantes con la mayor calificación
    SELECT 'Mayor' AS Tipo, s.name, t.grade, 
        CASE 
            WHEN t.grade = 'A' THEN 9
            WHEN t.grade = 'B' THEN 8
            WHEN t.grade = 'C' THEN 7
            WHEN t.grade = 'D' THEN 6
            WHEN t.grade = 'E' THEN 5
            WHEN t.grade = 'F' THEN 1
            ELSE 0 
        END AS Nota
    FROM takes t
    JOIN student s ON t.ID = s.ID
    WHERE t.course_id = courseID AND t.year = courseYear
    AND (CASE 
            WHEN t.grade = 'A' THEN 9
            WHEN t.grade = 'B' THEN 8
            WHEN t.grade = 'C' THEN 7
            WHEN t.grade = 'D' THEN 6
            WHEN t.grade = 'E' THEN 5
            WHEN t.grade = 'F' THEN 1
            ELSE 0 
        END) = (
            -- Subconsulta para encontrar la mayor nota
            SELECT MAX(
                CASE 
                    WHEN t2.grade = 'A' THEN 9
                    WHEN t2.grade = 'B' THEN 8
                    WHEN t2.grade = 'C' THEN 7
                    WHEN t2.grade = 'D' THEN 6
                    WHEN t2.grade = 'E' THEN 5
                    WHEN t2.grade = 'F' THEN 1
                    ELSE 0 
                END)
            FROM takes t2
            WHERE t2.course_id = courseID AND t2.year = courseYear
        )
    UNION ALL
    -- Seleccionar los estudiantes con la menor calificación
    SELECT 'Menor' AS Tipo, s.name, t.grade, 
        CASE 
            WHEN t.grade = 'A' THEN 9
            WHEN t.grade = 'B' THEN 8
            WHEN t.grade = 'C' THEN 7
            WHEN t.grade = 'D' THEN 6
            WHEN t.grade = 'E' THEN 5
            WHEN t.grade = 'F' THEN 1
            ELSE 0 
        END AS Nota
    FROM takes t
    JOIN student s ON t.ID = s.ID
    WHERE t.course_id = courseID AND t.year = courseYear
    AND (CASE 
            WHEN t.grade = 'A' THEN 9
            WHEN t.grade = 'B' THEN 8
            WHEN t.grade = 'C' THEN 7
            WHEN t.grade = 'D' THEN 6
            WHEN t.grade = 'E' THEN 5
            WHEN t.grade = 'F' THEN 1
            ELSE 0 
        END) = (
            -- Subconsulta para encontrar la menor nota
            SELECT MIN(
                CASE 
                    WHEN t2.grade = 'A' THEN 9
                    WHEN t2.grade = 'B' THEN 8
                    WHEN t2.grade = 'C' THEN 7
                    WHEN t2.grade = 'D' THEN 6
                    WHEN t2.grade = 'E' THEN 5
                    WHEN t2.grade = 'F' THEN 1
                    ELSE 0 
                END)
            FROM takes t2
            WHERE t2.course_id = courseID AND t2.year = courseYear
        );
END$$

DELIMITER ;

CALL proc_getNameMaxMin('CS-101', 2009);

-------- ejercicio 10 (prueva2) --------------------DELIMITER //

DELIMITER $$

CREATE PROCEDURE proc_getNameMaxMin(
    IN courseID VARCHAR(8),
    IN courseYear DECIMAL(4,0)
)
BEGIN
    -- Seleccionar los estudiantes con la mayor calificación
    SELECT 'Mayor' AS Tipo, s.name, t.grade, 
        CASE 
            WHEN t.grade = 'A' THEN 9
            WHEN t.grade = 'A+' THEN 9
            WHEN t.grade = 'A-' THEN 8
            WHEN t.grade = 'B' THEN 7
            WHEN t.grade = 'B+' THEN 7
            WHEN t.grade = 'B-' THEN 7
            WHEN t.grade = 'C' THEN 5
            WHEN t.grade = 'C+' THEN 5
            WHEN t.grade = 'C-' THEN 5
            WHEN t.grade = 'F' THEN 1
            WHEN t.grade = 'F+' THEN 1
            WHEN t.grade = 'F-' THEN 1
            ELSE 0 
        END AS Nota
    FROM takes t
    JOIN student s ON t.ID = s.ID
    WHERE t.course_id = courseID AND t.year = courseYear
    AND (CASE 
            WHEN t.grade = 'A' THEN 9
            WHEN t.grade = 'A+' THEN 9
            WHEN t.grade = 'A-' THEN 8
            WHEN t.grade = 'B' THEN 7
            WHEN t.grade = 'B+' THEN 7
            WHEN t.grade = 'B-' THEN 7
            WHEN t.grade = 'C' THEN 5
            WHEN t.grade = 'C+' THEN 5
            WHEN t.grade = 'C-' THEN 5
            WHEN t.grade = 'F' THEN 1
            WHEN t.grade = 'F+' THEN 1
            WHEN t.grade = 'F-' THEN 1
            ELSE 0 
        END) = (
            -- Subconsulta para encontrar la mayor nota
            SELECT MAX(
                CASE 
                    WHEN t2.grade = 'A' THEN 9
                    WHEN t2.grade = 'A+' THEN 9
                    WHEN t2.grade = 'A-' THEN 8
                    WHEN t2.grade = 'B' THEN 7
                    WHEN t2.grade = 'B+' THEN 7
                    WHEN t2.grade = 'B-' THEN 7
                    WHEN t2.grade = 'C' THEN 5
                    WHEN t2.grade = 'C+' THEN 5
                    WHEN t2.grade = 'C-' THEN 5
                    WHEN t2.grade = 'F' THEN 1
                    WHEN t2.grade = 'F+' THEN 1
                    WHEN t2.grade = 'F-' THEN 1
                    ELSE 0 
                END)
            FROM takes t2
            WHERE t2.course_id = courseID AND t2.year = courseYear
        )
    UNION ALL
    -- Seleccionar los estudiantes con la menor calificación
    SELECT 'Menor' AS Tipo, s.name, t.grade, 
        CASE 
            WHEN t.grade = 'A' THEN 9
            WHEN t.grade = 'A+' THEN 9
            WHEN t.grade = 'A-' THEN 8
            WHEN t.grade = 'B' THEN 7
            WHEN t.grade = 'B+' THEN 7
            WHEN t.grade = 'B-' THEN 7
            WHEN t.grade = 'C' THEN 5
            WHEN t.grade = 'C+' THEN 5
            WHEN t.grade = 'C-' THEN 5
            WHEN t.grade = 'F' THEN 1
            WHEN t.grade = 'F+' THEN 1
            WHEN t.grade = 'F-' THEN 1
            ELSE 0 
        END AS Nota
    FROM takes t
    JOIN student s ON t.ID = s.ID
    WHERE t.course_id = courseID AND t.year = courseYear
    AND (CASE 
            WHEN t.grade = 'A' THEN 9
            WHEN t.grade = 'A+' THEN 9
            WHEN t.grade = 'A-' THEN 8
            WHEN t.grade = 'B' THEN 7
            WHEN t.grade = 'B+' THEN 7
            WHEN t.grade = 'B-' THEN 7
            WHEN t.grade = 'C' THEN 5
            WHEN t.grade = 'C+' THEN 5
            WHEN t.grade = 'C-' THEN 5
            WHEN t.grade = 'F' THEN 1
            WHEN t.grade = 'F+' THEN 1
            WHEN t.grade = 'F-' THEN 1
            ELSE 0 
        END) = (
            -- Subconsulta para encontrar la menor nota
            SELECT MIN(
                CASE 
                    WHEN t2.grade = 'A' THEN 9
                    WHEN t2.grade = 'A+' THEN 9
                    WHEN t2.grade = 'A-' THEN 8
                    WHEN t2.grade = 'B' THEN 7
                    WHEN t2.grade = 'B+' THEN 7
                    WHEN t2.grade = 'B-' THEN 7
                    WHEN t2.grade = 'C' THEN 5
                    WHEN t2.grade = 'C+' THEN 5
                    WHEN t2.grade = 'C-' THEN 5
                    WHEN t2.grade = 'F' THEN 1
                    WHEN t2.grade = 'F+' THEN 1
                    WHEN t2.grade = 'F-' THEN 1
                    ELSE 0 
                END)
            FROM takes t2
            WHERE t2.course_id = courseID AND t2.year = courseYear
        );
END$$

DELIMITER ;
CALL proc_getNameMaxMin('CS-101', 2009);
CALL proc_getNameMaxMin('CS-315', 2010);


-------- ejercicio 11 --------------------DELIMITER //
DROP PROCEDURE IF EXISTS proc_getAboutCourse;

DELIMITER $$

CREATE PROCEDURE proc_getAboutCourse(
    IN courseID VARCHAR(8),
    IN courseYear DECIMAL(4,0),
    IN action INT
)
BEGIN
    IF action = 1 THEN
        -- Llamar a proc_getRankingCourse
        SELECT s.name, t.grade,
            CASE
                WHEN t.grade = 'A' THEN 9
                WHEN t.grade = 'A+' THEN 9
                WHEN t.grade = 'A-' THEN 8
                WHEN t.grade = 'B' THEN 7
                WHEN t.grade = 'B+' THEN 7
                WHEN t.grade = 'B-' THEN 7
                WHEN t.grade = 'C' THEN 5
                WHEN t.grade = 'C+' THEN 5
                WHEN t.grade = 'C-' THEN 5
                WHEN t.grade = 'F' THEN 1
                WHEN t.grade = 'F+' THEN 1
                WHEN t.grade = 'F-' THEN 1
                ELSE 0
            END AS Nota
        FROM takes t
        JOIN student s ON t.ID = s.ID
        WHERE t.course_id = courseID AND t.year = courseYear;
    ELSEIF action = 2 THEN
        -- Llamar a proc_getStatsCourse
        SELECT AVG(CASE
                    WHEN t.grade = 'A' THEN 9
                    WHEN t.grade = 'A+' THEN 9
                    WHEN t.grade = 'A-' THEN 8
                    WHEN t.grade = 'B' THEN 7
                    WHEN t.grade = 'B+' THEN 7
                    WHEN t.grade = 'B-' THEN 7
                    WHEN t.grade = 'C' THEN 5
                    WHEN t.grade = 'C+' THEN 5
                    WHEN t.grade = 'C-' THEN 5
                    WHEN t.grade = 'F' THEN 1
                    WHEN t.grade = 'F+' THEN 1
                    WHEN t.grade = 'F-' THEN 1
                    ELSE 0
                END) AS Promedio,
               MAX(CASE
                    WHEN t.grade = 'A' THEN 9
                    WHEN t.grade = 'A+' THEN 9
                    WHEN t.grade = 'A-' THEN 8
                    WHEN t.grade = 'B' THEN 7
                    WHEN t.grade = 'B+' THEN 7
                    WHEN t.grade = 'B-' THEN 7
                    WHEN t.grade = 'C' THEN 5
                    WHEN t.grade = 'C+' THEN 5
                    WHEN t.grade = 'C-' THEN 5
                    WHEN t.grade = 'F' THEN 1
                    WHEN t.grade = 'F+' THEN 1
                    WHEN t.grade = 'F-' THEN 1
                    ELSE 0
                END) AS Mayor,
               MIN(CASE
                    WHEN t.grade = 'A' THEN 9
                    WHEN t.grade = 'A+' THEN 9
                    WHEN t.grade = 'A-' THEN 8
                    WHEN t.grade = 'B' THEN 7
                    WHEN t.grade = 'B+' THEN 7
                    WHEN t.grade = 'B-' THEN 7
                    WHEN t.grade = 'C' THEN 5
                    WHEN t.grade = 'C+' THEN 5
                    WHEN t.grade = 'C-' THEN 5
                    WHEN t.grade = 'F' THEN 1
                    WHEN t.grade = 'F+' THEN 1
                    WHEN t.grade = 'F-' THEN 1
                    ELSE 0
                END) AS Menor
        FROM takes t
        WHERE t.course_id = courseID AND t.year = courseYear;
    ELSEIF action = 3 THEN
        -- Llamar a proc_getNameMaxMin

    SELECT 'Mayor' AS Tipo, s.name, t.grade, 
        CASE 
            WHEN t.grade = 'A' THEN 9
            WHEN t.grade = 'A+' THEN 9
            WHEN t.grade = 'A-' THEN 8
            WHEN t.grade = 'B' THEN 7
            WHEN t.grade = 'B+' THEN 7
            WHEN t.grade = 'B-' THEN 7
            WHEN t.grade = 'C' THEN 5
            WHEN t.grade = 'C+' THEN 5
            WHEN t.grade = 'C-' THEN 5
            WHEN t.grade = 'F' THEN 1
            WHEN t.grade = 'F+' THEN 1
            WHEN t.grade = 'F-' THEN 1
            ELSE 0 
        END AS Nota
    FROM takes t
    JOIN student s ON t.ID = s.ID
    WHERE t.course_id = courseID AND t.year = courseYear
    AND (CASE 
            WHEN t.grade = 'A' THEN 9
            WHEN t.grade = 'A+' THEN 9
            WHEN t.grade = 'A-' THEN 8
            WHEN t.grade = 'B' THEN 7
            WHEN t.grade = 'B+' THEN 7
            WHEN t.grade = 'B-' THEN 7
            WHEN t.grade = 'C' THEN 5
            WHEN t.grade = 'C+' THEN 5
            WHEN t.grade = 'C-' THEN 5
            WHEN t.grade = 'F' THEN 1
            WHEN t.grade = 'F+' THEN 1
            WHEN t.grade = 'F-' THEN 1
            ELSE 0 
        END) = (
            -- Subconsulta para encontrar la mayor nota
            SELECT MAX(
                CASE 
                    WHEN t2.grade = 'A' THEN 9
                    WHEN t2.grade = 'A+' THEN 9
                    WHEN t2.grade = 'A-' THEN 8
                    WHEN t2.grade = 'B' THEN 7
                    WHEN t2.grade = 'B+' THEN 7
                    WHEN t2.grade = 'B-' THEN 7
                    WHEN t2.grade = 'C' THEN 5
                    WHEN t2.grade = 'C+' THEN 5
                    WHEN t2.grade = 'C-' THEN 5
                    WHEN t2.grade = 'F' THEN 1
                    WHEN t2.grade = 'F+' THEN 1
                    WHEN t2.grade = 'F-' THEN 1
                    ELSE 0 
                END)
            FROM takes t2
            WHERE t2.course_id = courseID AND t2.year = courseYear
        )
    UNION ALL
    -- Seleccionar los estudiantes con la menor calificación
    SELECT 'Menor' AS Tipo, s.name, t.grade, 
        CASE 
            WHEN t.grade = 'A' THEN 9
            WHEN t.grade = 'A+' THEN 9
            WHEN t.grade = 'A-' THEN 8
            WHEN t.grade = 'B' THEN 7
            WHEN t.grade = 'B+' THEN 7
            WHEN t.grade = 'B-' THEN 7
            WHEN t.grade = 'C' THEN 5
            WHEN t.grade = 'C+' THEN 5
            WHEN t.grade = 'C-' THEN 5
            WHEN t.grade = 'F' THEN 1
            WHEN t.grade = 'F+' THEN 1
            WHEN t.grade = 'F-' THEN 1
            ELSE 0 
        END AS Nota
    FROM takes t
    JOIN student s ON t.ID = s.ID
    WHERE t.course_id = courseID AND t.year = courseYear
    AND (CASE 
            WHEN t.grade = 'A' THEN 9
            WHEN t.grade = 'A+' THEN 9
            WHEN t.grade = 'A-' THEN 8
            WHEN t.grade = 'B' THEN 7
            WHEN t.grade = 'B+' THEN 7
            WHEN t.grade = 'B-' THEN 7
            WHEN t.grade = 'C' THEN 5
            WHEN t.grade = 'C+' THEN 5
            WHEN t.grade = 'C-' THEN 5
            WHEN t.grade = 'F' THEN 1
            WHEN t.grade = 'F+' THEN 1
            WHEN t.grade = 'F-' THEN 1
            ELSE 0 
        END) = (
            -- Subconsulta para encontrar la menor nota
            SELECT MIN(
                CASE 
                    WHEN t2.grade = 'A' THEN 9
                    WHEN t2.grade = 'A+' THEN 9
                    WHEN t2.grade = 'A-' THEN 8
                    WHEN t2.grade = 'B' THEN 7
                    WHEN t2.grade = 'B+' THEN 7
                    WHEN t2.grade = 'B-' THEN 7
                    WHEN t2.grade = 'C' THEN 5
                    WHEN t2.grade = 'C+' THEN 5
                    WHEN t2.grade = 'C-' THEN 5
                    WHEN t2.grade = 'F' THEN 1
                    WHEN t2.grade = 'F+' THEN 1
                    WHEN t2.grade = 'F-' THEN 1
                    ELSE 0 
                END)
            FROM takes t2
            WHERE t2.course_id = courseID AND t2.year = courseYear
        );
    END IF;
END$$


CALL proc_getAboutCourse('CS-315', 2010, 1);
CALL proc_getAboutCourse('CS-101', 2009, 2);
CALL proc_getAboutCourse('CS-101', 2009, 3);

-------- ejercicio 12 (prueva2) --------------------DELIMITER //

DELIMITER $$

CREATE PROCEDURE proc_getAboutCourse_v2(
    IN courseID VARCHAR(8),
    IN courseYear DECIMAL(4,0),
    IN action INT
)
BEGIN
    IF action = 1 THEN
        CALL proc_getRankingCourse(courseID, courseYear);
    ELSEIF action = 2 THEN
        CALL proc_getStatsCourse(courseID, courseYear);
    ELSEIF action = 3 THEN
        CALL proc_getNameMaxMin(courseID, courseYear);
    END IF;
END$$

DELIMITER ;
CALL proc_getAboutCourse_v2('CS-315', 2010, 1);
CALL proc_getAboutCourse_v2('CS-101', 2009, 2);
CALL proc_getAboutCourse_v2('CS-101', 2009, 3);


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