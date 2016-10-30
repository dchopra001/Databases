DROP TABLE IF EXISTS gUser;
CREATE TABLE gUser(
	gAlias VARCHAR(34) PRIMARY KEY,
	EmailAddress VARCHAR(66),
	PasswordHash VARCHAR(66),
	PasswordSalt VARCHAR(66)
);

DROP TABLE IF EXISTS Doctor;
CREATE TABLE Doctor(
	gAlias VARCHAR(36) PRIMARY KEY,
	Gender VARCHAR(6),
	YearMedicalLicense INT,
	FOREIGN KEY (gAlias) REFERENCES gUser(gAlias)
);

DROP TABLE IF EXISTS Patient;
CREATE TABLE Patient(
	gAlias VARCHAR(36) PRIMARY KEY,
	City VARCHAR(36),
	Province VARCHAR(36),
	FOREIGN KEY (gAlias) REFERENCES gUser(gAlias)
);

DROP TABLE IF EXISTS WorkAddress;
CREATE TABLE WorkAddress(
	gAlias VARCHAR(34),
	Street_Name VARCHAR(34),
	Street_Number VARCHAR(10),
	Apt_Number VARCHAR(8),
	PostalCode VARCHAR(8),
	City VARCHAR(34),
	Province VARCHAR(34),
	FOREIGN KEY (gAlias) REFERENCES Doctor(gAlias)
        
);

DROP TABLE IF EXISTS DoctorSpecialization;
CREATE TABLE DoctorSpecialization(
	gAlias VARCHAR(34),
	SpecializationName VARCHAR(66),
	FOREIGN KEY (gAlias) REFERENCES Doctor(gAlias),
PRIMARY KEY(gAlias , SpecializationName )
);



DROP TABLE IF EXISTS FriendRequest;
CREATE TABLE FriendRequest(
	RequestergAlias VARCHAR(34),
	RequesteegAlias VARCHAR(34),
	FOREIGN KEY (RequestergAlias) REFERENCES Patient(gAlias),
	FOREIGN KEY (RequesteegAlias) REFERENCES Patient(gAlias),
PRIMARY KEY(RequestergAlias  , RequesteegAlias )
);

DROP TABLE IF EXISTS Friend;
CREATE TABLE Friend(
	PatientgAliasA VARCHAR(34),
	PatientgAliasB VARCHAR(34),
	FOREIGN KEY (PatientgAliasA) REFERENCES Patient(gAlias),
	FOREIGN KEY (PatientgAliasB) REFERENCES Patient(gAlias),
PRIMARY KEY(PatientgAliasA   , PatientgAliasB )
);

DROP TABLE IF EXISTS Review;
CREATE TABLE Review(
	ReviewContentID MEDIUMINT PRIMARY KEY AUTO_INCREMENT,
	PatientgAlias VARCHAR(34),
	DoctorgAlias VARCHAR(34),
	StarRating FLOAT,
	gDate DATETIME,
	Text VARCHAR(1002),
	FOREIGN KEY (PatientgAlias) REFERENCES Patient(gAlias),
	FOREIGN KEY (DoctorgAlias) REFERENCES Doctor(gAlias)
);

DROP TABLE IF EXISTS gName;
CREATE TABLE gName(
	gAlias VARCHAR(34) PRIMARY KEY,
	FirstName VARCHAR(34),
	MiddleName VARCHAR(34),
	LastName VARCHAR(34),
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

