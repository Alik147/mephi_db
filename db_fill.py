import random
import uuid

import psycopg2
import faker

class DbFiller:
    def __init__(self):
        self.conn = psycopg2.connect(
            database='mephi_booking', user='postgres', password='admin')
        self.cursor = self.conn.cursor()
        self.faker = faker.Faker('ru_RU')

    def __del__(self):
        self.conn.commit()
        self.cursor.close()
        self.conn.close()
    
    def create_user(self):
        gender_tuple = (
            'мужчина', 'женщина', 'предпочитает не говорить', 'небинарные'
            )
        gender = random.choice(gender_tuple)
        name = \
            self.faker.first_name_female()+ ' ' + self.faker.last_name_female()\
            if gender != 'мужчина' else\
            self.faker.first_name_male() + ' ' + self.faker.last_name_male()
        bday = self.faker.date_of_birth()
        phone = self.faker.phone_number()
        email = self.faker.ascii_free_email()
        passwd = str(uuid.uuid4())
        username = self.faker.user_name()
        address = self.faker.address()
        nationality_tuple = (
            'русские', 'татары', 'украинцы', 'башкиры', 'чуваши'
            )
        nationality = random.choice(nationality_tuple)
        self.cursor.execute(
            'INSERT INTO public.user \
            (name, birthday, phone_number, email_address, \
            password, address, gender, nationality, username) \
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)',
            (name, bday, phone, email, passwd, address, gender, nationality, username))

    def create_partner(self):
        gender_tuple = (
            'мужчина', 'женщина', 'предпочитает не говорить', 'небинарные'
            )
        gender = random.choice(gender_tuple)
        phone = self.faker.phone_number()
        email = self.faker.ascii_free_email()
        fname = self.faker.first_name_female() if gender != 'мужчина' else \
                self.faker.first_name_male()
        lname = self.faker.last_name_female() if gender != 'мужчина' else \
                self.faker.last_name_male()
        self.cursor.execute(
            'INSERT INTO public.partner \
            (email_address, phone_number, first_name, last_name)\
            VALUES (%s, %s, %s, %s)',
            (email, phone, fname, lname))
         
    def create_object(self):
        self.cursor.execute('SELECT * FROM public.partner')
        size_partners = len(self.cursor.fetchall())
        if size_partners:
            pass
    
    def load_comment_categories(self):
        with open('./src/comment_categories.txt', 'r') as f:
            for category in f:
                self.cursor.execute(
                    'INSERT INTO public.category (name) VALUES (%s)',
                    category
                )
    def load_services(self):
        with open('./src/service.txt', 'r') as f:
            for service in f:
                self.cursor.execute(
                    'INSERT INTO public.service (name) VALUES (%s)',
                    service
                )
    
    def load_object_types(self):
        with open('./src/object_type.txt', 'r') as f:
            for type_ in f:
                self.cursor.execute(
                    'INSERT INTO public.object_type (name) VALUES (%s)',
                    type_
                )
    def load_facilities(self):
        pass
        
  
def main():
    filler = DbFiller();
    filler.create_partner()
    pass

if __name__ == '__main__':
    main()
    