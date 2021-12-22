SET lc_monetary = 'ru_RU.UTF8';
SELECT reservation_time_start as start, reservation_time_end as end, o.name, a.price as object from object o
LEFT JOIN accommodation as a on a.object_id = o.id
LEFT JOIN reservation_accommodation as ra on ra.accommodations_id = a.id
LEFT JOIN reservation as r on r.id = ra.reservations_id
LEFT JOIN public.user as u on u.id = r.user_id
WHERE u.id = 2
ORDER BY start