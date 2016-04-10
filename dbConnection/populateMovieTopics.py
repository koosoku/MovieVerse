import psycopg2
import requests

import time
conn = psycopg2.connect("dbname='test_db' user='kyle' host='localhost' password='kyle1234' ")
cur = conn.cursor()

def addMovieTopics(id):
    print id
    r = requests.get('https://api.themoviedb.org/3/movie/' + str(id) + '?api_key=8a439f408d3ed4c974abe73cc1645699')
    if 'status_code' in r.json():
        print time.ctime()
        time.sleep(10)
        print time.ctime()
        addMovieTopics(id)
    else:
        genres = r.json()['genres']
        for i in range(len(genres)):
            try:
                cur.execute('INSERT INTO movietopics (movieid,topicid) VALUES(%s,%s)', (id,genres[i]['id']))
                conn.commit()
            except Exception as e:
                conn.rollback()
                print(e)
                pass


def readFromTable():
    try:
        cur.execute('SELECT movieid FROM movie')
        rows = cur.fetchall()
        print len(rows)
        for i in range(len(rows)):
            print rows[i][0]
            addMovieTopics(rows[i][0])
    except Exception as e:
        print e
        pass

readFromTable()