DROP DATABASE IF EXISTS newspaper_db;
CREATE DATABASE newspaper_db;
USE newspaper_db;

CREATE TABLE publisher (
publisher_name VARCHAR(50) NOT NULL,
publisher_username VARCHAR(10) NOT NULL,
publisher_password CHAR(4) NOT NULL,
PRIMARY KEY(publisher_name)
);

CREATE TABLE newspaper (
newspaper_name VARCHAR(50) NOT NULL,
release_freq ENUM('Daily', 'Weekly', 'Monthly') NOT NULL,
paper_owner VARCHAR(50) NOT NULL,
PRIMARY KEY(newspaper_name),
CONSTRAINT owns FOREIGN KEY(paper_owner)
REFERENCES publisher(publisher_name)
ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE worker (
worker_email VARCHAR(50) NOT NULL,
worker_name VARCHAR(50) NOT NULL,
worker_lname VARCHAR(50) NOT NULL,
worker_salary FLOAT NOT NULL,
recruitment_date DATE NOT NULL,
paper_name VARCHAR(50) NOT NULL,
worker_username VARCHAR(10) NOT NULL,
worker_password CHAR(4) NOT NULL,
PRIMARY KEY(worker_email),
CONSTRAINT works_to FOREIGN KEY(paper_name)
REFERENCES newspaper(newspaper_name)
ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE journalist (
journalist_email VARCHAR(50) NOT NULL,
months_of_experience INT NOT NULL,
journalist_cv TEXT NOT NULL,
PRIMARY KEY(journalist_email),
CONSTRAINT isa_1 FOREiGN KEY(journalist_email)
REFERENCES worker(worker_email)
ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE administrative (
admin_email VARCHAR(50) NOT NULL,
admin_street VARCHAR(50) NOT NULL,
admin_number INT NOT NULL,
admin_city VARCHAR(50) NOT NULL,
admin_duty ENUM('Secretary', 'Logistics') NOT NULL,
PRIMARY KEY(admin_email),
CONSTRAINT isa_2 FOREIGN KEY(admin_email)
REFERENCES worker(worker_email)
ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE editor_in_chief (
editor_email VARCHAR(50) NOT NULL,
PRIMARY KEY(editor_email),
CONSTRAINT isa_3 FOREIGN KEY(editor_email)
REFERENCES worker(worker_email)
ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE phones (
administrative_email VARCHAR(50) NOT NULL,
phone_number CHAR(10) NOT NULL,
PRIMARY KEY(administrative_email, phone_number),
CONSTRAINT admin_phones FOREIGN KEY(administrative_email)
REFERENCES administrative(admin_email)
ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE issue (
paper_name VARCHAR(50) NOT NULL,
issue_number INT NOT NULL,
release_date DATE NOT NULL,
issue_pages INT DEFAULT '30' NOT NULL,
copies_printed INT NOT NULL,
copies_not_sold INT NOT NULL,
PRIMARY KEY(paper_name, issue_number),
CONSTRAINT publishes FOREIGN KEY(paper_name)
REFERENCES newspaper(newspaper_name)
ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE category (
cat_id INT NOT NULL AUTO_INCREMENT,
cat_name VARCHAR(50) NOT NULL,
cat_descr TEXT NOT NULL,
cat_parent INT,
PRIMARY KEY(cat_id),
CONSTRAINT is_father FOREIGN KEY(cat_parent)
REFERENCES category(cat_id)
ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE article (
art_path VARCHAR(150) NOT NULL,
art_title VARCHAR(150) NOT NULL,
art_summary TEXT NOT NULL,
art_issue_num INT NOT NULL,
art_issue_paper_name VARCHAR(50) NOT NULL,
art_category INT NOT NULL,
art_edit_email VARCHAR(250) NOT NULL,
art_progress ENUM('Accepted','Rejected','to_be_revised') NOT NULL,
art_approval_date DATE,
art_start_page INT NOT NULL,
art_pages INT NOT NULL,
PRIMARY KEY(art_path),
CONSTRAINT appears_in FOREIGN KEY(art_issue_paper_name, art_issue_num)
REFERENCES issue(paper_name, issue_number)
ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT belongs FOREIGN KEY(art_category)
REFERENCES category(cat_id)
ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT checks FOREIGN KEY(art_edit_email)
REFERENCES editor_in_chief(editor_email)
ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE submits (
jrn_email VARCHAR(50) NOT NULL,
article_path VARCHAR(150) NOT NULL,
submit_date DATE NOT NULL,
PRIMARY KEY(jrn_email, article_path),
CONSTRAINT submits_1 FOREIGN KEY(jrn_email)
REFERENCES journalist(journalist_email)
ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT submits_2 FOREIGN KEY(article_path)
REFERENCES article(art_path)
ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE keywords (
key_article_path VARCHAR(150) NOT NULL,
keyword VARCHAR(50) NOT NULL,
PRIMARY KEY(key_article_path, keyword),
CONSTRAINT article_keywords FOREIGN KEY(key_article_path)
REFERENCES article(art_path)
ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO publisher VALUES
('Kwstas Peletidis','pelet45','6305'),
('Alexander Xiarchos','alex99','1999'),
('Katina Paksinou','kat8','2082'),
('Iwannis Tsiligiris','tsili69','8123'),
('Stefanos Xios','stefxios2','8736');

INSERT INTO newspaper VALUES
('Peloponnisos','Daily','Kwstas Peletidis'),
('Ta Nea tou CEID','Weekly','Alexander Xiarchos'),
('Super Katina','Daily','Katina Paksinou'),
('EFIMERIDA ALITHEIAS','Monthly','Iwannis Tsiligiris'),
('Makeleio','Weekly','Stefanos Xios');

INSERT INTO worker VALUES
('nikpapageo@gmail.com','Nikiforos','Papageorgiou','5000','2019-09-23','Ta Nea tou CEID','nikpap12','4598'),
('katinapatrini@yahoo.com','Noula','Akrivopoulou','680','2008-05-28','Super Katina','noula45','0543'),
('raptopoulos@hotmail.com','Kostis','Raptopoulos','2500','2013-03-21','EFIMERIDA ALITHEIAS','rapk29','2194'),
('eisaiomarkatos@gmail.com','Nikos','Markatos','450','2011-02-09','Makeleio','nikmark6','0023'),
('mizeria@gmail.com','Mizeros','Mizeropoulos','1200','2007-09-08','Peloponnisos','miz56','5816'),
('eimaicringe@hotmail.com','Giannis','Konstantellos','2100','2017-10-05','Ta Nea tou CEID','konst3','0408'),
('copypaste@gmail.com','Eirini','Rouxwta','100','2020-01-01','Ta Nea tou CEID','rouh1','8452'),
('fuego@yahoo.com','Eleni','Foureira','3000','2015-03-25','Makeleio','four513','8700'),
('wannabeontop@gmail.com','Katia','Tarabanko','390','2019-10-10','Super Katina','kattar2','1195'),
('GTXS@gmail.com','Mustis','Alitheias','166','2018-04-28','EFIMERIDA ALITHEIAS','mtk79','4308');

INSERT INTO journalist VALUES
('katinapatrini@yahoo.com','37','CV_of_Akrivopoulou'),
('wannabeontop@gmail.com','205','CV_of_Tarabanko'),
('nikpapageo@gmail.com','120','CV_of_Papageorgiou'),
('GTXS@gmail.com','18','CV_of_Alitheias'),
('eimaicringe@hotmail.com','20','CV_of_Konstantellos');

INSERT INTO administrative VALUES
('copypaste@gmail.com','Glafkou','69','Patrara','Secretary'),
('nikpapageo@gmail.com','Olumpou','15','Xalandri','Logistics'),
('raptopoulos@hotmail.com','Pontou','10','Athina','Logistics');

INSERT INTO editor_in_chief VALUES
('eisaiomarkatos@gmail.com'),
('katinapatrini@yahoo.com'),
('mizeria@gmail.com'),
('nikpapageo@gmail.com'),
('raptopoulos@hotmail.com');

INSERT INTO phones VALUES
('copypaste@gmail.com','6969696969'),
('nikpapageo@gmail.com','6940908153'),
('nikpapageo@gmail.com','6943207112');

INSERT INTO issue VALUES
('Super Katina','1','2020-06-12',DEFAULT,'1856','58'),
('Ta Nea tou CEID','6','2019-12-20',DEFAULT,'960','170'),
('Ta Nea tou CEID','7','2019-11-20','40','960','143'),
('Peloponnisos','9','2014-07-23','29','5972','1064'),
('Makeleio','3','2000-02-01','34','3450','1892'),
('Super Katina','2','2020-09-10','27','1800','793');

INSERT INTO category VALUES
(NULL,'Foititika','description_of_Foititika',NULL),
(NULL,'Proptuxiaka','description_of_Proptuxiaka','1'),
(NULL,'Metaptuxiaka','description_of_Metaptuxiaka','1'),
(NULL,'Koinwnika','description_of_Koinwnika',NULL),
(NULL,'Politika','description_of_Politika',NULL),
(NULL,'Gossip','description_of_gossip',NULL),
(NULL,'Athlitika','description_of_Athlitika',NULL),
(NULL,'Podosfairo','description_of_Podosfairo','7'),
(NULL,'Basket','description_of_Basket','7');

INSERT INTO article VALUES
('C:\articles\art1.doc','Prwto Radevou: Ola ta mustika','summary_of_art1','1','Super Katina','6','katinapatrini@yahoo.com','Rejected','2019-03-23','5','12'),
('C:\articles\art2.doc','Pws na antigrapseis se eksetasi','summary_of_art02','6','Ta Nea tou CEID','2','nikpapageo@gmail.com','Rejected',NULL,'1','7'),
('C:\articles\art3.doc','Argisa 1 wra sti dialeksi: Pws na kanw theamatiki eisodo','summary_of_art3','6','Ta Nea tou CEID','2','nikpapageo@gmail.com','Rejected',NULL,'8','10'),
('C:\articles\art4.doc','H empeiria mou apo to ERASMUS','summary_of_art4','6','Ta Nea tou CEID','2','nikpapageo@gmail.com','Rejected','2019-03-26','18','8'),
('C:\articles\art5.doc','Showbiz kai koutsompolia','summary_of_art5','1','Super Katina','6','katinapatrini@yahoo.com','Accepted','2019-12-30','1','4'),
('C:\articles\art6.doc','Pws xwrisa ton Giannh','summary_of_art6','1','Super Katina','6','katinapatrini@yahoo.com','to_be_revised',NULL,'18','3');

INSERT INTO submits VALUES
('katinapatrini@yahoo.com','C:\articles\art1.doc','2019-03-23'),
('eimaicringe@hotmail.com','C:\articles\art2.doc','2019-03-24'),
('eimaicringe@hotmail.com','C:\articles\art3.doc','2019-03-25'),
('nikpapageo@gmail.com','C:\articles\art4.doc','2019-03-26'),
('wannabeontop@gmail.com','C:\articles\art5.doc','2019-12-28'),
('wannabeontop@gmail.com','C:\articles\art6.doc','2019-12-19');

INSERT INTO keywords VALUES
('C:\articles\art1.doc','radevou'),
('C:\articles\art1.doc','mustika'),
('C:\articles\art2.doc','antigrafi'),
('C:\articles\art2.doc','eksetasi'),
('C:\articles\art3.doc','dialeksi'),
('C:\articles\art3.doc','eisodos'),
('C:\articles\art4.doc','ERASMUS'),
('C:\articles\art5.doc','showbiz'),
('C:\articles\art6.doc','xwrismos');