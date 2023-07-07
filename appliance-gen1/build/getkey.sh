#!/bin/sh
# (c) Qnetix Ltd 2023

cat /etc/zabbix/agentname.conf
read -r line < /etc/zabbix/agentd.psk
echo "PSK KEY: $line"

read -p "Press any key to continue"
