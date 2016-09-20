#PBS -l nodes=1:ppn=64 -q js -N raxml -j oe
module load RAxML

CPU=2

if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi

raxmlHPC-PTHREADS-SSE3 -T $CPU -# 100 -x 121 -f a -p 123 -o Pult -m PROTGAMMAAUTO -s all.JGI_1086.351.fasaln -n allseq_JGI_1086.351.1KFG
