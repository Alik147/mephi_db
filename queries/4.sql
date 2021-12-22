SELECT c.* FROM object as o
LEFT JOIN comment c on c.object_id = o.id
WHERE o.id=1 and c.rating > 6
