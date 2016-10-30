--O5:
/*
output: name, gender, work addresses, areas of specialization, numYearsLcsnd
        Avg Star Rating, NumReviews, Links to individual Reviews (reverse chrono)
        --link to write a new review

Input: Doctor Alias
*/

--We can write a stored procs that will generate all of this

--SELECT * FROM FullDoctorView 

-- get all of a doctor's specializations in one row concatenated
--SET group_concat_max_len = 2048
/*
SELECT NumYearsLicensed,Gender,AgAlias,Specialization,Address,FullName from
(
SELECT * from
(
SELECT AgAlias,Specialization,Address from
(
SELECT * from (SELECT gAlias as AgAlias, GROUP_CONCAT(SpecializationName SEPARATOR ',') as Specialization from DoctorSpecialization where gAlias="doc_aiken") A
) D
INNER JOIN
(
SELECT * FROM (SELECT gAlias as BgAlias, CONCAT(Street_Number,',',Street_Name,',', Apt_Number,',',City,',',Province,',',PostalCode) as Address FROM WorkAddress WHERE gAlias="doc_aiken") B
) C
ON
AgAlias = BgAlias
) X
INNER JOIN
(

SELECT * FROM (SELECT gAlias as EgAlias,CONCAT(FirstName,',',MiddleName,',',LastName) as FullName from gName WHERE gAlias = "doc_aiken") E 
) Y
ON
AgAlias=EgAlias
) Z
INNER JOIN
(
SELECT gAlias as LgAlias,Gender,(YEAR(CURDATE()) - YearMedicalLicense) as NumYearsLicensed from Doctor
) L
ON LgAlias=AgAlias
*/
--These 4 queries will return all the data we need for O5 and O8
SELECT * from FullDoctorView WHERE gAlias="doc_aiken"
SELECT SpecializationName from DoctorSpecialization WHERE gAlias="doc_aiken"
SELECT Street_Name,Street_Number,Apt_Number,PostalCode,City,Province from WorkAddress where gAlias="doc_aiken"
SELECT ReviewContentID,AVG(StarRating) as AvgRating,Count(*) from Review where DoctorgAlias="doc_heart"