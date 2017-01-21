#!/usr/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=hmmalign
#SBATCH --time=3:00:00
#SBATCH --mem-per-cpu=2G
#SBATCH --output=MSA.%A_%a.out
#SBATCH -p batch

module load trimal
module load muscle
module load BMGE
module load java
N=$SLURM_ARRAY_TASK_ID
if [ ! $N ]; then
  N=$1
fi

if [ ! $N ]; then
 echo "need to have a job id"
 exit;
fi

if [ -f config.txt ]; then
 source config.txt
else
 echo "need config file to set HMM variable"
 exit
fi

if [ ! $HMM ]; then
 echo "need to a config file to set the HMM folder name"
fi

DIR=aln/$HMM
LIST=alnlist.$HMM # this is the list file
N=$PBS_ARRAYID
if [ ! $N ]; then
  N=$1
fi

if [ ! $N ]; then
 echo "need to have a job id"
 exit;
fi

G=$(sed -n ${N}p $LIST)

if [ ! -f $DIR/$base.denovo.aln ]; then
 muscle -in $DIR/$G -out $DIR/$base.denovo.aln -quiet
fi

if [ ! -f $DIR/$base.denovo.trim ]; then
 trimal -resoverlap 0.50 -seqoverlap 60 -in $DIR/$base.denovo.aln -out $DIR/$base.denovo.filter
 trimal -automated1 -fasta -in $DIR/$base.denovo.filter -out $DIR/$base.denovo.trim
fi

if [ -f $DIR/$base.cds.fasta ]; then
 if [ ! -f $DIR/$base.denovo_cdsaln.trim ]; then
  bp_mrtrans.pl -if fasta -of fasta -i $DIR/$base.denovo.aln -s $DIR/$base.cds.fasta -o $DIR/$base.denovo.cdsaln
  java -jar $BMGE -t CODON -i $DIR/$base.denovo.cdsaln -of $DIR/$base.denovo_cdsaln.trim 
 fi
fi
