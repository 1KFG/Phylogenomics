#PBS -l nodes=1:ppn=1,mem=1gb,walltime=0:30:00 -j oe -N parsRAXML
N=$PBS_ARRAYID
if [ ! $N ]; then
 N=$1
fi

if [ ! $N ]; then
 N=1
fi

l=`head -n $N parsimony_run.cmds`
`$l`
