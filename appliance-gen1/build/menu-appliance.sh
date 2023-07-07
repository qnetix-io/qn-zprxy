# (c) Qnetix Ltd 2023
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
     APPLIANCE SETTINGS

     1.  Configure Appliance
     2.  Update Appliance
     3.  Reboot Appliance
    
     ZABBIX PROXY SETTINGS

     4.  Configure Proxy (Size)
     5.  Configure Proxy (Initialise)
     6.  Configure Proxy (Settings)
     7.  Configure Host Agent
     8.  Show Key Information

     TROUBLESHOOTING    
     9.  Show Zabbix Network Traffic
     10. Show Zabbix Local Agent Log
     11. Restart Appliance Agent
     12. Edit Appliance Hosts File

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

  1)  clear
      echo "Type 'menu' to return to main menu"
      /sbin/setup-dns && /sbin/setup-hostname && /sbin/setup-interfaces
      echo "   "
      read -p "Press any key to continue"
      menu;;

  2)  clear
      apk update && apk upgrade
      read -p "Press any key to continue"
      menu;;

  3)  reboot
      read -p "Press any key to continue"
      menu;;

  4)  /var/lib/qnetix/menu-size.sh
      menu;;

  5)  clear
      exec /var/lib/qnetix/init.sh
      menu;;

  6)  nano /var/lib/qnetix/vars/varglobal
      menu;;

  7)  nano /etc/zabbix/zabbix_agentd.general.conf
      menu;;

  8)  clear && exec /var/lib/qnetix/getkey.sh && menu;;

  9)  tcpdump 'port 10051';;
  10) tail -50 /var/log/zabbix/zabbix_agentd.log;;
  11) rc-service zabbix-agentd restart && menu;;
  12) nano /etc/hosts && menu;;

  u)  clear
      echo " "
      rm /root/getupdates.sh
      wget -O /root/getupdates.sh https://raw.githubusercontent.com/qnetix-io/qn-zprxy-base/main/appliance-gen1/build/getupdates.sh
      chmod +x /root/getupdates.sh
      /root/getupdates.sh
      menu;;

  x)  clear
      exit;;

  *) echo "invalid option";;

esac

done