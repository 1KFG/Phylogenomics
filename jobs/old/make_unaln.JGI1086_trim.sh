#PBS -N makeUaln.JGI_1086_trim -j oe -l walltime=8:00:00,mem=8gb
#which perl
# DUDUE DON"T RUN THIS AS ARRAY JOBS!!
module load perl
perl scripts/construct_unaln_files.pl -d search/JGI_1086_trim -db pep -o aln/JGI_1086_trim
