#PBS -l nodes=1:ppn=1 -j oe -N combineAll

if [ ! -f expected.filter ]; then
 bash jobs/make_expected_file_filt.sh
fi
perl scripts/combine_fasaln.pl -o all.Roz200_filt_denovo_longnames.fasaln -of fasta -d aln/Roz200.denovoaln -expected expected.filter -ext fasaln.trim

#bp_sreformat.pl -if fasta -of nexus --special=mrbayes -i all.Roz200.fasaln -o all.Roz200.nex
