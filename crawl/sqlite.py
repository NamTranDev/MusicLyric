import json
import os
import sqlite3
from sqlite3 import Error


def create_connection(db_file):
    conn = None
    try:
        conn = sqlite3.connect(db_file, isolation_level=None)
        c = conn.cursor()
        c.execute('''
            DROP table music
        ''')
        c.execute('''
          CREATE TABLE IF NOT EXISTS music
          ([id] INTEGER PRIMARY KEY AUTOINCREMENT, [nameOfSong] TEXT,[artist] TEXT,[fileName] TEXT,[lyric] TEXT,[duration] TEXT,[link] TEXT,[path] TEXT,[pathFileMacOs] TEXT)
          ''')
        
        with open('assets/data.json') as json_file:  
            json_data = json.load(json_file)
            
        files = os.listdir('musics')

        if len(files) == len(json_data):
            for file in files:
                for item in json_data:
                    if(item['fileName'] == os.path.basename(file)):
                        sql = "INSERT INTO music (nameOfSong,artist,fileName,lyric,duration,link,path,pathFileMacOs) VALUES (?,?,?,?,?,?,?,?)"
                        val = (item['nameOfSong'], item['artist'],item['fileName'],item['lyric'],item['duration'],item['link'],item['path'],os.path.abspath(file))
                        c.execute(sql,val)
        
        conn.commit()          
    except Error as e:
        print(e)
    finally:
        if conn:
            conn.close()


if __name__ == '__main__':
    create_connection('/Users/namtrandev/Project/MyGithub/FlutterProject/learn_english_with_music/assets/english_music.db')