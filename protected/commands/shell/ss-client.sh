#!/bin/sh

$port=$1;
$mode=$2;

if [ "$mode" = "start" ]; then
    ss-local -s 23.252.107.210 -p 443 \
        -b 0.0.0.0 -l $port \
        -k daijianhao \
        -m aes-256-cfb \
        -v -t 600 \
        -f /var/run/shm/ss-$port.pid &
fi

if [ "$mode" = "quit" ]; then
    pid=$(ps -ax|grep ss-local|grep "$port"|awk '{print $1}');
    if [ -n "$pid" ]; then
        kill $pid;
    fi
fi