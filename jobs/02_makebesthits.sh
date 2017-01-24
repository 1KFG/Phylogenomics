#!/usr/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=besthit
#SBATCH --time=0:30:00
#SBATCH --output=makebest.%A.out

DIR=search/JGI_1086
EXT=domtbl

if [ -f config.txt ]; then
 source config.txt
else
 echo "need config file to set HMM variable"
 exit
fi

for file in $DIR/*.$EXT
do
 stem=`basename $file .domtbl`
 if [ ! -f $DIR/$stem.best ]; then
  perl scripts/get_best_hmmtbl.pl -c $CUTOFF $file > $DIR/$stem.best
 fi
done
