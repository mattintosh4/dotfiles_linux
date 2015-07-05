#!/bin/sh
PATH=/usr/bin:/bin:/usr/sbin:/sbin
set -e
set -x

dstroot=${HOME}/Manpages
update_interval=14

cd /usr/share/man
find man? -type d | cpio -pdm "${dstroot}"

timestamp_file=${dstroot}/update-timestamp
test -f "${timestamp_file}" || date +%s >"${timestamp_file}"
timestamp_old=`cat "${timestamp_file}"`
timestamp_now=`date +%s`
timestamp_flag=`expr ${update_interval} \* 86400 \<= ${timestamp_now} - ${timestamp_old}` \
    && date +%s >"${timestamp_file}" \
    || : ${timestamp_flag:?}

SFI=${IFS} IFS='
'
set -- `find man? -type f | sort`
IFS=${SFI}

for f
do
    src=${f}
    dst=${dstroot}/${f%%/*}/${f##*/}
    case ${dst} in
    *[0-9]) dst=${dst}.pdf    ;;
         *) dst=${dst%.*}.pdf ;;
    esac

    case ${timestamp_flag} in
    1) ;;
    0) test ! -f "${dst}" || continue ;;
    esac

    man -t "${src}" \
    | \
    (
        set -x
        nice -n 19 ps2pdf - "${dst}"
    )
done
