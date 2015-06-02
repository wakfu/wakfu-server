#!/bin/sh

ss-local -s 23.252.107.210 -p 443 \
    -b 0.0.0.0 -l $1 \
    -k daijianhao \
    -m aes-256-cfb \
    -v -t 600 \
    -f /var/run/shm/ss-$1.pid &