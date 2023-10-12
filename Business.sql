DROP DATABASE if exists businessregistry;
CREATE DATABASE businessregistry DEFAULT CHARSET=greek;
USE businessregistry;

CREATE TABLE IF NOT EXISTS doy(
  id_kataxorisis int NOT NULL AUTO_INCREMENT,
  establish_year year(4) NOT NULL,
  url varchar(50) NOT NULL,
  name varchar(50) NOT NULL,
  PRIMARY KEY (id_kataxorisis)
) ENGINE = InnoDB CHARACTER SET greek COLLATE greek_general_ci;

CREATE TABLE IF NOT EXISTS business(
  businessname varchar(250) NOT NULL,
  title varchar(250) NOT NULL,
  registerdate datetime NOT NULL,
  id int NOT NULL,
  city varchar(50) NOT NULL,
  tk varchar(10) NOT NULL,
  number varchar(20) NOT NULL,
  branch int,
  doy_id int NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (branch) REFERENCES business(id)
  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (doy_id) REFERENCES doy(id_kataxorisis)
  ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET greek COLLATE greek_general_ci;

CREATE TABLE IF NOT EXISTS statutefile(
  path varchar(250) NOT NULL,
  size int NOT NULL,
  bus_id int NOT NULL,
  publicity boolean NOT NULL,
  registerdate datetime NOT NULL,
  PRIMARY KEY (path,bus_id),
  FOREIGN KEY (bus_id) REFERENCES business(id)
  ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET greek COLLATE greek_general_ci;

CREATE TABLE IF NOT EXISTS person(
  name varchar(100) NOT NULL,
  afm char(9) NOT NULL,
  email varchar(50) NOT NULL,
  cv text NOT NULL,
  genre ENUM('MALE','FEMALE') NOT NULL,
  PRIMARY KEY (afm)
) ENGINE = InnoDB CHARACTER SET greek COLLATE greek_general_ci;

CREATE TABLE IF NOT EXISTS auditor(
  person_afm char(9) NOT NULL,
  soel int NOT NULL,
  type ENUM('ANAPLHRWMATIKOS','TAKTIKOS') NOT NULL,
  service_start_date datetime NOT NULL,
  PRIMARY KEY (person_afm),
  FOREIGN KEY (person_afm) REFERENCES person(afm)
  ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET greek COLLATE greek_general_ci;

CREATE TABLE IF NOT EXISTS auditor_check(
  bus_id int NOT NULL,
  afm_auditor char(9) NOT NULL,
  startdate datetime NOT NULL,
  enddate datetime NOT NULL,
  PRIMARY KEY (bus_id,afm_auditor),
  FOREIGN KEY (bus_id) REFERENCES business(id)
  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (afm_auditor) REFERENCES auditor(person_afm)
  ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET greek COLLATE greek_general_ci;

CREATE TABLE IF NOT EXISTS shareholder(
  person_afm char(9) NOT NULL,
  nationality varchar(50) NOT NULL,
  PRIMARY KEY (person_afm),
  FOREIGN KEY (person_afm) REFERENCES person(afm)
  ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET greek COLLATE greek_general_ci;

CREATE TABLE IF NOT EXISTS share(
  bus_id int NOT NULL,
  afm_shareholder char(9) NOT NULL,
  percentage float(5,2) NOT NULL,
  ds_member boolean NOT NULL,
  PRIMARY KEY (bus_id,afm_shareholder),
  FOREIGN KEY (bus_id) REFERENCES business(id)
  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (afm_shareholder) REFERENCES shareholder(person_afm)
  ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET greek COLLATE greek_general_ci;

CREATE TABLE IF NOT EXISTS telephones(
  telephone_number char(10) NOT NULL,
  person_afm char(9) NOT NULL,
  PRIMARY KEY (person_afm,telephone_number),
  FOREIGN KEY (person_afm) REFERENCES person(afm)
  ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET greek COLLATE greek_general_ci;

CREATE TABLE IF NOT EXISTS chamber(
  edra varchar(20) NOT NULL,
  name varchar(50) NOT NULL,
  type varchar(50) NOT NULL,
  PRIMARY KEY (name)
) ENGINE = InnoDB CHARACTER SET greek COLLATE greek_general_ci;

CREATE TABLE IF NOT EXISTS belongs(
  bus_id int NOT NULL,
  ch_name varchar(50) NOT NULL,
  PRIMARY KEY (bus_id,ch_name),
  FOREIGN KEY (bus_id) REFERENCES business(id)
  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (ch_name) REFERENCES chamber(name)
  ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET greek COLLATE greek_general_ci;


USE businessregistry;

INSERT INTO doy VALUES
(1, '1980','zathin@doy.gr','DOY Z Athinwn'),
(2, '1988','apatrwn@doy.gr','DOY A PATRWN'),
(3, '1988','bpatrwn@doy.gr','DOY B PATRWN'),
(4, '1983','korin@doy.gr','DOY KORINTHOU'),
(5, '1989','volos@doy.gr','DOY Volou'),
(6, '1990','tripoli@doy.gr','DOY Tripolis');

INSERT INTO business VALUES 
('Vasilopoulos Nikolaos', 'Vasilopoulos','1995-05-20 00:00',26400,'Volos',20004,120,NULL,5),
('Tzatzadaki Maria', 'Tzatzadakis','1992-10-02 00:00',20001,'Patra',24222,58,NULL,2),
('Tzatzadaki Maria', 'Tzatzadakis','1998-08-04 00:00',31200,'Patra',24228,180,20001,3),
('Tzatzadaki Maria', 'Tzatzadakis Ypokatastima 2','1998-08-04 00:00',31201,'Patra',24228,180,31200,3),
('Papadopoulos Ioannis', 'Papadopoulou Mpiskota','2000-01-15 00:00',18777,'Athina',27366,280,NULL,1),
('Kallimani Athanasia', 'Thalassina Kallimanis','2000-03-17 00:00',54874,'Korinthos',22008,71,NULL,4),
('Xristopoulos Ioannis','Chris','2010-05-05 00:00',80000,'Athina',24111,56,NULL,1),
('Kallimani Athanasia', 'Thalassina Kallimanis Kalamatas','2000-03-25 00:00',54875,'Kalamata',25005,23,54874,4),
('Kallimani Athanasia', 'Thalassina Kallimanis Spartis','2000-04-17 00:00',54876,'Sparti',28667,34,54874,4),
('Kallimani Athanasia', 'Thalassina Kallimanis Spartis A tomeas','2000-04-17 00:00',54877,'Sparti',28667,34,54876,4),
('Kallimani Athanasia', 'Thalassina Kallimanis Spartis B tomeas','2000-04-18 00:00',54878,'Sparti',28667,34,54876,4),
('Kallimani Athanasia', 'Thalassina Kallimanis Spartis A tomeas Syskevastirio','2000-04-24 00:00',54879,'Sparti',28667,34,54877,4);


INSERT INTO statutefile VALUES 
('C:\docs\statute\ ',8,26400,0,'2011-02-20 14:35:24'),
('C:\falekos1\arxeio\ ',3,18777,1,'2012-10-05 09:30:14'),
('C:\fakelos2\arxeio2\ ',10,54874,1,'2011-02-20 20:30:55'),
('C:\falekos3\arxeio3\ ',5,54874,1,'2011-02-20 16:06:47');

INSERT INTO person VALUES
('Xristopoulos Panagioths','100000012','xristo@mail.com','cv 1','MALE'),
('Xristou Theodwra','100000250','theodxristo@gmail.com','cv 2','FEMALE'),
('Papadopoulou Niki','200000333','papadop@gmail.com','cv 3','FEMALE'),
('Dimitriou Vasiliki','200001006','dimitr@hotmail.com','cv 4','FEMALE'),
('Kostopoulos Stavros','210000050','kostopoulos@hotmail.com','cv 5','MALE'),
('Anagnostopoulos Xristos','103640089','anagnos@hotmail.gr','cv 6','MALE'),
('Papas Mairy','181560050','mapapado@yahoo.com','cv 7','FEMALE'),
('Zaxariou Iosif','172630020','zaxar@mail.com','cv 8','MALE'),
('Zaxariou Maria','172630021','zaxarm@mail.com','cv 8.1','FEMALE'),
('Zaxariou Iwanna','172630022','zaxari@mail.com','cv 8.2','FEMALE'),
('Neofytou Neofyta','105200066','neofytou@gmail.com','cv 9','FEMALE'),
('Neofytou Eleni','105200067','neofytoue@gmail.com','cv 10','FEMALE'),
('Neofytos Kwstas','105200068','neofytos@gmail.com','cv 11','MALE');

INSERT INTO auditor VALUES
('200000333',560,'TAKTIKOS','2001-11-12 00:00'),
('200001006',200,'TAKTIKOS','2010-04-03 00:00'),
('210000050',120,'ANAPLHRWMATIKOS','2009-02-20 00:00'),
('100000250',122,'ANAPLHRWMATIKOS','2004-09-25 00:00');

INSERT INTO auditor_check VALUES
(26400,'200001006','2010-08-01 00:00','2011-09-01 00:00'),
(31200,'100000250','2004-10-18 00:00','2006-12-05 00:00'),
(20001,'200000333','2002-01-08 00:00','2007-01-08 00:00'),
(18777,'210000050','2009-05-10 00:00','2011-02-20 00:00'),
(80000,'200000333','2009-02-02 00:00','2011-03-03 00:00'),
(18777,'200001006','2010-09-09 00:00','2012-05-05 00:00'),
(31200,'200000333','2011-02-10 00:00','2012-03-03 00:00'),
(54874,'200000333','2011-03-02 00:00','2011-03-13 00:00'),
(54877,'200001006','2011-04-09 00:00','2012-05-05 00:00'),
(54878,'210000050','2011-05-10 00:00','2012-03-03 00:00'),
(31201,'100000250','2011-12-11 00:00','2012-05-05 00:00');

INSERT INTO shareholder VALUES
('100000012','ellhnikhs'),
('181560050','agglikhs'),
('172630020','evraikhs'),
('172630021','evraikhs'),
('172630022','evraikhs'),
('105200066','kypriakhs'),
('105200067','kypriakhs'),
('105200068','kypriakhs');

INSERT INTO share VALUES
(54874,'100000012',25.00,1),
(26400,'172630020',10.50,0),
(26400,'172630021',30.00,1),
(26400,'172630022',40.00,1),
(20001,'181560050',50.00,1),
(18777,'105200066',35.00,1),
(18777,'105200067',25.00,1),
(18777,'105200068',40.00,1),
(18777,'181560050',15.00,1),
(18777,'172630020',15.00,1),
(18777,'172630022',05.00,1),
(18777,'172630021',11.00,1),
(31200,'172630020',120.00,1);

INSERT INTO telephones VALUES
('2610222555','100000012'),
('2105566880','100000250'),
('2610333000','200000333'),
('2106662220','103640089'),
('2104440002','200001006');

INSERT INTO chamber VALUES
('Patra','Epimelitirio Axaias','Emporiko'),
('Volos','Epimelitirio Volou','Emporiko'),
('Athina','Biotexniko Epimelitirio','Biotexniko'),
('Korinthos','Epimelitirio Korinthou','Emporiko'),
('Athina','Ksenodoxeiako Epimelhthrio','Ksenodoxeiako'),
('Patra','Texniko Epimelitirio Patrwn','Texniko');

INSERT INTO belongs VALUES
(18777,'Epimelitirio Volou'),
(20001,'Epimelitirio Axaias'),
(54874,'Epimelitirio Korinthou'),
(20001,'Epimelitirio Korinthou'),
(31200,'Epimelitirio Axaias');

-- SELECT url, name FROM doy WHERE establish_year >= 1985;
-- SELECT name, afm FROM person WHERE email LIKE '%hotmail%' AND genre = 'MALE';
-- SELECT businessname, title FROM business WHERE id > 20000 ORDER BY businessname, doy_id ASC LIMIT 0,3; 

-- SELECT business.businessname, statutefile.registerdate
-- FROM statutefile INNER JOIN business ON statutefile.bus_id=business.id
-- WHERE businessname LIKE 'Papadopoulos%';

-- SELECT person.name, telephones.telephone_number
-- FROM person INNER JOIN telephones ON telephones.person_afm = person.afm
-- WHERE person.genre = 'FEMALE' AND telephones.telephone_number LIKE '210%';

-- SELECT afm_auditor, count(*)
-- FROM auditor_check GROUP BY afm_auditor HAVING count(*) > 1;

-- SELECT count(*), edra FROM chamber GROUP BY edra ORDER BY count(*) DESC;

-- SELECT person.name, person.afm, auditor.soel
-- FROM auditor INNER JOIN person ON person.afm = auditor.person_afm
-- INNER JOIN auditor_check ON auditor_check.afm_auditor = auditor.person_afm
-- INNER JOIN business ON business.id = auditor_check.bus_id
-- WHERE business.registerdate > 1995 ORDER BY person.name ASC;

-- SELECT a.businessname AS parent, b.businessname AS child
-- FROM business AS a LEFT JOIN business AS b ON a.id = b.branch;

DROP PROCEDURE IF EXISTS getAuditorsPerBusiness;
DELIMITER $
CREATE PROCEDURE getAuditorsPerBusiness(doyID INT)
	BEGIN
		DECLARE bid INT;
        
        DECLARE not_found_flag INT;
        DECLARE bcursor CURSOR FOR
        SELECT id FROM business WHERE doy_id = doyID;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET not_found_flag = 1;
        SET not_found_flag = 0;
        
        OPEN bcursor;
        REPEAT
			FETCH bcursor INTO bid;
            IF (not_found_flag = 0) THEN
				SELECT id, businessname, title FROM business WHERE id = bid;
                SELECT name, afm, soel, type FROM auditor_check
                INNER JOIN auditor ON afm_auditor=person_afm
                INNER JOIN person ON person_afm = afm
                WHERE bus_id = bid;
			END IF;
		UNTIL (not_found_flag = 1)
        END REPEAT;
        
        CLOSE bcursor;
    END $
DELIMITER ;

CALL getAuditorsPerBusiness(3);