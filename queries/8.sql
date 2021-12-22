SELECT u.name, AGE(u.birthday) FROM public.user u
INNER JOIN reservation r on r.user_id = u.id
LEFT JOIN reservation_accommodation ra on ra.reservations_id = r.id
LEFT JOIN accommodation a on a.id = ra.accommodations_id
LEFT JOIN object o on o.id = a.object_id
WHERE o.id = 3