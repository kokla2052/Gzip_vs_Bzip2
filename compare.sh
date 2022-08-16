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
start=$(date +%s)
gzip $file
end=$(date +%s)
size=$(ls -l $file.gz |tr ' ' ','|cut -d, -f5)
size_gz=$(sum_byte)
echo "Doing unzip file gz......"
gunzip $file.gz
#------------------End Gzip --------------------------#
#------------------Start bzip2------------------------#
echo "Start compress $file by bzip2......"
start2=$(date +%s)
bzip2 $file
end2=$(date +%s)
size=$(ls -l $file.bz2 |tr ' ' ','|cut -d, -f5)
size_bz=$(sum_byte)
echo "Doing unzip file bz......"
bunzip2 $file.bz2
echo "Stop process"

echo "#---------------------compress sumary "$file"---------------------#"
time_gz=$(expr $end - $start)
echo "gzip compression time " $time_gz"s size" $size_gz
time_bz=$(expr $end2 - $start2)
echo "bzip2 compression time " $time_bz"s size" $size_bz
echo "#------------------------------End-----------------------------#"
