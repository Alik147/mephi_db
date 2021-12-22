SET lc_monetary = 'ru_RU.UTF8';
SELECT o.id as object_id, SUM(price) FROM reservation as r
LEFT JOIN reservation_accommodation as ra on r.id = ra.reservations_id
LEFT JOIN accommodation as a on a.id = ra.accommodations_id
LEFT JOIN object as o on o.id = a.object_id
WHERE r.created_at > date_trunc('month', CURRENT_DATE) - INTERVAL '1 year'
GROUP BY o.id
ORDER BY sum DESC