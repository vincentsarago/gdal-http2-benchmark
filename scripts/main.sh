#!/usr/bin/env bash


function run() {
    [ "$#" -lt 1 ] && echo "Usage: main <file>" && exit 1
    file=$1
    file=$(echo $file | sed 's/https:/\/vsicurl\/https:/g')

    log_file="/tmp/tmp.log"
    gdal_translate -q -srcwin 0 0 5000 5000 -outsize 2000 2000 $file /tmp/out.tif 2>$log_file
    nbGet=$(cat $log_file | grep "VSICURL: Downloading" | wc -l)
    nbBytes=$(cat $log_file | grep "VSICURL: Downloading" | awk '{print $3}' | awk '{split($0,a,"-"); print a[2]-a[1]}' | awk '{n += $1}; END {print n}')
    echo "Nb requests: "$nbGet
    echo "Nb bytes: "$nbBytes
    echo
    exit 0
}

[ "$0" = "$BASH_SOURCE" ] && run "$@"
