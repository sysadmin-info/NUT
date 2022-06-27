#!/bin/bash

sleep 60

IP=`echo $(ifconfig eth0 | grep 'inet' | cut -d: -f2 | awk '{ print $2}')`
HOSTNAME=`hostname -f`
echo "$HOSTNAME online.  IP address: $IP" > /root/email.txt
echo >> /root/email.txt
date >> /root/email.txt

echo "$HOSTNAME is up" | mail -A /root/email.txt -s "$HOSTNAME online" adrian.ambroziak@gmail.com

rm -rf /root/email.txt
