#PBS -l nodes=2:ppn=36 -N ExaML.BS -j oe -r n -l mem=64gb
module load ExaML
module load RAxML
# need starting tree 
BASE=aln.BS
N=$PBS_ARRAYID
if [ "$N" == "" ]; then
 N=$1
fi
if [ "$N" == "" ]; then
 echo "no array id or cmdline ID provided"
 exit
fi

if [ ! -f RAxML_info.${BASE}_ML ]; then
mpirun examl-OMP-AVX -s $BASE$N.binary -m GAMMA \
 -n ${BASE}${N}_ML -f d --auto-prot=aic -t RAxML_parsimonyTree.T${N}
fi
