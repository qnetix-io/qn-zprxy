#!/bin/sh
# (c) Qnetix Ltd 2023
#https://raw.githubusercontent.com/qnetix-io/qn-zprxy/main/appliance-gen1/init.sh


## DIRECTORIES ##
rm -f -r /root/update
mkdir /root/update
mkdir /root/update/vars


## EXEC ##
execfiles="init.sh init-names.sh menu-appliance.sh menu-size.sh getkey.sh"
for execfile in $execfiles; do

    echo "File Update: '${execfile}'"

    wget -O /root/update/${execfile} https://raw.githubusercontent.com/qnetix-io/qn-zprxy/main/appliance-gen1/${execfile}
    cp /root/update/${execfile} /var/lib/qnetix/${execfile}
    chmod +x /var/lib/qnetix/${execfile}

done


## VAR ##
varfiles="size-large size-med size-small size-xl zabbix_agentd.general.conf"
for varfile in $varfiles; do

    echo "Var Update: '${varfile}'"

    wget -O /root/update/vars/${varfile} https://raw.githubusercontent.com/qnetix-io/qn-zprxy/main/appliance-gen1/vars/${varfile}
    cp /root/update/vars/${varfile} /var/lib/qnetix/vars/${varfile}

done


## ALIAS ##
wget -O /etc/profile.d/90qnetix.sh https://raw.githubusercontent.com/qnetix-io/qn-zprxy/main/appliance-gen1/90qnetix.sh
chmod +x /etc/profile.d/90qnetix.sh