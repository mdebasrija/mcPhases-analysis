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

--Possible unit issue, 2 subjects to be dropped
SELECT gluc.id, gluc.day_in_study, hormone.phase, 
AVG(gluc.glucose_value) AS avg_glucose, STDDEV(gluc.glucose_value) AS stdev_glucose, 
COUNT(*) as n_readings
FROM read_csv_auto('data/raw/glucose.csv') AS gluc
JOIN read_csv_auto('data/raw/hormones_and_selfreport.csv') AS hormone
ON gluc.id = hormone.id AND gluc.day_in_study = hormone.day_in_study
WHERE hormone.phase IS NOT NULL AND gluc.id NOT IN (6, 11)
GROUP BY gluc.id, gluc.day_in_study, hormone.phase
HAVING COUNT(*) >= 276
ORDER BY gluc.id, gluc.day_in_study