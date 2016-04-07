SET SEARCH_PATH TO MOVIEVERSE;

-- Display all the information about a user‐specified movie. That is, the user should select the
-- name of the movie from a list, and the information as contained in the movie table should then
-- be displayed on the screen.
-- M.NAME IS A VARIABLE HERE
SELECT M.NAME, M.DATERELEASED
FROM MOVIE M
WHERE M.NAME = 'HERO';

-- Display the full list of actors, and their roles, of a specific movie. That is, the user should select
-- the name of the movie from a list, and all the details of the actors, together with their roles,
-- should be displayed on the screen.  
-- M.NAME IS A VARIABLE HERE
SELECT (A.FIRSTNAME || ' ' || A.LASTNAME) AS ACTORS_NAME, R.NAME AS ROLE_NAME
FROM MOVIE M, ACTOR A, ROLE R, ACTORPLAYS AP
WHERE M.MOVIEID = AP.MOVIEID AND A.ACTORID = AP.ACTORID AND A.ACTORID = R.ACTORID AND M.NAME = 'HERO';

-- For each user‐specified category of movie, list the details of the director(s) and studio(s),
-- together with the date that the movie has been released. The user should be able to select the
-- category (e.g. Horror or Nature) from a list.
-- T.DESCRIPTION IS A VARIABLE HERE
SELECT(D.FIRSTNAME || ' ' || D.LASTNAME) AS DIRECTORS_NAME, D.COUNTRY AS DIRECTORS_COUNTRY, 
ST.NAME AS STUDIO_NAME, ST.COUNTRY AS STUDIOS_COUNTRY, M.DATERELEASED
FROM MOVIE M, DIRECTOR D, TOPICS T, DIRECTS DI, MOVIETOPICS MT, SPONSORS S, STUDIO ST
WHERE M.MOVIEID = DI.MOVIEID AND D.DIRECTORID = DI.DIRECTORID 
AND M.MOVIEID = S.MOVIEID AND ST.STUDIOID = S.STUDIOID
AND MT.MOVIEID = M.MOVIEID AND T.TOPICID = MT.TOPICID AND T.DESCRIPTION = 'ACTION';

-- Display the information about the actor that appeared the most often in the movies, as
-- contained in your database. Display this information together with the details of the director(s)
-- and the studio(s) that s(he) worked with.
SELECT (A.FIRSTNAME || ' ' || A.LASTNAME) AS ACTORS_NAME, A.DATEOFBIRTH, 
(D.FIRSTNAME || ' ' || D.LASTNAME) AS DIRECTORS_NAME, D.COUNTRY AS DIRECTORS_COUNTRY, 
ST.NAME AS STUDIO_NAME, ST.COUNTRY AS STUDIOS_COUNTRY
FROM ACTOR A, ACTORPLAYS AP, DIRECTOR D, DIRECTS DI, MOVIE M, STUDIO ST
WHERE AP.ACTORID = A.ACTORID AND M.MOVIEID = DI.MOVIEID AND D.DIRECTORID = DI.DIRECTORID
GROUP BY AP.ACTORID, A.FIRSTNAME, A.LASTNAME, A.DATEOFBIRTH, D.FIRSTNAME, D.LASTNAME, D.COUNTRY, ST.NAME, ST.COUNTRY 
HAVING COUNT(AP.ACTORID) = (SELECT COUNT(AP2.ACTORID) 
				FROM ACTORPLAYS AP2
				GROUP BY AP2.ACTORID 
				ORDER BY COUNT(AP2.ACTORID) DESC 
				LIMIT 1);

-- Find the names of the ten movies with the highest overall ratings in your database.
SELECT M.NAME, AVG(W.RATING)
FROM MOVIE M, WATCHES W
WHERE M.MOVIEID = W.MOVIEID
GROUP BY M.NAME, W.RATING
ORDER BY AVG(W.RATING) DESC
LIMIT 10;

-- Find the movie(s) with the highest overall rating in your database. Display all the movie details,
-- together with the topics (tags) associated with it.
SELECT M.NAME, M.DATERELEASED, T.DESCRIPTION
FROM MOVIE M, WATCHES W, MOVIETOPICS MT, TOPICS T 
WHERE M.MOVIEID = W.MOVIEID AND MT.MOVIEID = M.MOVIEID AND T.TOPICID = MT.TOPICID
GROUP BY M.NAME, M.DATERELEASED, T.DESCRIPTION
HAVING AVG(W.RATING) = (SELECT AVG(W2.RATING) 
			FROM MOVIE M2, WATCHES W2
			WHERE M2.MOVIEID = W2.MOVIEID
			GROUP BY M2.NAME
			ORDER BY AVG(W2.RATING) DESC LIMIT 1);

-- Find the total number of rating for each movie, for each user. That is, the data should be
-- grouped by the movie, the specific users and the numeric ratings they have received.
SELECT COUNT(W.RATING), M.NAME, (P.FIRSTNAME || ' ' || P.LASTNAME) AS USERS_NAME
FROM WATCHES W,MOVIE M, PERSON P
WHERE W.MOVIEID = M.MOVIEID AND W.USERID = P.USERID
GROUP BY W.USERID, M.NAME, P.FIRSTNAME, P.LASTNAME;

-- Display the details of the movies that have not been rated since January 2016.
SELECT DISTINCT M.NAME, M.DATERELEASED
FROM MOVIE M, WATCHES W
WHERE W.MOVIEID = M.MOVIEID AND W.DATEWATCHED < '2016-01-01';

-- Find the names, release dates and the names of the directors of the movies that obtained rating
-- that is lower than any rating given by user X. Order your results by the dates of the ratings.
-- (Here, X refers to any user of your choice
--  P2.FIRSTNAME AND P2.LASTNAME ARE VARIABLES
SELECT M.NAME, M.DATERELEASED, (D.FIRSTNAME || ' ' || D.LASTNAME) AS DIRECTORS_NAME
FROM MOVIE M, DIRECTOR D, DIRECTS DI, PERSON P, WATCHES W
WHERE M.MOVIEID = DI.MOVIEID AND D.DIRECTORID = DI.DIRECTORID AND
W.USERID = P.USERID AND W.MOVIEID = M.MOVIEID
GROUP BY M.NAME, W.RATING, W.USERID, M.DATERELEASED, D.FIRSTNAME , D.LASTNAME
HAVING W.RATING < ANY( SELECT W1.RATING
FROM PERSON P1, WATCHES W1
WHERE W1.USERID = P1.USERID AND P2.FIRSTNAME ='NAME' AND P2.LASTNAME = 'USER');

-- List the details of the Type Y movie that obtained the highest rating. Display the movie name
-- together with the name(s) of the rater(s) who gave these ratings. (Here, Type Y refers to any
-- movie type of your choice, e.g. Horror or Romance.)
-- T.DESCRIPTION AND T2.DESCRIPTION ARE VARIABLES
SELECT DISTINCT M.NAME AS MOVIES_NAME, M.DATERELEASED,  (P.FIRSTNAME || ' ' || P.LASTNAME) AS USERS_NAME
FROM MOVIE M, TOPICS T, MOVIETOPICS MT, WATCHES W, PERSON P
WHERE MT.MOVIEID = M.MOVIEID AND T.TOPICID = MT.TOPICID AND T.DESCRIPTION = 'ACTION' 
AND W.MOVIEID = M.MOVIEID AND W.USERID = P.USERID
GROUP BY M.NAME, M.DATERELEASED, P.FIRSTNAME, P.LASTNAME
HAVING  AVG(W.RATING) = (SELECT AVG(W2.RATING)
			FROM WATCHES W2, MOVIE M2, MOVIETOPICS MT2, TOPICS T2
			WHERE W2.MOVIEID = M2.MOVIEID AND MT2.MOVIEID = M2.MOVIEID 
			AND T2.TOPICID = MT2.TOPICID AND T2.DESCRIPTION = 'ACTION' 
			GROUP BY M2.NAME
			ORDER BY AVG(W2.RATING) DESC
			LIMIT 1);

-- Provide a query to determine whether Type Y movies are “more popular” than other movies.  
-- (Here, Type Y refers to any movie type of your choice, e.g. Nature.) Yes, this query is open to
-- your own interpretation!
-- T2.DESCRIPTION AND T3.DESCRIPTION ARE VARIABLES
SELECT TRUE 
WHERE (SELECT AVG(W2.RATING)
			FROM MOVIE M2, WATCHES W2, MOVIETOPICS MT2, TOPICS T2
			WHERE M2.MOVIEID = W2.MOVIEID AND MT2.MOVIEID = M2.MOVIEID 
			AND MT2.TOPICID = T2.TOPICID AND T2.DESCRIPTION !='HORROR'
			GROUP BY M2.NAME
			ORDER BY W2.RATING DESC LIMIT 1)<
       (SELECT AVG(W3.RATING)
			FROM MOVIE M3, WATCHES W3, MOVIETOPICS MT3, TOPICS T3
			WHERE M3.MOVIEID = W3.MOVIEID AND MT3.MOVIEID = M3.MOVIEID 
			AND MT3.TOPICID = T3.TOPICID AND T3.DESCRIPTION ='HORROR'
			GROUP BY M3.NAME
			ORDER BY W3.RATING DESC LIMIT 1)
			
-- Find the names, join‐date and profiling information (age‐range, gender, and so on) of the users
-- that give the highest overall ratings. Display this information together with the names of the
-- movies and the dates the ratings were done.
SELECT (P.FIRSTNAME || ' ' || P.LASTNAME) AS USERS_NAME, PR.GENDER, PR.AGERANGE, 
M.NAME AS MOVIES_NAME, W.DATEWATCHED AS DATE_REVIEWED
FROM WATCHES W, PERSON P, PROFILE PR, MOVIE M
WHERE W.USERID = P.USERID AND PR.USERID = P.USERID AND W.MOVIEID = M.MOVIEID
GROUP BY W.RATING, P.FIRSTNAME, P.LASTNAME, PR.GENDER, PR.AGERANGE, M.NAME, W.DATEWATCHED
HAVING W.RATING = (SELECT W.RATING
FROM WATCHES W, PERSON P
WHERE W.USERID = P.USERID 
ORDER BY W.RATING DESC
LIMIT 1);

-- Find the names, join‐date and profiling information (age‐range, gender, and so on) of the users
-- that rated a specific movie (say movie Z) the most frequently. Display this information together
-- with their comments, if any. (Here movie Z refers to a movie of your own choice, e.g. The
-- Hundred Foot Journey).
-- M.NAME AND M2.NAME ARE VARIABLES
SELECT (P.FIRSTNAME || ' ' || P.LASTNAME) AS USERS_NAME, PR.GENDER, PR.AGERANGE, COUNT(W.DATEWATCHED)
FROM WATCHES W, PERSON P, PROFILE PR, MOVIE M
WHERE W.USERID = P.USERID AND PR.USERID = P.USERID AND W.MOVIEID = M.MOVIEID AND M.NAME = 'SHER'
GROUP BY P.FIRSTNAME, P.LASTNAME, W.USERID, PR.GENDER, PR.AGERANGE
HAVING COUNT(W.DATEWATCHED) = (SELECT COUNT(W2.DATEWATCHED)
				FROM WATCHES W2, PERSON P2, MOVIE M2
				WHERE W2.USERID = P2.USERID  AND W2.MOVIEID = M2.MOVIEID 
				AND M2.NAME = 'SHER'
				GROUP BY W2.USERID
				ORDER BY COUNT(W2.DATEWATCHED) DESC
				LIMIT 1);

-- Find the names and emails of all users who gave ratings that are lower than that of a rater with
-- a name called John Smith. (Note that there may be more than one rater with this name).
--  P2.FIRSTNAME AND P2.LASTNAME ARE VARIABLES
SELECT DISTINCT (P.FIRSTNAME || ' ' || P.LASTNAME) AS USERS_NAME, P.EMAIL
FROM WATCHES W, PERSON P
WHERE W.USERID = P.USERID
GROUP BY P.FIRSTNAME, P.LASTNAME, P.EMAIL, W.RATING
HAVING W.RATING < ALL (SELECT W2.RATING
FROM WATCHES W2, PERSON P2
WHERE W2.USERID = P2.USERID AND P2.FIRSTNAME ='NAME' AND P2.LASTNAME = 'USER');

-- Find the names and emails of the users that provide the most diverse ratings within a specific
-- genre. Display this information together with the movie names and the ratings. For example,
-- Jane Doe may have rated terminator 1 as a 1, Terminator 2 as a 10 and Terminator 3 as a 3.  
-- Clearly, she changes her mind quite often!
-- T.DESCRIPTION IS VARIABLE
SELECT DISTINCT (P.FIRSTNAME || ' ' || P.LASTNAME) AS USERS_NAME, P.EMAIL
FROM WATCHES W, PERSON P, MOVIE M, MOVIETOPICS MT, TOPICS T 
WHERE W.USERID = P.USERID AND W.MOVIEID = M.MOVIEID AND MT.MOVIEID = M.MOVIEID 
AND T.TOPICID = MT.TOPICID AND T.DESCRIPTION = 'ACTION'
GROUP BY P.USERID,  P.FIRSTNAME, P.LASTNAME, P.EMAIL
HAVING  MAX(W.RATING) - MIN(W.RATING) > 6