#!/usr/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --job-name=IQTREE_Denvo
#SBATCH --time=7-0:00:00
#SBATCH --mem 64G
#SBATCH --output=iqtree_denovo.%A.out

module load IQ-TREE

CPU=2

RUNFOLDER=phylo
if [ $SLURM_CPUS_ON_NODE ]; then
 CPU=$SLURM_CPUS_ON_NODE
fi

 EXTRAIQTREE="-nt AUTO -m TESTMERGE -bb 1000"

if [ -f config.txt ]; then
 source config.txt
else
 HMM=JGI_1086
 PREFIX=ALL
 FINALPREF=1KFG
 OUT=Pult
fi

count=`wc -l expected | awk '{print $1}'`
datestr=`date +%Y_%b_%d`
str=$datestr.denovo.$HMM.${count}sp
IN=all_${count}.denovo.$HMM
if [ ! -f phylo/$str.fasaln ]; then
 cp $IN.fasaln phylo/$str.fasaln
 cp $IN.partitions.txt phylo/$str.partitions
 cp $IN.phy phylo/$str.phy
fi
cd phylo

iqtree-omp -s $str.fasaln -spp $str.partitions $EXTRAIQTREE 
