#PBS -l walltime=1:00:00 -j oe -o hmmbuild
module load hmmer/3
N=$PBS_ARRAYID

if [ ! $N ]; then
 N=$1
fi

if [ ! $N ]; then
 echo "need a cmdline or PBS_ARRAYID"
 exit
fi
FILE=`ls *.stk | sed -n ${N}p`
echo $FILE
b=`basename $FILE .stk`
if [ ! -f $b.hmm ]; then
 hmmbuild $b.hmm $FILE
fi
