#PBS -l nodes=1:ppn=60 -q js -N raxml -j oe
module load RAxML/8.1.20

CPU=2

if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi

raxmlHPC-PTHREADS-SSE3 -T $CPU -# 100 -x 121 -f a -p 123 -o Rall -m PROTCATAUTO -s all.Roz200.fasaln -n allseq_1KFG
