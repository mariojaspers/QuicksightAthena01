SELECT *
FROM taxis.taxis
WHERE year=2016 AND type='yellow'
ORDER BY pickup_datetime desc
LIMIT 10;
