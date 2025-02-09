import sys
import argparse
import re
# Create the parser
parser = argparse.ArgumentParser(description='Parses the wiki.')

# Add arguments
parser.add_argument('-v', '--version', type=str, required=True)
parser.add_argument('-o', '--output', type=str, required=True)
parser.add_argument('input', type=str)
args = parser.parse_args()

with open(args.input) as fin:
    print ("creating",args.output)
    with open(args.output,"w") as fout:
        for line in fin:
            line = re.sub(r"\$version",args.version,line)
            fout.write(line)
