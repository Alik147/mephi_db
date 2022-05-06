import random
import datetime
import uuid

import psycopg2
import faker

class DbFiller:
    def __init__(self):
        self.conn = psycopg2.connect(
            database='mephi_db', user='postgres', password='admin')
        self.cursor = self.conn.cursor()
        self.faker = faker.Faker('ru_RU')


    def __del__(self):
        self.conn.commit()
        self.cursor.close()
        self.conn.close()
    

    def _create_file(self):
        type = random.randint(0, 2)
        path = self.faker.image_url()
        self.cursor.execute(
            'INSERT INTO public.file \
            (type, path) \
            VALUES (%s, %s)',
            (type, path))


    def _create_user(self):
        self.cursor.execute('SELECT * FROM public.File')
        files = self.cursor.fetchall()
        if not len(files):
            raise ValueError("no files in db")
        gender = random.randint(0,2)
        bday = self.faker.date_of_birth()
        phone = self.faker.phone_number()
        email = self.faker.ascii_free_email()
        fname = self.faker.first_name_female() if gender != 1 else \
                self.faker.first_name_male()
        lname = self.faker.last_name_female() if gender != 1 else \
                self.faker.last_name_male()
        patronimic = self.faker.middle_name_female() if gender != 1 else \
                     self.faker.middle_name_male()
        password = str(uuid.uuid4())
        birthplace = self.faker.city()
        place_of_residence = self.faker.city()
        status = self.faker.text(200)
        additioal_info = self.faker.text(512)
        is_online = True if random.randint(0,1) == 1 else False
        self.cursor.execute(
            'INSERT INTO public.user \
            (first_name, last_name, patronimic, phone_number, \
            password, birthplace, place_of_residence, status, additional_information,\
            is_online, email, gender, birth_date, avatar_id) \
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
            (fname, lname, patronimic, phone, password, birthplace, place_of_residence,
            status, additioal_info, is_online, email, gender, bday, 
            random.choice(files)[0]))
    

    def _create_chat(self):
        self.cursor.execute('SELECT * FROM public.File ORDER BY RANDOM() LIMIT 1')
        file = self.cursor.fetchone()
        if file is None:
            raise ValueError("no files in db")
        name = self.faker.text(20)
        self.cursor.execute('SELECT * FROM public.User ORDER BY RANDOM() LIMIT 1')
        user = self.cursor.fetchone()
        self.cursor.execute(
            'INSERT INTO public.chat \
                (name, avatar, owner) \
                VALUES (%s, %s, %s)',
                (name, file[0], user[0])
        )
        

    def _create_message(self):
        add_file = True if random.randint(0, 9) == 1 else False
        self.cursor.execute('SELECT * FROM public.User ORDER BY RANDOM() LIMIT 1')
        user = self.cursor.fetchone()
        created_at = self.faker.date_between('-1y', 'today')
        text = self.faker.text(128)
        self.cursor.execute('SELECT * FROM public.Chat ORDER BY RANDOM() LIMIT 1')
        chat = self.cursor.fetchone()
        self.cursor.execute('SELECT * FROM public.File ORDER BY RANDOM() LIMIT 1')
        file_id = self.cursor.fetchone()[0] if add_file else None
        self.cursor.execute(
            'INSERT INTO public.message \
                (text, created_at, chat_id, file_id, owner) \
                VALUES (%s, %s, %s, %s, %s)',
                (text, created_at, chat[0], file_id, user[0])
        )
    

    def _create_post(self):
        add_file = True if random.randint(0, 5) == 1 else False
        self.cursor.execute('SELECT * FROM public.User ORDER BY RANDOM() LIMIT 1')
        user = self.cursor.fetchone()
        created_at = self.faker.date_between('-1y', 'today')
        text = self.faker.text(128)
        self.cursor.execute('SELECT * FROM public.File ORDER BY RANDOM() LIMIT 1')
        file_id = self.cursor.fetchone()[0] if add_file else None
        self.cursor.execute(
            'INSERT INTO public.post \
                (text, created_at, owner, file_id) \
                VALUES (%s, %s, %s, %s)',
                (text, created_at, user[0], file_id)
        )


    def _create_comment(self):
        created_at = self.faker.date_between('-1y', 'today')
        text = self.faker.text(128)
        self.cursor.execute('SELECT * FROM public.Comment ORDER BY RANDOM() LIMIT 1')
        comment = self.cursor.fetchone()
        is_for_comment = True if random.randint(0, 2) > 0 else False
        post = None
        if comment is None:
            is_for_comment = False
        if not is_for_comment:
            self.cursor.execute('SELECT * FROM public.post ORDER BY RANDOM() LIMIT 1')
            post = self.cursor.fetchone()[0]
            comment = None
        else:
            comment = comment[0]
        add_file = True if random.randint(0, 5) == 1 else False
        self.cursor.execute('SELECT * FROM public.File ORDER BY RANDOM() LIMIT 1')
        file_id = self.cursor.fetchone()[0] if add_file else None
        self.cursor.execute('SELECT * FROM public.User ORDER BY RANDOM() LIMIT 1')
        user = self.cursor.fetchone()
        self.cursor.execute(
            'INSERT INTO public.comment \
                (text, to_comment_id, to_post_id, file_id, owner, created_at) \
                VALUES (%s, %s, %s, %s, %s, %s)',
            (text, comment, post, file_id, user[0], created_at)
        )


    def create_mtm(self, obj_name1, obj_name2, table_name, refname1, refname2):
        self.cursor.execute(
            f'SELECT * FROM public.{obj_name1} ORDER BY RANDOM() LIMIT 1')
        obj1_id = self.cursor.fetchall()[0][0]
        self.cursor.execute(
            f'SELECT * FROM public.{obj_name2} ORDER BY RANDOM() LIMIT 1')
        obj2_id = self.cursor.fetchall()[0][0]
        self.cursor.execute(
            f'SELECT * FROM public.{table_name} WHERE {refname1}={obj1_id} AND\
                 {refname2}={obj2_id}'
        )
        if len(self.cursor.fetchall()) == 0:
            try:
                req = f'INSERT INTO public.{table_name} \
                        ({refname1}, {refname2}) \
                        VALUES (%s, %s)'
                self.cursor.execute(
                    req,
                    (obj1_id, obj2_id)
                )
            except Exception as ex:
                print(ex)


def main():
    filler = DbFiller() 
    for _ in range(100):
        filler._create_file()
    for _ in range(100):
        filler._create_user()
    for _ in range(1_000):
        filler._create_chat()
    for _ in range(50_000):
        filler._create_message()
    for _ in range(500):
        filler._create_post()
    for _ in range(500):
        filler._create_comment()
    for _ in range(500):
        filler.create_mtm('user', 'chat', 'user_chats', 'user_id', 'chat_id')
    for _ in range(500):
        filler.create_mtm('user', 'comment', 'user_likes_comment', 'user_id', 'comment_id')
    for _ in range(500):
        filler.create_mtm('user', 'post', 'user_likes_post', 'user_id', 'post_id')
    for _ in range(500):
        filler.create_mtm('user', 'user', 'user_subscribe_user', 'to_user', 'from_user')



if __name__ == '__main__':
    main()
    