
import codecs
import datetime
import json
import os
from cv2 import reduce
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver import ActionChains
from selenium.webdriver.common.keys import Keys

import yt_dlp as youtube_dl

from bs4 import BeautifulSoup
import requests
import re

from youtube_transcript_api import YouTubeTranscriptApi

from datetime import timedelta

from time import strftime
from time import gmtime

URL_LYRIC = "https://www.megalobiz.com/search/all?qry="
URL_FILE = 'https://new.myfreemp3juices.cc/'
URL_YOUTUBE = "https://www.youtube.com/"

def write_json(datas):
    with open("assets/data2.json", "w") as outfile:
        json.dump(datas, outfile)

def list_json():
    json_data = [] 
    try:
        with open('assets/data.json') as json_file:  
            json_data = json.load(json_file)
    except:
        pass
    return json_data

datas_music_json = list_json()

def main():
    my_file = open("crawl/musics.txt", "r")
    content_list = my_file.readlines()
    for content in content_list:
        content = content.rstrip()
        artist = None
        if(' - ' in content):
            song = content.split(' - ')[1].strip()
            artist = content.split(' - ')[0].strip()
        else:
            song = content.strip()
        # print(content)
        isExist = False
        for item in datas_music_json:
            if song in item['nameOfSong'] and (artist if artist is not None else '') in item['artist']:
                isExist = True
                break
        if isExist:
            continue
        getLinkYoutube(song,artist)

def getLinkYoutube(nameOfSong,artist):
    _artist = artist if artist is not None else ''
    if '' == nameOfSong or '' == _artist:
        return
    soup = BeautifulSoup(requests.get(URL_YOUTUBE + 'results?search_query=' + nameOfSong.replace(' ',('+')) + _artist.replace('','+')).content, 'lxml')
    # web_youtube = webdriver.Chrome()
    # web_youtube.get()
    # Ctr + shift + c => view source and element web
    script = soup.find_all('script')[34]
    json_text = re.search('var ytInitialData = (.+)[,;]{1}',str(script)).group(1)
    json_data = json.loads(json_text)
    # print(json_data)
    content = (json_data
               ['contents']['twoColumnSearchResultsRenderer']['primaryContents']['sectionListRenderer']['contents'][0]['itemSectionRenderer']['contents'])
    for data in content:
        listInfo = []
        isError = False
        for key,value in data.items():
            if type(value) is dict:
                for k,v in value.items():
                    if k == 'videoId' and len(v) == 11:
                        listInfo.append(v)
                    if k == 'title':
                        #title
                        try:
                            listInfo.append(v['runs'][0]['text'])
                        except:
                            isError = True
                    if k == 'lengthText':
                        #time
                        listInfo.append(v['simpleText'])
                    if len(listInfo) == 3 or isError:
                        break
            if len(listInfo) == 3 or isError:
                break
        if len(listInfo) == 3:
            duration = listInfo[2]
            if nameOfSong in listInfo[1] and _artist in listInfo[1]:
                # downloadFile('https://www.youtube.com/watch?v=' + listInfo[0])
                transcript = get_video_transcript(video_id = listInfo[0])
                if transcript is None:
                    transcript = found_lyric([nameOfSong,_artist],duration)
                if transcript is not None:
                    SAVE_PATH = 'assets/music/'
                    file_name = _artist.replace(' ','_') + '_' + nameOfSong.replace(' ','_')
                    downloadFile('https://www.youtube.com/watch?v=' + listInfo[0],SAVE_PATH + file_name)
                    if os.path.exists(SAVE_PATH + file_name+'.mp3'):
                        datas_music_json.append({'nameOfSong' : nameOfSong,'artist' : _artist,'lyric':transcript,'fileName':file_name + '.mp3','duration' : duration})
                        write_json(datas_music_json)
                break

def secondsToStr(t):
    return "%02d:%02d:%02d.%03d" % \
        reduce(lambda ll,b : divmod(ll[0],b) + ll[1:],
            [(round(t*1000),),1000,60,60])

def found_lyric(song_value,time):
   timeFile = int(time.split(":")[0]) * 60 + int(time.split(":")[1])
   soup = BeautifulSoup(requests.get(URL_LYRIC + song_value[0].replace(" ",("+"))).content, 'lxml')
   items = soup.findAll('div',class_ = 'entity_full_member_info')
   for item in items:
       a_title = item.find('a','entity_name')
       title = a_title.text.strip()
       if song_value[0].upper() in title.upper() and (song_value[1].upper() if song_value[1] is not None else '') in title.upper():
            time_lyric = title[-9:-4]
            try:
                time_number_lyric = int(time_lyric.split(":")[0]) * 60 + int(time_lyric.split(":")[1])
                if (abs(timeFile - time_number_lyric) <= 1):
                    # print(song_value[0] + ' - ' + song_value[1])
                    #    print()
                    #    print()
                    #    print()
                    return get_lyric('https://www.megalobiz.com/' + a_title['href'])
            except:
                pass
   return None

def get_lyric(link):
    splits = link.split('.')
    id = 'lrc_' + splits[len(splits) - 1] + '_lyrics'
    soup = BeautifulSoup(requests.get(link).content, 'lxml')
    lyric = soup.find('span',id = id).text.strip().split(']\n[')
    return '[' + lyric[len(lyric) - 1]

def get_video_transcript(video_id: str = None):
    try:
        raw_transcript = YouTubeTranscriptApi.get_transcript(video_id)
        transcript = ""
        # end = None
        for t in raw_transcript:
            normal_string =re.sub("[^A-Z]", "", t['text'],0,re.IGNORECASE).strip()
            if len(normal_string) == 0:
                continue
            start = t['start']
            # if end is not None and start - end > 2:
            #     duration_end = strftime("%M:%S", gmtime(end)) + '.' + str(end).split('.')[1]
            #     transcript += '[' + duration_end + ']' + '\n'
            # end = start + t['duration']
            duration_start = strftime("%M:%S", gmtime(start)) + '.' + str(start).split('.')[1]
            transcript += '[' + duration_start + ']' + t['text'].replace('\u266a','').replace('\n',' ') + '\n'
        return transcript
    except:
        return None

def downloadFile(link,output):
    if os.path.exists(output + '.mp3'):
        return
    ydl_opts = {
        'format': 'bestaudio/best',
        'outtmpl': output,
        'postprocessors': [{
            'key': 'FFmpegExtractAudio',
            'preferredcodec': 'mp3',
            'preferredquality': '320',
        }],
    }
    with youtube_dl.YoutubeDL(ydl_opts) as ydl:
        ydl.download([link])
    print("Download Success : " + link)

main()