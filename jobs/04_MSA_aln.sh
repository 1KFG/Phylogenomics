#PBS -l nodes=1:ppn=1 -N MSA -j oe -l walltime=3:00:00
module load muscle
module load BMGE
module load java
F=$PBS_ARRAYID
DIR=aln/JGI_1086
LIST=alnlist.JGI_1086 # this is the list file
N=$PBS_ARRAYID
if [ ! $N ]; then
  N=$1
fi

if [ ! $N ]; then
 echo "need to have a job id"
 exit;
fi

G=$(sed -n ${N}p $LIST)
base=$(basename $G .aa.fasta)
echo "marker is $base for gene $G $N from $LIST"

CPU=1
if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi

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
