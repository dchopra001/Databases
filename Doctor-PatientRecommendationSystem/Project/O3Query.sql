
SELECT RequestergAlias, EmailAddress from
(
SELECT RequestergAlias from FriendRequest where RequesteegAlias="pat_kate"
) x 
INNER JOIN gUser ON x.RequestergAlias=gUser.gAlias;
