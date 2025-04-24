#!/bin/bash
source ~/.bashrc

source ./config.sh
conda activate py3.8


grep '^P' hprc-v1.0-mc-grch38.gfa | cut -f2 > hprc-v1.0-mc-grch38.paths.txt
grep -e '^W' hprc-v1.0-mc-grch38.gfa | cut -f2-6 | awk '{ print $1 "#" $2 "#" $3 ":" $4 "-" $5 }' >> hprc-v1.0-mc-grch38.paths.txt
cut -f1 -d\# hprc-v1.0-mc-grch38.paths.txt > hprc-v1.0-mc-grch38.groupnames.txt
paste hprc-v1.0-mc-grch38.paths.txt hprc-v1.0-mc-grch38.groupnames.txt > hprc-v1.0-mc-grch38.groups.txt

RUST_LOG=info panacus ordered-histgrowth -c bp -t 48 -l 1,1,2,1 -q 0.95,0.05,0,0 -S -e $gfa.exclude.$ref_hap.txt -O $output $dir/$gfa -o html > $gfa.ordered.html
RUST_LOG=info panacus ordered-histgrowth -c bp -t48 -l 1,1,2,1 -q 0.95,0.05,0,0 -S -e $gfa.exclude.$ref_hap.txt -O $output $dir/$gfa -o table > $gfa.ordered.tsv
panacus-visualize $gfa.ordered.tsv  > $gfa.ordered-histgrowth.bp.pdf

RUST_LOG=info panacus ordered-histgrowth -t16 -q 0,1,0.5,0.1 -g hprc-v1.0-mc-grch38.groups.txt -s hprc-v1.0-mc-grch38.paths.haplotypes.txt hprc-v1.0-mc-grch38.gfa > hprc-v1.0-mc-grch38.histgrowth.node.txt

# RUST_LOG=info panacus histgrowth -t48 -l 1,2,1,1,1 -q 0,0,0.1,0.5,1 -S  -s Nip_42_rice.paths.haplotypes.txt -c all -a -o html Nip_42_rice.gfa  > Nip_42_rice.full.histgrowth.html




