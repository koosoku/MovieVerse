import psycopg2
import requests

conn = psycopg2.connect("dbname='test_db' user='kyle' host='localhost' password='kyle1234' ")
cur = conn.cursor()

def inserIntoDB(results):
    try:
        cur.execute('INSERT INTO topics (topicid,description) VALUES (%s, %s)', (results['id'], results['name']))
    except:
        print 'topic already in the db'
        pass
    conn.commit()

def getGenreList():
    r = requests.get('https://api.themoviedb.org/3/genre/movie/list?api_key=8a439f408d3ed4c974abe73cc1645699')
    genres = r.json()['genres']
    for i in range(len(genres)):
        inserIntoDB(genres[i])

getGenreList()