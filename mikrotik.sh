#!/bin/bash
# The result of the script execution is recorded in the mikrotik.log located in the /root directory.
LOG_FILE=/root/mikrotik.log
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>${LOG_FILE} 2>&1
data=$( date +"%Y-%m-%d %H:%M:%S" )
nutlog=/var/log/nut.log
if [ "`grep -a "Mikrotik" "$nutlog"`" ]; then
        echo "$data -> Mikrotik router will go down."
        echo "UPS is down" > /root/emailmessage.txt
        mutt -a /root/mikrotik.log -s "UPS ALERT DOWN" -- example@gmail.com < /root/emailmessage.txt
        rm -f $nutlog
        touch $nutlog
        chown root:adm $nutlog
        chmod 640 $nutlog
        rm -f /root/emailmessage.txt
        systemctl restart rsyslog
        # I am using id_rsa private key to connect. id_rsa.pub is uploaded to Mikrotik.
        # In Mikrotik go to IP -> Services -> Enable ssh, set port and set IP allowed IP address or range
        # In Mikrotik go to System -> Users add for example a user: nut, set up allowed IP and then import SSH public key usin SSH keys tab.
        ssh -p 2244 -i /root/.ssh/id_rsa nut@10.10.0.1 "/system shutdown; /y; /quit;"
        exit
else
        echo "$data -> Mikrotik router will remain powered on."
        exit
fi
