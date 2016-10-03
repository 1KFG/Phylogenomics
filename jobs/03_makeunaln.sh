#PBS -N makeUaln.JGI_1086 -j oe -l walltime=8:00:00,mem=4gb
# DO NOT RUN WITH ARRAYJOBS
module load perl
module load cdbfasta
module load hmmer
MARKER=JGI_1086
ALN=aln
SEARCH=search
mkdir -p $ALN/$MARKER
perl scripts/construct_unaln_files_cdbfasta.pl -d $SEARCH/$MARKER -db pep -o $ALN/$MARKER -ext aa.fasta

LIST=alnlist.$MARKER # this is the list file
if [ ! -f $LIST ]; then
 pushd aln/$MARKER
 ls *.aa.fasta > ../../$LIST
 popd
fi

if [ -d cds ]; then
 perl scripts/construct_unaln_files_cdbfasta.pl -d $SEARCH/$MARKER -db cds -o $ALN/$MARKER -ext cds.fasta
fi 
