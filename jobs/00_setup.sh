#!/usr/bin/bash

if [ ! -f config.txt ]; then
 echo "Need a config.txt file"
 exit
fi

source ./config.txt

if [ ! -d HMM/$HMM  ]; then 
 echo "need a HMM defined in config.txt and this needs to be a folder in HMM/"
 echo "usually you checkout / download https://github.com/1KFG/Phylogenomics_HMMs/releases/latest and then "
 echo "symlink ln -s ../Phylogenomics_HMMs/HMM ./HMM"
 exit
fi

echo "make expected prefixes"
bash jobs/make_expected_file.sh
if [ ! -f prefix.tab ]; then
 echo "making prefix.tab"
 perl scripts/make_prefixes_readdata.pl pep > prefix.tab
else
 echo "prefix.tab already exists, not updating"
fi
echo "makeing list file for hmmsearch runs"
bash jobs/make_peplist.sh
