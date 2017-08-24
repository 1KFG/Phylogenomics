#!/usr/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --job-name=geneTreeraxmlAVX
#SBATCH --time=7-0:00:00
#SBATCH --mem-per-cpu=3G
#SBATCH --output=genetree.%A_%a.out

module load RAxML

CPU=2

RUNFOLDER=phylo
if [ $SLURM_CPUS_ON_NODE ]; then
 CPU=$SLURM_CPUS_ON_NODE
fi

if [ -f config.txt ]; then
 source config.txt
else
 PREFIX=ALL
 FINALPREF=1KFG
 OUT=Pult
 EXTRARAXML=
fi
OUTDIR=$GENETREES
if [ ! $OUTDIR ]; then
 OUTDIR=gene_trees
fi
type=denovo
raxml=raxmlHPC-PTHREADS-AVX
ALNDIR=aln/$HMM
GENOMELIST=aln_stats.tab
if [ ! -f $GENOMELIST ]; then
 echo "need target list already selected"
 perl scripts/make_completeness_matrix.pl expected aln/$HMM aln/$HMM
 exit;
fi
F=$SLURM_ARRAY_TASK_ID
if [ ! $F ]; then
 F=$1
fi

if [ ! $F ]; then
 echo "no SLURM ARRAY or input"
 exit
fi
F=$(expr $F + 1)
FILE=$(sed -n ${F}p $GENOMELIST | awk '{print $1}')
if [ ! $FILE ]; then
 echo "No input file - check PBS_ARRAYID or input number, F=$F GENOMELIST=$GENOMELIST"
 exit
fi
base=$FILE
PHY=$ALNDIR/${base}.$type.trim
OUTPHY=${base}.phy
perl -p -e 's/>([^\|]+)\|/>$1 /' $PHY > $OUTDIR/$OUTPHY
cd $OUTDIR
echo $base
if [ ! -f  RAxML_info.${base}_ML_PROTGAMMA ]; then
 #$raxml -T $CPU -o $OUTGROUP -N autoMRE -x 221 -f a -p 31 -m PROTGAMMAAUTO -s $OUTPHY -n ${base}"_ML_PROTGAMMA"
 $raxml -T $CPU -f D -p 771 -m PROTGAMMAAUTO -s $OUTPHY -n ${base}_ML_PROTGAMMA_RELL
fi
