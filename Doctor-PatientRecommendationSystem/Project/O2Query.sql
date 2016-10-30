


--O2
--returns 0 if friendship DNE and 1 (or more?) if it does
--input values must be exact!

DROP PROCEDURE IF EXISTS doesFriendshipExist;

DELIMITER $
CREATE PROCEDURE doesFriendshipExist(in ingAliasA VARCHAR(32), in ingAliasB VARCHAR(32), out rslt INT)
BEGIN

        SELECT COUNT(*) INTO rslt from Friend where ((PatientgAliasA=ingAliasA and PatientgAliasB=ingAliasB) OR (PatientgAliasA=ingAliasB and PatientgAliasB=ingAliasA));


END
$
DELIMITER ;

CALL doesFriendshipExist("pat_homer","pat_kate", @cnt);
SELECT @cnt

SELECT * from Friend