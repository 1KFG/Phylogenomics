#!/usr/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --mem-per-cpu=2G
#SBATCH --time=2-0:00:00
#SBATCH --job-name=raxmlCDS
#SBATCH --output=raxmlCDS.%A.log

module load RAxML

if [ ! -f expected ]; then
 bash jobs/make_expected_file.sh
fi
EXPECTEDNAMES=expected


if [ -f config.txt ]; then
 source config.txt
else
 echo "need config file to set these needed variables :  PREFIX, FINALPREF, OUT"
 exit
fi

if [ ! $HMM ]; then
 echo "need to a config file to set the HMM folder name"
fi

if [ ! $OUT ]; then
 echo "Need an 'OUT' variable set"
 exit
fi

if [ ! $PREFIX ]; then
 echo "need a PREFIX variable set"
 exit
fi

if [ ! $FINALPREF ]; then
 FINALPREF=$PREFIX
fi

CPU=${SLURM_CPUS_ON_NODE}
if [ ! $CPU ]; then
 CPU=4
fi

RUNFOLDER=phylo
mkdir -p $RUNFOLDER
count=`wc -l expected | awk '{print $1}'`
datestr=`date +%Y_%b_%d`
str=$PREFIX.$datestr.$HMM.${count}sp.CDS
IN=all_${count}.${HMM}.denovocds
if [ ! -f $RUNFOLDER/$str.fasaln ]; then
 cp $IN.fasaln $RUNFOLDER/$str.fasaln
 cp $IN.partitions.txt $RUNFOLDER/$str.partitions
fi
cd $RUNFOLDER
PREFIX=Standard.$str
raxmlHPC-PTHREADS-AVX -T $CPU -f a -x 227 -p 771 -o $OUT -m GTRGAMMA \
  -s $str.fasaln -n $PREFIX -N autoMRE 
