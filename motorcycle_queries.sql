CREATE TABLE motorcycle_db(
Make varchar(255),
Model varchar(255),
Year_of_launch int,
category varchar(255),
rating float,
displacement float,
engine_details varchar(355),
power_ps float,
power_rpm int,
torque_nm float,
torque_rpm int,
top_speed_km float,
fuel_system varchar(255),
fuel_control varchar(255),
cooling_system varchar(255),
gearbox int,
transmission_type varchar(255),
clutch varchar(355),
fuel_consumption float,
greenhouse_gases float
);

SELECT * FROM motorcycle_db

-- Number of models per year by brand
SELECT make, year_of_launch, COUNT(DISTINCT model) number_models 
FROM motorcycle_db
GROUP BY make, year_of_launch
ORDER BY make ASC;

-- Lessen emissions generated
SELECT make, model, MIN(greenhouse_gases) emission 
FROM motorcycle_db
GROUP BY make, model
HAVING MAX(greenhouse_gases) > 0
ORDER BY emission
LIMIT 5;

-- Average consumption by brand by year
SELECT make, year_of_launch, AVG(fuel_consumption)::Numeric(10,2) average_consumption 
FROM motorcycle_db
WHERE fuel_consumption IS NOT NULL
GROUP BY make, year_of_launch
ORDER BY year_of_launch;

-- Lowest consumption by model
SELECT make, model, year_of_launch, fuel_consumption 
FROM motorcycle_db
WHERE fuel_consumption IS NOT NULL
ORDER BY fuel_consumption asc
LIMIT 5;

-- Fastest motorcycle by model
WITH fastest_bikes AS(
	SELECT make, model, top_speed_km, ROW_NUMBER() OVER (PARTITION BY make ORDER BY top_speed_km DESC NULLS LAST) top_speed
	FROM motorcycle_db
	)
SELECT make, model, top_speed_km 
FROM fastest_bikes
WHERE top_speed = 1;

-- Bike with most power and torque by brand
WITH most_powerful AS(
	SELECT make, model, Year_of_launch, power_ps, torque_rpm, top_speed_km, ROW_NUMBER() OVER (PARTITION BY make ORDER BY power_ps DESC NULLS LAST , torque_rpm DESC NULLS LAST) bike_power
	FROM motorcycle_db
	)
SELECT make, model, Year_of_launch, power_ps, torque_rpm, top_speed_km
FROM most_powerful
WHERE bike_power = 1;

-- Number of models by brand
SELECT make, COUNT(DISTINCT model) number_models 
FROM motorcycle_db
GROUP BY make
ORDER BY number_models DESC;

-- Evolution of power by brand
SELECT make, year_of_launch, AVG(power_ps)::Numeric(10,2) average_power
FROM motorcycle_db
WHERE power_ps IS NOT NULL
GROUP BY make, year_of_launch
ORDER BY make,year_of_launch;

SELECT year_of_launch, AVG(greenhouse_gases)::numeric(10,2) average_emissions
FROM motorcycle_db
WHERE greenhouse_gases IS NOT NULL
GROUP BY year_of_launch
ORDER BY year_of_launch;

SELECT year_of_launch, AVG(fuel_consumption)::numeric(10,2) average_consumption
FROM motorcycle_db
WHERE fuel_consumption IS NOT NULL
GROUP BY year_of_launch
ORDER BY year_of_launch;





















