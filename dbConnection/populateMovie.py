import psycopg2
import requests

import time

conn = psycopg2.connect("dbname='test_db' user='kyle' host='localhost' password='kyle1234' ")
cur = conn.cursor()

def insertIntoDB(results):
    try:
        cur.execute('INSERT INTO Movie (movieid,name,datereleased) VALUES (%s, %s,%s)', (results['id'],results['title'], results['release_date']))
    except:
        print 'movie already in the db'
        pass
    conn.commit()

def fetchMovieByID(id):
    print id
    r = requests.get('https://api.themoviedb.org/3/movie/' + str(id) + '?api_key=8a439f408d3ed4c974abe73cc1645699')
    if 'status_code' not in r.json():
        print r.json()
        insertIntoDB(r.json())


def requestMovie(query):
    r = requests.get('https://api.themoviedb.org/3/search/keyword?api_key=8a439f408d3ed4c974abe73cc1645699&query='+query)
    results =  r.json()['results']
    print results
    for i in range(len(results)):
        fetchMovieByID(results[i]['id'])

def requestPopularMove(startPage,endPage):
    for i in range(startPage,endPage):
        r = requests.get('https://api.themoviedb.org/3/movie/popular?api_key=8a439f408d3ed4c974abe73cc1645699&page='+str(i))
        results = r.json()['results']
        print results
        for i in range(len(results)):
            insertIntoDB(results[i])

def addImagePathColumn():
    try:
        cur.execute('ALTER TABLE movie ADD imagepath VARCHAR(50)')
        conn.commit()
    except:
        print "failed to add column"
        pass


def addImagePathFromID(id):
    print id
    r = requests.get('https://api.themoviedb.org/3/movie/' + str(id) + '?api_key=8a439f408d3ed4c974abe73cc1645699')
    if 'status_code' in r.json():
        print time.ctime()
        time.sleep(10)
        print time.ctime()
        addImagePathFromID(id)
    else:
        cur.execute('UPDATE movie SET imagepath = %s WHERE movieid = %s',(r.json()['poster_path'],id))
        conn.commit()

def readFromTable():
    try:
        cur.execute('SELECT movieid FROM movie')
        rows = cur.fetchall()
        print len(rows)
        for i in range(len(rows)):
            print rows[i][0]
            addImagePathFromID(rows[i][0])
    except Exception as e:
        print e
        pass

readFromTable()





# addImagePathColumn()
