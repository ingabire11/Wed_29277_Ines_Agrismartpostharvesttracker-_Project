
analytical1
SELECT *
FROM Storage
ORDER BY date_stored DESC;

analytical2
SELECT * FROM Harvests
WHERE crop_type = 'Maize';

analytical3
SELECT DISTINCT crop_type
FROM Harvests;

analytical4
SELECT storage_id, humidity_percent, reading_time
FROM (
    SELECT hl.*,
           ROW_NUMBER() OVER (PARTITION BY storage_id ORDER BY reading_time DESC) rn
    FROM HumidityLogs hl
)
WHERE rn = 1;

analytical5
SELECT f.name,
       SUM(h.quantity) AS total_harvested
FROM Farmers f
JOIN Harvests h ON f.farmer_id = h.farmer_id
GROUP BY f.name;



