SELECT COUNT(*) AS total_productos FROM takes;


SELECT 
    (SELECT COUNT(*) FROM prereq) AS prereq_count,
    (SELECT COUNT(*) FROM time_slot) AS time_slot_count,
    (SELECT COUNT(*) FROM advisor) AS advisor_count,
    (SELECT COUNT(*) FROM takes) AS takes_count,
    (SELECT COUNT(*) FROM student) AS student_count,
    (SELECT COUNT(*) FROM teaches) AS teaches_count,
    (SELECT COUNT(*) FROM section) AS section_count,
    (SELECT COUNT(*) FROM instructor) AS instructor_count,
    (SELECT COUNT(*) FROM course) AS course_count,
    (SELECT COUNT(*) FROM department) AS department_count,
    (SELECT COUNT(*) FROM classroom) AS classroom_count;


SELECT * FROM prereq;
SELECT * FROM time_slot;
SELECT * FROM advisor;
SELECT * FROM takes;
SELECT * FROM student;
SELECT * FROM teaches;
SELECT * FROM section;
SELECT * FROM instructor;
SELECT * FROM course;
SELECT * FROM department;
SELECT * FROM classroom;
