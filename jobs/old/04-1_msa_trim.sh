module load trimal
for file in *.fasaln
do
 trimal -resoverlap 0.50 -seqoverlap 60 -in $file -out $file.trm
 trimal -automated1 -in $file.trm -out $file.autotrim
done
