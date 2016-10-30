--Insert USERS:

----Doctors:


call add_doctor ("doc_aiken","John","", "Aikenhead","aiken@head.com","M",1990,"doc_aiken");

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

call add_doctor ("doc_amnio","Jane","", "Amniotic","obgyn_clinic@rogers.com","F",2005,"doc_amnio");

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


call add_doctor ("doc_umbilical","Mary","", "Umbilical","obgyn_clinic@rogers.com","F",2006,"doc_umbilical");

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

call add_doctor ("doc_heart","Jack","", "Hearty","jack@healthyheart.com","M",1980,"doc_heart");

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

call add_doctor ("doc_cutter","Beth","", "Cutter","beth@tummytuck.com","F",2014,"doc_cutter");

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

call add_patient("pat_bob", "Bob", "", "Bobberson", "thebobbersons@sympatico.ca",  "pat_bob", "Waterloo", "Ontario");


--2. 

call add_patient("pat_peggy", "Peggy", "", "Bobberson", "thebobbersons@sympatico.ca",  "pat_peggy", "Waterloo", "Ontario");
--3. 

call add_patient("pat_homer", "Homer", "", "Homerson", "homer@rogers.com",   "pat_homer", "Kitchener", "Ontario");
--4.


call add_patient("pat_kate", "Kate", "", "Katemyer", "kate@hello.com",  "pat_kate", "Cambridge", "Ontario");
--5. 


call add_patient("pat_anne", "Anne", "", "Macdonald", "anne@gmail.com",  "pat_anne", "Guelph", "Ontario");


---------------------------------------------Sample data into friend table xxxxxxxxxxxxxxxxxxxxxxxxNOT OFFICIALxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx:
INSERT INTO Friend (PatientgAliasA, PatientgAliasB)
VALUES ("pat_peggy","pat_homer");
INSERT INTO Friend (PatientgAliasA, PatientgAliasB)
VALUES ("pat_anne","pat_kate");
INSERT INTO Friend (PatientgAliasA, PatientgAliasB)
VALUES ("pat_bob","pat_peggy");

--Sample data into friendrequest table:
INSERT INTO FriendRequest (RequestergAlias, RequesteegAlias)
VALUES ("pat_homer","pat_kate");
INSERT INTO FriendRequest (RequestergAlias, RequesteegAlias)
VALUES ("pat_bob","pat_kate");

--Sample data for review table:
INSERT INTO Review (ReviewContentID,PatientgAlias,DoctorgAlias,StarRating, gDate,Text )
VALUES (1,"pat_kate","doc_heart",1, "01/01/07", "Shditewter" );

INSERT INTO Review (ReviewContentID,PatientgAlias,DoctorgAlias,StarRating, gDate,Text )
VALUES (2,"pat_peggy","doc_heart",2, "01/01/02", "Shit" );

INSERT INTO Review (ReviewContentID,PatientgAlias,DoctorgAlias,StarRating, gDate,Text )
VALUES (3,"pat_peggy","doc_umbilical",3, "01/01/03", "Shitter" );

INSERT INTO Review (ReviewContentID,PatientgAlias,DoctorgAlias,StarRating, gDate,Text )
VALUES (4,"pat_homer","doc_amnio",4, "01/01/04", "Shditter" );

INSERT INTO Review (ReviewContentID,PatientgAlias,DoctorgAlias,StarRating, gDate,Text )
VALUES (5,"pat_homer","doc_umbilical",5, "01/01/05", "Shditewter" );
