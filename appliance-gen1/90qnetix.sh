# Alias
alias menu='/var/lib/qnetix/menu-appliance.sh'
alias update='rm /root/getupdates.sh;
wget -O /root/getupdates.sh https://raw.githubusercontent.com/qnetix-io/qn-zprxy/main/appliance-gen1/getupdates.sh;
chmod +x /root/getupdates.sh;
/root/getupdates.sh'

# Load menu
/var/lib/qnetix/menu-appliance.sh
