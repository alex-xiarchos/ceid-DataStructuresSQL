DROP DATABASE IF EXISTS user1059619;
CREATE DATABASE user1059619;
USE user1059619;

CREATE TABLE student(
`name` VARCHAR(25) DEFAULT 'unknown' NOT NULL,
`lastname` VARCHAR(25) DEFAULT 'unknown' NOT NULL,
`AM` INT(5) NOT NULL AUTO_INCREMENT,
PRIMARY KEY(`AM`)
) ENGINE = InnoDB;

CREATE TABLE professor(
`pr_name` VARCHAR(25) DEFAULT 'unknown' NOT NULL,
`pr_lastname` VARCHAR(25) DEFAULT 'unknown' NOT NULL,
`email` VARCHAR(255) NOT NULL,
PRIMARY KEY(`email`)
) ENGINE = InnoDB;

CREATE TABLE course(
	`title` VARCHAR(255) DEFAULT 'unknown' NOT NULL,
    `material` TEXT,
	`course_id` INT(4) NOT NULL AUTO_INCREMENT,
	`supervisor` VARCHAR(255) NOT NULL,
	PRIMARY KEY(`course_id`),
	UNIQUE(`title`),
	CONSTRAINT SUPERVISED
	FOREIGN KEY (`supervisor`) REFERENCES professor(`email`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE books (
	`title` VARCHAR(128) DEFAULT 'Title' NOT NULL,
	`course_book` INT(4) NOT NULL,
	PRIMARY KEY (`title`, `course_book`),
	CONSTRAINT CRSBOOK
	FOREIGN KEY (`course_book`) REFERENCES course(`course_id`)
	ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS lecture(
	`subject` VARCHAR(128),
	`num_lecture` INT(2) NOT NULL,
	`course_lecture` INT(4) NOT NULL,
	PRIMARY KEY(`num_lecture`, `course_lecture`),
	CONSTRAINT CRSLECTURE
    FOREIGN KEY (`course_lecture`) REFERENCES course(`course_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE registration(
	`reg_date` DATE NOT NULL,
	`reg_student` INT(5) NOT NULL,
	`reg_course` INT(4) NOT NULL,
	PRIMARY KEY (`reg_student`, `reg_course`),
	CONSTRAINT CRSREGISTRATION FOREIGN KEY (`reg_course`) REFERENCES course(`course_id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT STDNTREGISTRATION FOREIGN KEY (`reg_student`) REFERENCES student(`AM`) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP PROCEDURE IF EXISTS 