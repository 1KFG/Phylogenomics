#PBS -l nodes=1:ppn=64 -q js -N raxml -j oe
module load RAxML

CPU=2

if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi

raxmlHPC-PTHREADS-AVX -T $CPU -# 100  -N autoMRE -x 121 -f a -p 123 -o Rall -m PROTGAMMALG \
  -s Zygo_RD2.JGI1086.15Jul.noEgam.trim -n Zygo_RD2.JGI1086.15Jul
