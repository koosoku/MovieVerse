import psycopg2
import requests
import random

conn = psycopg2.connect("dbname='test_db' user='kyle' host='localhost' password='kyle1234' ")
cur = conn.cursor()

lastname = ['SMITH','JOHNSON','WILLIAMS','BROWN','JONES','MILLER','DAVIS','GARCIA','RODRIGUEZ']
firstname= ['NOAH','LIAM','MASON','JACON','WILLIAM','ETHAN','MICHAEL','ALEXANDER','JAMES','DANIEL']

def inserIntoDB():


    for i in range(20):
        Ifirstname = random.randint(0, 9)
        Ilastname = random.randint(0, 8)
        try:
            print i
            print Ifirstname
            print Ilastname
            cur.execute('INSERT INTO profile (userid,password,lastname,firstname) VALUES(%s,%s,%s,%s)',('user' + str(i), '1234',lastname[Ilastname], firstname[Ifirstname]))
            conn.commit()
        except Exception as e:
            print(e)
            pass

inserIntoDB()