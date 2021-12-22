SELECT o.id, o.name, coalesce(AVG(c.rating), 0) as rating FROM object o
LEFT JOIN comment c on c.object_id = o.id
GROUP BY o.id
ORDER BY rating DESC
LIMIT 10