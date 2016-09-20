#PBS -l nodes=1:ppn=1 -N raxmlRELL.BS -j oe
module load RAxML

CPU=1

count=`wc -l expected | awk '{print $1}'`
datestr=`date +%Y_%b_%d`
# need to change prefix at some point based on a config file
str=Zygo.$datestr".JGI1086".${count}sp
IN=all_${count}.JGI_1086
PREFIX=Zygo_RD2_RELL
cd phylo
raxmlHPC-AVX -f b -m PROTGAMMALG -t RAxML_bestTree.$PREFIX.$str \
 -z RAxML_rellBootstrap.$PREFIX.$str -n $PREFIX.${str}_BS