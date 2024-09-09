-- Active: 1725235843069@@127.0.0.1@2702

CREATE DATABASE universitysql;
USE universitysql;

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

INSERT INTO department VALUES ('Biology','Watson',90000.00),('Comp. Sci.','Taylor',100000.00),('Elec. Eng.','Taylor',85000.00),('Finance','Painter',120000.00),('History','Painter',50000.00),('Music','Packard',80000.00),('Physics','Watson',70000.00);
INSERT INTO classroom VALUES ('Packard','101',500),('Painter','514',10),('Taylor','3128',70),('Watson','100',30),('Watson','120',50);
INSERT INTO time_slot VALUES ('A','F','08:00:00','08:50:00'),('A','M','08:00:00','08:50:00'),('A','W','08:00:00','08:50:00'),('B','F','09:00:00','09:50:00'),('B','M','09:00:00','09:50:00'),('B','W','09:00:00','09:50:00'),('C','F','11:00:00','11:50:00'),('C','M','11:00:00','11:50:00'),('C','W','11:00:00','11:50:00'),('D','F','13:00:00','13:50:00'),('D','M','13:00:00','13:50:00'),('D','W','13:00:00','13:50:00'),('E','R','10:30:00','11:45:00'),('E','T','10:30:00','11:45:00'),('F','R','14:30:00','15:45:00'),('F','T','14:30:00','15:45:00'),('G','F','16:00:00','16:50:00'),('G','M','16:00:00','16:50:00'),('G','W','16:00:00','16:50:00'),('H','W','10:00:00','12:30:00');
INSERT INTO instructor VALUES ('10101','Srinivasan','Comp. Sci.',65000.00),('12121','Wu','Finance',90000.00),('15151','Mozart','Music',40000.00),('22222','Einstein','Physics',95000.00),('32343','El Said','History',60000.00),('33456','Gold','Physics',87000.00),('45565','Katz','Comp. Sci.',75000.00),('58583','Califieri','History',62000.00),('76543','Singh','Finance',80000.00),('76766','Crick','Biology',72000.00),('83821','Brandt','Comp. Sci.',92000.00),('98345','Kim','Elec. Eng.',80000.00);
INSERT INTO student VALUES ('00128','Zhang','Comp. Sci.',102),('12345','Shankar','Comp. Sci.',32),('19991','Brandt','History',80),('23121','Chavez','Finance',110),('44553','Peltier','Physics',56),('45678','Levy','Physics',46),('54321','Williams','Comp. Sci.',54),('55739','Sanchez','Music',38),('70557','Snow','Physics',0),('76543','Brown','Comp. Sci.',58),('76653','Aoi','Elec. Eng.',60),('98765','Bourikas','Elec. Eng.',98),('98988','Tanaka','Biology',120);
INSERT INTO advisor VALUES ('12345','10101'),('44553','22222'),('45678','22222'),('00128','45565'),('76543','45565'),('23121','76543'),('98988','76766'),('76653','98345'),('98765','98345');
INSERT INTO course VALUES ('BIO-101','Intro. to Biology','Biology',4),('BIO-301','Genetics','Biology',4),('BIO-399','Computational Biology','Biology',3),('CS-101','Intro. to Computer Science','Comp. Sci.',4),('CS-190','Game Design','Comp. Sci.',4),('CS-315','Robotics','Comp. Sci.',3),('CS-319','Image Processing','Comp. Sci.',3),('CS-347','Database System Concepts','Comp. Sci.',3),('EE-181','Intro. to Digital Systems','Comp. Sci.',3),('FIN-201','Investment Banking','Finance',3),('HIS-351','World History','History',3),('MU-199','Music Video Production','Music',3),('PHY-101','Physical Principles','Physics',4);
INSERT INTO prereq VALUES ('BIO-301','BIO-101'),('BIO-399','BIO-101'),('CS-190','CS-101'),('CS-315','CS-101'),('CS-319','CS-101'),('CS-347','CS-101'),('EE-181','PHY-101');
INSERT INTO section VALUES ('BIO-101','1','Summer',2009,'Painter','514','B'),('BIO-301','1','Summer',2010,'Painter','514','A'),('CS-101','1','Fall',2009,'Packard','101','H'),('CS-101','1','Spring',2010,'Packard','101','F'),('CS-190','1','Spring',2009,'Taylor','3128','E'),('CS-190','2','Spring',2009,'Taylor','3128','A'),('CS-315','1','Spring',2010,'Watson','120','D'),('CS-319','1','Spring',2010,'Watson','100','B'),('CS-319','2','Spring',2010,'Taylor','3128','C'),('CS-347','1','Fall',2009,'Taylor','3128','A'),('EE-181','1','Spring',2009,'Taylor','3128','C'),('FIN-201','1','Spring',2010,'Packard','101','B'),('HIS-351','1','Spring',2010,'Painter','514','C'),('MU-199','1','Spring',2010,'Packard','101','D'),('PHY-101','1','Fall',2009,'Watson','100','A');
INSERT INTO takes VALUES ('00128','CS-101','1','Fall',2009,'A'),('00128','CS-347','1','Fall',2009,'A-'),('12345','CS-101','1','Fall',2009,'C'),('12345','CS-190','2','Spring',2009,'A'),('12345','CS-315','1','Spring',2010,'A'),('12345','CS-347','1','Fall',2009,'A'),('19991','HIS-351','1','Spring',2010,'B'),('23121','FIN-201','1','Spring',2010,'C+'),('44553','PHY-101','1','Fall',2009,'B-'),('45678','CS-101','1','Fall',2009,'F'),('45678','CS-101','1','Spring',2010,'B+'),('45678','CS-319','1','Spring',2010,'B'),('54321','CS-101','1','Fall',2009,'A-'),('54321','CS-190','2','Spring',2009,'B+'),('55739','MU-199','1','Spring',2010,'A-'),('76543','CS-101','1','Fall',2009,'A'),('76543','CS-319','2','Spring',2010,'A'),('76653','EE-181','1','Spring',2009,'C'),('98765','CS-101','1','Fall',2009,'C-'),('98765','CS-315','1','Spring',2010,'B'),('98988','BIO-101','1','Summer',2009,'A'),('98988','BIO-301','1','Summer',2010,NULL);
INSERT INTO teaches VALUES ('76766','BIO-101','1','Summer',2009),('76766','BIO-301','1','Summer',2010),('10101','CS-101','1','Fall',2009),('45565','CS-101','1','Spring',2010),('83821','CS-190','1','Spring',2009),('83821','CS-190','2','Spring',2009),('10101','CS-315','1','Spring',2010),('45565','CS-319','1','Spring',2010),('83821','CS-319','2','Spring',2010),('10101','CS-347','1','Fall',2009),('98345','EE-181','1','Spring',2009),('12121','FIN-201','1','Spring',2010),('32343','HIS-351','1','Spring',2010),('15151','MU-199','1','Spring',2010),('22222','PHY-101','1','Fall',2009);