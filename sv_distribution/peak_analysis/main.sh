awk '/^>/ {if (seq) print name "_length=" length(seq) "\n" seq; name=$0; seq=""; next} {seq=seq $0} END {print name "_length=" length(seq) "\n" seq}' ../Nipponbare55.pangenome.sv.gfa.fa > length_SV_Nipponbare55.fa 
awk -v lens="155,156,222,237,244,266" '
BEGIN {
    split(lens, arr, ","); # 解析多个目标长度
    for (i in arr) target[arr[i]] = 1; 
}
/^>/ {
    if (seq && target[length(seq)]) print name "\n" seq;
    name=$0; seq="";
    next;
}
{
    seq = seq $0;
}
END {
    if (seq && target[length(seq)]) print name "\n" seq;
}' length_SV_Nipponbare55.fa > filtered.fa

makeblastdb -in rice7.0.0.liban -dbtype nucl -out rice_db
blastn -query filtered.fa -db rice_db -out blast_results.txt -outfmt 6 -evalue 1e-5
python3 rmdup.py 
Rscirpt plot.r

