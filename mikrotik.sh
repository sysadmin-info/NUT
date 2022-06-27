#!/bin/bash
# The result of the script execution is recorded in the mikrotik.log located in the /root directory.
LOG_FILE=/root/mikrotik.log
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>${LOG_FILE} 2>&1
data=$( date +"%Y-%m-%d %H:%M:%S" )
nutlog=/var/log/nut.log
if [ "`grep "Mikrotik" "$nutlog"`" ]; then
        echo "$data -> Mikrotik router will go down."
        echo "UPS is down!" | mail -s "UPS ALERT DOWN" adrian.ambroziak@gmail.com < /root/mikrotik.log
        rm -f $nutlog
        touch $nutlog
        chown root:adm $nutlog
        chmod 640 $nutlog
        systemctl restart rsyslog
        sshpass -f /root/creds ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o CheckHostIP=no -p 2244 nut@10.10.0.1 "/system shutdown; /y; /quit;"
        exit
else
        echo "$data -> Mikrotik router will remain powered on."
        exit
fi
