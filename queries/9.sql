SET lc_monetary = 'ru_RU.UTF8';
WITH avg_rating_obj as (
	SELECT c.object_id, AVG(c.rating) as avg_rating FROM comment c
	GROUP BY object_id
	ORDER BY object_id
), avg_rating_type as (
	SELECT type_id, AVG(c.rating) as avg_rating FROM comment c
	LEFT JOIN object o on o.id = c.object_id
	GROUP BY type_id
	ORDER BY type_id
), avg_price_type as (
	SELECT type_id, AVG(a.price :: numeric)::money as avg_money_type FROM accommodation a
	LEFT JOIN object o on o.id = a.object_id
	GROUP BY type_id
	ORDER BY type_id
)
SELECT o.id, o.name, ot.name, a.price, a.id,
aro.avg_rating as avg_rating_obj,
art.avg_rating as avg_rating_type,
apt.avg_money_type
FROM accommodation a
LEFT JOIN object o on o.id = a.object_id
LEFT JOIN avg_rating_obj aro on aro.object_id = o.id
LEFT JOIN avg_rating_type art on art.type_id = o.type_id
LEFT JOIN object_type ot on ot.id = o.type_id
LEFT JOIN avg_price_type apt on apt.type_id = o.id
ORDER BY o.id