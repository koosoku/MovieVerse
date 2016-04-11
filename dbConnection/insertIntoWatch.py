import psycopg2
import random

conn = psycopg2.connect("dbname='test_db' user='kyle' host='localhost' password='kyle1234' ")
cur = conn.cursor()

def inserIntoDB(rows):
    for i in range(20):
        for j in range(40):
            randomMovie = random.randint(0, len(rows)-1)
            try:
                cur.execute('INSERT INTO watches (userid,movieid,rating) VALUES(%s,%s,%s)',('user' + str(i),rows[randomMovie],random.randint(7,10)))
                conn.commit()
            except Exception as e:
                conn.rollback()
                print(e)
                pass



def readFromTable():
    try:
        cur.execute('SELECT movieid FROM movie')
        rows = cur.fetchall()
        inserIntoDB(rows)
    except Exception as e:
        print e
        pass

readFromTable()