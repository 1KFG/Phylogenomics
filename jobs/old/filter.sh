#module load orthoMCL
#orthomclFilterFasta clean 10 10
#/opt/wu-blast/2009-07/filter/pseg goodProteins.fasta -q -z 1 > goodProteins.seg
mkdir seg
for file in pep/*.fasta
do
 stem=`basename $file .fasta`
 if [ ! -f seg/$stem.seg ];
 then
   /opt/wu-blast/2009-07/filter/pseg $file -q -z 1 > seg/$stem.seg
 fi
done
