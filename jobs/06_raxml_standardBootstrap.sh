#!/usr/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --job-name=raxmlAVX
#SBATCH --time=7-0:00:00
#SBATCH --mem-per-cpu=3G
#SBATCH --output=raxmlAVX.%A_%a.out

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

mkdir -p $RUNFOLDER
count=`wc -l expected | awk '{print $1}'`
datestr=`date +%Y_%b_%d`
str=$PREFIX.$datestr.$HMM.${count}sp
IN=all_${count}.$HMM
if [ ! -f phylo/$str.fasaln ]; then
 cp $IN.fasaln $RUNFOLDER/$str.fasaln
 cp $IN.partitions.txt $RUNFOLDER/$str.partitions
fi
cd phylo
PREFIX=Standard.$str
raxmlHPC-PTHREADS-AVX -T $CPU -f a -x 227 -p 771 -o $OUT -m PROTGAMMAAUTO \
  -s $str.fasaln -n $PREFIX -N autoMRE $EXTRARAXML
