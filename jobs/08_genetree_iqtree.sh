#!/usr/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --job-name=geneTreeraxmlAVX
#SBATCH --time=4:00:00
#SBATCH --mem-per-cpu=3G
#SBATCH --output=iq-genetree.%A_%a.out

module load IQ-TREE

CPU=2

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
if [ ! -d $OUTDIR ]; then
 mkdir -p $OUTDIR
fi

type=denovo
raxml=raxmlHPC-PTHREADS-AVX
ALNDIR=aln/$HMM
GENOMELIST=aln_stats.tab
if [ ! -f $GENOMELIST ]; then
 echo "need target list already selected"
 # last 1 is to indicate this is a denovo processing rather than hmmalign processed
 perl scripts/make_completeness_matrix.pl expected aln/$HMM aln/$HMM 1
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
perl -p -e 's/>([^\|]+)\|(\S+)/>$1/' $PHY > $OUTDIR/$OUTPHY
cd $OUTDIR
echo $base
if [ ! -f  ${base}.treefile ]; then
 iqtree-omp -s $OUTPHY -nt AUTO -bb 1000 -alrt 1000
fi
