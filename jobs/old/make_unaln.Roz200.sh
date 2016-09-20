#PBS -N makeUaln.Roz200 -j oe -l walltime=8:00:00,mem=4gb
#which perl
module load perl
perl scripts/construct_unaln_files.pl -d search/Roz200 -db pep -o aln/Roz200
