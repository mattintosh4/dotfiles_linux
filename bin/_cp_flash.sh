#!/bin/sh

DSTROOT=${HOME}

case ${1} in
-d)
    DSTROOT=.
;;
esac

ifs=${IFS}
IFS='
'
set -- `ls -l /proc/*/fd/* 2>/dev/null | grep Flash`
IFS=${ifs}

for f
do
    src=`echo ${f} | cut -d' ' -f9`
    dst=`echo ${f} | cut -d' ' -f11`
    dst=${DSTROOT}/`date +%Y%m%d%H%M%S`_${dst##*/}.mp4
    printf '%s -> %s\n' ${src} ${dst}
    dd if=${src} of=${dst} bs=24M
done
