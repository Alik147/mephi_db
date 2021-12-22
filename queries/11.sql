WITH categories as (
SELECT cr.name FROM reservation r
INNER JOIN comment c on c.reservation_id = r.id
INNER JOIN comment_category cc on cc.comments_id = c.id
INNER JOIN category cr on cr.id = cc.categories_id
WHERE reservation_time_end - reservation_time_start > INTERVAL '10' day
	)
SELECT name, COUNT(name) FROM categories
GROUP BY name