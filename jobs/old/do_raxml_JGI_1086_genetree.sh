#PBS -l nodes=1:ppn=8 -q js -N raxml -j oe
module load RAxML

CPU=2

if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi

F=$PBS_ARRAYID
GENOMELIST=FILES
DIR=aln

if [ ! $F ]; then
 F=$1
fi

if [ ! $F ]; then
 echo "no PBS_ARRAYID or input"
 exit
fi

echo $GENOMELIST
file=`sed -n ${F}p $GENOMELIST`
base=`basename $file .trim`
if [ ! -f "RAxML_info.$base" ]; then  
    echo "$base $DIR/$file"
    outgrp=Pult
    n=`grep -c ">$outgrp" $DIR/$file`
    if [ $n == 0 ];  then
	outgrp=Atha
	n=`grep -c ">$outgrp" $DIR/$file`
	if [ $n == 0 ]; then
	    outgrp=Dmel
	    n=`grep -c ">$outgrp" $DIR/$file`
	    if [ $n == 0 ]; then
		outgrp=Ttra
		n=`grep -c ">$outgrp" $DIR/$file`
		if [ $n == 0 ]; then
		    outgrp=Rall
		    n=`grep -c ">$outgrp" $DIR/$file`
		    if [ $n == 0 ]; then
			outgrp=Spun
			n=`grep -c ">$outgrp" $DIR/$file`
			if [ $n == 0 ]; then
			    outgrp=Amac
			fi
		    fi
		fi
	    fi
	fi
    fi  
    raxmlHPC-PTHREADS-SSE3 -T $CPU -# 100 -x 121 -f a -p 123 -o $outgrp -m PROTGAMMAAUTO -s $DIR/$file -n $base
fi


