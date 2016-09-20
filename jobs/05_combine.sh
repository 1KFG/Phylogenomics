#PBS -l nodes=1:ppn=1,mem=8gb,walltime=3:00:00 -j oe -N combineAll
module load RAxML

if [ ! -f expected ]; then
 bash jobs/make_expected_file.sh
fi
EXPECTEDNAMES=expected
MARKERS=JGI_1086
ALN=aln
count=$(wc -l $EXPECTEDNAMES | awk '{print $1}')
#echo "count is $count"

perl scripts/combine_fasaln.pl -o all_${count}.${MARKERS}.fasaln -of fasta -d $ALN/$MARKERS -expected $EXPECTEDNAMES > all_${count}.${MARKERS}.partitions.txt
convertFasta2Phylip.sh all_${count}.${MARKERS}.fasaln > all_${count}.${MARKERS}.phy

ctCDS=$(ls $ALN/$MARKERS/*.cdsaln.trim | wc -l | awk '{print $1}')
if [ $ctCDS -gt 0 ]; then
perl scripts/combine_fasaln.pl -o all_${count}.${MARKERS}.cds.fasaln -ext cdsaln.trim -if fasta -of fasta -d $ALN/$MARKERS -expected $EXPECTEDNAMES > all_${count}.${MARKERS}.cds.partitions.txt
convertFasta2Phylip.sh all_${count}.${MARKERS}.cds.fasaln > all_${count}.${MARKERS}.cds.phy
fi
