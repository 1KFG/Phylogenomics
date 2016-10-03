#PBS -l nodes=1:ppn=32,mem=64gb -q highmem -N raxmlCDS -j oe
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
str=$PREFIX.$datestr".JGI1086".${count}sp.CDS
IN=all_${count}.JGI_1086
if [ ! -f phylo/$str.fasaln ]; then
 cp $IN.cds.fasaln phylo/$str.fasaln
 cp $IN.cds.partitions.txt phylo/$str.partitions
fi
cd phylo
PREFIX=Standard.$str
raxmlHPC-PTHREADS-AVX -T $CPU -f a -x 227 -p 771 -o $OUT -m GTRGAMMA \
  -s $str.fasaln -n $PREFIX -N autoMRE 
