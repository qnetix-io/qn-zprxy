# (c) Qnetix Ltd 2023

menu() {
clear
echo "  "
echo "
     ZABBIX PROXY SIZE

     1. Small
     2. Medium
     3. Large
     4. X-Large
     5. Edit Existing

     x. Exit Menu
"

echo -n "     Enter your menu choice: "
}

menu

while :
do
read choice

case $choice in

  1)  cp /var/lib/qnetix/vars/size-small /etc/zabbix/appliancesize
      echo  "  "
      read -p "     Complete, Press any key to continue"
      menu;;

  2)  cp /var/lib/qnetix/vars/size-med /etc/zabbix/appliancesize
      echo  "  "
      read -p "     Complete, Press any key to continue"
      menu;;

  3)  cp /var/lib/qnetix/vars/size-large /etc/zabbix/appliancesize
      echo  "  "
      read -p "     Complete, Press any key to continue"
      menu;;

  4)  cp /var/lib/qnetix/vars/size-xl /etc/zabbix/appliancesize
      echo  "  "
      read -p "     Complete, Press any key to continue"
      menu;;

  5)  nano /etc/zabbix/appliancesize
      menu;;

  x)  clear
      exit;;

  *) echo "invalid option";;

esac

done