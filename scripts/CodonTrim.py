#! /usr/bin/python

import os
import sys
import numpy
import math
import getopt
from shutil import copyfile
import Bio
from Bio import AlignIO

def usage():
	print 
"""
CodonTrim.py: reads a codon alignment in fasta format (start from the 1st codon position), and trim the remaining ends if it did not end with multiple of three.

Usage: CodonTrim.py [-h] <original codon alignment file> <cleaned codon alignment file>

-h                  print this help message

<original codon alignment file>   the output file from muscle, trimal, or BMCG, in fasta format
<cleaned codon alignment file> name the cleaned version for codon position wide analysis
"""

o, a = getopt.getopt(sys.argv[1:],'-output:h')
opts = {}

for k,v in o:
	opts[k]=v
if '-h' in opts.keys():
	usage(); sys.exit()

codonaln= sys.argv[1];
newaln= sys.argv[2];

try:
	t=open(codonaln)
except IOError:
	print("File %s does not exit!!!" % codonaln)

aln=AlignIO.read(codonaln, "fasta")
remain=aln.get_alignment_length()%3

if remain == 0:
	AlignIO.write(aln, newaln, "fasta")
else:
	n=aln[:, :-int(remain)]

	AlignIO.write(n, newaln, "fasta")
