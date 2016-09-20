#PBS -l nodes=1:ppn=2 -N JGItrim.HMMsearch -j oe -l walltime=2:00:00
module load hmmer/3
N=$PBS_ARRAYID
PEPDIR=pep
MARKERS=HMM/JGI_1086_trim/markers_3.hmmb
CUTOFF=1e-8
OUT=search/JGI_1086_trim
LIST=list # this is the list file
if [ ! $N ]; then
  N=$1
fi

if [ ! $N ]; then
 echo "need to have a job id"
 exit;
fi

CPU=$PBS_NP
if [ ! $CPU ]; then
 CPU=1
fi

mkdir -p $OUT
G=`sed -n ${N}p $LIST`
NM=`basename $G .aa.fasta`
echo "g=$G"

if [ ! -f "$OUT/$NM.domtbl" ]; then
 hmmsearch --cpu $CPU -E $CUTOFF --domtblout $OUT/$NM.domtbl $MARKERS $PEPDIR/$G >& $OUT/$NM.log
fi
