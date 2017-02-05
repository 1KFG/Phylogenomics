#PBS -l nodes=1:ppn=1 -N raxmlRELL.BS -j oe
module load RAxML

CPU=1
if [ -f config.txt ]; then
 source config.txt
else
 PREFIX=ALL
 FINALPREF=1KFG
 OUT=Pult
fi
count=`wc -l expected | awk '{print $1}'`
datestr=`date +%Y_%b_%d`
str=${PREFIX}.${datestr}.${HMM}.${count}sp
IN=all_${count}.${HMM}
FINALPREF=$str

cd phylo
raxmlHPC-AVX -f b -m PROTGAMMALG -t RAxML_bestTree.RELL.${FINALPREF} \
 -z RAxML_rellBootstrap.RELL.${FINALPREF} -n ${FINALPREF}_RELL_BS
