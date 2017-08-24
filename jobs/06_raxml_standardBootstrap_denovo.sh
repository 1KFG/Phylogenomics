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

count=`wc -l expected | awk '{print $1}'`
datestr=`date +%Y_%b_%d`
str=$datestr".denovo.JGI1086".${count}sp
IN=all_${count}.denovo.$HMM
if [ ! -f phylo/$str.fasaln ]; then
 cp $IN.fasaln phylo/$str.fasaln
 cp $IN.partitions.txt phylo/$str.partitions
 cp $IN.phy phylo/$str.phy
fi
cd phylo
#raxmlHPC-PTHREADS-AVX -T $CPU -f a -x 227 -p 771 -o $OUT -m PROTGAMMAAUTO -s $str.fasaln -n $PREFIX.$str -N autoMRE
raxmlHPC-PTHREADS-AVX -T $CPU -f a -x 227 -p 771 -o $OUT -m PROTGAMMALG -s $str.fasaln -n $PREFIX.$str -N autoMRE

