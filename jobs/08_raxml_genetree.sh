#PBS -l nodes=1:ppn=8,walltime=64:00:00,mem=16gb -N raxmlGeneTree -j oe
module load RAxML
raxml=raxmlHPC-PTHREADS-AVX
OUTGROUP=Rall
CPU=2
F=$PBS_ARRAYID
if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi
OUTDIR=gene_trees
ALNDIR=aln/JGI_1086
GENOMELIST=aln_stats.tab
if [ ! -f $GENOMELIST ]; then
 echo "need target list already selected"
 perl scripts/make_completeness_matrix.pl expected aln/JGI_1086 aln/JGI_1086
 exit;
fi

if [ ! $F ]; then
 F=$1
fi

if [ ! $F ]; then
 echo "no PBS_ARRAYID or input"
 exit
fi
F=$(expr $F + 1)
FILE=$(sed -n ${F}p $GENOMELIST | awk '{print $1}')
if [ ! $FILE ]; then
 echo "No input file - check PBS_ARRAYID or input number, F=$F GENOMELIST=$GENOMELIST"
 exit
fi
base=$FILE
PHY=$ALNDIR/${base}.msa.trim
OUTPHY=${base}.phy
perl -p -e 's/>([^\|]+)\|/>$1 /' $PHY > $OUTDIR/$OUTPHY
cd $OUTDIR
echo $base
if [ ! -f  RAxML_info.$base"_ML_PROTGAMMA" ]; then
 $raxml -T $CPU -o $OUTGROUP -N autoMRE -x 221 -f a -p 31 -m PROTGAMMAAUTO -s $OUTPHY -n ${base}"_ML_PROTGAMMA"
fi
