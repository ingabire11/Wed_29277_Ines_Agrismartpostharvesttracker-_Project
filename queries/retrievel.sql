SELECT s.storage_id,
       s.location AS storage_location,
       s.date_stored,
       h.crop_type,
       h.quantity,
       f.name AS farmer_name
FROM Storage s
JOIN Harvests h ON s.harvest_id = h.harvest_id
JOIN Farmers f ON h.farmer_id = f.farmer_id;


