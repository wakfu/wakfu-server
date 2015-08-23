#!/bin/sh

# remove mode
remove=0;
# create mode
create=1;
# view mode
view=0;

while getopts "s:p:cdvh" opt
do
    case $opt in
    s )
        server=$OPTARG;
        bool=`echo $server |sed "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}//g"`;
        if [ -n "$bool" ]; then
            echo "Invalid Service IP ($server)";
            exit 1;
        fi;;
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
        echo "-s <ip>  \t service ip.";
        echo "-p <port>\t service port.";
        echo "-c       \t create service by port. (default)";
        echo "-d       \t delete service by port.";
        echo "-v       \t view traffic data.";
        echo "-h       \t help information.";
        exit 0;;
    ? )
        echo "undefined parameter.";
        echo "-s <ip>  \t service ip.";
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
    if [ -z "$server" ]; then
        echo "Invalid service ip (empty)";
        exit 1;
    fi
    exists=$(iptables -n -v -L -t filter |grep "$port");
    if [ -z "$exists" ]; then
        $(iptables -I INPUT -d $server -p tcp --dport $port -j ACCEPT);
        $(iptables -I OUTPUT -s $server -p tcp --sport $port -j ACCEPT);
    fi
    $(/usr/local/bin/ss-client -s "$server" -p "$pid" -m start);
    exit 0;
fi

if [ "$remove" -eq "1" ]; then
    input=$(iptables -t filter -L -n --line-number |grep "dpt:$port" |awk '{print $1}');
    if [ -n "$input" ]; then
        $(iptables -t filter -D INPUT $input);
    fi

    output=$(iptables -t filter -L -n --line-number |grep "spt:$port" |awk '{print $1}');
    if [ -n "$input" ]; then
        $(iptables -t filter -D OUTPUT $output);
    fi
    $(/usr/local/bin/ss-client -p "$pid" -m quit);
    exit 0;
fi

if [ "$view" -eq "1" ]; then
    input=$(iptables -n -v -x -L -t filter |grep "dpt:$port" |awk '{print $2}');
    output=$(iptables -n -v -x -L -t filter |grep "spt:$port" |awk '{print $2}');
    total=$(expr $input / 1000 + $output / 1000);
    echo $total;
    exit 0;
fi

