SET lc_monetary = 'ru_RU.UTF8';
WITH obj_sum as (
SELECT o.id as object_id, SUM(price) as sum FROM reservation as r
LEFT JOIN reservation_accommodation as ra on r.id = ra.reservations_id
LEFT JOIN accommodation as a on a.id = ra.accommodations_id
LEFT JOIN object as o on o.id = a.object_id
GROUP BY o.id
ORDER BY object_id
	),
	partner_sum as (
SELECT p.id, p.first_name, p.last_name, coalesce(max(os.sum), 0::money) as sum FROM partner p
LEFT JOIN object o on o.partner_id = p.id
LEFT JOIN obj_sum os on os.object_id = o.id
GROUP BY p.id
ORDER BY id DESC
	)
	
SELECT ps.id as partner_id, ps.first_name, ps.last_name, ps.sum, o.name, o.id as object_id FROM partner_sum ps
LEFT JOIN object o on o.partner_id = ps.id
LEFT JOIN obj_sum os on os.object_id = o.id
WHERE os.sum = ps.sum
ORDER BY ps.id