-- Q1. Write a code to check NULL values

SELECT 
    SUM(CASE WHEN Province IS NULL THEN 1 ELSE 0 END) AS Province, 
    SUM(CASE WHEN Country_Region IS NULL THEN 1 ELSE 0 END) AS Country_Region, 
    SUM(CASE WHEN Latitude IS NULL THEN 1 ELSE 0 END) AS Latitude,
    SUM(CASE WHEN Longitude IS NULL THEN 1 ELSE 0 END) AS Longitude, 
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Date, 
    SUM(CASE WHEN Confirmed IS NULL THEN 1 ELSE 0 END) AS Confirmed,
    SUM(CASE WHEN Deaths IS NULL THEN 1 ELSE 0 END) AS Deaths
FROM [Corona_Dataset];
---------------------------------------------------------------------------------------------------------------
--Q2. If NULL values are present, update them with zeros for all columns. 

/*There is no NULL values are present in the dataset as we already check in the first question and 
we get result that there are zero NULL values in the dataset. */

/* If there is any null values in any columns then answer for the following question is below*/

UPDATE [Corona_Dataset]
SET Province = CASE WHEN Province IS NULL THEN 0 ELSE Province END,
    Country_Region = CASE WHEN Country_Region IS NULL THEN 0 ELSE Country_Region END,
    Latitude = CASE WHEN Latitude IS NULL THEN 0 ELSE Latitude END,
	Longitude = CASE WHEN Longitude IS NULL THEN 0 ELSE Longitude END,
	Date = CASE WHEN Date IS NULL THEN 0 ELSE Date END,
	Confirmed = CASE WHEN Confirmed IS NULL THEN 0 ELSE Confirmed END,
	Deaths = CASE WHEN Deaths IS NULL THEN 0 ELSE Deaths END;
---------------------------------------------------------------------------------------------------------------

-- Q3. Check total number of rows

SELECT COUNT(*) 
AS total_rows
FROM [Corona_Dataset];
---------------------------------------------------------------------------------------------------------------

-- Q4. Check what is start_date and end_date

SELECT FORMAT(MIN(CONVERT(DATE, Date, 105)), 'dd-MM-yyyy') AS start_date, 
       FORMAT(MAX(CONVERT(DATE, Date, 105)), 'dd-MM-yyyy') AS end_date
FROM Corona_Dataset;
---------------------------------------------------------------------------------------------------------------

-- Q5. Number of month present in dataset

SELECT 
    YEAR(CONVERT(DATE, Date, 105)) AS Year,
    COUNT(DISTINCT MONTH(CONVERT(DATE, Date, 105))) AS Total_Months_In_Year
FROM 
    Corona_Dataset
GROUP BY 
    YEAR(CONVERT(DATE, Date, 105))
ORDER BY 
    Year;
---------------------------------------------------------------------------------------------------------------

-- Q6. Find monthly average for confirmed, deaths, recovered

SELECT 
    YEAR(CONVERT(date, Date, 105)) AS Year,
    MONTH(CONVERT(date, Date, 105)) AS Month,
    AVG(Confirmed) AS AvgConfirmed,
    AVG(Deaths) AS AvgDeaths,
    AVG(Recovered) AS AvgRecovered
FROM 
    Corona_Dataset
GROUP BY 
    YEAR(CONVERT(date, Date, 105)),
    MONTH(CONVERT(date, Date, 105))
ORDER BY 
    Year, 
    Month;
---------------------------------------------------------------------------------------------------------------

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 

SELECT 
    main.Year,
    main.Month,
    subquery.Most_Frequent_Confirmed,
    subquery.Most_Frequent_Deaths,
    subquery.Most_Frequent_Recovered
FROM (
    SELECT 
        YEAR(CONVERT(DATE, Date, 105)) AS Year,
        MONTH(CONVERT(DATE, Date, 105)) AS Month
    FROM 
        Corona_Dataset
    WHERE 
        ISDATE(Date) = 1
    GROUP BY 
        YEAR(CONVERT(DATE, Date, 105)),
        MONTH(CONVERT(DATE, Date, 105))
) AS main
CROSS APPLY (
    SELECT 
        TOP 1 
        Confirmed AS Most_Frequent_Confirmed,
        Deaths AS Most_Frequent_Deaths,
        Recovered AS Most_Frequent_Recovered
    FROM 
        Corona_Dataset AS sub
    WHERE 
        YEAR(CONVERT(DATE, sub.Date, 105)) = main.Year 
        AND MONTH(CONVERT(DATE, sub.Date, 105)) = main.Month 
        AND Confirmed > 0 
        AND Deaths >0 
        AND Recovered > 0 
    GROUP BY 
        Confirmed,
        Deaths,
        Recovered
    ORDER BY 
        COUNT(*) DESC
) AS subquery
ORDER BY 
    main.Year,
    main.Month;
---------------------------------------------------------------------------------------------------------------

-- Q8. Find minimum values for confirmed, deaths, recovered per year

SELECT 
    YEAR(CONVERT(DATE, Date, 105)) AS Year,
    MIN(Confirmed) AS Min_Confirmed,
    MIN(Deaths) AS Min_Deaths,
    MIN(Recovered) AS Min_Recovered
FROM 
    Corona_Dataset
WHERE 
    ISDATE(Date) = 1
GROUP BY 
    YEAR(CONVERT(DATE, Date, 105))
ORDER BY 
    Year;
---------------------------------------------------------------------------------------------------------------

-- Q9. Find maximum values of confirmed, deaths, recovered per year

SELECT 
    YEAR(CONVERT(DATE, Date, 105)) AS Year,
    MAX(Confirmed) AS Max_Confirmed,
    MAX(Deaths) AS Max_Deaths,
    MAX(Recovered) AS Max_Recovered
FROM 
    Corona_Dataset
WHERE 
    ISDATE(Date) = 1
GROUP BY 
    YEAR(CONVERT(DATE, Date, 105))
ORDER BY 
    Year;
---------------------------------------------------------------------------------------------------------------

-- Q10. The total number of case of confirmed, deaths, recovered each month

SELECT 
    YEAR(CONVERT(DATE, Date, 105)) AS Year,
    MONTH(CONVERT(DATE, Date, 105)) AS Month,
    SUM(Confirmed) AS Total_Confirmed,
    SUM(Deaths) AS Total_Deaths,
    SUM(Recovered) AS Total_Recovered
FROM 
    Corona_Dataset
WHERE 
    ISDATE(Date) = 1
GROUP BY 
    YEAR(CONVERT(DATE, Date, 105)),
    MONTH(CONVERT(DATE, Date, 105))
ORDER BY 
    Year,
    Month;
---------------------------------------------------------------------------------------------------------------

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT SUM(Confirmed) AS TotalConfirmedCases,
	   AVG(Confirmed) AS AverageConfirmedCases,
	   VAR(Confirmed) AS VarianceConfirmedCases,
	   STDEV(Confirmed) AS StdDevConfirmedCases
FROM Corona_Dataset;


-- FOR MONTHLY DATA
SELECT
    YEAR(CONVERT(DATE, Date, 105)) AS Year,
    MONTH(CONVERT(DATE, Date, 105)) AS Month,
    SUM(Confirmed) AS Total_Confirmed_Cases,
    AVG(CAST(Recovered AS DECIMAL)) AS Average_Confirmed_Cases,
    VAR(CAST(Recovered AS DECIMAL)) AS Variance_Confirmed_Cases,
    STDEV(CAST(Recovered AS DECIMAL)) AS Stdev_Confirmed_Cases
FROM
    Corona_Dataset
WHERE
    ISDATE(Date) = 1  -- Filter out invalid date values
GROUP BY
    YEAR(CONVERT(DATE, Date, 105)),
    MONTH(CONVERT(DATE, Date, 105))
ORDER BY
    Year,
    Month;
---------------------------------------------------------------------------------------------------------------

-- Q12. Check how corona virus spread out with respect to death case per month
--   (Eg.: total death cases, their average, variance & STDEV )

SELECT
    YEAR(CONVERT(DATE, Date, 105)) AS Year,
    MONTH(CONVERT(DATE, Date, 105)) AS Month,
    SUM(Deaths) AS Total_Deaths_Cases,
    AVG(CAST(Deaths AS DECIMAL)) AS Average_Deaths_Cases,
    VAR(CAST(Deaths AS DECIMAL)) AS Variance_Deaths_Cases,
    STDEV(CAST(Deaths AS DECIMAL)) AS Stdev_Deaths_Cases
FROM
    Corona_Dataset
WHERE
    ISDATE(Date) = 1  -- Filter out invalid date values
GROUP BY
    YEAR(CONVERT(DATE, Date, 105)),
    MONTH(CONVERT(DATE, Date, 105))
ORDER BY
    Year,
    Month;
---------------------------------------------------------------------------------------------------------------

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total recovered cases, their average, variance & STDEV )

SELECT
    SUM(Recovered) AS TotalRecoveredCases,
    AVG(Recovered) AS AverageRecoveredCases,
    VAR(Recovered) AS VarianceRecoveredCases,
    STDEV(Recovered) AS StdevRecoveredCases
FROM
    Corona_Dataset;

--- FOR MONTHLY DATA

SELECT
    YEAR(CONVERT(DATE, Date, 105)) AS Year,
    MONTH(CONVERT(DATE, Date, 105)) AS Month,
    SUM(Recovered) AS Total_Recovered_Cases,
    AVG(CAST(Recovered AS DECIMAL)) AS Average_Recovered_Cases,
    VAR(CAST(Recovered AS DECIMAL)) AS Variance_Recovered_Cases,
    STDEV(CAST(Recovered AS DECIMAL)) AS Stdev_Recovered_Cases
FROM
    Corona_Dataset
WHERE
    ISDATE(Date) = 1  -- Filter out invalid date values
GROUP BY
    YEAR(CONVERT(DATE, Date, 105)),
    MONTH(CONVERT(DATE, Date, 105))
ORDER BY
    Year,
    Month;
---------------------------------------------------------------------------------------------------------------

-- Q14. Find Country having highest number of the Confirmed case

SELECT TOP 1 Country_Region, 
	MAX(Confirmed) AS Highest_Confirmed_Cases
FROM Corona_Dataset
GROUP BY Country_Region
ORDER BY MAX(Confirmed) DESC;
---------------------------------------------------------------------------------------------------------------

-- Q15. Find Country having lowest number of the death case

SELECT TOP 1 Country_Region, 
	MIN(Deaths) AS Lowest_Death_Cases
FROM Corona_Dataset
GROUP BY Country_Region
ORDER BY MIN(Deaths) ASC;
---------------------------------------------------------------------------------------------------------------

-- Q16. Find top 5 countries having highest recovered case

SELECT TOP 5 Country_Region, SUM(Recovered) AS Total_Recovered_Cases
FROM Corona_Dataset
GROUP BY Country_Region
ORDER BY SUM(Recovered) DESC;
---------------------------------------------------------------------------------------------------------------
