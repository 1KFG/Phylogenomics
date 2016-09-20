#PBS -l nodes=1:ppn=1 -j oe -N combineAll
module load RAxML

if [ ! -f expected ]; then
 bash jobs/make_expected_file.sh
fi
EXPECTEDNAMES=expected
MARKERS=JGI_1086
count=`wc -l $EXPECTEDNAMES | awk '{print $1}'`
#echo "count is $count"
perl scripts/combine_fasaln.pl -ext denovo.trim -o all_${count}.denovo.${MARKERS}.fasaln -of fasta -d aln/$MARKERS -expected $EXPECTEDNAMES > all_${count}.denovo.${MARKERS}.partitions.txt
convertFasta2Phylip.sh all_${count}.denovo.${MARKERS}.fasaln > all_${count}.denovo.${MARKERS}.phy

ctCDS=$(ls aln/$MARKERS/*.denovo_cdsaln.trim | wc -l | awk '{print $1}')
if [ $ctCDS -gt 0 ]; then
perl scripts/combine_fasaln.pl -o all_${count}.${MARKERS}.denovocds.fasaln -ext denovo_cdsaln.trim -if fasta -of fasta -d aln/$MARKERS -expected $EXPECTEDNAMES > all_${count}.${MARKERS}.cds.partitions.txt
convertFasta2Phylip.sh all_${count}.${MARKERS}.denovocds.fasaln > all_${count}.${MARKERS}.denovocds.phy
fi
