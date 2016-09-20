#PBS -N ssearch -l nodes=1:ppn=4,walltime=6:00:00 -j oe -o ssearch.out 
module load fasta
ODIR=ssearch-out
CPU=$PBS_NUM_PPN
LISTFILE=seglist
DBSIZE=3000000
INDIR=seg
mkdir -p $ODIR
RUN=$PBS_ARRAYID

if [ ! $CPU ]; then
 CPU=4
fi
if [ ! $RUN ]; then
 RUN=$1
fi

if [ ! $RUN ]; then
 echo "need a PBS_ARRAYID or cmdline number"
 exit
fi
length=`wc -l $LISTFILE | awk '{print $1}'`
query=`expr $RUN / $length`
subject=`expr $RUN - $query \* $length`
query=`expr $query + 1`
subject=`expr $subject + 1`
#echo "query is $query"
#echo "subject is $subject"

#echo "$query for $RUN subject $subject"
qfile=`head -n $query $LISTFILE | tail -n 1`
sfile=`head -n $subject $LISTFILE | tail -n 1`
qname=`basename $qfile .seg`
sname=`basename $sfile .seg`

outname="$ODIR/$qname-$sname.SSEARCH.tab"
echo "outname is $outname"
if [ -f $outname -o -f $outname.gz ]; then
 echo "$outname already processed, skipping"
else 
# hostname
time ssearch36 -m 8c -E 1e-5 -z 21 -Z $DBSIZE -S -T $CPU $INDIR/$qfile $INDIR/$sfile > $outname
fi
