#!/usr/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=makeUnaln.JGI_1086
#SBATCH --time=8:00:00
#SBATCH --mem-per=cpu=4G

# DO NOT RUN WITH ARRAYJOBS
module load cdbfasta
module load hmmer
if [ -f config.txt ]; then
 source config.txt
else
 echo "need config file to set HMM variable"
 exit
fi

if [ ! $HMM ]; then
 echo "need to a config file to set the HMM folder name"
fi

MARKER=$HMM
ALN=aln
SEARCH=search
mkdir -p $ALN/$MARKER
perl scripts/construct_unaln_files_cdbfasta.pl -d $SEARCH/$MARKER -db pep -o $ALN/$MARKER -ext aa.fasta

LIST=alnlist.$MARKER # this is the list file
if [ ! -f $LIST ]; then
 pushd aln/$MARKER
 ls *.aa.fasta > ../../$LIST
 popd
fi

if [ -d cds ]; then
 perl scripts/construct_unaln_files_cdbfasta.pl -d $SEARCH/$MARKER -db cds -o $ALN/$MARKER -ext cds.fasta
fi 
