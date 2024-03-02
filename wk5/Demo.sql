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

# 5.1.1 Create a Function
DROP Function IF EXISTS LeapYear;
DROP Function IF EXISTS Age;
CREATE FUNCTION LeapYear ( vYear YEAR ) RETURNS BOOLEAN
RETURN
(vYear % 4 = 0) AND ((vYear % 100 <> 0) OR (vYear % 400 = 0));


CREATE FUNCTION Age( vDate Date ) RETURNS INTEGER
RETURN TIMESTAMPDIFF(YEAR, vDate, CURDATE());

SELECT
StudID, StudName, Birth, Age(Birth) AS Age, LeapYear(YEAR(Birth))
AS LeapYear FROM Student;
# 5.1.2 Create a Trigger
# named Instructor_After_Insert that after an instructor has been inserted into the Instructor table 
# will insert the same row in a table named InstLog with a timestamp added.
# Hint, for a timestamp NOW(6):
DROP TABLE IF EXISTS InstLog;
CREATE TABLE InstLog LIKE Instructor;
ALTER TABLE InstLog ADD LogTime TIMESTAMP(6);

DELIMITER //
CREATE TRIGGER Instructor_After_Insert
AFTER INSERT ON Instructor FOR EACH ROW
BEGIN
INSERT InstLog VALUES (	New.InstID,
						New.InstName,
						New.DeptName,
						New.Salary,
						NOW(6));
END //
DELIMITER ;

SELECT * FROM Instructor;
SELECT * FROM InstLog;
INSERT Instructor VALUES
('11001', 'Valdez', 'Comp. Sci.', 36000),
('11002', 'Koerver', 'Comp. Sci.', 36000);
SELECT * FROM Instructor;
SELECT * FROM InstLog;
# 5.1.3 Create a Procedure
# As a continuation of 5.1.2, create a procedure called InstBackup that will copy all rows from 
# the Instructor table to a table called InstOld, and thereafter also delete all rows in the table InstLog.
# The procedure should delete the rows in the old backup table (i.e. InstOld), make a new backup table with 
# the rows of the Instructor table, and delete the rows in InstLog to prepare for recording new inserts into Instructor.
Drop Table IF EXISTS InstOld;
Drop Procedure IF EXISTS InstBackUp;
Create Table InstOld LIKE Instructor;

DELIMITER //
Create procedure InstBackUp()
Begin 
	DELETE FROM InstOld;
    INSERT INTO InstOld SELECT * FROM Instructor; 
    DELETE FROM InstLog;
End//
DELIMITER ;

SELECT * FROM Instructor; 
SELECT * FROM InstOld; 
SELECT * FROM InstLog;

SET SQL_SAFE_UPDATES = 0; 
CALL InstBackup;
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM Instructor;
SELECT * FROM InstOld; # contains the Instructor rows 
SELECT * FROM InstLog; # no rows

# 5.1.4 Create a Procedure with a Transaction
# As a continuation of 5.1.3, redefine the procedure called InstBackup so that all data 
# manipulations are done within a transaction. Test it.

DROP TABLE IF EXISTS InstOld; 
DROP TABLE IF EXISTS InstLog;
DROP PROCEDURE IF EXISTS InstBackup1;

CREATE TABLE InstOld LIKE Instructor; 
CREATE TABLE InstLog LIKE Instructor; 
ALTER TABLE InstLog ADD LogTime TIMESTAMP(6);

DELIMITER //
CREATE PROCEDURE InstBackup1 () 
BEGIN
	DECLARE vSQLSTATE CHAR(5) DEFAULT '00000'; 
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	# this handler statement below ensures that
	# if an exception is raised by SQL during the transaction 
    # then vSQLSTATE will be assigned a value <> '00000‘
	# and continue
	BEGIN
		GET DIAGNOSTICS CONDITION 1 vSQLSTATE = RETURNED_SQLSTATE;
	END;
    
	START TRANSACTION;
	DELETE FROM InstOld;
	INSERT INTO InstOld SELECT * FROM Instructor; 
	DELETE FROM InstLog;
	SELECT vSQLSTATE;
	IF vSQLSTATE = '00000' THEN COMMIT;
		ELSE ROLLBACK; 
	END IF;
END // 
DELIMITER ;

# Test the procedure before and after “DROP TABLE InstLog;”.
INSERT Instructor VALUES ('10000', 'Hansen', 'Comp. Sci.', 50000); 
SELECT * FROM InstLog; # contains the new row
SET SQL_SAFE_UPDATES = 0;
CALL InstBackup1; # SELECT vSQLSTATE returns 00000 and the transaction is committed
SELECT * FROM Instructor;
SELECT * FROM InstOld; #same as Instructor 
SELECT * FROM InstLog; #no rows
DROP TABLE IF EXISTS InstLog;
CALL InstBackup1; # SELECT vSQLSTATE returns 42S02 and the transaction is rolled back as Instlog does not exist
# Remove “SELECT vSQLSTATE;” inside the procedure when testing has been done!

# 5.1.5 Create an Event
# As a continuation of 5.1.4, create an event named InstEvent that will execute the called InstBackup 
# every week the night between Saturday and Sunday at 00:00:01, first time 2016-02-21.
Drop event if exists InstEvent;

CREATE TABLE InstLog LIKE Instructor;
ALTER TABLE InstLog ADD LogTime TIMESTAMP(6);

CREATE EVENT InstEvent
	ON SCHEDULE EVERY 1 WEEK STARTS '2024-02-29 00:00:01' DO CALL InstBackup;
SET GLOBAL event_scheduler = 1;
SHOW VARIABLES LIKE 'event_scheduler';

# 5.1.6 Create an Event making a dice roll
# Design a Gambling Machine which rolls a dice every 5 seconds:
# 1. Set the GLOBAL Event_Scheduler to 1.
SET GLOBAL event_scheduler = 1;
# 2. Create a table DiceRolls with attributes RollNo and DiceEyes of data type integer.
# Hint: If you add AUTO_INCREMENT after the type of the RollNo attribute, then each time 
# you insert a new row in the table, you need only stating the value of DiceEyes – the value 
# of RollNo will automatically be generated: First time it will be 1, then 2, etc.
Drop TABLES if exists DiceRolls;
Create table DiceRolls(
	RollNo		INTEGER AUTO_INCREMENT PRIMARY KEY,
	DiceEyes	INTEGER 
);
# 3. Create an event RollDice that executes every 5 seconds and inserts a random number of 1, 2, 3, 4, 5 or 6 (DiceEyes) into table DiceRolls.
# Hint: RAND() returns a random floating-point value v in the range 0 <= v < 1.0. FLOOR() returns the largest integer value not greater than the argument.
Drop EVENT if exists RollDice;
CREATE EVENT RollDice
	ON SCHEDULE EVERY 5 SECOND
    DO INSERT DiceRolls (DiceEyes) 
		VALUES (1+FLOOR(6*RAND()));
# Make a query showing the number of times the six dice values have been played within the first 10 rolls.
SELECT DiceEyes, COUNT(DiceEyes)
FROM DiceRolls WHERE RollNo <= 10
GROUP BY DiceEyes; 
#stop event after use
SET GLOBAL event_scheduler = 0;
# 5.2.1 Create a Function
# Create a function named BuildingCapacityFct which takes as input a Building of the Classroom table in the University database 
# and returns the total capacity of the building
DROP FUNCTION IF EXISTS BuildingCapacityFct;
DELIMITER //
CREATE FUNCTION BuildingCapacityFct(vBuilding VARCHAR(20)) RETURNS INT
BEGIN
	DECLARE vCapacity INT;
    SELECT SUM(Capacity) INTO vCapacity 
    FROM Classroom WHERE Building = vBuilding;
	
    RETURN vCapacity;
END
// 
DELIMITER ;

SELECT BuildingCapacityFct('Watson');

# 5.2.2 Procedure with Error Signalling
# For the TimeSlot table of the University database, state informally constraints (besides the key constraint) that should hold between
# the values of attributes in a single row and between values of attributes of two rows. Check your suggestion with a teaching assistant before continuing.
# Create a procedure InsertTimeSlot for inserting a row into the TimeSlot table. It should signal an error in case the insertion of the new tuple leads
# to a violation of the constraints. (The procedure should not check whether the constraints already hold before the insertion.) To make the
# procedure more readable, it is advisable to define one or several auxiliary/helper functions to express the error conditions.

DROP FUNCTION IF EXISTS TimeOverlap;
DELIMITER //
CREATE FUNCTION TimeOverlap
	(fvDate  ENUM('M','T','W','R','F','S','U'),
     fvStart TIME, fvEnd TIME,
	 svDate  ENUM('M','T','W','R','F','S','U'),
     svStart TIME, svEnd TIME) RETURNS BOOLEAN
    
    RETURN
    fvDate = svDate AND
    ((fvStart <= svStart AND fvEnd >= svStart) OR (svStart <= fvStart AND svEnd >= fvStart))
//
DELIMITER ;

SELECT TimeOverlap(	'M', '08:00:00', '08:50:00', 
					'T', '07:00:00', '08:20:00');
SELECT TimeOverlap(	'M', '08:00:00', '08:50:00', 
					'T', '08:20:00', '08:50:00');
SELECT TimeOverlap(	'M', '08:00:00', '08:50:00', 
					'M', '07:00:00', '08:20:00');
SELECT TimeOverlap(	'M', '08:00:00', '08:50:00', 
					'M', '08:20:00', '08:50:00');

DROP FUNCTION IF EXISTS CheckTime;
DELIMITER //
CREATE FUNCTION CheckTime
	(vSlotID VARCHAR(4),
     fvDate  ENUM('M','T','W','R','F','S','U'),
     fvStart TIME, fvEnd TIME) RETURNS BOOLEAN
    
    RETURN EXISTS
    (SELECT * FROM TimeSlot
	 WHERE TimeSlotID = vSlotID AND
     TimeOverlap(fvDate, fvStart, fvEnd,
				 DayCode, StartTime, EndTime)
    );
//
DELIMITER ;

SELECT CheckTime('A', 'M', '08:00:00', '08:50:00');
SELECT CheckTime('A', 'M', '09:00:00', '09:50:00');

DROP PROCEDURE IF EXISTS InsertTimeSlot;
DELIMITER //
CREATE PROCEDURE InsertTimeSlot(
	IN vSlotID VARCHAR(4),
    IN vDayCode ENUM('M','T','W','R','F','S','U'),
    IN vStart TIME, 
    IN vEnd TIME)
BEGIN
	IF vEnd <= vStart
    THEN SIGNAL SQLSTATE 'A0000'
			SET MYSQL_ERRNO = 1525,
            MESSAGE_TEXT = 
            'EndTime is equal to or before StartTime';
    ELSEIF CheckTime(vSlotID, vDayCode, vStart, vEnd) 
    THEN SIGNAL SQLSTATE 'B0000'
			SET MYSQL_ERRNO = 1530,
            MESSAGE_TEXT = 
            'Time overlaps with exisiting time interval in the same time slot';
	END IF;
    INSERT TimeSlot VALUES (vSlotID, vDayCode, vStart, vEnd);
END
// DELIMITER ;

-- SELECT * FROM TimeSlot;
-- CALL InsertTimeSlot('A', 'M', '08:50:00', '08:00:00');
-- CALL InsertTimeSlot('A', 'M', '08:00:00', '08:50:00');
-- CALL InsertTimeSlot('A', 'T', '08:00:00', '08:50:00'); 
-- SELECT * FROM TimeSlot;

# 5.2.3 Trigger with Error Signalling
# Make a trigger TimeSlot_Before_Insert, which automatically raises a signal when inserting a row into TimeSlot (directly with an INSERT without 
# using the InsertTimeSlot procedure), if the insertion of the new row leads to a violation of the constraints identified in the previous exercise. 
# Test the trigger by making INSERTs into TimeSLOT

DROP TRIGGER IF EXISTS TimeSlot_Before_Insert;
DELIMITER //
CREATE TRIGGER TimeSlot_Before_Insert BEFORE INSERT ON TimeSlot FOR EACH ROW
BEGIN
	IF NEW.EndTime <= NEW.StartTime
    THEN SIGNAL SQLSTATE 'A0000'
			SET MYSQL_ERRNO = 1525,
            MESSAGE_TEXT = 
            'EndTime is equal to or before StartTime';
	ELSEIF CheckTime(NEW.TimeSlotID, NEW.DayCode, NEW.StartTime, NEW.EndTime) 
    THEN SIGNAL SQLSTATE 'B0000'
			SET MYSQL_ERRNO = 1530,
            MESSAGE_TEXT = 
            'Time overlaps with exisiting time interval in the same time slot';
	END IF;
END
// DELIMITER ;

-- INSERT TimeSlot VALUES ('A', 'M', '08:50:00', '08:00:00');
-- INSERT TimeSlot VALUES ('A', 'M', '08:00:00', '08:50:00');
-- INSERT TimeSlot VALUES ('A', 'R', '08:00:00', '08:50:00');

# 5.2.4 Create an Event for a European Roulette
# Design a Gambling Machine which rolls a ball on a European Roulette every 10 seconds and stores the Lucky number. 
# Create a table called BallRolls with attributes RollNo and LuckyNo. 
DROP TABLE IF EXISTS BallRolls;
CREATE TABLE BallRolls(
		RollNo INTEGER AUTO_INCREMENT PRIMARY KEY,
        LuckNo INTEGER);
#Create an event RollBall that executes every 10 seconds and inserts RollNo (automatically counting from 1) and LuckyNo  
# (i.e. random number between 0 and 36) into the table BallRolls.
DROP EVENT IF EXISTS 
