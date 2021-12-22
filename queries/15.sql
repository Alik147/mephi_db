WITH fur_accom AS
(
	SELECT a.id  FROM public.accommodation as a
	LEFT JOIN furniture_accommodation as fa on fa.accommodation_id = a.id
	LEFT JOIN furniture as f on f.id = fa.furniture_id
	WHERE f.name = 'двуспальная кровать'
	GROUP BY a.id
), facility_accom AS
(
	WITH f1 AS(
	SELECT a.id FROM public.accommodation as a
	LEFT JOIN object as o on o.id = a.object_id
	LEFT JOIN facility_object as fo on fo.object_id = o.id
	LEFT JOIN facility as f on f.id = fo.facilities_id
	WHERE f.name = 'Туалетная бумага'), 
	f2 AS(
	SELECT a.id FROM public.accommodation as a
	LEFT JOIN object as o on o.id = a.object_id
	LEFT JOIN facility_object as fo on fo.object_id = o.id
	LEFT JOIN facility as f on f.id = fo.facilities_id
	WHERE f.name = 'Полотенца'), 
	f3 AS(
	SELECT a.id FROM public.accommodation as a
	LEFT JOIN object as o on o.id = a.object_id
	LEFT JOIN facility_object as fo on fo.object_id = o.id
	LEFT JOIN facility as f on f.id = fo.facilities_id
	WHERE f.name = 'Ванна или душ')
	
	SELECT * FROM f1
	INTERSECT
	SELECT * FROM f2
	INTERSECT
	SELECT * FROM f3
)
SELECT o.name, a.people_number, a.price, a.photo, a.area FROM accommodation as a
LEFT JOIN object as o on o.id = a.object_id
WHERE a.id IN (SELECT id from fur_accom) AND
a.id IN (SELECT id from facility_accom)
order by a.id