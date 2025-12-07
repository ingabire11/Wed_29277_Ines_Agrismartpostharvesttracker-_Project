
test query1
SELECT * FROM Alerts WHERE harvest_id = 10;

test query2

SELECT table_name 
FROM user_tables 
WHERE table_name IN ('FARMERS', 'HARVESTS', 'STORAGE', 'DECAYRATES', 'MARKETS', 'HUMIDITYLOGS', 'ALERTS', 'AUDITLOG');

testquery3
SELECT * FROM AuditLog ORDER BY attempt_time DESC;

testquery4
UPDATE Harvests SET quantity = 300 WHERE harvest_id = 10;


