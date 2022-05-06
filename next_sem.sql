DROP TABLE IF EXISTS public.User_likes_Post, public.User_Chats, 
public.User_subscribe_User, public.User_likes_Comment,
public.File, public.User, public.Chat, public.Message,
public.Post, public.Comment; 



CREATE TABLE IF NOT EXISTS public.File(
	id SERIAL PRIMARY KEY,
	type int, 
	path varchar(512) NOT NULL
);


CREATE TABLE IF NOT EXISTS public.User(
	id SERIAL PRIMARY KEY,
	first_name varchar(128) NOT NULL,
	last_name varchar(128) NOT NULL,
	patronimic varchar(128),
	phone_number varchar(68),
	password varchar(512) NOT NULL,
	birthplace varchar(128),
	place_of_residence varchar(128),
	status varchar(256),
	additional_information varchar(1024),
	is_online boolean NOT NULL,
	email varchar(128) NOT NULL,
	gender int,
	birth_date date NOT NULL,
	avatar_id int,
	FOREIGN KEY (avatar_id) REFERENCES public.File (id)
);


CREATE TABLE IF NOT EXISTS public.Post(
	id SERIAL PRIMARY KEY,
	text varchar(1024),
	created_at timestamp with time zone NOT NULL,
	owner int NOT NULL,
	file_id int,
	FOREIGN KEY (owner) REFERENCES public.User (id),
	FOREIGN KEY (file_id) REFERENCES public.File (id)
);


CREATE TABLE IF NOT EXISTS public.Comment(
	id SERIAL PRIMARY KEY,
	text varchar(1024),
	to_comment_id int,
	to_post_id int,
	file_id int,
	owner int NOT NULL,
	created_at timestamp with time zone NOT NULL,
	FOREIGN KEY (owner) REFERENCES public.User (id),
	FOREIGN KEY (file_id) REFERENCES public.File (id),
	FOREIGN KEY (to_comment_id) REFERENCES public.Comment (id),
	FOREIGN KEY (to_post_id) REFERENCES public.Post (id)
);

	
CREATE TABLE IF NOT EXISTS public.Chat(
	id SERIAL PRIMARY KEY,
	name varchar(128),
	avatar int,
	owner int NOT NULL,
	FOREIGN KEY (avatar) REFERENCES public.File (id),
	FOREIGN KEY (owner) REFERENCES public.User
);


CREATE TABLE IF NOT EXISTS public.Message(
	id SERIAL PRIMARY KEY,
	text varchar(1024),
	created_at timestamp with time zone NOT NULL,
	chat_id int NOT NULL,
	file_id int,
	owner int NOT NULL,
	FOREIGN KEY (owner) REFERENCES public.User (id),
	FOREIGN KEY (file_id) REFERENCES public.File (id),
	FOREIGN KEY (chat_id) REFERENCES public.Chat (id)
);


CREATE TABLE IF NOT EXISTS public.User_Chats(
	user_id int,
	chat_id int,
	FOREIGN KEY (user_id) REFERENCES public.User (id),
	FOREIGN KEY (chat_id) REFERENCES public.Chat (id),
	PRIMARY KEY (user_id, chat_id)
);


CREATE TABLE IF NOT EXISTS public.User_likes_Post(
	user_id int,
	post_id int,
	FOREIGN KEY (user_id) REFERENCES public.User (id),
	FOREIGN KEY (post_id) REFERENCES public.Post (id),
	PRIMARY KEY (user_id, post_id)
);


CREATE TABLE IF NOT EXISTS public.User_likes_Comment(
	user_id int,
	comment_id int,
	FOREIGN KEY (user_id) REFERENCES public.User (id),
	FOREIGN KEY (comment_id) REFERENCES public.Comment (id),
	PRIMARY KEY (user_id, comment_id)
);


CREATE TABLE IF NOT EXISTS public.User_subscribe_User(
	to_user int,
	from_user int,
	FOREIGN KEY (to_user) REFERENCES public.User (id),
	FOREIGN KEY (from_user) REFERENCES public.User (id),
	PRIMARY KEY (to_user, from_user)
);