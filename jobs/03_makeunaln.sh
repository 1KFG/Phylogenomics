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

if [ -d cds ]; then
 perl scripts/construct_unaln_files_cdbfasta.pl -d $SEARCH/$MARKER -db cds -o $ALN/$MARKER -ext cds.fasta
fi 
