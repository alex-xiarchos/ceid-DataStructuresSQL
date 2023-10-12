USE newspaper_db;

/* 3a */
DROP PROCEDURE IF EXISTS article_info;
DELIMITER $
CREATE PROCEDURE article_info(IN issueNum INT, IN paperName VARCHAR(50))
BEGIN
      DECLARE artPath VARCHAR(150);
      DECLARE artPages INT;
      DECLARE issuePages INT;
      DECLARE availablePages INT;
      DECLARE not_found INT;
      
      DECLARE artcursor CURSOR FOR
      SELECT art_path FROM article
      INNER JOIN issue ON art_issue_num=issue_number
      WHERE issue_number=issueNum AND paper_name=paperName
      ORDER BY art_start_page ASC;
      
      DECLARE CONTINUE HANDLER FOR NOT FOUND
      SET not_found=1;
      
      OPEN artcursor;
      SET not_found=0;
      
      REPEAT
             FETCH artcursor INTO artPath;
             IF(not_found=0)
             THEN
                  SELECT art_title, worker_name, worker_lname, art_approval_date, art_start_page, art_pages 
                  FROM article 
                  INNER JOIN submits ON article_path=art_path
                  INNER JOIN journalist ON jrn_email=journalist_email
                  INNER JOIN worker ON worker_email=journalist_email
                  WHERE art_path=artPath;
             END IF;
      UNTIL(not_found=1)
      END REPEAT;
      CLOSE artcursor;
      
      SELECT SUM(art_pages) INTO artPages
      FROM article WHERE art_issue_num=issueNum;
      
      SELECT issue_pages INTO issuePages
      FROM issue WHERE issue_number=issueNum;
      
      IF (artPages < issuePages)
        THEN SET availablePages=issuePages-artPages;
        SELECT availablePages;
      END IF;  
END$
DELIMITER ;

CALL article_info('6','Ta Nea tou CEID');
CALL article_info('1','Super Katina');


/* 3b */
DROP PROCEDURE IF EXISTS give_me_a_raise;
DELIMITER $
CREATE PROCEDURE give_me_a_raise(IN jrnEmail VARCHAR(50))
BEGIN
	   DECLARE employee VARCHAR(50);
       DECLARE wrkExperience INT;
       DECLARE startDate DATE;
       DECLARE currDiff FLOAT;
       DECLARE months INT;
       DECLARE raise FLOAT;
	   DECLARE not_found INT;
       
       DECLARE raise_cursor CURSOR FOR
       SELECT worker_email, recruitment_date, months_of_experience FROM worker
       INNER JOIN journalist ON worker_email=journalist_email
       WHERE journalist_email=jrnEmail;
       
       DECLARE CONTINUE HANDLER FOR NOT FOUND
       SET not_found=1;
       
       OPEN raise_cursor;
       SET not_found=0;
       
       REPEAT 
              FETCH raise_cursor INTO employee, startDate, wrkExperience;
              IF (not_found=0)
			  THEN
                   SET currDiff=DATEDIFF('2020-02-09', startDate);
                   SET currDIff=currDiff/30;
                   SET months=currDiff + wrkExperience;
                   SET raise=(months*0.5)/100;
                   
                   UPDATE worker SET worker_salary=worker_salary+raise
                   WHERE worker_email=employee;
                   
                   SELECT worker_name, worker_lname, worker_salary FROM worker
                   WHERE worker_email=employee;
              END IF;
	   UNTIL (not_found=1)
       END REPEAT;
	   CLOSE raise_cursor;
END$
DELIMITER ;

CALL give_me_a_raise('nikpapageo@gmail.com');


/* 3c */
DROP TRIGGER IF EXISTS basic_salary;
DELIMITER $
CREATE TRIGGER basic_salary BEFORE INSERT ON worker
FOR EACH ROW
BEGIN
      SET NEW.worker_salary='650';
END$
DELIMITER ;      
      
INSERT INTO worker VALUES
('sackofpotatoes@gmail.com','Tony','Zafiris','5000','2019-09-27','Ta Nea tou CEID','zaf63','5072');

/* 3d */
DROP TRIGGER IF EXISTS article_accepted;
DELIMITER $
CREATE TRIGGER article_accepted AFTER INSERT ON submits
FOR EACH ROW
BEGIN
      DECLARE editEmail VARCHAR(50);
      
      SELECT art_edit_email INTO editEmail FROM article
      INNER JOIN submits ON art_edit_email=jrn_email
      WHERE jrn_email=NEW.jrn_email LIMIT 1;
      
	  IF (NEW.jrn_email = editEmail)
	   THEN UPDATE article SET art_progress='Accepted' WHERE art_path=NEW.article_path;
	  END IF;
END$
DELIMITER ;   
/* eksetazoume th leitoyrgia tou trigger prin tis eisagwges ston pinaka 'submits' */
SELECT * FROM article;

/* 3e */
DROP TRIGGER IF EXISTS check_issue_pages;
DELIMITER $
CREATE TRIGGER check_issue_pages AFTER INSERT ON article
FOR EACH ROW
BEGIN
      DECLARE Pages INT;
      DECLARE issuePages INT;
	  
      SELECT SUM(art_pages), issue_pages INTO Pages, issuePages FROM article
      INNER JOIN issue ON art_issue_num=issue_number
      WHERE art_issue_num=NEW.art_issue_num;
      
      SET issuePages=issuePages-Pages;
      
      IF (issuePages < 0)
        THEN 
             SIGNAL SQLSTATE VALUE '45000'
             SET MESSAGE_TEXT='Den uparxei diathesimos xwros!';
	  END IF;

END$
DELIMITER ;
	
INSERT INTO article VALUES
('C:\articles\art7.doc','Theseis Ergasias gia Mihanikous','summary_of_art07','6','Ta Nea tou CEID','3','nikpapageo@gmail.com','Rejected',NULL,'24','10');
