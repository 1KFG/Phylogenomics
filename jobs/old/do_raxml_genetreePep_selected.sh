#PBS -l nodes=1:ppn=16,walltime=168:00:00,mem=16gb -N raxmlRoz200 -j oe
module load RAxML/8.1.20
CPU=2
F=$PBS_ARRAYID
if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi
OUTDIR=phylo_genetree/Roz200
ALNDIR=aln/Roz200
GENOMELIST=$OUTDIR/aln_stats.tab
if [ ! -f $GENOMELIST ]; then
 echo "need target list already selected"
 exit;
fi

if [ ! $F ]; then
 F=$1
fi

if [ ! $F ]; then
 echo "no PBS_ARRAYID or input"
 exit
fi

FILE=`head -n $F $GENOMELIST | tail -n 1 | awk '{print $1}'`
if [ ! $FILE ]; then
 echo "No input file - check PBS_ARRAYID or input number, F=$F GENOMELIST=$GENOMELIST"
 exit
fi
base=$FILE
PHY=$ALNDIR/$base.msa.trim

cd $OUTDIR
echo $base
if [ ! -f  RAxML_info.$base"_ML_PROTGAMMA" ]; then
 raxmlHPC-PTHREADS-SSE3 -T $CPU -o Tgon -# 100 -x 121 -f a -p 123 -m PROTGAMMAAUTO -s ../../$PHY -n $base"_ML_PROTGAMMAAUTO"
fi
