#!/bin/sh
# (c) Qnetix Ltd 2023 v1.2
COL='\033[0;36m'
NCOL='\033[0m'

menu() {
clear
echo -e " ${COL}
        ____                 __   _
       / __ \  ____   ___   / /_ (_)_  __
      / / / / / __ \ / _ \ / __// /| |/ /
     / /_/ / / / / //  __// /_ / / >  <
     \___\_\/_/ /_/ \___/ \__//_/ /_/|_|

     ZABBIX PROXY APPLIANCE
     (c) Qnetix Ltd, 2023${NCOL}"

echo "
     APPLIANCE
     1.  Configure Appliance
     2.  Update Appliance
     3.  Reboot Appliance

     ZABBIX PROXY
     4.  Configure Proxy (Size)
     5.  Configure Proxy (Names)
     6.  Configure Proxy (Initialise)
     7.  Show Zabbix Proxy Log
     8.  Restart Zabbix Proxy

     ZABBIX AGENT
     9.  Configure Host Agent
     10. Show Zabbix Agent Log
     11. Restart Zabbix Agent

     OTHER
     12. Show Key Information
     13. Network Monitor
     14. Edit Appliance Hosts File

     u. Update Build Files
     x. Exit Menu
"

echo -n "     Enter your menu choice: "
}

menu

while :
do
read choice

case $choice in

  1)  clear && echo "Type 'menu' to return to main menu" && /sbin/setup-dns && /sbin/setup-hostname && /sbin/setup-interfaces &&  echo " " && read -p "Press any key to continue" && menu;;
  2)  clear && apk update && apk upgrade && read -p "Press any key to continue" && menu;;
  3)  reboot;;

  4)  /var/lib/qnetix/menu-size.sh && menu;;
  5)  /var/lib/qnetix/init-names.sh && menu;;
  6)  clear && /var/lib/qnetix/init.sh && exit;;
  7)  docker logs zproxylite && read -p "Press any key to continue" && menu;;
  8)  clear && docker restart zproxylite && docker container list && read -p "Press any key to continue" && menu;;

  9)  nano /etc/zabbix/zabbix_agentd.general.conf && menu;;
  10) clear && tail -200 /var/log/zabbix/zabbix_agentd.log && read -p "Press any key to continue" && menu;;
  11) rm /var/log/zabbix/zabbix_agentd.log && rc-service zabbix-agentd restart && read -p "Press any key to continue" && menu;;

  12) clear && exec /var/lib/qnetix/getkey.sh && menu;;
  13) iptraf-ng && menu;;
  14) clear && nano /etc/hosts && menu;;

  u)  clear 
      echo " "
      rm /root/getupdates.sh
      wget -O /root/getupdates.sh https://raw.githubusercontent.com/qnetix-io/qn-zprxy/main/appliance-gen1/getupdates.sh
      chmod +x /root/getupdates.sh
      /root/getupdates.sh
      read -p "Press any key to continue"
      menu;;

  x)  clear
      exit;;

  *) echo "invalid option, Please try again";;

esac

done