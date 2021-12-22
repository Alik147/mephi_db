SET lc_monetary = 'ru_RU.UTF8';
SELECT p.id as partner_id, SUM(a.price) FROM partner p
LEFT JOIN object o on o.partner_id = p.id
LEFT JOIN accomodation a on a.object_id = o.id
LEFT JOIN reservation_accomodation ra on ra.accomodations_id = a.id
LEFT JOIN reservation r on r.id = ra.reservations_id 
WHERE r.reservation_time_start > date_trunc('month', current_date - interval '1' month)
GROUP BY p.id
ORDER BY sum DESC