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
FILE=`ls *.trim | sed -n ${N}p`
echo $FILE
b=`basename $FILE .fa.fasaln`
if [ ! -f $b.stk ]; then
 esl-reformat stockholm $FILE > $b.stk
fi

if [ ! -f $b.hmm ]; then
 hmmbuild $b.hmm $b.stk
fi
