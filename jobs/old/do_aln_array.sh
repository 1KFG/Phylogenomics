#PBS -l nodes=1:ppn=1 -N MSA -j oe
module load muscle
F=$PBS_ARRAYID
GENOMELIST=FILES
if [ ! -f $GENOMELIST ]; then
 ls *.fa > $GENOMELIST
fi

if [ ! $F ]; then
 F=$1
fi

if [ ! $F ]; then
 echo "no PBS_ARRAYID or input"
 exit
fi

if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi

FILE=`sed -n ${F}p $GENOMELIST`
if [ ! $FILE ]; then
 echo "No input file - check PBS_ARRAYID or input number, F=$F GENOMELIST=$GENOMELIST"
 exit
fi
base=`basename $FILE .rename`
if [ ! -f $base.fasaln ]; then
# t_coffee $FILE -n_core $CPU
 muscle -in $FILE -out $base.fasaln -quiet
fi
