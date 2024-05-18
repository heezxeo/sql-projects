USE world_life_expectancy;

SELECT *
FROM worldlifexpectancy;

#create a primary key with country and year 
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM worldlifexpectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1;

#find the specific row_id with the duplicates
SELECT *
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year), 
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS row_num
	FROM worldlifexpectancy
    ) AS row_table
WHERE row_num > 1
;

-- DELETE FROM worldlifexpectancy
-- WHERE Row_ID IN (
-- 	SELECT Row_ID
-- 	FROM (
-- 		SELECT Row_ID, 
-- 		CONCAT(Country, Year), 
-- 		ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS row_num
-- 		FROM worldlifexpectancy
-- 		) AS row_table
-- 	WHERE row_num > 1
-- );


SELECT *
FROM worldlifexpectancy
WHERE Status IS NULL;

#find the country that is status = Developing
SELECT DISTINCT (country)
FROM worldlifexpectancy
WHERE Status = 'Developing';

#this has an error
-- UPDATE worldlifexpectancy
-- SET Status = 'Developing'
-- WHERE Country IN (
-- 	SELECT DISTINCT (Country)
-- 	FROM worldlifexpectancy
-- 	WHERE Status = 'Developing'
--     )
-- ;

-- UPDATE worldlifexpectancy t1
-- JOIN worldlifexpectancy t2
-- 	ON t1.Country = t2.Country
-- SET t1.Status = 'Developing'
-- WHERE t1.Status = '' AND t2.Status != '' AND t2.Status = 'Developing'
-- ;

SELECT DISTINCT (country)
FROM worldlifexpectancy
WHERE Status = 'Developed';

-- UPDATE worldlifexpectancy t1
-- JOIN worldlifexpectancy t2
-- 	ON t1.Country = t2.Country
-- SET t1.Status = 'Developed'
-- WHERE t1.Status = '' AND t2.Status != '' AND t2.Status = 'Developed'
-- ;


SELECT *
FROM worldlifexpectancy
WHERE Lifeexpectancy = ''; #Afghanistan, Albania

SELECT t1.Country, t1.Year, t1.Lifeexpectancy,
t2.Country, t2.Year, t2.Lifeexpectancy,
t3.Country, t3.Year, t3.Lifeexpectancy,
ROUND((t2.Lifeexpectancy + t3.Lifeexpectancy)/2, 1)
FROM worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country = t2.Country AND t1.Year = t2.Year - 1
JOIN worldlifexpectancy t3
	ON t1.Country = t3.Country AND t1.Year = t3.Year + 1
WHERE t1.Lifeexpectancy = '';

UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country = t2.Country AND t1.Year = t2.Year - 1
JOIN worldlifexpectancy t3
	ON t1.Country = t3.Country AND t1.Year = t3.Year + 1
SET t1.Lifeexpectancy = ROUND((t2.Lifeexpectancy + t3.Lifeexpectancy)/2, 1)
WHERE t1.Lifeexpectancy = '';

#EDA
SELECT *
FROM worldlifexpectancy;

#which country did a good job with life expectancy
SELECT Country, 
MIN(Lifeexpectancy), 
MAX(Lifeexpectancy),
ROUND(MAX(Lifeexpectancy) - MIN(Lifeexpectancy),1) AS life_increase_over_15years
FROM worldlifexpectancy
GROUP BY Country
HAVING MIN(Lifeexpectancy) != 0 AND MAX(Lifeexpectancy) != 0
ORDER BY life_increase_over_15years DESC;

#average life expectancy for each year
SELECT year, ROUND(AVG(Lifeexpectancy),2)
FROM worldlifexpectancy
WHERE Lifeexpectancy != 0
GROUP BY year
ORDER BY year;

#the correlation between life expectancy and gdp
SELECT country, ROUND(AVG(Lifeexpectancy), 1), ROUND(AVG(GDP), 1)
FROM worldlifexpectancy
GROUP BY country
HAVING AVG(Lifeexpectancy) > 0 AND AVG(GDP) > 0
ORDER BY AVG(GDP) DESC
;

#Case statement
SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP,
AVG(CASE WHEN GDP >= 1500 THEN Lifeexpectancy ELSE NULL END) High_GDP_Life,
#give the average of the life expectancy of high GDP country
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP,
AVG(CASE WHEN GDP <= 1500 THEN Lifeexpectancy ELSE NULL END) Low_GDP_Life
#low GDP have 10 year less compared to high GDP country 
FROM worldlifexpectancy;

SELECT Status, COUNT(DISTINCT country), ROUND(AVG(Lifeexpectancy), 1)
FROM worldlifexpectancy
GROUP BY Status;

#the correlation between life expectancy and gdp 
SELECT country, ROUND(AVG(Lifeexpectancy), 1), ROUND(AVG(BMI), 1), ROUND(AVG(GDP), 1)
FROM worldlifexpectancy
GROUP BY country
HAVING AVG(Lifeexpectancy) > 0 AND AVG(BMI) > 0 AND AVG(GDP) > 0
ORDER BY AVG(BMI) DESC
#it is interesting that even though high BMI there are still 
;

#rolling total
SELECT Country, Year, Lifeexpectancy, AdultMortality,
SUM(AdultMortality) OVER(PARTITION BY Country ORDER BY year) AS Rolling_total
FROM worldlifexpectancy
WHERE Country LIKE '%Korea%';
#we might also want to compare between total population and the sum of adult mortality



    