--Hypothesis-free data exploration

--Number of participants
SELECT COUNT(DISTINCT id) FROM read_csv_auto('data/raw/subject-info.csv');

--How many days per participant
SELECT id, COUNT(DISTINCT day_in_study) as days
FROM read_csv_auto('data/raw/hormones_and_selfreport.csv')
GROUP BY id
ORDER BY days DESC;

--Which cycle phases exist
SELECT DISTINCT phase 
FROM read_csv_auto('data/raw/hormones_and_selfreport.csv');

--What does the glucose table look like
SELECT * FROM read_csv_auto('data/raw/glucose.csv') LIMIT 10;
--This has timestamp being read as interval, hence the fix
SELECT * FROM read_csv_auto('data/raw/glucose.csv', all_varchar=true) LIMIT 10;

--How many glucose readings per participant
SELECT id, COUNT(*) as readings
FROM read_csv_auto('data/raw/glucose.csv')
GROUP BY id
ORDER BY readings DESC";

--Hormones structure
SELECT * FROM read_csv_auto('data/raw/hormones_and_selfreport.csv', all_varchar=true) LIMIT 10;

--Have to use id and day_in_study for joins to see how glucose varies per participant in the cycle per phase
SELECT gluc.id, gluc.day_in_study, hormone.phase, gluc.glucose_value
FROM read_csv_auto('data/raw/glucose.csv') AS gluc
JOIN read_csv_auto('data/raw/hormones_and_selfreport.csv') AS hormone
ON gluc.id = hormone.id 
AND gluc.day_in_study = hormone.day_in_study
LIMIT 20;

--summary stats for glucose distributions per person per phase
SELECT gluc.id, gluc.day_in_study, hormone.phase, AVG(gluc.glucose_value) AS avg_glucose, STDDEV(gluc.glucose_value) AS stdev_glucose, COUNT(*) as n_readings
FROM read_csv_auto('data/raw/glucose.csv') AS gluc
JOIN read_csv_auto('data/raw/hormones_and_selfreport.csv') AS hormone
ON gluc.id = hormone.id 
AND gluc.day_in_study = hormone.day_in_study
WHERE hormone.phase IS NOT NULL
GROUP BY gluc.id, gluc.day_in_study, hormone.phase
ORDER BY gluc.id, gluc.day_in_study
LIMIT 20;

--Decision to keep only one hour max of missing glucose readings rows from this
SELECT gluc.id, gluc.day_in_study, hormone.phase, AVG(gluc.glucose_value) AS avg_glucose, STDDEV(gluc.glucose_value) AS stdev_glucose, COUNT(*) as n_readings
FROM read_csv_auto('data/raw/glucose.csv') AS gluc
JOIN read_csv_auto('data/raw/hormones_and_selfreport.csv') AS hormone
ON gluc.id = hormone.id 
AND gluc.day_in_study = hormone.day_in_study
WHERE hormone.phase IS NOT NULL
GROUP BY gluc.id, gluc.day_in_study, hormone.phase
HAVING COUNT(*)>=276
ORDER BY gluc.id, gluc.day_in_study
LIMIT 20;