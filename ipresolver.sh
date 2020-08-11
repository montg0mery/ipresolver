#!/bin/bash

list=$(cat $1)

for host in $list
do
        ip=$(ping -c1 $host 2>/dev/null | grep PING | awk -F'[()]' '{print $2}')
        echo "$host : $ip"
        echo "$host : $ip" >> ip.txt
done
