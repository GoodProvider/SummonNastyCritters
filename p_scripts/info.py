import sys
import argparse
import re
import hashlib
# Create the parser
parser = argparse.ArgumentParser()

# Add arguments
parser.add_argument('-v', '--version', type=str, required=True)
parser.add_argument('-n', '--name', type=str, required=True)
parser.add_argument('-o', '--output', type=str, required=True)
parser.add_argument('input', type=str)
args = parser.parse_args()

with open(args.output,"w") as fout:
    with open(args.input) as fin:
        buffer = fin.read() 
        md5 = hashlib.md5(buffer.encode('utf-8')).hexdigest()
        print("{",file=fout)
        print (f'   "name":"{args.name}",',file=fout)
        print (f'   "version":"{args.version}",',file=fout)
        print (f'   "creatures_md5":"{md5}"',file=fout)
        print("}",file=fout)