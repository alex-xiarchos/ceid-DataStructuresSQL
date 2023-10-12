DROP DATABASE IF EXISTS user1059619;
CREATE DATABASE user1059619;
USE user1059619;

CREATE TABLE doctor (
	`id` int(5) AUTO_INCREMENT NOT NULL,
    `name` varchar(50) DEFAULT 'unknown' NOT NULL,
    `surname` varchar(50) DEFAULT 'unknown' NOT NULL,
    `sex` ENUM('MALE', 'FEMALE', 'OTHER') NOT NULL,
    `AT` varchar(10) NOT NULL,
    `street_name` varchar(50) DEFAULT 'unknown' NOT NULL,
    `street_number` int(3) NOT NULL,
    `city` varchar(50) DEFAULT 'unknown' NOT NULL,
    `office_number` int(5) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE diploma (
	`doctor_id` int(5) NOT NULL,
    `title` varchar(50) DEFAULT 'unknown' NOT NULL,
    `date` DATE NOT NULL,
    `speciality` SET('Heart', 'Anus') NOT NULL,
    PRIMARY KEY (`title`, `doctor_id`),
    CONSTRAINT DOCTORID
    FOREIGN KEY (`doctor_id`) REFERENCES doctor(`id`)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE clinic (
	`name` varchar(50) DEFAULT 'Unknown' NOT NULL,
    `rooms_number` INT(3) NOT NULL,
    `building` ENUM('Evaggelismos', 'Theotokou'),
    `floor` int(1) NOT NULL, 
    `head` int(5) NOT NULL,
    `from` DATE NOT NULL,
    `until` DATE NOT NULL,
    PRIMARY KEY (`name`),
    CONSTRAINT HEAD
    FOREIGN KEY (`name`) REFERENCES doctor(`id`)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE patient (
	`id` int(5) AUTO_INCREMENT NOT NULL,
    `name` varchar(50) DEFAULT 'unknown' NOT NULL,
    `surname` varchar(50) DEFAULT 'unknown' NOT NULL,
    `sex` ENUM('MALE', 'FEMALE', 'OTHER') NOT NULL,
    `AT` varchar(10) NOT NULL,
    `street_name` varchar(50) DEFAULT 'unknown' NOT NULL,
    `street_number` int(3) NOT NULL,
    `city` varchar(50) DEFAULT 'unknown' NOT NULL,
    `clinic` varchar(50) DEFAULT 'Unknown' NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT HOSPITAL
    FOREIGN KEY (`clinic`) REFERENCES
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE telephones (
	`doctor_id` int(5) NOT NULL,
    `telephone` int(10) NOT NULL,
    PRIMARY KEY (`doctor_id`, `telephone`),
    CONSTRAINT DOCTORID
    FOREIGN KEY (`doctor_id`) REFERENCES doctor(`id`)
    ON UPDATE CASCADE ON DELETE CASCADE
); 

CREATE TABLE drugs (
	`patient_id` int(5) NOT NULL,
    `drug` varchar(100) DEFAULT 'Unknown' NOT NULL,
    PRIMARY KEY (`patient_id`, `drug`),
    CONSTRAINT PATIENTID
    FOREIGN KEY (`patient_id`) REFERENCES patient(`id`)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE doctor_works (
	`doctor_id` int(5) NOT NULL,
    `clinic_name` varchar(50) DEFAULT 'Unknown' NOT NULL,
    PRIMARY KEY (`doctor_id`, `clinic_name`),
    CONSTAINT CLINICNAME
    FOREIGN KEY (`clinic_name`) REFERENCES 
);

CREATE TABLE responsible (
	`doctor_id` int(5) NOT NULL,
    `patient_id` int(5) NOT NULL,
    PRIMARY KEY (`doctor_id`, `patient_id`),
	CONSTRAINT PATIENTID
    FOREIGN KEY (`patient_id`) REFERENCES patient(`id`)
    ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT DOCTORID
    FOREIGN KEY (`doctor_id`) REFERENCES doctor(`id`)
    ON UPDATE CASCADE ON DELETE CASCADE
);