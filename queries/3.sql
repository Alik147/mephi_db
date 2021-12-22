-- sums
SET lc_monetary = 'ru_RU.UTF8';
SELECT u.id, u.username, u.name, coalesce(SUM(a.price), 0.0::money) as price_sum from public.user as u
LEFT JOIN reservation as r on r.user_id = u.id
LEFT JOIN reservation_accommodation as ra on ra.reservations_id = r.id
LEFT JOIN public.accommodation as a on a.id = ra.accommodations_id
GROUP BY u.id, u.username, u.name
--HAVING SUM(a.price) is NOT NULL
ORDER BY price_sum DESC