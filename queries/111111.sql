SELECT COUNT(*) FROM partner p
LEFT JOIN object o on o.partner_id = p.id
WHERE p.id = 2