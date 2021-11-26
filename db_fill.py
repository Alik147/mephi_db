import random
import datetime
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
    
    def __create_user(self):
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

    def __create_partner(self):
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
         
    def __create_object(self):
        self.cursor.execute('SELECT * FROM public.partner')
        partners = (self.cursor.fetchall())
        self.cursor.execute('SELECT * FROM public.object_type')
        object_types = self.cursor.fetchall()
        if len(partners) and len(object_types):
            self.cursor.execute(
                'INSERT INTO public.object (location, type_id, partner_id)\
                    VALUES (%s, %s, %s)',
                    (self.faker.address(),
                     random.choice(object_types)[0],
                    #  float(random.randint(0, 9)) + float(random.randint(0,9))/10,
                     random.choice(partners)[0]
                     )
            )
            
    def __create_accomodation(self):
        checkin_time = str(random.randint(6, 20)) + ':00'
        name = self.faker.word() + ' ' + self.faker.word()
        people_number = random.randint(1, 5)
        area = random.randint(20, 100)
        price = random.randrange(500, 10000, 100)
        photo = f'/src/accomodation/photos/{self.faker.word()}.jpg'
        self.cursor.execute('SELECT * FROM public.object')
        objects = self.cursor.fetchall()
        object_id = random.choice(objects)[0]
        self.cursor.execute(
            'INSERT INTO public.accomodation \
                (checkin_time, name, people_number, area, price, photo, object_id)\
                VALUES (%s, %s, %s, %s, %s, %s, %s)',
                (checkin_time, name, people_number, area, price, photo, object_id)
        )
    
    def __create_comment(self):
        self.cursor.execute('SELECT * FROM public.reservation')
        reservation = random.choice(self.cursor.fetchall())
        user_id = reservation[4]
        rating = float(random.randint(0, 9)) + float(random.randint(0,9))/10
        comment_delay = random.randint(1, 30)
        created_at = reservation[3]
        plus_number = random.randint(0,5)
        minus_number = random.randint(0,5)
        pluses = []
        minuses = []
        for i in range(plus_number):
            pluses.append(self.faker.sentence())
        for i in range(minus_number):
            minuses.append(self.faker.sentence())
        residents = random.randint(1, 5)
        photo = f'/src/comment/photos/{self.faker.word()}.jpg'
        self.cursor.execute(
            'INSERT INTO public.comment \
                (photo, created_at, rating, pluses, minuses, plus_number, minus_number,\
                residents, owner_id, reservation_id)\
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
            (photo, created_at, rating, pluses, minuses, plus_number, minus_number, residents, user_id, reservation[0])
        )

        
    def __create_reservation(self):
        reservation_time_start = self.faker.date_between('-1y', 'today')
        created_at = self.faker.date_between('-1y', 'today')
        if reservation_time_start < created_at:
            reservation_time_start, created_at = created_at, reservation_time_start
        days = random.randint(1, 14)
        reservation_time_end = (reservation_time_start + datetime.timedelta(days=days))
        self.cursor.execute('SELECT * FROM public.user')
        user_id = random.choice(self.cursor.fetchall())[0]
        self.cursor.execute(
            'INSERT INTO public.reservation \
                (created_at, reservation_time_start, reservation_time_end, user_id)\
                VALUES (%s, %s, %s, %s)',
            (created_at, reservation_time_start, reservation_time_end, user_id)
        )
    
    def __load_comment_categories(self):
        with open('./src/comment_categories.txt', 'r') as f:
            for category in f:
                self.cursor.execute(
                    'INSERT INTO public.category (name) VALUES (%s)',
                    (category, )
                )

    def __load_services(self):
        with open('./src/service.txt', 'r') as f:
            for service in f:
                self.cursor.execute(
                    'INSERT INTO public.service (name) VALUES (%s)',
                    (service, )
                )
    
    def __load_object_types(self):
        with open('./src/object_type.txt', 'r') as f:
            for type_ in f:
                self.cursor.execute(
                    'INSERT INTO public.object_type (name) VALUES (%s)',
                    (type_, )
                )

    def __load_facilities(self):
        with open('./src/facility.txt', 'r') as f:
            self.cursor.execute('SELECT * FROM public.facility_type')
            last_id = len(self.cursor.fetchall())
            for facility in f:
                if facility.startswith('~'):
                    self.cursor.execute(
                        'INSERT INTO public.facility_type (name) VALUES (%s)',
                        (facility[1:], )
                    )
                    last_id+=1
                else:
                    self.cursor.execute(
                        'INSERT INTO public.facility (name, facility_type_id) VALUES\
                            (%s, %s)',
                            (facility, last_id)
                    )
                    
    def __load_furniture(self):
        with open('./src/furniture.txt', 'r') as f:
            for furniture in f:
                self.cursor.execute(
                    'INSERT INTO public.furniture (name) VALUES (%s)',
                    (furniture, )
                )
    
    def __create_mtm_comment_category(self):
        self.cursor.execute('SELECT id FROM public.comment')
        comment_ids = self.cursor.fetchall()
        self.cursor.execute('SELECT id FROM public.category')
        category_ids = self.cursor.fetchall()
        for comment_id in comment_ids:
            quantity_category = random.randint(0, 5)
            categories_rnd = random.choices(category_ids, k=quantity_category)
            for category in categories_rnd:
                self.cursor.execute(
                    'INSERT INTO public.comment_category (score, categories_id, comments_id)\
                        VALUES (%s, %s, %s)',
                    (random.randint(1, 10), category[0], comment_id[0])
                )

    def __create_mtm_facility_object(self):
        self.cursor.execute('SELECT id FROM public.object')
        objects_ids = self.cursor.fetchall()
        self.cursor.execute('SELECT id FROM public.facility')
        facility_ids = self.cursor.fetchall()
        for object_id in objects_ids:
            quantity_facility = random.randint(0, 10)
            facilities_ids_rnd = random.choices(facility_ids, k=quantity_facility)
            for facility_id in facilities_ids_rnd:
                self.cursor.execute(
                    'INSERT INTO public.facility_object (facilities_id, object_id)\
                        VALUES (%s, %s)',
                    (facility_id[0], object_id[0])
                )

    def __create_mtm_furniture_accomodation(self):
        self.cursor.execute('SELECT id FROM public.accomodation')
        accomodation_ids = self.cursor.fetchall()
        self.cursor.execute('SELECT id FROM public.furniture')
        furniture_ids = self.cursor.fetchall()
        for accomodation_id in accomodation_ids:
            quantity_furniture = random.randint(1, 4)
            furniture_ids_rnd = random.choices(furniture_ids, k=quantity_furniture)
            for furniture_id in furniture_ids_rnd:
                self.cursor.execute(
                    'INSERT INTO public.furniture_accomodation (quantity, furniture_id, accomodation_id)\
                        VALUES (%s, %s, %s)',
                    (random.randint(1,3), furniture_id[0], accomodation_id[0])
                )

    def __create_mtm_reservation_accomodation(self):
        self.cursor.execute('SELECT id FROM public.accomodation')
        accomodation_ids = self.cursor.fetchall()
        self.cursor.execute('SELECT id FROM public.reservation')
        reservaiton_ids = self.cursor.fetchall()
        for reservation_id in reservaiton_ids:
            quantity_accomodation = random.randint(1, 2)
            accomodation_ids_rnd = random.choices(accomodation_ids, k=quantity_accomodation)
            for accomodation_id in accomodation_ids_rnd:
                self.cursor.execute(
                    'INSERT INTO public.reservation_accomodation (reservations_id, accomodations_id)\
                        VALUES (%s, %s)',
                    (reservation_id[0], accomodation_id[0])
                )

    def __create_mtm_service_object(self):
        self.cursor.execute('SELECT id FROM public.service')
        service_ids = self.cursor.fetchall()
        self.cursor.execute('SELECT id FROM public.object')
        object_ids = self.cursor.fetchall()
        for object_ in object_ids:
            quantity_service = random.randint(3, 8)
            service_ids_rnd = random.choices(service_ids, k=quantity_service)
            for service in service_ids_rnd:
                self.cursor.execute(
                    'INSERT INTO public.service_object (service_id, object_id)\
                        VALUES (%s, %s)',
                    (service[0], object_[0])
                )
                
    def fill(self, user_qantity, object_qantity):
        self.__load_comment_categories()
        self.__load_facilities()
        self.__load_object_types()
        self.__load_services()
        self.__load_furniture()
        for _ in range(user_qantity):
            self.__create_user()
        for _ in range(int(object_qantity/2) + random.randint(1, int(object_qantity/2))):
            self.__create_partner()
        for _ in range(object_qantity):
            self.__create_object()
        for _ in range(object_qantity * random.randint(2,4)):
            self.__create_accomodation()
        for _ in range(user_qantity * 2):
            self.__create_reservation()
        for _ in range(int(user_qantity / 3)):
            self.__create_comment()
        self.__create_mtm_comment_category()
        self.__create_mtm_facility_object()
        self.__create_mtm_furniture_accomodation()
        self.__create_mtm_reservation_accomodation()
        self.__create_mtm_service_object()
  
def main():
    filler = DbFiller();
    filler.fill(200, 75)
    # filler.load_comment_categories()
    # filler.load_facilities()
    # filler.load_object_types()
    # filler.load_services()
    # filler.load_furniture()
    # filler.create_partner()
    #filler.create_object()
    # filler.create_comment()
    # filler.create_reservation()
    

if __name__ == '__main__':
    main()
    