grep -h ">" aln/Roz200.filter/*.fa | awk -F\| '{print $1}' | awk '{print $1}' | sort | uniq > expected.filter
