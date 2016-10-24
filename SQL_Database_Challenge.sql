--WHERE

--1) What is the population of the US? (starts with 2, ends with 000)
--CODE:
    SELECT population
    FROM countries
    WHERE code= 'USA'

--2)What is the area of the US? (starts with 9, ends with million square miles)
--CODE:
    SELECT surfacearea
    FROM countries
    WHERE code= 'USA'

--3)List the countries in Africa that have a population smaller than 30,000,000 and a life expectancy of more than 45? (all 37 of them)
--CODE:
  SELECT name
  FROM countries
  WHERE continent = 'Africa' AND population < 30000000 AND lifeexpectancy > 45

--4)Which countries are something like a republic? (are there 122 or 143 countries or ?)
--CODE:
  SELECT name, governmentform
  FROM countries
  WHERE governmentform like '%Republic%'

--5)Which countries are some kind of republic and acheived independence after 1945?
--CODE:
  SELECT name, governmentform, indepyear
  FROM countries
  WHERE governmentform like '%Republic%' AND indepyear > 1945
  ORDER BY indepyear

--6) Which countries acheived independence after 1945 and are not some kind of republic?
--CODE:
  SELECT name, governmentform, indepyear
  FROM countries
  WHERE NOT (governmentform like '%Republic%') AND indepyear > 1945
  ORDER BY indepyear

--ORDER BY --
-- 1) Which fifteen countries have the lowest life expectancy? highest life expactancy?
--CODE
  --Lowest
  SELECT name, lifeexpectancy
  FROM countries
  ORDER BY lifeexpectancy
  LIMIT 15
  --highest
  SELECT name, lifeexpectancy
  FROM countries
  WHERE lifeexpectancy > 0
  ORDER BY lifeexpectancy  DESC
  LIMIT 15
--2)Which five countries have the lowest population density? highest population density?
--CODE
  --Lowest
  SELECT name, population
  FROM countries
  WHERE population > 0
  ORDER BY population
  LIMIT 5
  --Highest
  SELECT name, population
  FROM countries
  WHERE population > 0
  ORDER BY population DESC
  LIMIT 5

--3)Which is the smallest country, by area and population? the 10 smallest countries, by area and population?
--CODE
  --smallest
  SELECT name, population, surfacearea
  FROM countries
  WHERE population > 0 AND surfacearea > 0
  ORDER BY population
  LIMIT 1
  -- 10 smallest
  SELECT name, population, surfacearea
  FROM countries
  WHERE population > 0 AND surfacearea > 0
  ORDER BY population
  LIMIT 10

--4) Which is the biggest country, by area and population? the 10 biggest countries, by area and population?
--CODE
  --Biggest
  SELECT name, population, surfacearea
  FROM countries
  WHERE population > 0 AND surfacearea > 0
  ORDER BY population DESC
  LIMIT 1
  -- 10 Biggest
  SELECT name, population, surfacearea
  FROM countries
  WHERE population > 0 AND surfacearea > 0
  ORDER BY population DESC
  LIMIT 10

--with
--1) Of the smallest 10 countries, which has the biggest gnp? (hint: use WITH and LIMIT)
 --Smallest country with biggest gdp
   WITH
  	biggest_gnp AS
  	  (SELECT
  		name, population, surfacearea, gnp
  	  FROM
  		countries
  	  WHERE
  		population > 0 AND surfacearea > 0
  	  ORDER BY
  		population
  	  LIMIT 10)
  SELECT name, population, surfacearea, gnp
  FROM biggest_gnp
  WHERE gnp > 0
  ORDER BY gnp DESC
  LIMIT 1

--2) Of the smallest 10 countries, which has the biggest per capita gnp?
--CODE
    WITH
     biggest_gnp AS
       (SELECT
       name, population, surfacearea, gnp
       FROM
       countries
       WHERE
       population > 0 AND surfacearea > 0
       ORDER BY
       population
       LIMIT 10)
    SELECT name, population, surfacearea, gnp
    FROM biggest_gnp
    WHERE gnp > 0
    ORDER BY gnp/population DESC
    LIMIT 1

--3)Of the biggest 10 countries, which has the biggest gnp?
--CODE:
  WITH
  	biggest_gnp AS
  	  (SELECT
  		name, population, surfacearea, gnp
  	  FROM
  		countries
  	  WHERE
  		population > 0
  	  ORDER BY
  		population DESC
  	  LIMIT 10)
  SELECT name, population, surfacearea, gnp
  FROM biggest_gnp
  WHERE gnp > 0
  ORDER BY gnp DESC
  LIMIT 1

--4)Of the biggest 10 countries, which has the biggest per capita gnp?
--CODE:
  WITH
  biggest_gnp AS
    (SELECT
    name, population, surfacearea, gnp
    FROM
    countries
    WHERE
    population > 0
    ORDER BY
    population DESC
    LIMIT 10)
  SELECT name, population, surfacearea, gnp
  FROM biggest_gnp
  WHERE gnp > 0
  ORDER BY gnp/population DESC
  LIMIT 1

--5)What is the sum of surface area of the 10 biggest countries in the world? The 10 smallest?
--CODE
  WITH total_surface AS
    (SELECT name, population, surfacearea
    FROM countries
    WHERE population > 0 AND surfacearea > 0
    ORDER BY population DESC
    LIMIT 10)
  SELECT SUM(surfacearea)
  FROM total_surface

--GROUP BY

--1)How big are the continents in term of area and population?
--CODE:
  SELECT continent, SUM(surfacearea) AS total_surface, SUM(population) AS total_population
  FROM countries
  GROUP BY continent

--2)Which region has the highest average gnp
--CODE:
  WITH avg_gnp AS
    (SELECT region, gnp
    FROM countries
    WHERE gnp > 0
    ORDER BY gnp DESC)
  SELECT region, avg(avg_gnp.gnp) AS new_gnp
  FROM avg_gnp
  GROUP BY region
  ORDER BY new_gnp DESC

--3) Who is the most influential head of state measured by population?
--CODE:
    SELECT headofstate, SUM(population) AS influential
    FROM countries
    WHERE population > 0
    GROUP BY headofstate
    ORDER BY influential DESC
--4) Who is the most influential head of state measured by surface area?
--CODE:
    SELECT headofstate, SUM(surfacearea) AS influential
    FROM countries
    WHERE surfacearea > 0
    GROUP BY headofstate
    ORDER BY influential DESC
  --5) What are the most common forms of government? (hint: use count(*))
  --CODE:
     SELECT governmentform, count(governmentform) AS gov_form
     FROM countries
     GROUP BY governmentform
     ORDER BY gov_form DESC

--6) What are the forms of government for the top ten countries by surface area?
--CODE:
    SELECT name, governmentform, surfacearea
      FROM countries
      WHERE surfacearea > 0
      ORDER BY surfacearea DESC
      LIMIT 10

--7) What are the forms of government for the top ten richest nations? (technically most productive)
--CODE:
  SELECT name, governmentform, gnp
    FROM countries
    WHERE gnp > 0
    ORDER BY gnp DESC
    LIMIT 10

--8) What are the forms of government for the top ten richest per capita nations? (technically most productive)
--CODE:
  SELECT name, governmentform, gnp/population
    FROM countries
    WHERE gnp > 0 AND population > 0
    ORDER BY gnp/population DESC
    LIMIT 10
--INTERESTING
--5) Which countries are in the top 5% in terms of area? (hint: use a SELECT in a LIMIT clause)
  SELECT	 name, surfacearea
  FROM countries
  WHERE surfacearea > 0
  ORDER BY surfacearea DESC
  LIMIT
  (SELECT count(*) * .05
  FROM countries
  )
