/* The University Database from the textbook "Database System Concepts" by 
A. Silberschatz, H.F. Korth and S. Sudarshan, McGraw-Hill International Edition, 
Sixth Edition, 2011.*/

/* UniversityDB.sql is a script for creating tables for the University database of the book 
   and populating them with data */

# Names of tables and attributes are changed slightly to improve the naming standard!

# If the tables already exists, then they are deleted!
use test;

DROP TABLE IF EXISTS PreReq;
DROP TABLE IF EXISTS TimeSlot;
DROP TABLE IF EXISTS Advisor;
DROP TABLE IF EXISTS Takes;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Teaches;
DROP TABLE IF EXISTS Section;
DROP TABLE IF EXISTS Instructor;

DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Classroom;

# Table creation! Create Tables with Foreign Keys after the referenced tables are created!

CREATE TABLE Classroom
	(Building		VARCHAR(15),
	 Room			VARCHAR(7),
	 Capacity		DECIMAL(4,0),
	 PRIMARY KEY(Building, Room)
	);

CREATE TABLE Department
	(DeptName		VARCHAR(20), 
	 Building		VARCHAR(15), 
	 Budget		    DECIMAL(12,2),
	 PRIMARY KEY(DeptName)
	);

CREATE TABLE Course
	(CourseID		VARCHAR(8), 
	 Title			VARCHAR(50), 
	 DeptName		VARCHAR(20),
	 Credits		DECIMAL(2,0),
	 PRIMARY KEY(CourseID),
	  FOREIGN KEY(DeptName) REFERENCES Department(DeptName) ON DELETE SET NULL
	);

CREATE TABLE Instructor
	(InstID			VARCHAR(5), 
	 InstName		VARCHAR(20) NOT NULL, 
	 DeptName		VARCHAR(20), 
	 Salary			DECIMAL(8,2),
	 PRIMARY KEY (InstID),
	 FOREIGN KEY(DeptName) REFERENCES Department(DeptName) ON DELETE SET NULL
	);

CREATE TABLE Section
	(CourseID		VARCHAR(8), 
     SectionID		VARCHAR(8),
	 Semester		ENUM('Fall','Winter','Spring','Summer'), 
	 StudyYear		YEAR, 
	 Building		VARCHAR(15),
	 Room			VARCHAR(7),
	 TimeSlotID		VARCHAR(4),
	 PRIMARY KEY(CourseID, SectionID, Semester, StudyYear),
	 FOREIGN KEY(CourseID) REFERENCES Course(CourseID)
		ON DELETE CASCADE,
	 FOREIGN KEY(Building, Room) REFERENCES Classroom(Building, Room) ON DELETE SET NULL
	);

CREATE TABLE Teaches
	(InstID			VARCHAR(5), 
	 CourseID		VARCHAR(8),
	 SectionID		VARCHAR(8), 
	 Semester		ENUM('Fall','Winter','Spring','Summer'),
	 StudyYear		YEAR,
	 PRIMARY KEY(InstID, CourseID, SectionID, Semester, StudyYear),
	 FOREIGN KEY(CourseID, SectionID, Semester, StudyYear) REFERENCES Section(CourseID, SectionID, Semester, StudyYear) 
     ON DELETE CASCADE,
	 FOREIGN KEY(InstID) REFERENCES Instructor(InstID) ON DELETE CASCADE
	);

CREATE TABLE Student
	(StudID			VARCHAR(5), 
	 StudName		VARCHAR(20) NOT NULL, 
	 Birth 			DATE,
	 DeptName		VARCHAR(20),
     TotCredits		DECIMAL(3,0),
	 PRIMARY KEY(StudID),
	 FOREIGN KEY(DeptName) REFERENCES Department(DeptName) ON DELETE SET NULL
	);

CREATE TABLE Takes
	(StudID			VARCHAR(5), 
	 CourseID		VARCHAR(8),
	 SectionID		VARCHAR(8), 
	 Semester		ENUM('Fall','Winter','Spring','Summer'),
	 StudyYear		YEAR,
	 Grade		    VARCHAR(2),
	 PRIMARY KEY(StudID, CourseID, SectionID, Semester, StudyYear),
	 FOREIGN KEY(CourseID, SectionID, Semester, StudyYear) REFERENCES Section(CourseID, SectionID, Semester, StudyYear) 
		ON DELETE CASCADE,
	 FOREIGN KEY(StudID) REFERENCES Student(StudID) ON DELETE CASCADE
	);

CREATE TABLE Advisor
	(StudID			VARCHAR(5),
	 InstID			VARCHAR(5),
	 PRIMARY KEY(StudID),
	 FOREIGN KEY(InstID) REFERENCES Instructor(InstID) ON DELETE SET NULL,
	 FOREIGN KEY(StudID) REFERENCES Student(StudID) ON DELETE CASCADE
	);

CREATE TABLE TimeSlot
	(TimeSlotID 	VARCHAR(4),
	 DayCode		ENUM('M','T','W','R','F','S','U'),
	 StartTime		TIME,
	 EndTime		TIME,
	 PRIMARY KEY(TimeSlotID, DayCode, StartTime)
	);

CREATE TABLE PreReq
	(CourseID		VARCHAR(8), 
	 PreReqID		VARCHAR(8),
	 PRIMARY KEY(CourseID, PreReqID),
	 FOREIGN KEY(CourseID) REFERENCES Course(CourseID) ON DELETE CASCADE,
	 FOREIGN KEY(PreReqID) REFERENCES Course(CourseID)
);


# Insertion of table rows one by one!

INSERT Classroom VALUES('Packard','101','500');
INSERT Classroom VALUES('Painter','514','10');
INSERT Classroom VALUES('Taylor','3128','70');
INSERT Classroom VALUES('Watson','100','30');
INSERT Classroom VALUES('Watson','120','50');

# Insertion of multiple table rows in one go!

INSERT Department VALUES
('Biology','Watson','90000'),
('Comp. Sci.','Taylor','100000'),
('Elec. Eng.','Taylor','85000'),
('Finance','Painter','120000'),
('History','Painter','50000'),
('Music','Packard','80000'),
('Physics','Watson','70000');

INSERT Course VALUES
('BIO-101','Intro. to Biology','Biology','4'),
('BIO-301','Genetics','Biology','4'),
('BIO-399','Computational Biology','Biology','3'),
('CS-101','Intro. to Computer Science','Comp. Sci.','4'),
('CS-190','Game Design','Comp. Sci.','4'),
('CS-315','Robotics','Comp. Sci.','3'),
('CS-319','Image Processing','Comp. Sci.','3'),
('CS-347','Database System Concepts','Comp. Sci.','3'),
('EE-181','Intro. to Digital Systems','Elec. Eng.','3'),
('FIN-201','Investment Banking','Finance','3'),
('HIS-351','World History','History','3'),
('MU-199','Music Video Production','Music','3'),
('PHY-101','Physical Principles','Physics','4');

INSERT Instructor VALUES
('10101','Srinivasan','Comp. Sci.','65000'),
('12121','Wu','Finance','90000'),
('15151','Mozart','Music','40000'),
('22222','Einstein','Physics','95000'),
('32343','El Said','History','60000'),
('33456','Gold','Physics','87000'),
('45565','Katz','Comp. Sci.','75000'),
('58583','Califieri','History','62000'),
('76543','Singh','Finance','80000'),
('76766','Crick','Biology','72000'),
('83821','Brandt','Comp. Sci.','92000'),
('98345','Kim','Elec. Eng.','80000');

INSERT Section VALUES
('BIO-101','1','Summer','2009','Painter','514','B'),
('BIO-301','1','Summer','2010','Painter','514','A'),
('CS-101','1','Fall','2009','Packard','101','H'),
('CS-101','1','Spring','2010','Packard','101','F'),
('CS-190','1','Spring','2009','Taylor','3128','E'),
('CS-190','2','Spring','2009','Taylor','3128','A'),
('CS-315','1','Spring','2010','Watson','120','D'),
('CS-319','1','Spring','2010','Watson','100','B'),
('CS-319','2','Spring','2010','Taylor','3128','C'),
('CS-347','1','Fall','2009','Taylor','3128','A'),
('EE-181','1','Spring','2009','Taylor','3128','C'),
('FIN-201','1','Spring','2010','Packard','101','B'),
('HIS-351','1','Spring','2010','Painter','514','C'),
('MU-199','1','Spring','2010','Packard','101','D'),
('PHY-101','1','Fall','2009','Watson','100','A');

INSERT Teaches VALUES
('10101','CS-101','1','Fall','2009'),
('10101','CS-315','1','Spring','2010'),
('10101','CS-347','1','Fall','2009'),
('12121','FIN-201','1','Spring','2010'),
('15151','MU-199','1','Spring','2010'),
('22222','PHY-101','1','Fall','2009'),
('32343','HIS-351','1','Spring','2010'),
('45565','CS-101','1','Spring','2010'),
('45565','CS-319','1','Spring','2010'),
('76766','BIO-101','1','Summer','2009'),
('76766','BIO-301','1','Summer','2010'),
('83821','CS-190','1','Spring','2009'),
('83821','CS-190','2','Spring','2009'),
('83821','CS-319','2','Spring','2010'),
('98345','EE-181','1','Spring','2009');

INSERT Student VALUES
('00128','Zhang','1992-04-18','Comp. Sci.','102'),
('12345','Shankar','1995-12-06','Comp. Sci.','32'),
('19991','Brandt','1993-05-24','History','80'),
('23121','Chavez','1992-04-18','Finance','110'),
('44553','Peltier','1995-10-18','Physics','56'),
('45678','Levy','1995-08-01','Physics','46'),
('54321','Williams','1995-02-28','Comp. Sci.','54'),
('55739','Sanchez','1995-06-04','Music','38'),
('70557','Snow','1995-11-22','Physics','0'),
('76543','Brown','1994-03-05','Comp. Sci.','58'),
('76653','Aoi','1993-09-18','Elec. Eng.','60'),
('98765','Bourikas','1992-09-23','Elec. Eng.','98'),
('98988','Tanaka','1992-06-02','Biology','120');

INSERT Takes VALUES
('00128','CS-101','1','Fall','2009','A'),
('00128','CS-347','1','Fall','2009','A-'),
('12345','CS-101','1','Fall','2009','C'),
('12345','CS-190','2','Spring','2009','A'),
('12345','CS-315','1','Spring','2010','A'),
('12345','CS-347','1','Fall','2009','A'),
('19991','HIS-351','1','Spring','2010','B'),
('23121','FIN-201','1','Spring','2010','C+'),
('44553','PHY-101','1','Fall','2009','B-'),
('45678','CS-101','1','Fall','2009','F'),
('45678','CS-101','1','Spring','2010','B+'),
('45678','CS-319','1','Spring','2010','B'),
('54321','CS-101','1','Fall','2009','A-'),
('54321','CS-190','2','Spring','2009','B+'),
('55739','MU-199','1','Spring','2010','A-'),
('76543','CS-101','1','Fall','2009','A'),
('76543','CS-319','2','Spring','2010','A'),
('76653','EE-181','1','Spring','2009','C'),
('98765','CS-101','1','Fall','2009','C-'),
('98765','CS-315','1','Spring','2010','B'),
('98988','BIO-101','1','Summer','2009','A'),
('98988','BIO-301','1','Summer','2010', NULL);

INSERT Advisor VALUES
('00128','45565'),
('12345','10101'),
('23121','76543'),
('44553','22222'),
('45678','22222'),
('76543','45565'),
('76653','98345'),
('98765','98345'),
('98988','76766');

INSERT TimeSlot VALUES
('A','M','8:00','8:50'),
('A','W','8:00','8:50'),
('A','F','8:00','8:50'),
('B','M','9:00','9:50'),
('B','W','9:00','9:50'),
('B','F','9:00','9:50'),
('C','M','11:00','11:50'),
('C','W','11:00','11:50'),
('C','F','11:00','11:50'),
('D','M','13:00','13:50'),
('D','W','13:00','13:50'),
('D','F','13:00','13:50'),
('E','T','10:30','11:45'),
('E','R','10:30','11:45'),
('F','T','14:30','15:45'),
('F','R','14:30','15:45'),
('G','M','16:00','16:50'),
('G','W','16:00','16:50'),
('G','F','16:00','16:50'),
('H','W','10:00','12:30');

INSERT PreReq VALUES
('BIO-301','BIO-101'),
('BIO-399','BIO-101'),
('CS-190','CS-101'),
('CS-315','CS-101'),
('CS-319','CS-101'),
('CS-347','CS-101'),
('EE-181','PHY-101');

# 4.1.1 NATURAL JOIN Use the University Database and display a list of all students with ID, name, department and
# building. The list should be ordered by the students IDs
SELECT StudID, StudName, DeptName, Building
FROM Student NATURAL JOIN Department
ORDER BY StudID;
# 4.1.2 Display a list of all instructors, showing their ID, name and the number of sections that they have
# taught. Argue for the choice of join type
SELECT InstID, InstName, COUNT(SectionID) AS
SectionsTought
FROM Instructor NATURAL LEFT OUTER JOIN Teaches
GROUP BY InstID, InstName;
# 4.1.3 Nested SELECT alternative Write the same query as in the Exercise above, but use a scalar subquery (i.e. a SELECT statement
# that returns a single value for a number of rows) within another SELECT statement.
SELECT InstID, InstName,
(SELECT COUNT(*) FROM Teaches WHERE Teaches.InstID
= Instructor.InstID) AS SectionsTought FROM Instructor;
# 4.1.4 Create a VIEW Called SeniorStudents(StudID, StudName) of students with a TotCredits > 100
DROP VIEW IF EXISTS SeniorStudents;
CREATE VIEW SeniorStudents AS
SELECT StudID, StudName FROM Student
WHERE TotCredits > 100;
SELECT * FROM SeniorStudents;
# 4.1.5 Create a VIEW Called Creditview(StudyYear, SumCredits) giving the total number of credits taken by students in each year.
DROP VIEW IF EXISTS Creditview;
CREATE VIEW Creditview(StudyYear, SumCredits) AS
(SELECT StudyYear, SUM(Credits) FROM Takes
NATURAL JOIN Course GROUP BY StudyYear);
SELECT * FROM Creditview;
# 4.2.1 JOINs Display the list of all departments, with the total number of instructors in each department.
# Note:
# Department(DeptName, Building, Budget)
# Instructor(InstID, InstName, DeptName, Salary)
SELECT DeptName, COUNT(InstID) AS TotNumInst
FROM Department NATURAL LEFT OUTER JOIN Instructor
GROUP BY DeptName;
# 4.2.2 JOINs
# List titles of those courses that are prereqs of other courses. Make the solution without using WHERE.
SELECT DISTINCT Title  FROM Course JOIN PreReq ON 
PreReq.PreReqID=Course.CourseID;
# 4.2.3 JOINs
# List for each course its id and the number of courses that is is a prereq for. 
SELECT Course.CourseID,COUNT(PreReq.CourseID) FROM Course LEFT JOIN PreReq
ON PreReq.PreReqID = Course.CourseID 
GROUP BY Course.CourseID;
# 4.2.4 JOINs
# Display the list of active students, along with titles of the courses they
# take. The list should be sorted by the student names. (A student is active
# means: is taking a course.
SELECT StudName, Title FROM Student NATURAL JOIN Takes
JOIN Course Using(CourseID)
ORDER BY StudName;
# 4.2.5 Referential Actions
# Consider the CREATE TABLE commands for the university database in the
# appendix. Discuss why the referential ON DELETE actions have been chosen as they are
DELETE FROM Course WHERE CourseID = 'BIO-301';
# 4.2.6 CREATE a View
# Called 
# SeniorInstructors(InstID, InstName, DeptName)
# of instructors with a salary > 80000
# Note:
# Instructor(InstID, InstName, DeptName, Salary)
DROP VIEW IF EXISTS SeniorInstructors;
CREATE VIEW SeniorInstructors(InstID, InstName, DeptName) AS
SELECT InstID, InstName, DeptName FROM Instructor 
WHERE Salary > 80000;
SELECT * FROM SeniorInstructors;
# 4.2.7 Authorization
# a) Connect to the database as Database Administrator (root) and create the users Karen, Linda and Susan with the generic password
# SetPassword. Please observe that user names are case sensitive
DROP USER IF EXISTS 'Karen';
DROP USER IF EXISTS 'Linda';
DROP USER IF EXISTS 'Susan';
CREATE USER 'Karen' IDENTIFIED BY 'SetPassword';
CREATE USER 'Linda' IDENTIFIED BY 'SetPassword';
CREATE USER 'Susan' IDENTIFIED BY 'SetPassword';

SELECT user FROM mysql.user; -- shows users
# b) Then grant SELECT to Karen and ALL to Linda and Susan to a database under your DBA control.
GRANT SELECT ON University.* TO 'Karen';
GRANT ALL ON University.* TO 'Linda';
GRANT ALL ON University.* TO 'Susan';

SHOW GRANTS FOR 'Karen';
SHOW GRANTS FOR 'Linda';
SHOW GRANTS FOR 'Susan';

# h) Close the connection and then connect as DBA (root) and drop users Karen, Linda and Susan.
DROP USER 'Karen';
DROP USER 'Linda';
DROP USER 'Susan';

