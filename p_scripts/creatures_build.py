#!  /usr/bin/env python3
import sys,os
import json
import yaml
import re
from bs4 import BeautifulSoup
from collections import OrderedDict
import argparse
# Create the parser
parser = argparse.ArgumentParser(description='Parses the wiki.')

# Add arguments
parser.add_argument('-g', '--groups_file', type=str, required=True)
parser.add_argument('-c', '--creatures_file', type=str, required=True)
parser.add_argument('-u', '--unsexable_file', type=str, required=True)
parser.add_argument('output', type=str)

mask = 0xFFFFFF

# Parse the arguments
args = parser.parse_args()

members_no_sex = set() 

re_number = re.compile(r"^\d+$")
def main():
    unsexable = unsexable_load(args.unsexable_file)
    name_creature = creatures_load(args.creatures_file,unsexable)
    name_paths = groups_load(args.groups_file,name_creature)
    creatures = [] 
    for name,creature in sorted(name_creature.items()):
        if re_number.search(name):
            continue 
        if len(creature['paths']) > 0:
            creatures.append(creature)
        else:
            print ("no paths for",creature)
    print ("creating",args.output)
    with open(args.output,"w") as fout:
        fout.write(json.dumps(creatures,indent=4))
    
def creatures_load(fname, unsexable):
    re_plug_order = re.compile(r"^\d\d0+")
    with open(fname) as fin:
        creatures = json.load(fin)
        name_creature = {} 
        for creature in creatures:
            creature['id'] = mask&int(creature['id'])
            if 'Name' in creature:
                creature['name'] = creature['Name']
                del creature['Name']

            if 'name' not in creature or creature['name'] == "" or "edit " in creature['name']:
                creature['name'] = str(creature['id'])
            else:
                if "Summoned" in creature['name']:
                    creature['name'] = creature['name'][9:]
            if creature['name'] in unsexable:
                creature['sexable'] = 0

        for creature in sorted(creatures, key=lambda c:c['name']):
            name = creature['name']
            if name not in name_creature:
                name_creature[name] = {
                    "name":name,
                    "ids":[],
                    "paths":[]
                }
            name_creature[name]['ids'].append({
                'id':creature['id'],
                'plugin':creature['plugin'],
                'sexable':creature['sexable']
            })
        return name_creature
    sys.exit(1) 

def groups_load(fname, name_creature):
    with open(fname) as fin:
        groups = yaml.safe_load(fin)
        groups_parse(groups, "", name_creature)

def unsexable_load(fname):
    unsexable = set() 
    print (fname)
    with open(fname) as fin:
        for name in yaml.safe_load(fin):
            unsexable.add(name)
    return unsexable

def groups_parse(groups, path_base, name_creature):
    for group in groups:
        path = f"{path_base}.{group['name']}"
        if "groups" in group:
            groups_parse(group["groups"],path,name_creature)
        if "members" in group: 
            for name in group['members']:
                if name in name_creature:
                    name_creature[name]['paths'].append(f"{path}.{name}")
                else:
                    print ("  not found",name)
        if "members_no_sex" in group:
            for name in group["members_no_sex"]:
                members_no_sex.add(name)

main()
