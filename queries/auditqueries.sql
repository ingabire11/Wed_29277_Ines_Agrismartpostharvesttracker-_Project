audit1
SELECT *
FROM AuditLog
ORDER BY attempt_time DESC;

audit2
SELECT *
FROM AuditLog
WHERE status = 'DENIED'
ORDER BY attempt_time DESC;

audit3
SELECT *
FROM AuditLog
WHERE status = 'DENIED'
  AND reason LIKE '%holiday%';

audit4
SELECT *
FROM AuditLog
WHERE status = 'DENIED'
  AND reason LIKE '%Weekday%';
