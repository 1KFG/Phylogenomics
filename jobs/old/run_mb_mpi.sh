#PBS -l nodes=1:ppn=16 -q js -j oe -N fungi_269
module load mrbayes/3.2.2-r512-mpi-64

mpirun --hostfile $PBS_NODEFILE -np $PBS_NP mb fungi_269.nex >& fungi_269.mb.out
