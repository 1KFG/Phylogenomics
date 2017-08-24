#!/usr/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --job-name=IQTREE
#SBATCH --time=7-0:00:00
#SBATCH --mem 64G
#SBATCH --output=iqtree.%A.out

module load IQ-TREE

CPU=2

RUNFOLDER=phylo
if [ $SLURM_CPUS_ON_NODE ]; then
 CPU=$SLURM_CPUS_ON_NODE
fi

if [ -f config.txt ]; then
 source config.txt
else
 HMM=JGI_1086
 PREFIX=ALL
 FINALPREF=1KFG
 OUT=Pult
 EXTRAIQTREE="-nt AUTO -m TESTMERGE -bb 1000"
fi

count=`wc -l expected | awk '{print $1}'`
datestr=`date +%Y_%b_%d`
str=$datestr.$HMM.${count}sp
IN=all_${count}.$HMM
if [ ! -f phylo/$str.fasaln ]; then
 cp $IN.fasaln phylo/$str.fasaln
 cp $IN.partitions.txt phylo/$str.partitions
 cp $IN.phy phylo/$str.phy
fi
cd phylo

iqtree-omp -s $str.fasaln -spp $str.partitions $EXTRAIQTREE 
