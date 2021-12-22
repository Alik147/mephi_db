DROP TABLE IF EXISTS public.User, public.Reservation, public.Accommodation, 
	public.Reservation_Accommodation, public.Object, public.Partner, 
	public.Comment, public.Category, public.Comment_Category, 
	public.Service, public.Service_Object, public.Facility, public.Facility_Type, public.Facility_Object, 
	public.Furniture_Accommodation, public.Furniture, public.Object_Type;

CREATE TABLE IF NOT EXISTS public.User(
	id SERIAL PRIMARY KEY,
	name varchar(64) NOT NULL,
	birthday date NOT NULL,
	phone_number varchar(32),
	email_address varchar(128) NOT NULL,
	password varchar(128) NOT NULL,
	address varchar(128),
	gender varchar(128),
	nationality varchar(128),
	username varchar(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.Reservation(
	id SERIAL PRIMARY KEY,
	created_at timestamp with time zone NOT NULL,
	reservation_time_start timestamp with time zone NOT NULL,
	reservation_time_end timestamp with time zone NOT NULL,
	user_id int NOT NULL,
	FOREIGN KEY (user_id) REFERENCES public.User (id)
);

CREATE TABLE IF NOT EXISTS public.Partner(
	id SERIAL PRIMARY KEY,
	email_address varchar(128) NOT NULL,
	phone_number varchar(32) NOT NULL,
	first_name varchar(128) NOT NULL,
	last_name varchar(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.Object_Type(
	id SERIAL PRIMARY KEY,
	name varchar(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.Object(
	id SERIAL PRIMARY KEY,
	name varchar(64) NOT NULL,
	location varchar(128) NOT NULL,
	type_id int NOT NULL,
	rating real,
	partner_id int NOT NULL,
	FOREIGN KEY (partner_id) REFERENCES public.Partner (id),
	FOREIGN KEY (type_id) REFERENCES public.Object_Type (id)
);

CREATE TABLE IF NOT EXISTS public.Furniture(
	id SERIAL PRIMARY KEY,
	type varchar(128),
	name varchar(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.Accommodation(
	id SERIAL PRIMARY KEY,
	checkin_time time,
	people_number int,
	area int,
	restrictions text,
	price money NOT NULL,
	photo varchar(256),
	object_id int NOT NULL,
	FOREIGN KEY (object_id) REFERENCES public.Object (id)
);

CREATE TABLE IF NOT EXISTS public.Furniture_Accommodation(
	id SERIAL PRIMARY KEY,
	quantity int,
	furniture_id int,
	accommodation_id int,
	FOREIGN KEY (furniture_id) REFERENCES public.Furniture (id),
	FOREIGN KEY (accommodation_id) REFERENCES public.Accommodation (id)
);

CREATE TABLE IF NOT EXISTS public.Reservation_Accommodation(
	id SERIAL PRIMARY KEY,
	accommodations_id int,
	reservations_id int,
	FOREIGN KEY (accommodations_id) REFERENCES public.Accommodation (id),
	FOREIGN KEY (reservations_id) REFERENCES public.Reservation (id)
);

CREATE TABLE IF NOT EXISTS public.Comment(
	id SERIAL PRIMARY KEY,
	photo varchar(128),
	created_at timestamp with time zone NOT NULL,
	rating real NOT NULL,
	pluses text[],
	minuses text[],
	plus_number int,
	minus_number int,
	residents int,
	object_id int NOT NULL,
	owner_id int NOT NULL,
	reservation_id int NOT NULL,
	FOREIGN KEY (object_id) REFERENCES public.Object (id),
	FOREIGN KEY (reservation_id) REFERENCES public.Reservation (id),
	FOREIGN KEY (owner_id) REFERENCES public.User (id)
);

CREATE TABLE IF NOT EXISTS public.Category(
	id SERIAL PRIMARY KEY,
	name varchar(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.Comment_Category(
	id SERIAL PRIMARY KEY,
	score int NOT NULL,
	categories_id int,
	comments_id int,
	FOREIGN KEY (categories_id) REFERENCES public.Category (id) ON DELETE CASCADE,
	FOREIGN KEY (comments_id) REFERENCES public.Comment (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.Service(
	id SERIAL PRIMARY KEY,
	name varchar(128) NOT NULL,
	comment varchar(128)
);

CREATE TABLE IF NOT EXISTS public.Service_Object(
	id SERIAL PRIMARY KEY,
	service_id int,
	object_id int,
	FOREIGN KEY (service_id) REFERENCES public.Service (id),
	FOREIGN KEY (object_id) REFERENCES public.Object (id)
);

CREATE TABLE IF NOT EXISTS public.Facility_Type(
	id SERIAL PRIMARY KEY,
	name varchar(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.Facility(
	id SERIAL PRIMARY KEY,
	name varchar(128) NOT NULL,
	comment varchar(128),
	facility_type_id int,
	FOREIGN KEY (facility_type_id) REFERENCES public.Facility_Type (id)
);

CREATE TABLE IF NOT EXISTS public.Facility_Object(
	id SERIAL PRIMARY KEY,
	facilities_id int,
	object_id int,
	FOREIGN KEY (facilities_id) REFERENCES public.Facility (id),
	FOREIGN KEY (object_id) REFERENCES public.Object (id)
);