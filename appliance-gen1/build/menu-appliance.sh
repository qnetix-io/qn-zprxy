# (c) Qnetix Ltd 2023
COL='\033[0;36m'
NCOL='\033[0m'

menu() {
clear
echo "  "
echo -e " ${COL}

        ____                 __   _
       / __ \  ____   ___   / /_ (_)_  __
      / / / / / __ \ / _ \ / __// /| |/_/
     / /_/ / / / / //  __// /_ / /_>  <
     \___\_\/_/ /_/ \___/ \__//_//_/|_|

     ZABBIX PROXY APPLIANCE
     (c) Qnetix Ltd, 2023${NCOL}"

echo "
     APPLIANCE SETTINGS

     1. Configure Appliance
     2. Update Appliance
     3. Reboot Appliance


     ZABBIX PROXY SETTINGS

     4. Configure Proxy (Size)
     5. Configure Proxy (Initialise)
     6. Configure Proxy (Settings)
     7. Configure Agent

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

  x)  clear
      exit;;

  *) echo "invalid option";;

esac

done