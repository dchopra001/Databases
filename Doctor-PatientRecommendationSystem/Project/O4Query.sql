DROP PROCEDURE IF EXISTS superDoctorSearch;

DELIMITER $

CREATE PROCEDURE superDoctorSearch(
	in inpatientAlias VARCHAR(32),
	in inFirstName VARCHAR(32),
	in inMiddleName VARCHAR(32),
	in inLastName VARCHAR(32),
	in inGender VARCHAR(1),
	in inYearsLicensed INT,
	in inStreet_Name VARCHAR(32),
	in inStreet_Number VARCHAR(8),
	in inApt_Number VARCHAR(6),
	in inPostalCode VARCHAR(6),
	in inCity VARCHAR(32),
	in inProvince VARCHAR(32),
	in inSpecialization VARCHAR(32),
	in inAverageStarRating float,
	in inFriendReviewed INT,
	in inReviewKeyword VARCHAR(32)
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
	
	IF(inFirstName = "") THEN
            set inFirstName = "%";
        END IF;
        IF(inMiddleName = "") THEN
            set inMiddleName = "%";
        END IF;
        IF(inLastName = "") THEN
            set inLastName = "%";
        END IF;
        IF(inGender = "") THEN
            set inGender = "%";
        END IF;
        IF(inStreet_Name = "") THEN
            set inStreet_Name = "%";
        END IF;
        IF(inStreet_Number = "") THEN
            set inStreet_Number = "%";
        END IF;
        IF(inApt_Number = "") THEN
            set inApt_Number = "%";
        END IF;
        IF(inPostalCode = "") THEN
            set inPostalCode = "%";
        END IF;
        IF(inPostalCode = "") THEN
            set inPostalCode = "%";
        END IF;
        IF(inCity = "") THEN
            set inCity = "%";
        END IF;
        IF(inProvince = "") THEN
            set inProvince = "%";
        END IF;
        IF(inSpecialization = "") THEN
            set inSpecialization = "%";
        END IF;
        IF(inReviewKeyword = "") THEN
            set inReviewKeyword = "%";
        END IF;

        
	SELECT DoctorAlias as DoctorAlias, AvgStarRating, ReviewCount, Gender, YearMedicalLicense, FirstName, MiddleName, LastName FROM
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
			SELECT gAlias as DoctorAlias, Gender, YearMedicalLicense, FirstName, MiddleName, LastName, 1 As MetDFCriteria FROM FullDoctorView WHERE FirstName LIKE inFirstName AND MiddleName LIKE inMiddleName AND LastName LIKE inLastName AND year(CURDATE()) - YearMedicalLicense > inYearsLicensed AND Gender LIKE inGender
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
        "Mary",--inFirstName 
        "",--inMiddleName 
        "",--inLastName 
        "f",--inGender 
        -1,--inYearsLicensed 
        "",--inStreet_Name
        "",--inStreet_Number 
        "",--inApt_Number 
        "",--inPostalCode
        "",--inCity 
        "",--inProvince 
        "",--inSpecialization 
        -1,--inAverageStarRating
        1,--inFriendReviewed
        ""--inReviewKeyword
);
*/