#PBS -l nodes=1:ppn=1,mem=1gb,walltime=0:30:00 -j oe -n parseExaml
module load ExaML
BASE=aln.BS
PARTFILE=partitions.all.txt
n=$PBS_ARRAYID
if [ "$n" == "" ]; then
 n=$1
fi

if [ "$n" == "" ]; then
 echo "no job ID provided"
 exit
fi
parse-examl -s ${BASE}$n -m PROT -n BS${n} -q $PARTFILE
