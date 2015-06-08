#!/bin/sh

while getopts "s:p:m:h" opt
do
    case $opt in
    s )
        server=$OPTARG;
        bool=`echo $server |sed "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}//g"`;
        if [ -n "$bool" ]; then
            echo "Invalid Server IP ($server)";
            exit 1;
        fi;;
    p )
        port=$OPTARG;
        bool=`echo $port |sed "s/[0-9]//g"`;
        if [ -n "$bool" ]; then
            echo "Invalid Port number ($port)";
            exit 1;
        fi;;
    m )
        mode=$OPTARG;;
    h )
        echo "-s <ip>  \t server ip.";
        echo "-p <port>\t server port.";
        echo "-m       \t mode:start or quit";
        echo "-h       \t help information.";
        exit 0;;
    ? )
        echo "undefined parameter.";
        echo "-s <ip>  \t server ip.";
        echo "-p <port>\t server port.";
        echo "-m       \t mode:start or quit";
        echo "-h       \t help information.";
        exit 0;;
    esac
done

if [ -z "$port" ]; then
    echo "Invalid port number (empty)";
    exit 1;
fi

if [ "$mode" = "start" ]; then
    if [ -z "$server" ]; then
        echo "Invalid server ip (empty)";
        exit 1;
    fi
    ss-local -s $server -p 443 \
        -b 0.0.0.0 -l $port \
        -k wakfualiyun \
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