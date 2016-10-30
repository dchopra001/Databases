--5.1 
DROP PROCEDURE IF EXISTS Test_ResetDB;
DELIMITER @@
CREATE PROCEDURE Test_ResetDB ()
BEGIN
/* resets the database to the initial state described in Section 3 */
---------------Drop all tables-----------------------------------------------

DROP TABLE IF EXISTS FriendRequest;
DROP TABLE IF EXISTS Friend;

DROP TABLE IF EXISTS gName;
DROP TABLE IF EXISTS WorkAddress;

DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS DoctorSpecialization;

DROP TABLE IF EXISTS Doctor;
DROP TABLE IF EXISTS Patient;
DROP TABLE IF EXISTS gUser;

DROP VIEW IF EXISTS FullPatientView;
DROP VIEW IF EXISTS DoctorReviewsMetaData;
DROP VIEW IF EXISTS FullDoctorView;

---------------------------Reinsert all tables------------------------------------

DROP TABLE IF EXISTS gUser;
CREATE TABLE gUser(
	gAlias VARCHAR(32) PRIMARY KEY,
	EmailAddress VARCHAR(64),
	PasswordHash VARCHAR(64),
	PasswordSalt VARCHAR(64)
);

DROP TABLE IF EXISTS Doctor;
CREATE TABLE Doctor(
	gAlias VARCHAR(32) PRIMARY KEY,
	Gender VARCHAR(1),
	YearMedicalLicense INT,
	FOREIGN KEY (gAlias) REFERENCES gUser(gAlias)
);

DROP TABLE IF EXISTS Patient;
CREATE TABLE Patient(
	gAlias VARCHAR(32) PRIMARY KEY,
	City VARCHAR(32),
	Province VARCHAR(32),
	FOREIGN KEY (gAlias) REFERENCES gUser(gAlias)
);

DROP TABLE IF EXISTS WorkAddress;
CREATE TABLE WorkAddress(
	gAlias VARCHAR(32),
	Street_Name VARCHAR(32),
	Street_Number VARCHAR(8),
	Apt_Number VARCHAR(6),
	PostalCode VARCHAR(6),
	City VARCHAR(32),
	Province VARCHAR(32),
	FOREIGN KEY (gAlias) REFERENCES Doctor(gAlias)
        
);

DROP TABLE IF EXISTS DoctorSpecialization;
CREATE TABLE DoctorSpecialization(
	gAlias VARCHAR(32),
	SpecializationName VARCHAR(64),
	FOREIGN KEY (gAlias) REFERENCES Doctor(gAlias),
PRIMARY KEY(gAlias , SpecializationName )
);



DROP TABLE IF EXISTS FriendRequest;
CREATE TABLE FriendRequest(
	RequestergAlias VARCHAR(32),
	RequesteegAlias VARCHAR(32),
	FOREIGN KEY (RequestergAlias) REFERENCES Patient(gAlias),
	FOREIGN KEY (RequesteegAlias) REFERENCES Patient(gAlias),
PRIMARY KEY(RequestergAlias  , RequesteegAlias )
);

DROP TABLE IF EXISTS Friend;
CREATE TABLE Friend(
	PatientgAliasA VARCHAR(32),
	PatientgAliasB VARCHAR(32),
	FOREIGN KEY (PatientgAliasA) REFERENCES Patient(gAlias),
	FOREIGN KEY (PatientgAliasB) REFERENCES Patient(gAlias),
PRIMARY KEY(PatientgAliasA   , PatientgAliasB )
);

DROP TABLE IF EXISTS Review;
CREATE TABLE Review(
	ReviewContentID INT PRIMARY KEY,
	PatientgAlias VARCHAR(32),
	DoctorgAlias VARCHAR(32),
	StarRating FLOAT,
	gDate DATE,
	Text VARCHAR(1000),
	FOREIGN KEY (PatientgAlias) REFERENCES Patient(gAlias),
	FOREIGN KEY (DoctorgAlias) REFERENCES Doctor(gAlias)
);

DROP TABLE IF EXISTS gName;
CREATE TABLE gName(
	gAlias VARCHAR(32) PRIMARY KEY,
	FirstName VARCHAR(32),
	MiddleName VARCHAR(32),
	LastName VARCHAR(32),
	FOREIGN KEY (gAlias) REFERENCES gUser(gAlias)
);

DROP VIEW IF EXISTS FullDoctorView;
CREATE VIEW FullDoctorView AS
SELECT gUser.gAlias, Gender, YearMedicalLicense,EmailAddress,FirstName,MiddleName,LastName from Doctor INNER JOIN gUser ON (Doctor.gAlias=gUser.gAlias) INNER JOIN gName ON (gName.gAlias=gUser.gAlias);

DROP VIEW IF EXISTS DoctorReviewsMetaData;
CREATE VIEW DoctorReviewsMetaData AS 
SELECT COUNT(DoctorgAlias) as ReviewCount, AVG(StarRating) as AvgStarRating, DoctorgAlias FROM Review GROUP BY DoctorgAlias;

DROP VIEW IF EXISTS FullPatientView;
CREATE VIEW FullPatientView AS
SELECT gUser.gAlias, EmailAddress,FirstName,MiddleName,LastName,Province,City from Patient INNER JOIN gUser ON (Patient.gAlias=gUser.gAlias) INNER JOIN gName ON (gName.gAlias=gUser.gAlias);

--------------------------------Reinsert all procs and function--------------------------



----------------------------Reinsert all their sample data--------------------------

--Insert USERS:

----Doctors:

CALL add_doctor ('doc_aiken','John','', 'Aikenhead','aiken@head.com','M','1990','doc_aiken');

INSERT INTO 
WorkAddress (gAlias, Street_Name,Street_Number,Apt_Number,PostalCode,City,Province)
VALUES("doc_aiken","Elizabeth Street","1","","N2L2W8","Waterloo","Ontario");


INSERT INTO 
WorkAddress (gAlias, Street_Name,Street_Number,Apt_Number,PostalCode,City,Province)
VALUES("doc_aiken","Aikenhead Street","2","","N2P1K2","Kitchener","Ontario");

INSERT INTO
DoctorSpecialization(gAlias,SpecializationName)
VALUES ("doc_aiken", "allergologist");

INSERT INTO
DoctorSpecialization(gAlias,SpecializationName)
VALUES ("doc_aiken", "naturopath");

--2. 

call add_doctor ('doc_amnio','Jane','', 'Amniotic','obgyn_clinic@rogers.com','F',2005,'doc_amnio');

INSERT INTO 
WorkAddress (gAlias, Street_Name,Street_Number,Apt_Number,PostalCode,City,Province)
VALUES("doc_amnio","Jane Street","1","","N2L2W8","Waterloo","Ontario");

INSERT INTO 
WorkAddress(gAlias, Street_Name,Street_Number,Apt_Number,PostalCode,City,Province)
VALUES("doc_amnio","Amniotic Street","2","","N2P2K5","Kitchener","Ontario");



INSERT INTO
DoctorSpecialization(gAlias,SpecializationName)
VALUES ("doc_amnio","obstetrician");

INSERT INTO
DoctorSpecialization(gAlias,SpecializationName)
VALUES ("doc_amnio","gynecologist");

--3. 


call add_doctor ('doc_umbilical','Mary','', 'Umbilical','obgyn_clinic@rogers.com','F',2006,'doc_umbilical');

INSERT INTO 
WorkAddress(gAlias, Street_Name,Street_Number,Apt_Number,PostalCode,City,Province)
VALUES("doc_umbilical","Mary Street","1","","N2L1A2","Cambridge","Ontario");

INSERT INTO 
WorkAddress(gAlias, Street_Name,Street_Number,Apt_Number,PostalCode,City,Province)
VALUES("doc_umbilical","Amniotic Street","2","","N2P2K5","Kitchener","Ontario");


INSERT INTO
DoctorSpecialization(gAlias,SpecializationName)
VALUES ("doc_umbilical","obstetrician");

INSERT INTO
DoctorSpecialization(gAlias,SpecializationName)
VALUES ("doc_umbilical","naturopath");

--4. 

call add_doctor ('doc_heart','Jack','', 'Hearty','jack@healthyheart.com','M',1980,'doc_heart');

INSERT INTO 
WorkAddress(gAlias, Street_Name,Street_Number,Apt_Number,PostalCode,City,Province)
VALUES("doc_heart","Jack Street","1","","N2L1G2","Guelph","Ontario");

INSERT INTO 
WorkAddress(gAlias, Street_Name,Street_Number,Apt_Number,PostalCode,City,Province)
VALUES("doc_heart","Heart Street","2","","N2P2W5","Waterloo","Ontario");


INSERT INTO
DoctorSpecialization(gAlias,SpecializationName)
VALUES ("doc_heart","cardiologist");

INSERT INTO
DoctorSpecialization(gAlias,SpecializationName)
VALUES ("doc_heart","surgeon");


--5. 

call add_doctor ('doc_cutter','Beth','', 'Cutter','beth@tummytuck.com','F',2014,'doc_cutter');

INSERT INTO 
WorkAddress(gAlias, Street_Name,Street_Number,Apt_Number,PostalCode,City,Province)
VALUES("doc_cutter","Beth Street","1","","N2L1C2","Cambridge","Ontario");

INSERT INTO 
WorkAddress(gAlias, Street_Name,Street_Number,Apt_Number,PostalCode,City,Province)
VALUES("doc_cutter","Cutter Street","2","","N2P2K5","Kitchener","Ontario");


INSERT INTO
DoctorSpecialization(gAlias,SpecializationName)
VALUES ("doc_cutter","surgeon");

INSERT INTO
DoctorSpecialization(gAlias,SpecializationName)
VALUES ("doc_cutter","psychiatrist");



----Patients

--1. 

call add_patient('pat_bob', 'Bob', '', 'Bobberson', 'thebobbersons@sympatico.ca',  'pat_bob', 'Waterloo', 'Ontario');


--2. 

call add_patient('pat_peggy', 'Peggy', '', 'Bobberson', 'thebobbersons@sympatico.ca',  'pat_peggy', 'Waterloo', 'Ontario');
--3. 

call add_patient('pat_homer', 'Homer', '', 'Homerson', 'homer@rogers.com',   'pat_homer', 'Kitchener', 'Ontario');
--4.


call add_patient('pat_kate', 'Kate', '', 'Katemyer', 'kate@hello.com',  'pat_kate', 'Cambridge', 'Ontario');
--5. 


call add_patient('pat_anne', 'Anne', '', 'Macdonald', 'anne@gmail.com',  'pat_anne', 'Guelph', 'Ontario');


-----------------Reinsert all our temp data-------------------------------

END @@
DELIMITER ;


--5.2
DROP PROCEDURE IF EXISTS Test_PatientSearch;
DELIMITER @@
CREATE PROCEDURE Test_PatientSearch
(IN province VARCHAR(20), IN city VARCHAR(20), OUT num_matches INT)
BEGIN
SELECT COUNT(*) INTO num_matches FROM Patient WHERE (Patient.City LIKE city and Patient.Province LIKE province); 
/* returns in num_matches the total number of patients in the given province and city */
END @@
DELIMITER;


--5.3  --TODO: Replace Gender with male or female instead of m or f

DROP PROCEDURE IF EXISTS Test_DoctorSearch;
DELIMITER @@
CREATE PROCEDURE Test_DoctorSearch
(IN gender VARCHAR(20), IN city VARCHAR(20), IN specialization VARCHAR(20), IN
num_years_licensed INT, OUT num_matches INT)
BEGIN
SELECT COUNT(AgAlias) INTO num_matches FROM 
    (
        (
        SELECT AgAlias FROM
            (
                (
                SELECT gAlias as AgAlias from Doctor WHERE Doctor.Gender=gender and Doctor.YearMedicalLicense=(YEAR(CURDATE()) - num_years_licensed)
                ) A
                INNER JOIN 
                (
                SELECT gAlias as BgAlias from WorkAddress WHERE WorkAddress.City=city
                ) B
                ON
                AgAlias=BgAlias 
            )
        ) C
        INNER JOIN
        (
        SELECT gAlias as CgAlias from DoctorSpecialization WHERE SpecializationName=specialization
        ) D
        ON
        AgAlias=CgAlias
    );



/* returns in num_matches the total number of doctors that match exactly on all the given
criteria: gender ('male' or 'female'), city, specialization, and number of years licensed */
END @@
DELIMITER;


--5.4 -----------TOBEDONE BY JAMES
DROP PROCEDURE IF EXISTS Test_DoctorSearchStarRating;
DELIMITER @@
CREATE PROCEDURE Test_DoctorSearchStarRating
(IN avg_star_rating FLOAT, OUT num_matches INT)
BEGIN
/* returns in num_matches the total number of doctors whose average star rating is equal to
or greater than the given threshold */
END @@
DELIMITER;


--5.5 TO BE DONE BY JAMES
DROP PROCEDURE IF EXISTS Test_DoctorSearchFriendReview;
DELIMITER @@
CREATE PROCEDURE Test_DoctorSearchFriendReview
(IN patient_alias VARCHAR(20), IN review_keyword VARCHAR(20), OUT num_matches INT)
BEGIN
/* returns in num_matches the total number of doctors who have been reviewed by friends of
the given patient, and where at least one of the reviews for that doctor (not necessarily
written by a friend) contains the given keyword (case-sensitive) */
END @@
DELIMITER;


--5.6
DROP PROCEDURE IF EXISTS Test_RequestFriend;
DELIMITER @@
CREATE PROCEDURE Test_RequestFriend
(IN requestor_alias VARCHAR(20), IN requestee_alias VARCHAR(20))
BEGIN
INSERT INTO FriendRequest (RequestergAlias,RequesteegAlias) 
VALUES (requestor_alias,requestee_alias);
/* add friendship request from requestor_alias to requestee_alias */
END @@
DELIMITER;



--5.7 --we will probably need to discuss the freindship request logic to make sure we check if a friendship is requested before inserting this
--------but for this case we should be fine
DROP PROCEDURE IF EXISTS Test_ConfirmFriendRequest;
DELIMITER @@
CREATE PROCEDURE Test_ConfirmFriendRequest
(IN requestor_alias VARCHAR(20), IN requestee_alias VARCHAR(20))
BEGIN
INSERT INTO Friend (PatientgAliasA,PatientgAliasB) 
VALUES (requestor_alias,requestee_alias);
/* add friendship between requestor_alias and requestee_alias, assuming that friendship was
requested previously */
END @@
DELIMITER;


--5.8 --SINCE entries don't repeat in the table, we can assume that the count result will always be one or zero anyway

DROP PROCEDURE IF EXISTS Test_AreFriends;
DELIMITER @@
CREATE PROCEDURE Test_AreFriends
(IN patient_alias_1 VARCHAR(20), IN patient_alias_2 VARCHAR(20), OUT are_friends INT)
BEGIN
SELECT COUNT(*) INTO are_friends from Friend WHERE ((PatientgAliasA=patient_alias_1 and PatientgAliasB=patient_alias_2) OR (PatientgAliasA=patient_alias_2 and PatientgAliasB=patient_alias_1));
/* returns 1 in are_friends if patient_alias_1 and patient_alias_2 are friends, 0 otherwise */
END @@
DELIMITER;



--5.9 --if user specifies somehow (we should only allow a dropdown of star ratings) a star rating greater than 5 or less than 0, then this sproc will autoadjust 
--------that to 0 or 5. 
DROP PROCEDURE IF EXISTS Test_AddReview;
DELIMITER @@
CREATE PROCEDURE Test_AddReview
(IN patient_alias VARCHAR(20), IN doctor_alias VARCHAR(20), IN star_rating FLOAT,
IN comments VARCHAR(256))
BEGIN
IF star_rating > 5.0 THEN
    SET star_rating = 5.0;
ELSEIF star_rating < 0.0 THEN
    SET star_rating = 0.0;
END IF;

INSERT INTO Review (PatientgAlias,DoctorgAlias,StarRating,gDate,Text)
VALUES (patient_alias,doctor_alias,star_rating,CURDATE(),comments);
/* add review by patient_alias for doctor_alias with the given star_rating and comments
fields, assign the current date to the review automatically, assume that star_rating is an
integer multiple of 0.5 (e.g., 1.5, 2.0, 2.5, etc.) */
END @@
DELIMITER;

DROP PROCEDURE IF EXISTS Test_CheckReviews;
DELIMITER @@
CREATE PROCEDURE Test_CheckReviews
(IN doctor_alias VARCHAR(20), OUT avg_star FLOAT, OUT num_reviews INT)
BEGIN
SELECT COUNT(DoctorgAlias) INTO num_reviews FROM Review WHERE DoctorgAlias=doctor_alias;
SELECT AVG(StarRating) INTO avg_star FROM Review WHERE DoctorgAlias=doctor_alias;

END @@
DELIMITER;
