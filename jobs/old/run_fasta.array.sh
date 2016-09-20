#PBS -N fastaMulticell -l nodes=1:ppn=2,walltime=36:00:00,mem=2gb -j oe -o fastaMulticell.out 
#PBS -d /bigdata/jstajich/Multicellular/split
module load fasta
PREF=multicell
fasta36 -m 8c -E 1e-3 -S -T 4 $PREF.$PBS_ARRAYID ../goodProteins.seg > $PREF.$PBS_ARRAYID.OrthoMCL_BLASTP.tab
