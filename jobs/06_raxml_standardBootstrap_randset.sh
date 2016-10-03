#PBS -l nodes=1:ppn=32,mem=64gb -q highmem -N raxmlAVX -j oe
module load RAxML

CPU=2
RND=50
if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi
if [ -f config.txt ]; then
 source config.txt
else
 PREFIX=ALL
 FINALPREF=1KFG
 OUT=Pult
 EXTRARAXML=
fi

count=`wc -l expected | awk '{print $1}'`
datestr=`date +%Y_%b_%d`
str=$PREFIX.$datestr".rand$RND.JGI1086".${count}sp
IN=all_${count}.rand$RND.JGI_1086
if [ ! -f phylo/$str.fasaln ]; then
 cp $IN.fasaln phylo/$str.fasaln
 cp $IN.partitions.txt phylo/$str.partitions
fi
cd phylo
PREFIX=Standard.$str
raxmlHPC-PTHREADS-AVX -T $CPU -f a -x 227 -p 771 -o $OUT -m PROTGAMMALG \
  -s $str.fasaln -n $PREFIX -N autoMRE $EXTRARAXML
