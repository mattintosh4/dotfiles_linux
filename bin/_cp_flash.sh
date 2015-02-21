#!/bin/sh

ifs=${IFS}
IFS='
'
set -- `ls -l /proc/*/fd/* 2>/dev/null | grep Flash`
IFS=${ifs}

for f
do
    src=`echo ${f} | cut -d' ' -f9`
    dst=`echo ${f} | cut -d' ' -f11`
    dst=${HOME}/`date +%Y%m%d%H%M%S`_${dst##*/}.mp4
    printf '%s -> %s\n' ${src} ${dst}
    dd if=${src} of=${dst}
done
