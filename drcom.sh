#!/bin/bash
# author: feix.chow@gmail.com
# date:   2015-03-31

SCRIPT_SELF_PATH=$(cd "$(dirname "$0")"; pwd)
conf_file="${SCRIPT_SELF_PATH}/drcom.conf"
c_file="${SCRIPT_SELF_PATH}/drcom.c"
md5_file="${SCRIPT_SELF_PATH}/md5.c"
drcomd_file="${SCRIPT_SELF_PATH}/drcomd"
GCC=$(which gcc 2>/dev/null)

username=$(awk '{print $1}' "$conf_file" | awk -F'=' '$1 ~ /^username/ {print $2}')
password=$(awk '{print $1}' "$conf_file" | awk -F'=' '$1 ~ /^password/ {print $2}')
mac_addr=$(ifconfig | egrep -io "([0-9a-f]{2}:){5}[0-9a-f]{2}" | tr -d ":")

if [ -z "$username" -o -z "$password" ]; then
    echo "username or password is empty"
    exit 1
fi

if [ -z "$GCC" ]; then
    echo "install gcc first"
    exit 1
else
    sed "s/change to your username here/$username/; s/change to your password here/$password/; s/000000000000/$mac_addr/" -i "$c_file" && 
    "$GCC" -o "$drcomd_file" "$md5_file" "$c_file"
    if [ "$?" -eq 0 ]; then
        echo "drcomd is ok"
    else
        echo "compile error"
        exit 1
    fi
fi
