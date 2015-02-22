#!/bin/sh
set -e
set -u

dstroot=~/Manpages

cd /usr/share/man
find man? -type d | cpio -pdm ${dstroot}
SFI=$IFS IFS='
'
set -- `find man? -type f | sort`
IFS=$SFI
for f
do
   src=${f}
   dst=${dstroot}/${f%%/*}/${f##*/}
   dst=${dst%.*}.pdf

   test ! -f "${dst}" || continue
 
   man -t "${src}" \
   | (
       set -x
       nice -n 19 ps2pdf - "${dst}"
   )
done
