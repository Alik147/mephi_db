-- all object of partner
SELECT o.id, o.name, o.location, p.first_name, p.last_name FROM object as o
LEFT JOIN partner as p on p.id = o.partner_id
WHERE p.first_name = 'Алевтина' and p.last_name = 'Гордеева'