#!/bin/bash

list=$(cat $1)
touch redundant.log

for host in $list
do
        ips=$(dig "$host" +short 2>/dev/null | grep -oP "([0-9]{1,3}\.){3}[0-9]{1,3}")
        if [ -z "$ips" ]
        then
                echo "$host : :" >> ip.txt
        else
                line=$(echo $ips | tr -d '\n' | tr ' ' ', ' )
       
                first_ip=$(echo $line | awk -F',' '{print $1}')
		if grep -q $first_ip redundant.log
		then
			echo "$host : $(cat redundant.log | grep $first_ip)" >> ip.txt
		else	
                	echo ""
                	echo "scanning $host -> $first_ip"
                	echo ""
                	masscan $first_ip -p 1-65535 -oG tmp.grep --max-rate 10000
                	ports=$(cat tmp.grep | grep tcp | awk -F'Ports: ' '{print $2}' | cut -d/ -f1 | tr '\n' ',')
                	rm tmp.grep
                	echo "$host : $line : $ports"
                	echo "$host : $line : $ports" >> ip.txt
			echo "$first_ip : $ports" >> redundant.log
		fi
        fi

done
rm redundant.log
