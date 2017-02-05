#!/usr/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --job-name=raxmlRELL
#SBATCH --time=7-0:00:00
#SBATCH --mem-per-cpu=3G
#SBATCH --output=raxmlRELL.%A.out

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
count=`wc -l expected | awk '{print $1}'`
datestr=`date +%Y_%b_%d`
str=$PREFIX.$datestr.$HMM.${count}sp
IN=all_${count}.$HMM
FINALPREF=$str
mkdir -p phylo
if [ ! -f phylo/$str.fasaln ]; then
 cp $IN.fasaln phylo/$str.fasaln
 cp $IN.partitions.txt phylo/$str.partitions
fi

cd phylo
raxmlHPC-PTHREADS-AVX -T $CPU -f D -p 771 -o $OUT -m PROTGAMMALG \
  -s $str.fasaln -n ${FINALPREF}_RELL
