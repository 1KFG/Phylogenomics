#PBS -l nodes=1:ppn=1 -j oe -N combineAll

if [ ! -f expected ]; then
 bash jobs/make_expected_file.sh
fi
perl scripts/combine_fasaln.pl -o all.Roz200.fasaln -of fasta -d aln/Roz200 -expected expected

#bp_sreformat.pl -if fasta -of nexus --special=mrbayes -i all.Roz200.fasaln -o all.Roz200.nex
