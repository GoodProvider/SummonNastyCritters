#!  /usr/bin/env python3
import sys,os
import re
import requests
import json
import yaml
from bs4 import BeautifulSoup
from collections import OrderedDict
import argparse
# Create the parser
parser = argparse.ArgumentParser(description='Parses the wiki.')

# Add arguments
parser.add_argument('-g', '--groups_file', type=str)
parser.add_argument('-c', '--creatures_file', type=str)

# Parse the arguments
args = parser.parse_args()

URL=f"https://elderscrolls.fandom.com"
URL_START=f"{URL}/wiki/Creatures_(Skyrim)"
url_plugin = {
    "/wiki/Creatures_(Skyrim)":"Skyrim.esm",
    "/wiki/Category:Dragonborn:_Creatures":"Dragonborn.esm",
    "/wiki/Category:Dawnguard:_Creatures":"Dawnguard.esm"
}
HTMLS_DIR="htmls"

url_manual= [
    "/wiki/Skeleton_(Skyrim)",
    "/wiki/Keeper",
    "/wiki/Wrathman_(Dawnguard)",
]

def main():
    name_creatures = {}
    for u in url_manual:
        name = u[6:].split("_")[0]
        print (name)
        name_creatures[name] = [{"url":u}]
    for url in url_plugin.keys():
        creatures_download(f"{URL}{url}",name_creatures)

    plugin_id_name = {} 
    num_names = 0
    for name in sorted(name_creatures.keys()):
        cs = name_creatures[name]
        for c in cs: 
            for plugin_id in creature_load(c['url']):
                p,i = plugin_id['plugin'],plugin_id['id']
                if p not in plugin_id_name:
                    plugin_id_name[p] = {} 
                id_name = plugin_id_name[p]
                if i not in id_name or len(name) < len(id_name[i]):
                    id_name[i] = name
    name_ids = {} 
    for plugin,id_name in plugin_id_name.items():
        for i,name in id_name.items():
            if " " not in i: 
                if name not in name_ids:
                    name_ids[name] = []
                i = "00"+i[2:]
                name_ids[name].append({
                    "plugin":plugin,
                    "id":int(i, 16)
                })
            else:
                print ("failed to parse",name,i)
    creatures = []
    for name in sorted(name_ids.keys()):
        creature = {}
        creature['name'] = name
        creature['ids'] = name_ids[name]
        creatures.append(creature)

    #groups = sorted(g_creatures.values(),key=lambda g:g["name"])
    #print ("creating",args.groups_file)
    #with open(args.groups_file,"w") as fout:
    #    fout.write(yaml.dump(groups,sort_keys=False))
    print ("creating",args.creatures_file)
    with open(args.creatures_file,"w") as fout:
        fout.write(yaml.dump(creatures,sort_keys=False))
    

re_wiki = re.compile("^/wiki")
def creatures_download(url, name_creatures):
    soup = download(url)
    content = soup.find("div",{"class":"mw-parser-output"})
    for elm in content.findAll():
        if elm.has_attr("class") and 'mw-headline' in elm['class']:
            group = elm.text
        elif elm.name == 'ul':
            for a in elm.findAll("a"):
                if "#" not in a['href']:
                    name = a.text
                    if name not in name_creatures:
                        name_creatures[name] = []
                    name_creatures[name].append({
                        "url":a['href'],
                        "group":group,
                        "name":a.text
                    })
    
def creature_load(url):
    url = f"{URL}{url}"
    soup = download(url)

    plugin = "Skyrim.esm"
    for div in soup.findAll("div",{"class":"page-header__categories"}):
        for a in div.findAll("a"):
            if a.has_attr('href') and a['href'] in url_plugin:
                plugin = url_plugin[a['href']]

    divs = [] 
    for div in soup.findAll("div",{"data-source":"BaseID"}):
        divs.append(div)
    for div in soup.findAll("div",{"data-source":"baseid"}):
        divs.append(div)
    ids = []
    for div in divs:
        for span in div.findAll("span"):
            if len(span.text) == 8:
                ids.append({
                    "plugin":plugin,
                    "id":span.text
                })
    return ids


def download(url):
    fname = url.split("/")[-1]
    fname = f"{HTMLS_DIR}/{fname}.html"
    if not os.path.exists(fname):
        try:
            print ("downloading",fname)
            resp = requests.get(url)
            resp.raise_for_status()
            with open(fname,"wb") as fin:
                fin.write(resp.content)
        except requests.exceptions.RequestException as e:
            print (f"Failed to download {url}\n\t{e}")

    with open(fname,"rb") as fin:
        content = fin.read()
        return BeautifulSoup(content,"html.parser")

    return None

main()
