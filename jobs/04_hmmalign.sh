#PBS -l nodes=1:ppn=1 -j oe -N hmmalign.1086 -l walltime=3:00:00
module load trimal
module load hmmer/3
module load java
module load BMGE
MARKER=JGI_1086
DBDIR=HMM/$MARKER/HMM3
DIR=aln/$MARKER
LIST=alnlist.$MARKER # this is the list file
if [ ! -f $LIST ]; then
 pushd aln/$MARKER
 ls *.aa.fasta > ../../$LIST
 popd
fi
N=$PBS_ARRAYID
if [ ! $N ]; then
  N=$1
fi

if [ ! $N ]; then
 echo "need to have a job id"
 exit;
fi

G=`sed -n ${N}p $LIST`
marker=`basename $G .aa.fasta`
echo "marker is $marker for gene $G $N from $LIST"

if [ ! -f $DIR/$marker.msa ]; then
 hmmalign --trim --amino $DBDIR/$marker.hmm $DIR/$marker.aa.fasta | perl -p -e 's/^>(\d+)\|/>/' > $DIR/$marker.msa
fi

if [ ! -f $DIR/$marker.aln ]; then
 esl-reformat --replace=\*:-  --gapsym=- clustal $DIR/$marker.msa > $DIR/$marker.1.aln
 esl-reformat --replace=x:- clustal $DIR/$marker.1.aln > $DIR/$marker.aln
fi

if [ ! -f $DIR/$marker.msa.trim ]; then
 trimal -resoverlap 0.50 -seqoverlap 60 -in $DIR/$marker.aln -out $DIR/$marker.msa.filter
 trimal -automated1 -fasta -in $DIR/$marker.msa.filter -out $DIR/$marker.msa.trim 
fi

if [ -f $DIR/$marker.cds.fasta ]; then
 if [ ! -f $DIR/$marker.cdsaln.trim ]; then
  bp_mrtrans.pl -if clustalw -of fasta -i $DIR/$marker.aln -s $DIR/$marker.cds.fasta -o $DIR/$marker.cdsaln
  java -jar $BMGE -t CODON -i $DIR/$marker.cdsaln -of $DIR/$marker.cdsaln.trim
 fi
fi
