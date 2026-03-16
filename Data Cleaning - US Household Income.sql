USE p2__us_household_income;

SELECT *
FROM household_income;

SELECT *
FROM household_income_statistics;

----------------------------------------------------------------------------

-- Data Cleaning

----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- Removing duplicates records
----------------------------------------------------------------------------

-- Finding the duplicate records
--For 'household_income' table
SELECT id, COUNT(id)
FROM household_income
GROUP BY id
HAVING COUNT(id) >= 2 ;

--For 'household_income_statistics' table
SELECT id, COUNT(id)
FROM household_income_statistics
GROUP BY id
HAVING COUNT(id) >= 2 ;

-- Identifying the duplicates and removing them from 'household_income' table
WITH 
CTE1 AS (
    SELECT *,
        ROW_NUMBER() OVER(PARTITION BY id) AS rn
    FROM household_income
) ,
CTE2 AS (
    SELECT row_id, id, rn
    FROM CTE1
    WHERE rn >= 2
)
DELETE
FROM household_income
WHERE row_id IN (
    SELECT row_id
    FROM CTE2
) ;


----------------------------------------------------------------------------
-- Fixing data quality issues
----------------------------------------------------------------------------

SELECT *
FROM household_income;

SELECT COUNT(*)
FROM household_income;

-- Data cleaning for 'State_Name' column
SELECT DISTINCT State_Name
FROM household_income ;

UPDATE household_income
SET State_Name = CONCAT(
    UPPER(LEFT(State_Name, 1)),
    LOWER(SUBSTRING(State_Name, 2))
) ;

UPDATE household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'Georia' ;

-- Data cleaning for 'State_ab' column
SELECT DISTINCT State_ab
FROM household_income ;

UPDATE household_income
SET State_ab = UPPER(State_ab) ;

-- Data cleaning for 'County' column
SELECT DISTINCT County
FROM household_income ;

--No cleaning needed

-- Data cleaning for 'Place' column
SELECT DISTINCT Place
FROM household_income ;

SELECT *
FROM household_income
WHERE Place IS NULL OR Place = '' ;

SELECT County, City, Place
FROM household_income
WHERE COunty = 'Autauga County' ;

UPDATE household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County' AND City = 'Vinemont' ;

-- Data cleaning for 'Type' column
SELECT `Type`, COUNT(*)
FROM household_income
GROUP BY `Type` ;

UPDATE household_income
SET `Type` = 'Borough'
WHERE `Type` = 'Boroughs' ;

UPDATE household_income
SET `Type` = 'CDP'
WHERE `Type` = 'CPD' ;

-- Data cleaning for 'Primary' column
SELECT `Primary`, COUNT(*)
FROM household_income
GROUP BY `Primary` ;

UPDATE household_income
SET `Primary` = 'Place'
WHERE `Primary` = 'place' ;

-- Data cleaning for 'Zip_Code' column
SELECT Zip_Code, COUNT(*)
FROM household_income
GROUP BY Zip_Code
HAVING COUNT(*) >= 2 
ORDER BY COUNT(*) ;

WITH
CTE AS (
    SELECT Zip_Code, COUNT(*) AS cnt
    FROM household_income
    GROUP BY Zip_Code
    HAVING COUNT(*) >= 2
)
SELECT SUM(cnt)
FROM CTE ;

-- No cleaning needed

-- Data cleaning for 'Area_Code' column
SELECT Area_Code, COUNT(*)
FROM household_income
GROUP BY Area_Code
HAVING COUNT(*) >= 2 
ORDER BY COUNT(*) ;

WITH
CTE AS (
    SELECT Area_Code, COUNT(*) AS cnt
    FROM household_income
    GROUP BY Area_Code
    HAVING COUNT(*) >= 2
)
SELECT SUM(cnt)
FROM CTE ;

-- No cleaning needed

-- Data cleaning for 'ALand' & 'AWater' column
SELECT DISTINCT ALand   -- Checking for distinct values
FROM household_income
WHERE ALand IS NULL OR ALand IN (0, '') ;

SELECT DISTINCT AWater  -- Checking for distinct values
FROM household_income
WHERE AWater IS NULL OR AWater IN (0, '') ;

SELECT ALand, AWater    -- Checking for invalid combination
FROM household_income
WHERE ALand = 0 AND AWater = 0 ;

SELECT ALand, AWater
FROM household_income
WHERE ALand = 0 ;

SELECT ALand, AWater
FROM household_income
WHERE AWater = 0 ;

SELECT ALand, AWater    -- Checking for negative values
FROM household_income
WHERE ALand < 0 OR AWater < 0 ;


----------------------------------------------------------------------------

-- Data cleaning issues identified during EDA process

----------------------------------------------------------------------------

