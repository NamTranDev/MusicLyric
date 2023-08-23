import json
from bs4 import BeautifulSoup
import requests

if __name__ == '__main__':

    json_data = [] 
    try:
        with open('assets/data.json',encoding="utf8") as json_file:  
            json_data = json.load(json_file)
    except Exception as e:
        print(e)

    my_file = open("crawl/path2.txt", "r")
    content_list = my_file.readlines()
    another = []
    for content in content_list:
        soup = BeautifulSoup(requests.get(content).content, 'lxml')
        link = str(soup).split('"downloadlink": "')[1].split('",\n\t"result"')[0]
        paths = link.split('\\/')
        title = paths[(len(paths) - 1)]
        isFound = False
        for item in json_data:
            title_item = item['artist'].replace(' ','_') + '_' + item['nameOfSong'].replace(' ','_') + '.mp3'
            if title_item == title:
                isFound = True
                if 'https:\\/\\/p-def7.pcloud.com\\/' not in item['fileName']:
                    item['fileName'] = link
                else:
                    break
        if isFound is False:
            another.append({'title' : title,'path':link})
    with open("assets/data.json", "w") as outfile:
        json.dump(json_data, outfile)
    print(another)
            
                
            