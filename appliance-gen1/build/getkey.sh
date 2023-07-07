#!/bin/sh
# (c) Qnetix Ltd 2023

read -r line < /etc/zabbix/agentname.conf
echo "PSK Identity : $line"

read -r line < /etc/zabbix/agentd.psk
echo "PSK KEY: $line"

read -p "Press any key to continue"
