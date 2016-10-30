/*SELECT 
Patient.gAlias, Patient.City, Patient.Province, Review.ReviewContentID 
FROM Patient
INNER JOIN Review
ON Patient.gAlias=Review.PatientgAlias
*/
DROP PROCEDURE IF EXISTS patientToPatientSearch;

DELIMITER $
CREATE PROCEDURE patientToPatientSearch(in ingAlias VARCHAR(32), in inProvince VARCHAR(32), in inCity VARCHAR(32))
BEGIN
        SET ingAlias = CONCAT('%',ingAlias);
        SET ingAlias = CONCAT(ingAlias,'%');
        SET inProvince = CONCAT('%',inProvince);
        SET inProvince = CONCAT(inProvince,'%');
        SET inCity = CONCAT('%',inCity);
        SET inCity = CONCAT(inCity,'%');
        SELECT PatientgAlias, LastReviewDate, ReviewCount, City, Province FROM 
            (
            SELECT PatientgAlias, MAX(gDate) as LastReviewDate, COUNT(*) as ReviewCount FROM Review
            GROUP BY PatientgAlias 
            ) PatientReview
            INNER JOIN 
            (
            SELECT gAlias,City,Province FROM Patient
            where gAlias LIKE ingAlias and City LIKE inCity and Province LIKE inProvince
            ) filteredPatients 
            ON PatientReview.PatientgAlias = filteredPatients.gAlias;
END
$
DELIMITER ;


