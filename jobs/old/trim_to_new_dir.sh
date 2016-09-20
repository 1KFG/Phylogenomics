#PBS -l walltime=1:00:00 -j oe -o trimal
module load trimal
N=$PBS_ARRAYID

if [ ! $N ]; then
 N=$1
fi

if [ ! $N ]; then
 echo "need a cmdline or PBS_ARRAYID"
 exit
fi
FILE=`ls ../*.fasaln | sed -n ${N}p`
echo $FILE
b=`basename $FILE .fa.fasaln`
trimal -in $FILE -out $b.trim -automated1
