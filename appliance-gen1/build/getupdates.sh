#!/bin/sh
# (c) Qnetix Ltd 2023

rm -f -r /root/update

mkdir /root/update
mkdir /root/update/vars
mkdir /var/lib/qnetix
mkdir /var/lib/qnetix/vars

wget -O /root/update/init.sh https://raw.githubusercontent.com/qnetix-io/qn-zprxy-base/main/appliance-gen1/build/init.sh
wget -O /root/update/menu-appliance.sh https://raw.githubusercontent.com/qnetix-io/qn-zprxy-base/main/appliance-gen1/build/menu-appliance.sh
wget -O /root/update/menu-size.sh https://raw.githubusercontent.com/qnetix-io/qn-zprxy-base/main/appliance-gen1/build/menu-size.sh
wget -O /root/update/vars/size-default https://raw.githubusercontent.com/qnetix-io/qn-zprxy-base/main/appliance-gen1/build/vars/size-default
wget -O /root/update/vars/size-large https://raw.githubusercontent.com/qnetix-io/qn-zprxy-base/main/appliance-gen1/build/vars/size-large
wget -O /root/update/vars/size-med https://raw.githubusercontent.com/qnetix-io/qn-zprxy-base/main/appliance-gen1/build/vars/size-med
wget -O /root/update/vars/size-small https://raw.githubusercontent.com/qnetix-io/qn-zprxy-base/main/appliance-gen1/build/vars/size-small
wget -O /root/update/vars/size-xl https://raw.githubusercontent.com/qnetix-io/qn-zprxy-base/main/appliance-gen1/build/vars/size-xl
wget -O /root/update/vars/varglobal https://raw.githubusercontent.com/qnetix-io/qn-zprxy-base/main/appliance-gen1/build/vars/varglobal
wget -O /root/update/vars/zabbix_agentd.general.conf https://raw.githubusercontent.com/qnetix-io/qn-zprxy-base/main/appliance-gen1/build/vars/zabbix_agentd.general.conf

cp /root/update/init.sh /var/lib/qnetix/init.sh
chmod +x /var/lib/qnetix/init.sh

cp /root/update/menu-appliance.sh /var/lib/qnetix/menu-appliance.sh
chmod +x /var/lib/qnetix/menu-appliance.sh

cp /root/update/menu-size.sh /var/lib/qnetix/menu-size.sh
chmod +x /var/lib/qnetix/menu-size.sh

cp -r /root/update/vars /var/lib/qnetix
