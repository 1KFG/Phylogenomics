#PBS -l nodes=6:ppn=16 -q js -N raxmlMPI -j oe
module load RAxML

CPU=2

if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi

count=`wc -l expected | awk '{print $1}'`
datestr=`date +%Y_%b_%d`
str=Zygo.$datestr".JGI1086".${count}sp
IN=all_${count}.JGI_1086
if [ ! -f $IN ]; then
 cp $IN.fasaln phylo/$str.fasaln
 cp $IN.partitions.txt phylo/$str.partitions
fi

cd phylo
mpirun -n $CPU raxmlHPC-MPI-SSE3 -# 100  -N autoMRE \
 -x 121 -f a -p 123 -o Rall -m PROTGAMMALG \
 -s $IN.fasaln -n $str
