#!/usr/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=8G
#SBATCH --time=2:00:00
#SBATCH --job-name=combineThemAll

module load RAxML

if [ ! -f expected ]; then
 bash jobs/make_expected_file.sh
fi
EXPECTEDNAMES=expected

if [ -f config.txt ]; then
 source config.txt
else
 echo "need config file to set HMM variable"
 exit
fi

if [ ! $HMM ]; then
 echo "need to a config file to set the HMM folder name"
fi

MARKERS=$HMM
ALN=aln
RANDCT=50
count=$(wc -l $EXPECTEDNAMES | awk '{print $1}')
#echo "count is $count"

perl scripts/combine_fasaln.pl --rand $RANDCT -v --seed 121 -o all_${count}.rand${RANDCT}.${MARKERS}.fasaln -of fasta -d $ALN/$MARKERS -expected $EXPECTEDNAMES > all_${count}.rand${RANDCT}.${MARKERS}.partitions.txt
convertFasta2Phylip.sh all_${count}.rand${RANDCT}.${MARKERS}.fasaln > all_${count}.rand${RANDCT}.${MARKERS}.phy

ctCDS=$(ls $ALN/$MARKERS/*.cdsaln.trim | wc -l | awk '{print $1}')
if [ $ctCDS -gt 0 ]; then
perl scripts/combine_fasaln.pl -rand $RANDCT -seed 121 -o all_${count}.rand${RANDCT}.${MARKERS}.cds.fasaln -ext cdsaln.trim -if fasta -of fasta -d $ALN/$MARKERS -expected $EXPECTEDNAMES > all_${count}.rand${RANDCT}.${MARKERS}.cds.partitions.txt
convertFasta2Phylip.sh all_${count}.rand${RANDCT}.${MARKERS}.cds.fasaln > all_${count}.${RANDCT}.${MARKERS}.cds.phy
fi
