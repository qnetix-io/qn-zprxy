# Gen 1 Template Proxy Setup

# Download files
    mkdir /var/lib/qnetix
    chmod 700 -R /var/lib/qnetix/

    # upload files to /var/lib/qnetix
    # menu-appliance
    # menu-size
    # init
    # /vars folder

    chmod +x /var/lib/qnetix/*.sh

# Set menu alias
    nano /etc/profile.d/90qnetix.sh

# Alias
alias menu='/var/lib/qnetix/menu-appliance.sh'
alias update='rm /root/getupdates.sh;
wget -O /root/getupdates.sh https://raw.githubusercontent.com/qnetix-io/qn-zprxy-base/main/appliance-gen1/build/getupdates.sh;
chmod +x /root/getupdates.sh;
/root/getupdates.sh'

# Load menu
/var/lib/qnetix/menu-appliance.sh








