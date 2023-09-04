#!/bin/bash

sleep 60

IP=`echo $(hostname -I | awk '{ print $1}')`
HOSTNAME=`hostname -f`
echo "$HOSTNAME online.  IP address: $IP" > /root/email.txt
echo >> /root/email.txt
date >> /root/email.txt
echo "$HOSTNAME is up" >> /root/emailmessage.txt

mutt -a /root/email.txt -s "$HOSTNAME online" -- example@gmail.com < /root/emailmessage.txt

rm -r /root/email.txt
rm -f /root/emailmessage.txt
