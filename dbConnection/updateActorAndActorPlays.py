import psycopg2
import requests
import time

conn = psycopg2.connect("dbname='test_db' user='kyle' host='localhost' password='kyle1234' ")
cur = conn.cursor()

def addMovieTopics(id):
    print id
    r = requests.get('https://api.themoviedb.org/3/movie/' + str(id) +'/credits' + '?api_key=8a439f408d3ed4c974abe73cc1645699')
    if 'status_code' in r.json():
        print time.ctime()
        time.sleep(10)
        print time.ctime()
        addMovieTopics(id)
    else:
        casts = r.json()['cast']
        print casts
        if len(casts)>=10:
            for i in range(10):
                print casts[i]
                try:
                    cur.execute('INSERT INTO actor (actorid,name) VALUES(%s,%s)', (casts[i]['id'], casts[i]['name']))
                    conn.commit()
                except Exception as e:
                    conn.rollback()
                    print(e)
                    pass
                try:
                    cur.execute('INSERT INTO actorplays (role,actorid,movieid) VALUES(%s,%s,%s)',
                                (casts[i]['character'], casts[i]['id'],id))
                    conn.commit()
                except Exception as e:
                    conn.rollback()
                    print(e)
                    pass


        else:
            for i in range(len(casts)):
                print casts[i]
                try:
                    cur.execute('INSERT INTO actor (actorid,actor_name) VALUES(%s,%s)', (casts[i]['id'], casts[i]['name']))
                    conn.commit()
                except Exception as e:
                    conn.rollback()
                    print(e)
                    pass
                try:
                    cur.execute('INSERT INTO role_in_movie (rolename,actorid,movieid) VALUES(%s,%s,%s)', (casts[i]['character'],casts[i]['id']),id)
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
            print rows[i]
            addMovieTopics(rows[i][0])
    except Exception as e:
        print e
        pass

readFromTable()