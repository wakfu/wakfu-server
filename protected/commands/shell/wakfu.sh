#!/bin/sh
ip="123.57.74.156";
remove=0;
create=1;
view=0;

while getopts "p:cdvh" opt
do
    case $opt in
    p )
        port=$OPTARG;
        bool=`echo $port |sed "s/[0-9]//g"`;
        if [ -n "$bool" ]; then
            echo "Invalid port number ($port)";
            exit 1;
        fi;;
    c )
        create=1;
        view=0;
        remove=0;;
    d )
        create=0;
        view=0;
        remove=1;;
    v )
        create=0;
        view=1;
        remove=0;;
    h )
        echo "-p <port>\t service port.";
        echo "-c       \t create service by port. (default)";
        echo "-d       \t delete service by port.";
        echo "-v       \t view traffic data.";
        echo "-h       \t help information.";
        exit 0;;
    ? )
        echo "undefined parameter.";
        echo "-p <port>\t service port.";
        echo "-c       \t create service by port. (default)";
        echo "-d       \t delete service by port.";
        echo "-v       \t view traffic data.";
        echo "-h       \t help information.";
        exit 1;;
    esac
done

if [ -z "$port" ]; then
    echo "Invalid port number (empty)";
    exit 1;
fi

if [ "$create" -eq "1" ]; then
    exists=$(iptables -n -v -L -t filter |grep "$port");
    if [ "$exists" -eq "" ]; then
        $(iptables -I INPUT -d 123.57.74.156 -p tcp --dport $port);
        $(iptables -I OUTPUT -s 123.57.74.156 -p tcp --sport $port);
        $(sh ss-client.sh $port);
    else
        echo "port:$port already exists";
    fi
    exit 0;
fi

if [ "$remove" -eq "1" ]; then
    input=$(iptables -t filter -L -n --line-number |grep "dpt:$port" |awk '{print $1}');
    if [ "$input" -eq "" ]; then
        echo "port:$port not found in INPUT";
    else
        $(iptables -t filter -D INPUT $input);
    fi

    output=$(iptables -t filter -L -n --line-number |grep "spt:$port" |awk '{print $1}');
    if [ "$input" -eq "" ]; then
        echo "port:$port not found in OUTPUT";
    else
        $(iptables -t filter -D OUTPUT $output);
    fi

    pid=$(ps -ax|grep ss-local|grep "$port"|awk '{print $1}');
    if [ "$pid" -eq "" ]; then
        echo "client of $port is already killed";
    else
        $(kill $pid);
    fi
    exit 0;
fi

if [ "$view" -eq "1" ]; then
    input=$(iptables -n -v -x -L -t filter |grep "dpt:$port" |awk '{print $2}');
    output=$(iptables -n -v -x -L -t filter |grep "spt:$port" |awk '{print $2}');
    total=$(expr $input / 1024 + $output / 1024);
    echo $total;
    exit 0;
fi

