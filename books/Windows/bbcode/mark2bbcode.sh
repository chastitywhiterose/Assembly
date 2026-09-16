#!/bin/sh
infile=0.txt
outfile=1.txt
cp $infile $outfile

sed 's/size=200/size=24/g' -i $outfile
sed 's/size=170/size=18/g' -i $outfile
sed 's/size=150/size=12/g' -i $outfile

sed 's|\[table\]|\[list\]|g' -i $outfile
sed 's|\[\/table\]|\[\/list\]|g' -i $outfile

sed 's|\[tr\]|\[*\] |g' -i $outfile
sed 's|\[\/tr\]||g' -i $outfile

sed 's|\[td\]| |g' -i $outfile
sed 's|\[\/td\]||g' -i $outfile

sed 's|\[th\]| |g' -i $outfile
sed 's|\[\/th\]||g' -i $outfile

#this script is meant to modify bbcode from the following conversion tool online
# https://www.markdowntools.io/markdown-to-bbcode
#first I use it to convert my markdown file and then I make quick changes via sed to the bbcode
#mostly this fixes font size issues to be compatible with the fasm forum.

#sh mark2bbcode.sh
