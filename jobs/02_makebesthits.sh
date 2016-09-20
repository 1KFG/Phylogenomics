#PBS -l nodes=1:ppn=1 -j oe -N besthit.JGI

DIR=search/JGI_1086
EXT=domtbl

for file in $DIR/*.$EXT
do
 stem=`basename $file .domtbl`
 if [ ! -f $DIR/$stem.best ]; then
  perl scripts/get_best_hmmtbl.pl -c 1e-20 $file > $DIR/$stem.best
 fi
done
