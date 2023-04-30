
-- Find the GameID's of the Away Team for each Game that is recorded in Weather

SELECT A.ID AS HomeID, B.ID AS AwayID
FROM MLB..MLBGames A, MLB..MLBGames B
WHERE A.Team = B.Opp
AND A.GameDateConverted = B.GameDateConverted
AND A.Venue = 'Home'
AND B.Venue = 'Away'
ORDER BY HomeID

SELECT * FROM MLB..MLBGames

-- Add a column to the table called OppGameID
ALTER TABLE MLB..MLBGames
ADD OppGameID INT;

-- Insert OppGameID into the OppGameID column 
UPDATE A
SET OppGameID = B.ID
FROM MLB..MLBGames A
JOIN MLB..MLBGames B ON A.Team = B.Opp AND A.GameDateConverted = B.GameDateConverted AND A.Win = B.Win AND A.R = B.RA


SELECT ID, OppGameID
FROM MLB..MLBGafmes



-- Test to see if above query works 
SELECT * FROM MLB..MLBGames
WHERE ID = '841' OR ID = '1'



-- Games where the average temperature on that day was over 100 F
SELECT mlb.Team, mlb.Opp, wth.Date, wth.temp
FROM MLB..Weather wth
JOIN MLB..MLBGames mlb
ON wth.GameID = mlb.ID
WHERE wth.temp >= 100


-- Who played the hottest away games on average? 
SELECT mlb.Team AS AwayTeam, AVG(wth.temp) as AVGTempMax
FROM MLB..MLBGames mlb
JOIN MLB..Weather wth
ON mlb.OppGameID = wth.GameID
GROUP BY mlb.Team
ORDER BY AVGTempMax DESC; 

-- Who Played the hottest home games on average? 
SELECT mlb.Team AS HomeTeam, AVG(wth.temp) as AVGTempMax
FROM MLB..MLBGames mlb
JOIN MLB..Weather wth
ON mlb.ID = wth.GameID
GROUP BY mlb.Team
ORDER BY AVGTempMax DESC; 

-- Who played away on days with the most precipitation last year? 
SELECT mlb.Team AS AwayTeam, SUM(wth.precip) as TotalPrecip
FROM MLB..MLBGames mlb
JOIN MLB..Weather wth
ON mlb.OppGameID = wth.GameID
GROUP BY mlb.Team
ORDER BY TotalPrecip DESC; 

-- Who played home on days with the most precipitation last year? 
SELECT mlb.Team AS HomeTeam, SUM(wth.precip) as TotalPrecip
FROM MLB..MLBGames mlb
JOIN MLB..Weather wth
ON mlb.ID = wth.GameID
GROUP BY mlb.Team
ORDER BY TotalPrecip DESC; 

-- Who played the most games with the precipitation last year
SELECT mlb.Team, 
(SELECT SUM(CASE WHEN mlb.ID = wth.GameID THEN wth.precip ELSE NULL END)) AS TotalHomePrecip, 
(SELECT SUM(CASE WHEN mlb.OppGameID = wth.GameID THEN wth.precip ELSE NULL END)) AS TotalAwayPrecip, 
(SELECT SUM(CASE WHEN mlb.ID = wth.GameID THEN wth.precip ELSE NULL END) + SUM(CASE WHEN mlb.OppGameID = wth.GameID THEN wth.precip ELSE NULL END)) AS TotalPrecip
FROM MLB..MLBGames mlb
INNER JOIN MLB..Weather wth
ON (mlb.ID = wth.GameID OR mlb.OppGameID = wth.GameID)
GROUP BY mlb.Team
ORDER BY TotalPrecip DESC; 


-- 