#!/bin/bash
source ./config.sh
echo "after manually check our $output" # here FaHC_P8_Nipponbare_TEJ.sorted.txt
# and order (deafulted ordered with column [Rice type])

sort $output -o sorted_$output
cat $output | cut -d "," -f 1 > tmp
mv tmp $output

sort $output.raw -o sorted_$output.raw
comm -12 sorted_$output sorted_$output.raw > filtered_$graph_info
# rm $output.raw
rm sorted_$output
# rm sorted_$output.raw


