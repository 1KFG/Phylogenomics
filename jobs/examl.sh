#PBS -l nodes=32:ppn=4,mem=16gb -q js -N raxml -j oe
module load ExaML

mpirun examl-AVX -s JGI1086.56sp_8Jul.binary -m GAMMA -n JGI1086.56sp_8Jul  -f d --auto-prot=aic -t StartingTree.tre
