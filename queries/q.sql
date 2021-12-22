-- select information about all hostel's/hotels's accomodations
SET lc_monetary = 'ru_RU.UTF8';
SELECT object.name, location, object_type.name as type, accomodation.photo, accomodation.price FROM public.object 
LEFT JOIN public.accomodation on object.id = accomodation.object_id
LEFT JOIN public.object_type on object_type.id = object.type_id
WHERE object_type.name IN ('Хостелы', 'Рёканы')