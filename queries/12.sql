SELECT r.id, r.created_at, r.reservation_time_start, r.reservation_time_end, a.id as accommodation_id FROM reservation as r
LEFT JOIN reservation_accommodation as ra on ra.reservations_id = r.id
LEFT JOIN accommodation as a on a.id = ra.accommodations_id
LEFT JOIN object as o on o.id = a.object_id
WHERE o.id = 1
ORDER BY r.created_at DESC
LIMIT 1