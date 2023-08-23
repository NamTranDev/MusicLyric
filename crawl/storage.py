import json
import os


if __name__ == '__main__':
    # getPath()
    json_data = [] 
    try:
        with open('assets/data.json',encoding="utf8") as json_file:  
            json_data = json.load(json_file)
    except Exception as e:
        print(e)

    files = os.listdir('assets/music_lyric')
    if len(files) == len(json_data):
        for file in files:
            file_name = os.path.basename(file).replace('_',' ')
            for item in json_data:
                name = item['nameOfSong']
                artist = item['artist']
                if name in file_name and artist in file_name:
                    item['fileName'] = os.path.basename(file)
                else :
                    print(file_name + '                     ' + os.path.basename(file)) 

    with open("assets/data.json", "w") as outfile:
        json.dump(json_data, outfile)

    