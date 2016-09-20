#PBS -l nodes=1:ppn=32 -q batch -N raxmlRELL -j oe
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
str=$PREFIX.$datestr".JGI1086".${count}sp
IN=all_${count}.JGI_1086
if [ ! -f phylo/$str.fasaln ]; then
 cp $IN.fasaln phylo/$str.fasaln
 cp $IN.partitions.txt phylo/$str.partitions
fi

cd phylo
raxmlHPC-PTHREADS-AVX -T $CPU -f D -p 771 -o $OUT -m PROTGAMMALG \
  -s $str.fasaln -n ${FINALPREF}_RELL.$str 
