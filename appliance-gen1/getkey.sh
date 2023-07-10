#!/bin/sh
# (c) Qnetix Ltd 2023

cat /etc/zabbix/applianceconf

read -r line < /etc/zabbix/tlskey
echo "TLSKEY=$line"

read -p "Press any key to continue"

/var/lib/qnetix/menu-appliance.sh
