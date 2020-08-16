#!/bin/bash

list=$(cat $1)

for host in $list
do
        ips=$(dig "$host" +short 2>/dev/null | grep -oP "([0-9]{1,3}\.){3}[0-9]{1,3}")
        line=$(echo $ips | tr -d '\n' | tr ' ' ', ' )

        first_ip=$(echo $line | awk -F',' '{print $1}')
        if [ -z "$first_ip" ]
        then
                :
        else
                echo ""
                echo "scanning $host -> $first_ip"
                echo ""
                masscan $first_ip -p 1-65535 -oG tmp.grep
                ports=$(cat tmp.grep | grep tcp | awk -F'Ports: ' '{print $2}' | cut -d/ -f1 | tr '\n' ',')
                rm tmp.grep
        fi

        echo "$host : $line : $ports"
        echo "$host : $line : $ports" >> ip.txt
done
