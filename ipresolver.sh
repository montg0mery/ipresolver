#!/bin/bash

list=$(cat $1)

for host in $list
do
        ips=$(dig "$host" +short 2>/dev/null | grep -oP "([0-9]{1,3}\.){3}[0-9]{1,3}")
        line=$(echo $ips | tr -d '\n' | tr ' ' ', ' )
        echo "$host : $line"
        echo "$host : $line" >> ip.txt
done
