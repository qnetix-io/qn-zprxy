#!/bin/sh
# (c) Qnetix Ltd 2023 v1.2
# https://raw.githubusercontent.com/qnetix-io/qn-zprxy/main/appliance-gen1/init.sh


clear
echo 'Use existing key/name information (y/n)? ' && read answer;

if [ "$answer" != "${answer#[Yy]}" ] ;then 
    echo "Using existing name and key information"
else
    # Set TLS Key
    rm -f /etc/zabbix/tlskey > /dev/null;
    echo "Creating New Key";
    TLSKEY=$(openssl rand -hex 32);
    echo ${TLSKEY} >> /etc/zabbix/tlskey;

    # Set Names
    rm -f /etc/zabbix/applianceconf;
    echo "Please enter the appliance details (do not add any FQDN elements)"

    read -p "Customer ID - example: '4001' :" server_id
    read -p "Local Proxy Appliance Number - example: '01' :" proxy_number

    echo -e "CUSTOMERID=\"${server_id}\"" >> /etc/zabbix/applianceconf
    echo -e "PROXYID=\"${proxy_number}\"" >> /etc/zabbix/applianceconf
    echo -e "TLSID=\"proxy-${server_id}-${proxy_number}\"" >> /etc/zabbix/applianceconf
    echo -e "TLSFILE=\"/etc/zabbix/tlskey\"" >> /etc/zabbix/applianceconf
    echo -e "PROXYNAME=\"proxy-${server_id}-${proxy_number}\"" >> /etc/zabbix/applianceconf
fi