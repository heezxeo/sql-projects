#Data Cleaning
USE US_household_income;

SELECT *
FROM ushouseholdincome_statistics;

SELECT *
FROM USHouseholdIncome;

SELECT COUNT(row_id)
FROM USHouseholdIncome;

SELECT COUNT(id)
FROM ushouseholdincome_statistics;

SELECT id, COUNT(row_id)
FROM USHouseholdIncome
GROUP BY id
HAVING id > 1;

SELECT row_id
FROM (
	SELECT row_id, id,
    ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS row_num
    FROM USHouseholdIncome
    ) duplicates
WHERE row_num > 1
;

-- DELETE FROM USHouseholdIncome
-- WHERE row_id IN (
-- 	SELECT row_id
-- 	FROM (
-- 		SELECT row_id, id,
-- 		ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS row_num
-- 		FROM USHouseholdIncome
-- 		) duplicates
-- 	WHERE row_num > 1
-- );

SELECT id
FROM (
	SELECT id,
    ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS row_num
    FROM USHouseholdIncome
    ) duplicates
WHERE row_num > 1
;

SELECT DISTINCT State_Name
FROM USHouseholdIncome
ORDER BY 1;

-- UPDATE USHouseholdIncome
-- SET State_Name = 'Georgia'
-- WHERE State_Name = 'georia';

-- UPDATE USHouseholdIncome
-- SET State_Name = 'Alabama'
-- WHERE State_Name = 'alabama';
	
SELECT *
FROM USHouseholdIncome
WHERE County = 'Autauga County'
ORDER BY 1;

-- UPDATE USHouseholdIncome
-- SET Place = 'Autaugaville'
-- WHERE County = 'Autauga County' AND City = 'Vinemont';

SELECT Type, COUNT(Type)
FROM USHouseholdIncome
GROUP BY Type
;

UPDATE USHouseholdIncome
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;

SELECT ALand, AWater
FROM USHouseholdIncome
WHERE AWater = 0 OR AWater = '' OR AWater = NULL AND ALand = 0 OR ALand = '' OR ALand = NULL;

SELECT ALand, AWater
FROM USHouseholdIncome
WHERE ALand = 0 OR ALand = '' OR ALand = NULL;

#Explanatory Data Analysis (EDA)
#which state has more land and water
SELECT State_Name, ALand, AWater
FROM USHouseholdIncome;

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM USHouseholdIncome
GROUP BY State_Name
ORDER BY 3 DESC;

#top 10 largest state by land
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM USHouseholdIncome
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

#top 10 largest state by water
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM USHouseholdIncome
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10;

SELECT u.State_Name, u.County, `Primary`, Type, Mean, Median
FROM USHouseholdIncome u 
INNER JOIN ushouseholdincome_statistics us
	ON u.id = us.id;


SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM USHouseholdIncome u 
INNER JOIN ushouseholdincome_statistics us
	ON u.id = us.id
WHERE Mean != 0
GROUP BY u.State_Name
ORDER BY 3 DESC
LIMIT 10;

SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM USHouseholdIncome u 
INNER JOIN ushouseholdincome_statistics us
	ON u.id = us.id
WHERE Mean != 0
GROUP BY u.Type
HAVING Count(Type) > 100 #filter out some of the outliers (smaller number of type) 
ORDER BY 4 DESC;

#Which city in each state is making the greatest income
SELECT u.State_Name, City, ROUND(AVG(Mean),1)
FROM USHouseholdIncome u 
INNER JOIN ushouseholdincome_statistics us
	ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY ROUND(AVG(Mean),1) DESC;
