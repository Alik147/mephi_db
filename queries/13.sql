WITH count_accommodations AS (
SELECT accommodations_id, count(reservations_id) FROM reservation_accommodation
GROUP BY accommodations_id
	)
SELECT o.id, o.name, coalesce(SUM(count), 0) as reservations_count FROM public.object o
LEFT JOIN accommodation a on a.object_id = o.id
LEFT JOIN count_accommodations ca on ca.accommodations_id = a.id
GROUP BY o.id
ORDER BY reservations_count DESC LIMIT 10