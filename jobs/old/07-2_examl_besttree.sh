#PBS -l nodes=2:ppn=16,mem=64gb -N ExaML.Best -j oe
module load ExaML
module load RAxML
# need starting tree 

N=$PBS_ARRAYID
if [ "$N" == "" ]; then
 N=$1
fi
if [ "$N" == "" ]; then
 echo "no array id or cmdline ID provided"
 exit
fi

PARTITION=partitions_all.txt
BASE=aln
if [ ! -f ${BASE}_Best.binary ]; then
 convertFasta2Phylip.sh $BASE > $BASE.phy
 parse-examl -s $BASE.phy -m PROT -n ${BASE}_Best -q $PARTITION
fi


mpirun examl-OMP-AVX -s ${BASE}_Best.binary -m GAMMA \
 -n all_Phylo.T$N -f d --auto-prot=aic -t RAxML_parsimonyTree.T$N

