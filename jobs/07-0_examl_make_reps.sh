#PBS -l nodes=1:ppn=1 -N examl.make_reps -j oe
module load RAxML
module load ExaML
RANDOM=$$
echo $RANDOM
count=`wc -l expected | awk '{print $1}'`
# this needs to be from a config file!
#if [ ! -f phylo.config ]; then
# need to change prefix at some point based on a config file
str=JGI1086.${count}sp
IN=all_${count}.JGI_1086
PREFIX=1KFG
DIR=phylo/ExaML_$str
PARTFILE=partitions.all.txt
mkdir -p $DIR
if [ ! -f $DIR/aln ]; then
 cp $IN.fasaln $DIR/aln
fi


BASE=aln.BS
if [ ! -f $DIR/${BASE}0 ]; then
 cd $DIR
 raxmlHPC-AVX -# 100 -b $RANDOM -f j -m PROTGAMMALG -s aln -n REPS
 cd ..
fi

qsub -d$DIR jobs/07-1_examl_make_parsStartTree.sh -t 0-99

len=`head -n1 $DIR/aln.BS0 | awk '{print $2}'`
echo "AUTO,p1=1-$len" > $DIR/$PARTFILE

qsub -d $DIR -t 0-99 jobs/07-1_parse-examl.sh
 parse-examl -s ${BASE}$n -m PROT -n BS${n} -q  $PARTFILE
