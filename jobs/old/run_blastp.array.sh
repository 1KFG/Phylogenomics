#PBS -N blastp -l nodes=1:ppn=8,walltime=6:00:00 -j oe 
module load ncbi-blast/2.2.30+
ODIR=pairwise
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

outname="$ODIR/$qname-$sname.BLASTP.tab"
echo "outname is $outname"
if [ -f $outname -o -f $outname.gz ]; then
 echo "$outname already processed, skipping"
else 
# hostname
time blastp -query $INDIR/$qfile -db $INDIR/$sfile -out $outname -use_sw_tback -num_threads $CPU -evalue 1e-8 -outfmt 6 -dbsize  $DBSIZE -lcase_masking
fi
