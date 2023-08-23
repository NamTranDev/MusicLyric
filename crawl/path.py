import json
import os


def getPath():

    json_data = [] 
    try:
        with open('assets/data.json',encoding="utf8") as json_file:  
            json_data = json.load(json_file)
    except Exception as e:
        print(e)
    
    my_file = open("assets/path.txt", "r")
    content_list = my_file.readlines()
    content = content_list[0].rstrip().split(',')
    print(content)
    files = os.listdir('assets/music')
    if len(files) == len(content):
        for idx, file in enumerate(files):
            file_name = os.path.basename(file)
            for item in json_data:
                if item['fileName'] == file_name or item['fileName'].replace("'",'_') == file_name:
                    item['fileName'] = content[idx]
                    try:
                        os.remove('assets/music/' + file)
                    except Exception as e:
                        print(e)
                        

    with open("assets/data.json", "w") as outfile:
        json.dump(json_data, outfile)

        

if __name__ == '__main__':
    # getPath()
    json_data = [] 
    try:
        with open('assets/data.json',encoding="utf8") as json_file:  
            json_data = json.load(json_file)
    except Exception as e:
        print(e)

    for item in json_data:
        if 'https://drive.google.com' not in item['fileName']:
            print(item)