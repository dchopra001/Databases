DROP FUNCTION IF EXISTS SALT_SHA2;

CREATE FUNCTION SALT_SHA2(salt CHAR(64), password VARCHAR(64))
RETURNS CHAR(64) DETERMINISTIC
RETURN SHA2(CONCAT(salt,password),256);

DROP PROCEDURE IF EXISTS add_doctor;

DELIMITER $


CREATE PROCEDURE add_doctor(in ingAlias VARCHAR(34), in inFirstName VARCHAR(34), in inMiddleName VARCHAR(34), in inLastName VARCHAR(34), in inEmailAddress VARCHAR(66), in inGender VARCHAR(8), in inYearMedicalLicense INT, in inPassword VARCHAR(34))
BEGIN

	DECLARE passwordSalt VARCHAR(66);
	SET passwordSalt = CONCAT(ingAlias, "_salt");
	INSERT INTO gUser(gAlias, EmailAddress, PasswordHash, PasswordSalt) VALUES( ingAlias, inEmailAddress, SALT_SHA2(passwordSalt, inPassword),passwordSalt);
	INSERT INTO Doctor(gAlias, Gender, YearMedicalLicense) VALUES (ingAlias, inGender, inYearMedicalLicense);
	INSERT INTO gName (gAlias, FirstName, MiddleName, LastName) VALUES (ingAlias, inFirstName, inMiddleName, inLastName);
END
$
DELIMITER ;


DROP PROCEDURE IF EXISTS getAllSpecializations;

DELIMITER $
CREATE PROCEDURE getAllSpecializations()
BEGIN

    SELECT DISTINCT SpecializationName FROM DoctorSpecialization ORDER BY SpecializationName;

	
END
$
DELIMITER ;



DROP PROCEDURE IF EXISTS add_patient;

DELIMITER $



CREATE PROCEDURE add_patient(in ingAlias VARCHAR(34), in inFirstName VARCHAR(34), in inMiddleName VARCHAR(34), in inLastName VARCHAR(34), in inEmailAddress VARCHAR(66),  in inPassword VARCHAR(34), in inCity VARCHAR(34), in inProvince VARCHAR(34))
BEGIN

	DECLARE passwordSalt VARCHAR(66);
	SET passwordSalt = CONCAT(ingAlias, "_salt");
	INSERT INTO gUser(gAlias, EmailAddress, PasswordHash, PasswordSalt) VALUES( ingAlias, inEmailAddress, SALT_SHA2(passwordSalt, inPassword),passwordSalt);
	INSERT INTO gName (gAlias, FirstName, MiddleName, LastName) VALUES (ingAlias, inFirstName, inMiddleName, inLastName);
        INSERT INTO Patient(gAlias,City,Province) VALUES (ingAlias, inCity, inProvince);
END
$
DELIMITER ;

DROP PROCEDURE IF EXISTS doesUserExist;
DROP PROCEDURE IF EXISTS DoesUserExist;

DROP PROCEDURE IF EXISTS loginValidation;

DELIMITER $



CREATE PROCEDURE loginValidation(in ingAlias VARCHAR(34), in inpassword VARCHAR(64))--, OUT answer int)
BEGIN
        --answer: 0=patient, 1=doctor, -1 = none
        DECLARE answer INT;
	SET answer = -1;
        SET @cnt= 0; --he
        SELECT COUNT(*) INTO @cnt FROM gUser WHERE gAlias = ingAlias AND SALT_SHA2(PasswordSalt, inpassword) = PasswordHash;

        IF @cnt = 1 THEN --pasword is valid
            SET @cnt = 0;
            SELECT COUNT(*) INTO @cnt from Doctor where gAlias=ingAlias;

            IF @cnt = 0 THEN --user is not doctor
                SET @cnt = 0;
                SELECT COUNT(*) INTO @cnt from Patient where gAlias=ingAlias;
                IF @cnt>0 THEN
                    SET answer = 0; --Patient
                END IF;
            ELSEIF @cnt = 1 THEN --user is doctor
                SET answer = 1; --DOCTOR
            ELSE 
                SET answer = -1;
            END IF;
        ELSE --password not valid
            SET answer = -1;
        END IF;
            
       SELECT answer;
END
$
DELIMITER ;


---------------------------------

DROP PROCEDURE IF EXISTS findAllFriendsForUser;

DELIMITER $



CREATE PROCEDURE findAllFriendsForUser(in ingAlias VARCHAR(34))--, OUT answer int)
BEGIN
        SELECT a.PatientgAliasA as FriendAlias from Friend a WHERE PatientgAliasB=ingAlias UNION SELECT b.PatientgAliasB FROM Friend b WHERE PatientgAliasA=ingAlias;

END
$
DELIMITER ;


--------------------------------------------------------        OPERATIONS        ----------------------------------------------------------------------------------------
----------------------------------xxxxxxxxxxxxxxxxxxxxxx--------------------------xxxxxxxxxxxxxxxxxxxxxx------------------------------------------------------------------
----------------------------------xxxxxxxxxxxxxxxxxxxxxx--------------------------xxxxxxxxxxxxxxxxxxxxxx------------------------------------------------------------------
----------------------------------xxxxxxxxxxxxxxxxxxxxxx--------------------------xxxxxxxxxxxxxxxxxxxxxx------------------------------------------------------------------
----------------------------------xxxxxxxxxxxxxxxxxxxxxx--------------------------xxxxxxxxxxxxxxxxxxxxxx------------------------------------------------------------------
----------------------------------xxxxxxxxxxxxxxxxxxxxxx--------------------------xxxxxxxxxxxxxxxxxxxxxx------------------------------------------------------------------
----------------------------------xxxxxxxxxxxxxxxxxxxxxx--------------------------xxxxxxxxxxxxxxxxxxxxxx------------------------------------------------------------------
----------------------------------xxxxxxxxxxxxxxxxxxxxxx--------------------------xxxxxxxxxxxxxxxxxxxxxx------------------------------------------------------------------
----------------------------------xxxxxxxxxxxxxxxxxxxxxx--------------------------xxxxxxxxxxxxxxxxxxxxxx------------------------------------------------------------------
----------------------------------xxxxxxxxxxxxxxxxxxxxxx--------------------------xxxxxxxxxxxxxxxxxxxxxx------------------------------------------------------------------

--O1
DROP PROCEDURE IF EXISTS patientToPatientSearch;

DELIMITER $
CREATE PROCEDURE patientToPatientSearch(in ingAlias VARCHAR(34), in inProvince VARCHAR(34), in inCity VARCHAR(34))
BEGIN
        SET ingAlias = CONCAT('%',ingAlias);
        SET ingAlias = CONCAT(ingAlias,'%');
        SET inProvince = CONCAT('%',inProvince);
        SET inProvince = CONCAT(inProvince,'%');
        SET inCity = CONCAT('%',inCity);
        SET inCity = CONCAT(inCity,'%');
        SELECT gAlias, LastReviewDate, IFNULL(ReviewCount,0) as ReviewCount, City, Province FROM 
            (
            SELECT PatientgAlias, MAX(gDate) as LastReviewDate, COUNT(*) as ReviewCount FROM Review
            GROUP BY PatientgAlias 
            ) PatientReview
            RIGHT JOIN 
            (
            SELECT gAlias,City,Province FROM Patient
            where gAlias LIKE ingAlias and City LIKE inCity and Province LIKE inProvince
            ) filteredPatients 
            ON PatientReview.PatientgAlias = filteredPatients.gAlias;
END
$
DELIMITER ;


---------------------------------------------------------

DROP PROCEDURE IF EXISTS patientToPatientSearchFriend;

DELIMITER $
CREATE PROCEDURE patientToPatientSearchFriend(in ingAlias VARCHAR(34), in inProvince VARCHAR(34), in inCity VARCHAR(34), in inSearcherAlias VARCHAR(34))
BEGIN
        SET ingAlias = CONCAT('%',ingAlias);
        SET ingAlias = CONCAT(ingAlias,'%');
        SET inProvince = CONCAT('%',inProvince);
        SET inProvince = CONCAT(inProvince,'%');
        SET inCity = CONCAT('%',inCity);
        SET inCity = CONCAT(inCity,'%');
        

        SELECT gAlias, LastReviewDate, ReviewCount, City, Province, IFNULL(IsFriend,0) as IsFriend FROM  
        (
        SELECT * FROM        
        (
        SELECT gAlias, LastReviewDate, IFNULL(ReviewCount,0) as ReviewCount, City, Province FROM 
            (
            SELECT PatientgAlias, MAX(gDate) as LastReviewDate, COUNT(*) as ReviewCount FROM Review
            GROUP BY PatientgAlias 
            ) PatientReview
            RIGHT JOIN 
            ( 
            SELECT gAlias,City,Province FROM Patient
            where gAlias LIKE ingAlias and City LIKE inCity and Province LIKE inProvince
            ) filteredPatients 
            ON PatientReview.PatientgAlias = filteredPatients.gAlias

        ) ps 
        LEFT JOIN 
        (
            SELECT FriendAlias, 1 as IsFriend FROM (SELECT a.PatientgAliasA as FriendAlias FROM Friend a WHERE PatientgAliasB = inSearcherAlias UNION SELECT b.PatientgAliasB FROM Friend b WHERE PatientgAliasA = inSearcherAlias) e
        ) FriendTable
        ON 
        ps.gAlias = FriendTable.FriendAlias
        ) wat;
        
END
$
DELIMITER ;


--call patientToPatientSearchFriend("","","","pat_peggy")

-----------------------------------------------O2 BEGIN-------------------------------------------------------------
--O2.1
--returns 0 if friendship DNE and 1 if it does
--input values must be exact!

DROP PROCEDURE IF EXISTS doesFriendshipExist;

DELIMITER $
CREATE PROCEDURE doesFriendshipExist(in ingAliasA VARCHAR(34), in ingAliasB VARCHAR(34), out rslt INT)
BEGIN

        SELECT COUNT(*) INTO rslt from Friend where ((PatientgAliasA=ingAliasA and PatientgAliasB=ingAliasB) OR (PatientgAliasA=ingAliasB and PatientgAliasB=ingAliasA));


END
$
DELIMITER ;

--02.2
--Checks to see who added who.. this may be required as part of O2
--input values must be exact!
--if there are rows, then we can see from requester and requestee who added who
--if a result with no rows is returned then neither of them added each other

DROP PROCEDURE IF EXISTS whoAddedWho;

DELIMITER $
CREATE PROCEDURE whoAddedWho(in ingAliasA VARCHAR(34), in ingAliasB VARCHAR(34), out rslt INT)
BEGIN
    
        DECLARE TBC INT;
        SET TBC = 0;
        SELECT COUNT(*) INTO rslt from FriendRequest where ((RequestergAlias=ingAliasA and RequesteegAlias=ingAliasB));
        IF rslt = 1 THEN --A requested B
            SET rslt = 0; --A requested B
            SET TBC = 1;
        END IF;
        SELECT COUNT(*) INTO rslt from FriendRequest where ((RequestergAlias=ingAliasB and RequesteegAlias=ingAliasA));
        IF rslt = 1 AND TBC = 0 THEN --B requested A
            SET rslt = 1; --B requested A
            SET TBC = 1;
        END IF;
        IF TBC = 0 THEN
            SET rslt = 2; --No requests between B and A
        END IF;

           


END
$
DELIMITER ;

-----------------DELETE FROM FRIEND REQUEST TABLE------------------
--This is supplementary to O2

DROP PROCEDURE IF EXISTS deleteFromFriendRequest;

DELIMITER $
CREATE PROCEDURE deleteFromFriendRequest(in inRequestergAlias VARCHAR(34), in inRequesteegAlias VARCHAR(34))
BEGIN
        DELETE FROM FriendRequest WHERE RequestergAlias=inRequestergAlias AND RequesteegAlias=inRequesteegAlias;
END
$
DELIMITER ;

----------------------INSERT INTO FRIEND TABLE--------------------
--supplementary to O2
DROP PROCEDURE IF EXISTS InsertFriendRelation;

DELIMITER $
CREATE PROCEDURE InsertFriendRelation(in inPatientgAliasA VARCHAR(34), in inPatientgAliasB VARCHAR(34))
BEGIN
        INSERT INTO Friend (PatientgAliasA,PatientgAliasB)
        VALUES (inPatientgAliasA,inPatientgAliasB);
END
$
DELIMITER ;

------------------INSERT FRIEND REQUEST-----------------------------------
--supplementary to O2
DROP PROCEDURE IF EXISTS InsertFriendRequest;

DELIMITER $
CREATE PROCEDURE InsertFriendRequest(in inRequestergAlias VARCHAR(34), in inRequesteegAlias VARCHAR(34))
BEGIN
        INSERT INTO FriendRequest (RequestergAlias,RequesteegAlias)
        VALUES (inRequestergAlias,inRequesteegAlias);
END
$
DELIMITER ;

-------------------------------------------------------------------


--O2 Complete function .. call this to invoke and use all the other functions part of the O2 tree
--supplementary to O2
DROP PROCEDURE IF EXISTS Friendship;

DELIMITER $
CREATE PROCEDURE Friendship(in inRequestergAlias VARCHAR(34), in inRequesteegAlias VARCHAR(34))
BEGIN
        --First check if this friendship already exists
        DECLARE rslt INT;
        DECLARE TBC INT;
        SET TBC = 0;
        CALL doesFriendshipExist(inRequestergAlias,inRequesteegAlias,rslt);
        IF rslt > 0 THEN --Friendship already exists
            SET rslt = 0; --Friendship already exists
            SET TBC= 1;
        END IF;
        IF TBC = 0 THEN
            CALL whoAddedWho(inRequestergAlias,inRequesteegAlias,rslt);
            IF rslt = 0 THEN
                SET rslt = 1; --requester already made an attempt to add this person
                SET TBC = 1;
            ELSEIF rslt = 1 THEN
                SET rslt = 2; --requestee made an attempt before, so now friendship can be confirmed
                SET TBC = 1;
                CALL deleteFromFriendRequest(inRequesteegAlias,inRequestergAlias); --delete from friendrequesttable
                CALL InsertFriendRelation(inRequestergAlias,inRequesteegAlias); --insert into friend table
                

            ELSEIF rslt = 2 THEN --no relation between the two parties, so just insert into friend request table
                SET rslt = 3; --no relation existed, so a request has been submitted
                SET TBC = 1;
                CALL InsertFriendRequest(inRequestergAlias,inRequesteegAlias);
            END IF;
        END IF;
        SELECT rslt;
        
END
$
DELIMITER ;
------------------------------------O2 PROCEDURES END----------------------------------------------------------


--O3
--requestee alias must be EXACT!
--the link to confirm friendship can be obtained by calling the stored
--proc and passing the requester's alias which wil be returned in this table

DROP PROCEDURE IF EXISTS viewMyFriendRequests;

DELIMITER $
CREATE PROCEDURE viewMyFriendRequests(in ingAlias VARCHAR(34))
BEGIN


        SELECT RequestergAlias, EmailAddress from
        (
        SELECT RequestergAlias from FriendRequest where RequesteegAlias=ingAlias
        ) x 
        INNER JOIN gUser ON x.RequestergAlias=gUser.gAlias;


END
$
DELIMITER ;




--O4
--I DONNO WTF THIS IS
--JAMES CAN HANDLE THIS SHIZZNAT
DROP PROCEDURE IF EXISTS superDoctorSearch;

DELIMITER $

CREATE PROCEDURE superDoctorSearch(
	in inpatientAlias VARCHAR(34),
	in inFirstName VARCHAR(34),
	in inMiddleName VARCHAR(34),
	in inLastName VARCHAR(34),
	in inGender VARCHAR(8),
	in inYearsLicensed INT,
	in inStreet_Name VARCHAR(34),
	in inStreet_Number VARCHAR(10),
	in inApt_Number VARCHAR(8),
	in inPostalCode VARCHAR(8),
	in inCity VARCHAR(34),
	in inProvince VARCHAR(34),
	in inSpecialization VARCHAR(34),
	in inAverageStarRating float,
	in inFriendReviewed INT,
	in inReviewKeyword VARCHAR(34)
)
BEGIN
       
	declare CareWACriteria VARCHAR(1); 
	declare CareSPCriteria VARCHAR(1); 
	declare CareRFCriteria VARCHAR(1); 
	declare CareRKCriteria VARCHAR(1); 
	declare CareRMCriteria VARCHAR(1); 
	declare CareDFCriteria VARCHAR(1); 	
	
	IF(inStreet_Name = "" AND inStreet_Number = "" AND inApt_Number = "" AND inPostalCode = "" AND inCity = "" AND inProvince = "") THEN
		set CareWACriteria = "%";
	ELSE
		set CareWACriteria = "1";
	END IF;
	
	IF(inSpecialization = "") THEN
		set CareSPCriteria = "%";
	ELSE
		set CareSPCriteria = "1";
	END IF;
	
	IF(inFriendReviewed != 1) THEN
		set CareRFCriteria = "%";
	ELSE
		set CareRFCriteria = "1";
	END IF;
	
	IF(inReviewKeyword = "") THEN
		set CareRKCriteria = "%";
	ELSE
		set CareRKCriteria = "1";
	END IF;
	
	IF( inAverageStarRating < 0) THEN
		set CareRMCriteria = "%";
	ELSE
		set CareRMCriteria = "1";
	END IF;
	
	IF (inYearsLicensed < 0 AND inFirstName = "" AND inMiddleName = "" AND inLastName = "" AND inGender = "") THEN
		set CareDFCriteria = "%";
	ELSE
		set CareDFCriteria = "1";
	END IF;
	
        SET inFirstName = CONCAT('%',inFirstName); --prefix
        SET inFirstName = CONCAT(inFirstName,'%'); --suffix

        SET inMiddleName = CONCAT('%',inMiddleName); --prefix
        SET inMiddleName = CONCAT(inMiddleName,'%'); --suffix

        SET inLastName = CONCAT('%',inLastName); --prefix
        SET inLastName = CONCAT(inLastName,'%'); --suffix

        /*SET inGender = CONCAT('%',inGender); --prefix*/
        SET inGender = CONCAT(inGender,'%'); --suffix

        SET inStreet_Name = CONCAT('%',inStreet_Name); --prefix
        SET inStreet_Name = CONCAT(inStreet_Name,'%'); --suffix

        SET inStreet_Number = CONCAT('%',inStreet_Number); --prefix
        SET inStreet_Number = CONCAT(inStreet_Number,'%'); --suffix

        SET inApt_Number = CONCAT('%',inApt_Number); --prefix
        SET inApt_Number = CONCAT(inApt_Number,'%'); --suffix

        SET inPostalCode = CONCAT('%',inPostalCode); --prefix
        SET inPostalCode = CONCAT(inPostalCode,'%'); --suffix

        SET inCity = CONCAT('%',inCity); --prefix
        SET inCity = CONCAT(inCity,'%'); --suffix

        SET inProvince = CONCAT('%',inProvince); --prefix
        SET inProvince = CONCAT(inProvince,'%'); --suffix

        SET inSpecialization = CONCAT('%',inSpecialization); --prefix
        SET inSpecialization = CONCAT(inSpecialization,'%'); --suffix

        SET inReviewKeyword = CONCAT('%',inReviewKeyword); --prefix
        SET inReviewKeyword = CONCAT(inReviewKeyword,'%'); --suffix






        
	SELECT DoctorAlias as DoctorAlias, IFNULL(AvgStarRating,0) as AvgStarRating, IFNULL(ReviewCount,0) as ReviewCount, Gender, YearMedicalLicense, FirstName, MiddleName, LastName FROM
	(
		SELECT WA_SP_RF_RK_RM.DoctorAlias as DoctorAlias, MetWACriteria, MetSPCriteria, MetRFCriteria, MetRKCriteria, MetRMCriteria, MetDFCriteria, AvgStarRating, ReviewCount, Gender, YearMedicalLicense, FirstName, MiddleName, LastName FROM
		(
			SELECT WA_SP_RF_RK.DoctorAlias as DoctorAlias, MetWACriteria, MetSPCriteria, MetRFCriteria, MetRKCriteria, MetRMCriteria, AvgStarRating, ReviewCount FROM
			(
				SELECT WA_SP_RF.DoctorAlias as DoctorAlias, MetWACriteria, MetSPCriteria, MetRFCriteria, MetRKCriteria FROM
				(
					SELECT WA_SP.DoctorAlias as DoctorAlias, MetWACriteria, MetSPCriteria, MetRFCriteria FROM 
					(
						SELECT WA.DoctorAlias as DoctorAlias, MetWACriteria, MetSPCriteria FROM
							(
								 SELECT DISTINCT gAlias as DoctorAlias, 1 As MetWACriteria FROM WorkAddress WHERE Street_Name LIKE inStreet_Name AND  Street_Number LIKE inStreet_Number AND  Apt_Number LIKE inApt_Number AND PostalCode LIKE inPostalCode AND City LIKE inCity AND Province LIKE inProvince 
							) WA
						INNER JOIN
							(
								SELECT DISTINCT gAlias as DoctorAlias, 1 As MetSPCriteria FROM DoctorSpecialization WHERE SpecializationName LIKE inSpecialization
							) SP
						ON
						WA.DoctorAlias = SP.DoctorAlias
					) WA_SP
					LEFT JOIN
					(
							SELECT DISTINCT DoctorgAlias as DoctorAlias, 1 as MetRFCriteria FROM (SELECT * FROM Review r LEFT JOIN (SELECT FriendAlias, 1 as IsFriend FROM (SELECT a.PatientgAliasA as FriendAlias FROM Friend a WHERE PatientgAliasB = inpatientAlias UNION SELECT b.PatientgAliasB FROM Friend b WHERE PatientgAliasA = inpatientAlias) f ) ff ON r.PatientgAlias = ff.FriendAlias)  e WHERE e.IsFriend = 1

					) RF
					ON
					WA_SP.DoctorAlias = RF.DoctorAlias
				) WA_SP_RF
				LEFT JOIN
				(
					SELECT DISTINCT DoctorgAlias as DoctorAlias, 1 as MetRKCriteria FROM Review WHERE Text LIKE inReviewKeyword				
				) RK 
				ON
				WA_SP_RF.DoctorAlias = RK.DoctorAlias
			) WA_SP_RF_RK
			LEFT JOIN
			(
				SELECT DoctorgAlias as DoctorAlias, 1 as MetRMCriteria, AvgStarRating, ReviewCount FROM DoctorReviewsMetaData WHERE AvgStarRating > inAverageStarRating
			) RM
			ON
			WA_SP_RF_RK.DoctorAlias = RM.DoctorAlias
		) WA_SP_RF_RK_RM
		INNER JOIN
		(
			SELECT gAlias as DoctorAlias, Gender, YearMedicalLicense, FirstName, MiddleName, LastName, 1 As MetDFCriteria FROM FullDoctorView WHERE FirstName LIKE inFirstName AND MiddleName LIKE inMiddleName AND LastName LIKE inLastName AND year(CURDATE()) - YearMedicalLicense >= inYearsLicensed AND Gender LIKE inGender
		) DF
		ON
		WA_SP_RF_RK_RM.DoctorAlias = DF.DoctorAlias
	) MagicTable  WHERE IFNULL(MetWACriteria,0) LIKE CareWACriteria AND
                            IFNULL(MetSPCriteria,0) LIKE CareSPCriteria AND
                            IFNULL(MetRFCriteria,0) LIKE CareRFCriteria AND
                            IFNULL(MetRKCriteria,0) LIKE CareRKCriteria AND
                            IFNULL(MetRMCriteria,0) LIKE CareRMCriteria AND
                            IFNULL(MetDFCriteria,0) LIKE CareDFCriteria;
	
END
$
DELIMITER ;

/* EXAMPLE USAGE
call superDoctorSearch(
	"pat_peggy" ,--inpatientAlias 
        "",--inFirstName 
        "",--inMiddleName 
        "",--inLastName 
        "",--inGender 
        -1,--inYearsLicensed 
        "",--inStreet_Name
        "",--inStreet_Number 
        "",--inApt_Number 
        "",--inPostalCode
        "",--inCity 
        "",--inProvince 
        "",--inSpecialization 
        -1,--inAverageStarRating
        -1,--inFriendReviewed
        ""--inReviewKeyword
);
*/

--O5.1:
--O5.1-5.4 will return email address as well
--for patients the email address should not be shown
--we should be able to easily limit that on client side
DROP PROCEDURE IF EXISTS getDoctorProfileInfo;

DELIMITER $
CREATE PROCEDURE getDoctorProfileInfo(in ingAlias VARCHAR(34))
BEGIN

        --remember to remove email address here
        SELECT * from FullDoctorView WHERE gAlias=ingAlias;


END
$
DELIMITER ;


--O5.2
DROP PROCEDURE IF EXISTS getDoctorSpecialization;

DELIMITER $
CREATE PROCEDURE getDoctorSpecialization(in ingAlias VARCHAR(34))
BEGIN


        SELECT SpecializationName from DoctorSpecialization WHERE gAlias=ingAlias;


END
$
DELIMITER ;

--O.5.3
DROP PROCEDURE IF EXISTS getDoctorWorkAddresses;

DELIMITER $
CREATE PROCEDURE getDoctorWorkAddresses(in ingAlias VARCHAR(34))
BEGIN

        SELECT Street_Name,Street_Number,Apt_Number,PostalCode,City,Province from WorkAddress where gAlias=ingAlias;

END
$
DELIMITER ;

--O5.4
DROP PROCEDURE IF EXISTS getDoctorReviewStats;

DELIMITER $
CREATE PROCEDURE getDoctorReviewStats(in ingAlias VARCHAR(34))
BEGIN

        SELECT AVG(StarRating) as AvgRating,Count(*) as NumReviews from Review where DoctorgAlias=ingAlias;

END
$
DELIMITER ;







--O6.1......---------------EVERYTHING FOR THIS PAGE IN ONE FUNCTION--------------

DROP PROCEDURE IF EXISTS getReviewAndNeighbors;

DELIMITER $
CREATE PROCEDURE getReviewAndNeighbors(in inReviewId INT)
BEGIN

        declare doctorAlias VARCHAR(34);
        declare currDate DATETIME;
        declare nextReviewId INT;
        declare prevReviewId INT;
        
        --remember to remove email address here
        SELECT DoctorgAlias, gDate INTO doctorAlias, currDate FROM Review WHERE ReviewContentID = inReviewId;

        SELECT ReviewContentID INTO prevReviewId FROM Review WHERE DoctorgAlias = doctorAlias AND gDate < currDate ORDER BY gDate DESC LIMIT 1;

        SELECT ReviewContentID INTO nextReviewId FROM Review WHERE DoctorgAlias = doctorAlias AND gDate > currDate ORDER BY gDate LIMIT 1;

        SELECT DoctorgAlias as DoctorAlias, Text as Comments, PatientgAlias as PatientAlias, StarRating, gDate as ReviewDate, FirstName, MiddleName, LastName, IFNULL(prevReviewId,-1) as nextReviewId, IFNULL(nextReviewId,-1) as prevReviewId FROM (SELECT DoctorgAlias, PatientgAlias, StarRating, gDate, Text  FROM Review  WHERE ReviewContentID = inReviewId) r INNER JOIN gName n ON r.DoctorgAlias = n.gAlias;

END
$
DELIMITER ;

--O6.1
/*
The only way to access this page is from the view doctor profile (O5) and so
we will for sure have the ReviewContentID for each of the reviews. So,
we can use the ReviewContentID to get the relevant review. In 6.2 we can get 
a list of all the ReviewIDs and then on the JAVA side we can find the NEXT and
PREVIOUS ReviewContentIDs and then those links will trigger this query again 
using the ReviewContentIDs
*/
DROP PROCEDURE IF EXISTS getSpecificReview;

DELIMITER $
CREATE PROCEDURE getSpecificReview(in inID INT)
BEGIN

        SELECT * from Review where ReviewContentID=inID;
END
$
DELIMITER ;

--O6.2
/*get a list of all the ReviewIDs and then on the JAVA side we can find the NEXT
and PREVIOUS ReviewContentIDs (it will be sorted)
*/


DROP PROCEDURE IF EXISTS getReviewIDs;

DELIMITER $
CREATE PROCEDURE getReviewIDs(in ingAlias VARCHAR(34))
BEGIN

        SELECT ReviewContentID from Review WHERE DoctorgAlias=ingAlias ORDER BY gDate DESC;
END
$
DELIMITER ;


--O7
--this is a simple insertion. Once this is done, the app goes back to the 
--doctor's profile and the data should automatically be accounted for
--if our queries are right

DROP PROCEDURE IF EXISTS writeDoctorReview;

DELIMITER $
CREATE PROCEDURE writeDoctorReview(in inPatientgAlias VARCHAR(34),in inDoctorgAlias VARCHAR(34),in inStarRating FLOAT, in inText VARCHAR(1002))
BEGIN

        INSERT INTO Review (PatientgAlias,DoctorgAlias,StarRating,gDate,Text)
        VALUES (inPatientgAlias,inDoctorgAlias,inStarRating,NOW(),inText);
END
$
DELIMITER ;



--O8 can be executed exactly like O5 but in O5 we must exclude the email address 
--column

--------------------------------------------------------Procedures    for  Testing----------------------------------------------------------------------------------------
----------------------------------xxxxxxxxxxxxxxxxxxxxxx--------------------------xxxxxxxxxxxxxxxxxxxxxx------------------------------------------------------------------
----------------------------------xxxxxxxxxxxxxxxxxxxxxx--------------------------xxxxxxxxxxxxxxxxxxxxxx------------------------------------------------------------------
----------------------------------xxxxxxxxxxxxxxxxxxxxxx--------------------------xxxxxxxxxxxxxxxxxxxxxx------------------------------------------------------------------
----------------------------------xxxxxxxxxxxxxxxxxxxxxx--------------------------xxxxxxxxxxxxxxxxxxxxxx------------------------------------------------------------------
----------------------------------xxxxxxxxxxxxxxxxxxxxxx--------------------------xxxxxxxxxxxxxxxxxxxxxx------------------------------------------------------------------
----------------------------------xxxxxxxxxxxxxxxxxxxxxx--------------------------xxxxxxxxxxxxxxxxxxxxxx------------------------------------------------------------------
----------------------------------xxxxxxxxxxxxxxxxxxxxxx--------------------------xxxxxxxxxxxxxxxxxxxxxx------------------------------------------------------------------
----------------------------------xxxxxxxxxxxxxxxxxxxxxx--------------------------xxxxxxxxxxxxxxxxxxxxxx------------------------------------------------------------------
----------------------------------xxxxxxxxxxxxxxxxxxxxxx--------------------------xxxxxxxxxxxxxxxxxxxxxx------------------------------------------------------------------
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
	gAlias VARCHAR(34) PRIMARY KEY,
	EmailAddress VARCHAR(66),
	PasswordHash VARCHAR(66),
	PasswordSalt VARCHAR(66)
);

DROP TABLE IF EXISTS Doctor;
CREATE TABLE Doctor(
	gAlias VARCHAR(34) PRIMARY KEY,
	Gender VARCHAR(8),
	YearMedicalLicense INT,
	FOREIGN KEY (gAlias) REFERENCES gUser(gAlias)
);

DROP TABLE IF EXISTS Patient;
CREATE TABLE Patient(
	gAlias VARCHAR(34) PRIMARY KEY,
	City VARCHAR(34),
	Province VARCHAR(34),
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

--------------------------------Reinsert all procs and function--------------------------



----------------------------Reinsert all their sample data--------------------------

--Insert USERS:

----Doctors:

CALL add_doctor ('doc_aiken','John','', 'Aikenhead','aiken@head.com','male','1990','doc_aiken');

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

call add_doctor ('doc_amnio','Jane','', 'Amniotic','obgyn_clinic@rogers.com','female',2005,'doc_amnio');

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


call add_doctor ('doc_umbilical','Mary','', 'Umbilical','obgyn_clinic@rogers.com','female',2006,'doc_umbilical');

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

call add_doctor ('doc_heart','Jack','', 'Hearty','jack@healthyheart.com','male',1980,'doc_heart');

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

call add_doctor ('doc_cutter','Beth','', 'Cutter','beth@tummytuck.com','female',2014,'doc_cutter');

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

SELECT COUNT(*) INTO num_matches FROM DoctorReviewsMetaData WHERE AvgStarRating >= avg_star_rating;

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

    SET review_keyword = CONCAT(review_keyword,'%');
    SET review_keyword = CONCAT('%',review_keyword);

   SELECT COUNT(*) INTO num_matches FROM 
    (
                    SELECT DISTINCT DoctorgAlias as DoctorAlias FROM (SELECT * FROM Review r LEFT JOIN (SELECT FriendAlias, 1 as IsFriend FROM (SELECT a.PatientgAliasA as FriendAlias FROM Friend a WHERE PatientgAliasB = patient_alias UNION SELECT b.PatientgAliasB FROM Friend b WHERE PatientgAliasA = patient_alias) f ) ff ON r.PatientgAlias = ff.FriendAlias)  e WHERE e.IsFriend = 1

    ) RF
    INNER JOIN
    (
            SELECT DISTINCT DoctorgAlias as DoctorAlias FROM Review WHERE Text COLLATE latin1_bin  LIKE review_keyword				
    ) RK
    ON
    RF.DoctorAlias = RK.DoctorAlias;
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




