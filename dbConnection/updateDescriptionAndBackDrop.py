import psycopg2
import requests

import time
conn = psycopg2.connect("dbname='test_db' user='kyle' host='localhost' password='kyle1234' ")
cur = conn.cursor()

def addImagePathAndDescriptionFromID(id):
    print id
    r = requests.get('https://api.themoviedb.org/3/movie/' + str(id) + '?api_key=8a439f408d3ed4c974abe73cc1645699')
    print r.json()
    if 'status_code' in r.json():
        print time.ctime()
        time.sleep(10)
        print time.ctime()
        addImagePathAndDescriptionFromID(id)
    else:
        try:
            cur.execute('UPDATE movie SET backdrop_image_path = %s WHERE movieid = %s',(r.json()['backdrop_path'],id))
            conn.commit()
        except Exception as e:
            conn.rollback()
            print e
            pass
        try:
            cur.execute('UPDATE movie SET description = %s WHERE movieid = %s', (r.json()['overview'], id))
            conn.commit()
        except Exception as e:
            conn.rollback()
            print e
            pass

def readFromTable():
    try:
        cur.execute('SELECT movieid FROM movie')
        rows = cur.fetchall()
        print len(rows)
        for i in range(len(rows)):
            print rows[i][0]
            addImagePathAndDescriptionFromID(rows[i][0])
    except Exception as e:
        conn.rollback()
        print e
        pass
readFromTable()