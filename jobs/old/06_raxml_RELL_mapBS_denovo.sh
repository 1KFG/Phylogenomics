#!/usr/bin/bash
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --time=1:00:00
module load RAxML

CPU=1
if [ -f config.txt ]; then
 source config.txt
else
 PREFIX=ALL
 FINALPREF=1KFG
 OUT=Pult
fi
count=`wc -l expected | awk '{print $1}'`
datestr=`date +%Y_%b_%d`
str=${PREFIX}.${datestr}.denovo.${HMM}.${count}sp
IN=all_${count}.denovo.${HMM}
FINALPREF=${str}_RELL

cd phylo
raxmlHPC-AVX -f b -m PROTGAMMALG -t RAxML_bestTree.${FINALPREF} \
 -z RAxML_rellBootstrap.${FINALPREF} -n ${FINALPREF}_BS
