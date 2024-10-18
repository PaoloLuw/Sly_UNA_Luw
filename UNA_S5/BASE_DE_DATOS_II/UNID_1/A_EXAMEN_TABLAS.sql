CREATE DATABASE IF NOT EXISTS big_university;
USE big_university;
CREATE TABLE department (
  dept_name varchar(20) NOT NULL,
  building varchar(15) DEFAULT NULL,
  budget decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (dept_name)
);

CREATE TABLE classroom (
  building varchar(15) NOT NULL,
  room_number varchar(7) NOT NULL,
  capacity decimal(4,0) DEFAULT NULL,
  PRIMARY KEY (building,room_number)
);

CREATE TABLE time_slot (
  time_slot_id varchar(4) NOT NULL,
  day varchar(1) NOT NULL,
  start_time time NOT NULL,
  end_time time DEFAULT NULL,
  PRIMARY KEY (time_slot_id,day,start_time)
);

CREATE TABLE instructor (
  ID varchar(5) NOT NULL,
  name varchar(20) NOT NULL,
  dept_name varchar(20) DEFAULT NULL,
  salary decimal(8,2) DEFAULT NULL,
  PRIMARY KEY (ID),
  KEY dept_name (dept_name),
  CONSTRAINT instructor_ibfk_1 FOREIGN KEY (dept_name) REFERENCES department (dept_name) ON DELETE SET NULL
);

CREATE TABLE student (
  ID varchar(5) NOT NULL,
  name varchar(20) NOT NULL,
  dept_name varchar(20) DEFAULT NULL,
  tot_cred decimal(3,0) DEFAULT NULL,
  PRIMARY KEY (ID),
  KEY dept_name (dept_name),
  CONSTRAINT student_ibfk_1 FOREIGN KEY (dept_name) REFERENCES department (dept_name) ON DELETE SET NULL
);

CREATE TABLE advisor (
  s_ID varchar(5) NOT NULL,
  i_ID varchar(5) DEFAULT NULL,
  PRIMARY KEY (s_ID),
  KEY i_ID (i_ID),
  CONSTRAINT advisor_ibfk_1 FOREIGN KEY (i_ID) REFERENCES instructor (ID) ON DELETE SET NULL,
  CONSTRAINT advisor_ibfk_2 FOREIGN KEY (s_ID) REFERENCES student (ID) ON DELETE CASCADE
);

CREATE TABLE course (
  course_id varchar(8) NOT NULL,
  title varchar(50) DEFAULT NULL,
  dept_name varchar(20) DEFAULT NULL,
  credits decimal(2,0) DEFAULT NULL,
  PRIMARY KEY (course_id),
  KEY dept_name (dept_name),
  CONSTRAINT course_ibfk_1 FOREIGN KEY (dept_name) REFERENCES department (dept_name) ON DELETE SET NULL
);

CREATE TABLE prereq (
  course_id varchar(8) NOT NULL,
  prereq_id varchar(8) NOT NULL,
  PRIMARY KEY (course_id,prereq_id),
  KEY prereq_id (prereq_id),
  CONSTRAINT prereq_ibfk_1 FOREIGN KEY (course_id) REFERENCES course (course_id) ON DELETE CASCADE,
  CONSTRAINT prereq_ibfk_2 FOREIGN KEY (prereq_id) REFERENCES course (course_id)
);

CREATE TABLE section (
  course_id varchar(8) NOT NULL,
  sec_id varchar(8) NOT NULL,
  semester varchar(6) NOT NULL,
  year decimal(4,0) NOT NULL,
  building varchar(15) DEFAULT NULL,
  room_number varchar(7) DEFAULT NULL,
  time_slot_id varchar(4) DEFAULT NULL,
  PRIMARY KEY (course_id,sec_id,semester,year),
  KEY building (building,room_number),
  CONSTRAINT section_ibfk_1 FOREIGN KEY (course_id) REFERENCES course (course_id) ON DELETE CASCADE,
  CONSTRAINT section_ibfk_2 FOREIGN KEY (building, room_number) REFERENCES classroom (building, room_number) ON DELETE SET NULL
);

CREATE TABLE takes (
  ID varchar(5) NOT NULL,
  course_id varchar(8) NOT NULL,
  sec_id varchar(8) NOT NULL,
  semester varchar(6) NOT NULL,
  year decimal(4,0) NOT NULL,
  grade varchar(2) DEFAULT NULL,
  PRIMARY KEY (ID,course_id,sec_id,semester,year),
  KEY course_id (course_id,sec_id,semester,year),
  CONSTRAINT takes_ibfk_1 FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES section (course_id, sec_id, semester, year) ON DELETE CASCADE,
  CONSTRAINT takes_ibfk_2 FOREIGN KEY (ID) REFERENCES student (ID) ON DELETE CASCADE
);

CREATE TABLE teaches (
  ID varchar(5) NOT NULL,
  course_id varchar(8) NOT NULL,
  sec_id varchar(8) NOT NULL,
  semester varchar(6) NOT NULL,
  year decimal(4,0) NOT NULL,
  PRIMARY KEY (ID,course_id,sec_id,semester,year),
  KEY course_id (course_id,sec_id,semester,year),
  CONSTRAINT teaches_ibfk_1 FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES section (course_id, sec_id, semester, year) ON DELETE CASCADE,
  CONSTRAINT teaches_ibfk_2 FOREIGN KEY (ID) REFERENCES instructor (ID) ON DELETE CASCADE
);