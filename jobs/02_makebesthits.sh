#!/usr/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=besthit
#SBATCH --time=0:30:00

DIR=search/JGI_1086
EXT=domtbl

for file in $DIR/*.$EXT
do
 stem=`basename $file .domtbl`
 if [ ! -f $DIR/$stem.best ]; then
  perl scripts/get_best_hmmtbl.pl -c 1e-20 $file > $DIR/$stem.best
 fi
done
