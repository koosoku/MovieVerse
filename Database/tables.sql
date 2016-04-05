SET SEARCH_PATH TO MOVIEVERSE;

CREATE TABLE PERSON(
	USERID VARCHAR(50) PRIMARY KEY,
	PASSWORD VARCHAR(50),
	LASTNAME  VARCHAR(50),
	FIRSTNAME  VARCHAR(50),
	EMAIL VARCHAR(50),
	CITY VARCHAR(50),
	PROVINCE VARCHAR(50),
	COUNTRY VARCHAR(50)
);

CREATE TABLE PROFILE(
	USERID VARCHAR(50) PRIMARY KEY,
	AGERANGE VARCHAR(50),
	YEARBORN  INT CHECK ( YEARBORN > 1900 AND YEARBORN < 2016),
	GENDER  VARCHAR(50) CHECK ( GENDER IN ('MALE', 'FEMALE', 'OTHER')),
	OCCUPATION VARCHAR(50),
	DEVICEUSED VARCHAR(50),
	FOREIGN KEY (USERID) REFERENCES PERSON
);

CREATE TABLE TOPICS(
	TOPICID INT PRIMARY KEY,
	DESCRIPTION VARCHAR(50)
);

CREATE TABLE MOVIE(
	MOVIEID VARCHAR(50) PRIMARY KEY,
	NAME VARCHAR(50),
	DATERELEASED DATE
);

CREATE TABLE WATCHES(
	MOVIEID VARCHAR(50),
	USERID VARCHAR(50), 
	PRIMARY KEY (MOVIEID, USERID),
	DATEWATCHED DATE,
	RATING INT,
	FOREIGN KEY (USERID) REFERENCES PERSON,
	FOREIGN KEY (MOVIEID) REFERENCES MOVIE
);

CREATE TABLE MOVIETOPICS(
	MOVIEID VARCHAR(50),
	TOPICID INT, 
	PRIMARY KEY (MOVIEID, TOPICID),
	LANGUAGE VARCHAR(50),
	SUBTITLES BOOLEAN,
	COUNTRY VARCHAR(50),
	FOREIGN KEY (TOPICID) REFERENCES TOPICS,
	FOREIGN KEY (MOVIEID) REFERENCES MOVIE
);

CREATE TABLE ACTOR(
	ACTORID VARCHAR(50) PRIMARY KEY,
	LASTNAME VARCHAR(50),
	FIRSTNAME VARCHAR(50),
	DATEOFBIRTH DATE
);

CREATE TABLE ROLE(
	ROLEID VARCHAR(50) PRIMARY KEY,
	NAME VARCHAR(50),
	ACTORID VARCHAR(50),
	FOREIGN KEY (ACTORID) REFERENCES ACTOR
);

CREATE TABLE ACTORPLAYS(
	MOVIEID VARCHAR(50),
	ACTORID VARCHAR(50),
	PRIMARY KEY (MOVIEID, ACTORID),
	FOREIGN KEY (ACTORID) REFERENCES ACTOR,
	FOREIGN KEY (MOVIEID) REFERENCES MOVIE
);

CREATE TABLE DIRECTOR(
	DIRECTORID VARCHAR(50) PRIMARY KEY,
	LASTNAME VARCHAR(50),
	FIRSTNAME VARCHAR(50),
	COUNTRY VARCHAR(50)
);

CREATE TABLE DIRECTS(
	MOVIEID VARCHAR(50),
	DIRECTORID VARCHAR(50),
	PRIMARY KEY (MOVIEID, DIRECTORID),
	FOREIGN KEY (DIRECTORID) REFERENCES DIRECTOR,
	FOREIGN KEY (MOVIEID) REFERENCES MOVIE
);

CREATE TABLE STUDIO(
	STUDIOID VARCHAR(50) PRIMARY KEY,
	NAME VARCHAR(50),
	COUNTRY VARCHAR(50)
);

CREATE TABLE SPONSORS(
	MOVIEID VARCHAR(50),
	STUDIOID VARCHAR(50),
	PRIMARY KEY (MOVIEID, STUDIOID),
	FOREIGN KEY (STUDIOID) REFERENCES STUDIO,
	FOREIGN KEY (MOVIEID) REFERENCES MOVIE
);
