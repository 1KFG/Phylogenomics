#PBS -l nodes=1:ppn=1 -j oe -N hmmalign

module load hmmer/3.1b1


LIST=list # this is the list file
if [ ! $N ]; then
  N=$1
fi

if [ ! $N ]; then
 echo "need to have a job id"
 exit;
fi

G=`head -n $N $LIST | tail -n 1`
NM=`basename $G .fa`


hmmalign --trim --amino $DBDIR/markers/$CLADE/HMM3/$marker.hmm $base_name.$marker.fasta > $base_name.$marker.msa
