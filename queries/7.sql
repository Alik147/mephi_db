SELECT u.id, u.name FROM public.user u
INNER JOIN reservation r on r.user_id = u.id
INNER JOIN reservation r1 on r.id != r1.id and r1.user_id = u.id
INNER JOIN reservation r2 on r1.id != r2.id and r2.id != r.id and r2.user_id = u.id
GROUP BY u.name, u.id
ORDER BY u.id