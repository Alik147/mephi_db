DROP TABLE IF EXISTS public.User, public.Reservation, public.Accomodation, 
	public.Reservation_Accomodation, public.Object, public.Partner, 
	public.Comment, public.Category, public.Comment_Category, 
	public.Service, public.Service_Object, public.Facility, public.Facility_Type, public.Facility_Object;

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
	last_name varchar(128 NOT NULL)
);

CREATE TABLE IF NOT EXISTS public.Object(
	id SERIAL PRIMARY KEY,
	location varchar(128) NOT NULL,
	type varchar(128) NOT NULL,
	rating real,
	partner_id int NOT NULL,
	FOREIGN KEY (partner_id) REFERENCES public.Partner (id)
);

CREATE TABLE IF NOT EXISTS public.Accomodation(
	id SERIAL PRIMARY KEY,
	checkin_time timestamp with time zone,
	name varchar(64) NOT NULL,
	people_number int,
	area int,
	restrictions text,
	price real NOT NULL,
	furniture text,
	photo varchar(256),
	object_id int NOT NULL,
	FOREIGN KEY (object_id) REFERENCES public.Object (id)
);

CREATE TABLE IF NOT EXISTS public.Reservation_Accomodation(
	id SERIAL PRIMARY KEY,
	accomodations_id int,
	reservations_id int,
	FOREIGN KEY (accomodations_id) REFERENCES public.Accomodation (id),
	FOREIGN KEY (reservations_id) REFERENCES public.Reservation (id)
);

CREATE TABLE IF NOT EXISTS public.Comment(
	id SERIAL PRIMARY KEY,
	photo varchar(128),
	arrival_date  date NOT NULL,
	created_at timestamp with time zone NOT NULL,
	rating real NOT NULL,
	nights_number int,
	pluses text[],
	minuses text[],
	plus_number int,
	minus_number int,
	residents int,
	owner_id int NOT NULL,
	object_id int NOT NULL,
	FOREIGN KEY (owner_id) REFERENCES public.User (id),
	FOREIGN KEY (object_id) REFERENCES public.Object (id)
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
	FOREIGN KEY (categories_id) REFERENCES public.Category (id),
	FOREIGN KEY (comments_id) REFERENCES public.Comment (id)
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