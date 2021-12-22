SELECT u.id, u.username FROM object as o
LEFT JOIN comment c on c.object_id = o.id
LEFT JOIN public.user u on u.id = c.owner_id
WHERE o.id=1 and c.created_at > date_trunc('month', current_date - interval '6' month)
GROUP BY u.id, u.username
HAVING AVG(c.rating) > 6