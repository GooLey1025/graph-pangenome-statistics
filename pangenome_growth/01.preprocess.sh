#!/bin/bash
source ~/.bashrc
source ./config.sh
conda activate py3.8

sed -i 's/-/_/g' $graph_info

if [ ! -f $dir/$gfa ]; then
    if [ -f $dir/$gfa.gz ]; then
        echo "gunzip $gfa.gz ... "
        gunzip -c $dir/$gfa.gz > $dir/$gfa
    else
        echo "Error: $dir/$gfa.gz does not exist."
    fi
fi
# Exclude paths from reference genome.
grep '^W' $dir/$gfa | cut -f2 | grep -ie "$ref" | sort | uniq > $gfa.exclude.$ref_hap.txt
# grep '^W' $dir/$gfa | cut -f4 | grep -ie "$ref" | sort | uniq > $gfa.exclude.$ref_hap.txt
# for establish order
grep '^W' $dir/$gfa | cut -f2 | grep -ive "$ref" | sort | uniq > $gfa.paths.no_ref.haplotypes.txt

#### Below step is to prepare ordered.txt for panacus. 
#### Below is the example for what our data process, you do not have to follow the steps due to different backgrounds.
#### We recommend that you check the panacus markdown tutorial in github.
#### Detailed for ordered_pangenome_growth_statistics tutorial can be aviailable at https://github.com/marschall-lab/panacus/blob/main/examples/ordered_pangenome_growth_statistics.md . 

# cat -A $second | less -S ## See the last line for your file. it should be ended with $ or \n or other sepcial character.
## If csv file exported from EXCEL (MAC or Windows), the format need to be normalized. Otherwise it will omit one row in running codes below.
# Here our file exported from EXCEL (MAC), there is no $ in the last line. So we do this:

dos2unix < $graph_info > tmp_$graph_info
sed -e '$a\' tmp_$graph_info > formatted_$graph_info

> "$output"
echo "remove $output"

# If the value in the AccessionID column (second column) of the graph_info file 
# is contained within any line of the $gfa.paths.no_ref.haplotypes.txt file, grep that line, 
# read the data, and write the matched line along with the corresponding data from the second file to the output.
while IFS=',' read -r -a columns; do
    accession=${columns[1]}
    matched_line=$(grep -F "$accession" "$gfa.paths.no_ref.haplotypes.txt")
    if [ -n "$matched_line" ]; then
        echo -e "$matched_line,$(IFS=","; echo "${columns[*]}")" >> "$output"
    fi
done < formatted_$graph_info
echo "Processing completed. Results saved in $output"
comm -3 <(cut -d "," -f1 $output | sort) $gfa.paths.no_ref.haplotypes.txt > possible_redundant.rows
echo "-----------------------"
cat possible_redundant.rows 
N=$(cat possible_redundant.rows | wc -l)
echo "-----------------------"
echo "possible redundant rows above."
echo "This results need to be manually checked and remove redundant rows due to similar namespcae."
rm tmp_$graph_info
cp $output $output.raw
echo "So we remove some these $N redundant rows in the $output  manually!!! "
echo "Also we generated the $output.raw for mapping when plotting, if you use this for plot, please manually manually edit therows which only has one column. It is hard to explain. Here , we need to delete CW03 row and sed the YCW03,CW03 into CW03,CW03 "

