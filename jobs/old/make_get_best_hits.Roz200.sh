#PBS -l nodes=1:ppn=1 -j oe -N make_best_hit_aln

DIR=search/Roz200
EXT=domtbl

for file in $DIR/*.$EXT
do
 stem=`basename $file .domtbl`
 if [ ! -f $DIR/$stem.best ]; then
  perl scripts/get_best_hmmtbl.pl $file > $DIR/$stem.best
 fi
done
