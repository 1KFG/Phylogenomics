#PBS -l nodes=1:ppn=1 -j oe -N besthit.JGI-trim

DIR=search/JGI_1086_trim
EXT=domtbl

for file in $DIR/*.$EXT
do
 stem=`basename $file .domtbl`
 if [ ! -f $DIR/$stem.best ]; then
  perl scripts/get_best_hmmtbl.pl $file > $DIR/$stem.best
 fi
done
