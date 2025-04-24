#!/bin/bash

# input_file=/public/home/cszx_huangxh/qiujie/collabrators/gulei/rice_graph_pangenome/graph_construction/MC/Nip_42_rice/results/Nip_42_rice/Nip_42_rice.sv.gfa.gz
input_file=/public/home/cszx_huangxh/qiujie/collabrators/gulei/maize_graph_pangenome/graph_construction/MC/step_ID1_Chr.pangenome/ID1_Chr.pangenome.sv.gfa
output_file=37maize_sv_distribution.tsv

cat "$input_file" | \
awk '/^S/ {match($0, /LN:i:([0-9]+)/, arr); if (arr[1] != "") print arr[1]}' | \
sort -n | uniq -c | \
awk '{print $2 "\t" $1}' | sort -n > "$output_file"

echo "output to  $output_file"
