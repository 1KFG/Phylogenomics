#PBS -l nodes=1:ppn=32,mem=64gb -q highmem -N raxmlAVX.denovo -j oe
module load RAxML

CPU=2

if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi
if [ -f config.txt ]; then
 source config.txt
else
 PREFIX=ALL
 FINALPREF=1KFG
 OUT=Pult
fi
count=`wc -l expected | awk '{print $1}'`
datestr=`date +%Y_%b_%d`
str=$datestr".denovo.JGI1086".${count}sp
IN=all_${count}.denovo.JGI_1086
if [ ! -f phylo/$str.fasaln ]; then
 cp $IN.fasaln phylo/$str.fasaln
 cp $IN.partitions.txt phylo/$str.partitions
 cp $IN.phy phylo/$str.phy
fi
cd phylo

#raxmlHPC-PTHREADS-AVX -T $CPU -f a -x 227 -p 771 -o $OUT -m PROTGAMMAAUTO \
#  -s $str.fasaln -n $PREFIX -N autoMRE 
raxmlHPC-PTHREADS-AVX -T $CPU -f a -x 227 -p 771 -o $OUT -m PROTGAMMAAUTO -s $str.fasaln -n $PREFIX -N autoMRE
