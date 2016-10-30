
SELECT * from Review where ReviewContentID=1

--For links to the next doctors, we can use this query and find the value of
--the next and previous ReviewContentIDs
SELECT ReviewContentID from Review WHERE DoctorgAlias="doc_heart"