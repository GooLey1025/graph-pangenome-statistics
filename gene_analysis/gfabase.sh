#!/bin/bash
dir=/public/home/cszx_huangxh/qiujie/collabrators/gulei/rice_graph_pangenome/graph_construction/MC/step_Nipponbare55.pangenome/Nipponbare55.pangenome
prefix=Nipponbare55.pangenome
positions=(
    "FaHC_P8_Nipponbare_TEJ#0#Chr07:6062889-6069317"
    "FaHC_P8_Nipponbare_TEJ#0#Chr07:6241368-6241999"
    "FaHC_P8_Nipponbare_TEJ#0#Chr07:6244130-6244880"
    "FaHC_P8_Nipponbare_TEJ#0#Chr07:6254861-6255627"
    "FaHC_P8_Nipponbare_TEJ#0#Chr07:6258913-6259695"
    "FaHC_P8_Nipponbare_TEJ#0#Chr07:6276077-6276821"
    "FaHC_P8_Nipponbare_TEJ#0#Chr07:6336108-6336920"
)
genes=("Rc" "RAL1" "RAL2" "RAL3" "RAL4" "RAL5" "RAL6")
# gunzip -c $prefix.gfa.gz | ./gfabase --verbose load -o $prefix.gfab
# gfabase --verbose load -o $prefix.gfab $dir/$prefix.gfa
for i in ${!positions[@]}; do
    pos=${positions[i]}
    gene=${genes[i]}
    echo "Processing $gene with position $pos..."
    

    # time ./gfabase sub $prefix.gfab $pos --range --cutpoints 2 --no-sequences --guess-ranges
    gfabase sub $prefix.gfab -o $gene.gfa $pos --range --cutpoints 2 --guess-ranges 
    gfabase sub $prefix.gfab -o $gene.con.gfa $pos --range --cutpoints 1 --guess-ranges --connected
	echo "one sample done."
done
echo "All positions processed."
