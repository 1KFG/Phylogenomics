#PBS -l nodes=1:ppn=1,mem=4gb -j oe -N raxmlParsStart
module load RAxML
n=$PBS_ARRAYID
if [ "$n" == "" ]; then
 n=$1
fi

if [ "$n" == "" ]; then
 echo "no job ID provided"
 exit
fi

BASE=aln.BS
randnum=`perl -e 'print int(rand(1000000000)),"\n"'`
echo "$randnum $n"
raxmlHPC-AVX -y -s ${BASE}$n -m PROTGAMMALG -n T${n} -p $randnum

