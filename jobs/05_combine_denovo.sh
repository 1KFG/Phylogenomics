#!/usr/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=8G
#SBATCH --time=2:00:00
#SBATCH --job-name=combineThemAll


module load RAxML

if [ -f config.txt ]; then
 source config.txt
else
 echo "need config file to set HMM variable"
 exit
fi

if [ ! $HMM ]; then
 echo "need to a config file to set the HMM folder name"
fi

if [ ! -f expected ]; then
 bash jobs/make_expected_file.sh
fi
EXPECTEDNAMES=expected
MARKERS=$HMM
count=`wc -l $EXPECTEDNAMES | awk '{print $1}'`
#echo "count is $count"
perl scripts/combine_fasaln.pl -ext denovo.trim -o all_${count}.denovo.${MARKERS}.fasaln -of fasta -d aln/$MARKERS -expected $EXPECTEDNAMES > all_${count}.denovo.${MARKERS}.partitions.txt
convertFasta2Phylip.sh all_${count}.denovo.${MARKERS}.fasaln > all_${count}.denovo.${MARKERS}.phy

ctCDS=$(ls aln/$MARKERS/*.denovo_cdsaln.trim | wc -l | awk '{print $1}')
if [ $ctCDS -gt 0 ]; then
perl scripts/combine_fasaln.pl -mol 'DNA' -alpha 'dna' -o all_${count}.${MARKERS}.denovocds.fasaln -ext denovo_cdsaln.trim.clean -if fasta -of fasta -d aln/$MARKERS -expected $EXPECTEDNAMES > all_${count}.${MARKERS}.denovocds.partitions.txt
convertFasta2Phylip.sh all_${count}.${MARKERS}.denovocds.fasaln > all_${count}.${MARKERS}.denovocds.phy
fi
