CREATE VIEW forestation AS 
SELECT  fa.country_code id , fa.country_name name, fa.year "year", fa.forest_area_sqkm forest_area_sqkm,
        la.total_area_sq_mi total_area_sq_mi,
        r.region region, r.income_group income,
        (fa.forest_area_sqkm / (la.total_area_sq_mi * 2.59)*100.0) AS percentage

FROM forest_area fa, land_area la, regions r
WHERE (fa.country_code = la.country_code AND fa.year = la.year AND r.country_code = la.country_code);

-- 1
SELECT sum(fa.forest_area_sqkm), fa.year, fa.country_name
FROM forest_area fa
WHERE year = '1990' AND country_name = 'World'

SELECT sum(fa.forest_area_sqkm), fa.year, fa.country_name
FROM forest_area fa
WHERE year = '2016' AND country_name = 'World'
GROUP BY 2,3

-- WORLD's forest area is 41282694.90 sqr km  in 1990
-- WORLDS's forest area is 39958245.90 sqr km in 2016

SELECT current.forest_area_sqkm - previous.forest_area_sqkm AS difference
FROM forest_area AS current
JOIN forest_area AS previous
ON (current.year = '2016' AND previous.year = '1990')
AND current.country_name = 'World' AND previous.country_name = 'World';

SELECT (current.forest_area_sqkm - previous.forest_area_sqkm)*100 /  previous.forest_area_sqkm)  AS difference
FROM forest_area AS current
JOIN forest_area AS previous
ON (current.year = '2016' AND previous.year = '1990')
AND current.country_name = 'World' AND previous.country_name = 'World';

-- The difference of the forest area between 1990 and 2016 is - 1324449
-- That's a loss of -3.20824258980244

SELECT country, (total_area_sq_mi * 2.59) AS total_area_sq_mi
FROM forestation
WHERE year = 2016
ORDER BY total_area_sq_mi;

-- PERU 1279999.9891

-- 2

SELECT percentage
FROM forestation
WHERE year = 1990
AND country = 'World';

-- 32.4222035575689

SELECT ROUND(CAST((region_forest_1990) / region_forest_1990 ) * 100 AS NUMERIC),2) AS region_forest_percent_1990,

       ROUND(CAST((region_forest_2016) * 100 AS NUMERIC),2) AS region_forest_percent_2016, 
       
       region

FROM (SELECT SUM(a.forest_area_sqkm) region_forest_1990,
    SUM(a.total_area_sqkm) region_area_1990, a.region,
    SUM(b.forest_area_sqkm) region_forest_2016,
    SUM(b.total_area_sqkm) region_forest_2016
        FROM forestation a, forestation b
        WHERE a.year = '1990'
            AND a.country != 'World'
            AND b.year = '2016'
            AND b.country != 'World'
            AND a.region = b.region
        GROUP BY a.region) region_percentage
ORDER BY region_forest_percent_1990 DESC;

-- region_forest_percent_1990 | region_forest_percent_2016 | region
-- 51.03                        46.16                       Latin America & Caribbean
-- 37.28                        38.04                       Europe & Central Asia
-- 35.65                        36.04                       North America
-- 30.67                        28.79                       Sub-Saharan Africa
-- 25.78                        26.36                       East Asia & Pacific
-- 16.51                        17.51                       South Asia
--  1.78                         2.07                       Middle East & North Africa

-- 3
SELECT current.country_name,
       current.forest_area_sqkm - previous.forest_area_sqkm AS difference

FROM forest_area AS current
JOIN forest_area AS previous
ON (current.year = '2016' AND previous.year = '1990') AND current.country_name = previous.country_code
ORDER BY difference DESC;

-- China            527229.062
-- United States    79200

SELECT current.country_name,
       (current.forest_area_sqkm - previous.forest_area_sqkm) * 100.0 / previous.forest_area_sqkm AS percentage

FROM forest_area AS current
JOIN forest_area AS previous
ON (current.year = '2016' AND previous.year = '1990') AND current.country_name = previous.country_code
ORDER BY percentage DESC;

-- Iceland          213.66458
-- French Polynesia 181.81818

SELECT current.country_name,
       current.forest_area_sqkm - previous.forest_area_sqkm AS difference

FROM forest_area AS current
JOIN forest_area AS previous
ON (current.year = '2016' AND previous.year = '1990') AND current.country_name = previous.country_code
ORDER BY difference ;

-- Brazil       -541510
-- Indonesia    -282194
-- Myanmar      -107234
-- Nigeria      -106506
-- Tanzania     -102320

SELECT current.country_name,
       (current.forest_area_sqkm - previous.forest_area_sqkm) * 100.0 / previous.forest_area_sqkm AS percentage

FROM forest_area AS current
JOIN forest_area AS previous
ON (current.year = '2016' AND previous.year = '1990') AND current.country_name = previous.country_code
ORDER BY percentage ;

-- Togo         -75.45
-- Nigeria      -61.8
-- Uganda       -59.13
-- Mauritania   -46.75
-- Honduras     -45.03

SELECT distinct(quartiles), COUNT(country) OVER (PARTITION BY quartiles)
FROM ( SELECT country,)
    CASE WHEN percentage <= 25 THEN '0-25 %'
         WHEN percentage <= 75 AND percentage > 50 THEN '50-75%'
         WHEN percentage <= 50 AND percentage > 25 THEN '25-50%'
         ELSE '75-100%' END AS quartiles FROM forestation

WHERE percentage IS NOT NULL AND year = 2016) quarti;

-- quartiles   |    count
-- 0-25%       |     85
-- 25-50%      |     73
-- 50-75%      |     38
-- 75-100%     |      9

SELECT country, percentage
FROM forestation
WHERE percentage > 75 AND year = 2016;

-- country          |   percentage
-- American Samoa		98.26
-- Micronesia	        91.86
-- Gabon	    	    90.04
-- Guyana	            83.90
-- Lao PDR	        	82.11
-- Palau	        	87.61
-- Solomon Islands		77.86
-- Suriname	        	98.26
-- Seychelles	    	88.41


