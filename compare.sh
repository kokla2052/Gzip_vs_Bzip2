#!/bin/bash
#---------------------function-----------------------#
sum_byte(){
sum=$(echo "scale=4; $size/1073741824" | bc -l)
if [ $(echo "scale=4; $sum > 1.0" | bc) -ge 1 ]
then
echo $sum "GB"
else
num=$(echo "scale=4; $sum * 1024" | bc -l)
echo $num "MB"
fi
}
#-------------------function-------------------------#
read -e -p "Enter filename: " file
echo "Start compress $file by gzip......."
t_start_gz=$((`date +%s`*1000+`date +%-N`/1000000))
start=$(date +%s)
gzip $file
t_end_gz=$((`date +%s`*1000+`date +%-N`/1000000))
end=$(date +%s)
size=$(ls -l $file.gz |tr ' ' ','|cut -d, -f5)
size_gz=$(sum_byte)
echo "Doing unzip file gz......"
gunzip $file.gz
#------------------End Gzip --------------------------#
#------------------Start bzip2------------------------#

echo "Start compress $file by bzip2......"
t_start_bz=$((`date +%s`*1000+`date +%-N`/1000000))
start2=$(date +%s)
bzip2 $file
t_end_bz=$((`date +%s`*1000+`date +%-N`/1000000))
end2=$(date +%s)
size=$(ls -l $file.bz2 |tr ' ' ','|cut -d, -f5)
size_bz=$(sum_byte)
echo "Doing unzip file bz......"
bunzip2 $file.bz2
echo "Stop process"

t_diff_gz=$(( $t_end_gz - $t_start_gz ))
t_diff_bz=$(( $t_end_bz - $t_start_bz ))

echo "#---------------------compress sumary "$file"---------------------#"
time_gz=$(expr $end - $start)
echo "gzip compression time " $t_diff_gz"ms size" $size_gz
time_bz=$(expr $end2 - $start2)
echo "bzip2 compression time " $t_diff_bz"ms size" $size_bz
echo "#------------------------------End-----------------------------#"
