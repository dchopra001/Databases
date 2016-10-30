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
							 SELECT DISTINCT gAlias as DoctorAlias, "1" As MetWACriteria FROM WorkAddress WHERE Street_Name LIKE "%" AND  Street_Number LIKE "%" AND  Apt_Number LIKE "%" AND PostalCode LIKE "%" AND City LIKE "%" AND Province LIKE "%" 
						) WA
					INNER JOIN
						(
							SELECT DISTINCT gAlias as DoctorAlias, "1" As MetSPCriteria FROM DoctorSpecialization WHERE SpecializationName LIKE "%" 
						) SP
					ON
					WA.DoctorAlias = SP.DoctorAlias
				) WA_SP
				LEFT JOIN
				(
						SELECT DISTINCT DoctorgAlias as DoctorAlias, "1" as MetRFCriteria FROM (SELECT * FROM Review r LEFT JOIN (SELECT FriendAlias, 1 as IsFriend FROM (SELECT a.PatientgAliasA as FriendAlias FROM Friend a WHERE PatientgAliasB="pat_peggy" UNION SELECT b.PatientgAliasB FROM Friend b WHERE PatientgAliasA = "pat_peggy") f ) ff ON r.PatientgAlias = ff.FriendAlias)  e WHERE e.IsFriend = '1'

				) RF
				ON
				WA_SP.DoctorAlias = RF.DoctorAlias
			) WA_SP_RF
			LEFT JOIN
			(
				SELECT DISTINCT DoctorgAlias as DoctorAlias, "1" as MetRKCriteria FROM Review WHERE Text LIKE "%"				
			) RK
			ON
			WA_SP_RF.DoctorAlias = RK.DoctorAlias
		) WA_SP_RF_RK
		LEFT JOIN
		(
			SELECT DoctorgAlias as DoctorAlias, "1" as MetRMCriteria, AvgStarRating, ReviewCount FROM DoctorReviewsMetaData WHERE AvgStarRating > -1 AND ReviewCount > -1
		) RM
		ON
		WA_SP_RF_RK.DoctorAlias = RM.DoctorAlias
	) WA_SP_RF_RK_RM
	INNER JOIN
	(
		SELECT gAlias as DoctorAlias, Gender, YearMedicalLicense, FirstName, MiddleName, LastName, "1" As MetDFCriteria FROM FullDoctorView WHERE FirstName LIKE "%" AND MiddleName LIKE "%" AND LastName LIKE "%" AND year(CURDATE()) - YearMedicalLicense > -1 AND Gender LIKE "%"
	) DF
	ON
	WA_SP_RF_RK_RM.DoctorAlias = DF.DoctorAlias
) MagicTable









