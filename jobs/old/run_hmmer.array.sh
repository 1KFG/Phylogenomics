#PBS -N hmmerpRozella -l nodes=1:ppn=2,walltime=96:00:00,mem=2gb -j oe -o hmmerpRozella.out 
#PBS -d /home_stajichlab/jstajich/bigdata/Rozella/OrthoMCL/sp
module load stajichlab
module load hmmer/3.0
BASE=rall
CPU=2

hmmscan-3.0 --cpu $CPU --tblout $BASE.$PBS_ARRAYID.tbl --domtblout $BASE.$PBS_ARRAYID.domtbl.tab /srv/projects/db/pfam/2011-12-09-Pfam26.0/Pfam-A.hmm $BASE.$PBS_ARRAYID.fa > $BASE.$PBS_ARRAYID.Pfam_26.hmmscan
