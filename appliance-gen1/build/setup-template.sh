# Gen 1 Template General Setup

#
# mst1 - Clean installed image
#

#lvmsys
#defaults for the rest
#no additional users
#GB timezone
#1st mirror
#no special config


#
# mst2 - Zabbix Proxy Appliance Configuration
#

# Change root password
passwd


# Set Repo and Update 
apk update
apk add nano

nano /etc/apk/repositories
# UNCOMMENT COMMUNITY REPO

#http://dl-cdn.alpinelinux.org/alpine/v3.18/main
#http://dl-cdn.alpinelinux.org/alpine/v3.18/community

https://uk.alpinelinux.org:443/alpine/edge/main
https://uk.alpinelinux.org:443/alpine/edge/community
http://alpine.mirror.wearetriple.com/edge/main
http://alpine.mirror.wearetriple.com/edge/community

apk upgrade

reboot


# Packages
apk add dialog git docker zabbix-agent open-vm-tools mc

# open-vm-tools
rc-service open-vm-tools start
rc-update add open-vm-tools boot

# docker
adduser -SDHs /sbin/nologin dockremap
addgroup -S dockremap

echo dockremap:$(cat /etc/passwd|grep dockremap|cut -d: -f3):65536 >> /etc/subuid
echo dockremap:$(cat /etc/passwd|grep dockremap|cut -d: -f4):65536 >> /etc/subgid

mkdir /etc/docker
nano /etc/docker/daemon.json

{
    "userns-remap": "dockremap",
    "experimental": false,
    "ipv6":         false,
    "icc":          false,
    "no-new-privileges": false
}

nano /etc/update-extlinux.conf

    default_kernel_opts="quiet rootfstype=ext4 cgroup_enable=memory swapaccount=1"

update-extlinux

rc-service docker start
rc-update add docker boot

# Mesage of the day (edit)
nano /etc/motd
    # Clean

# Edit zabbix agent configuration
nano /etc/zabbix/zabbix_agentd.conf

    # Qnetix configuration include file
    Include=/etc/zabbix/zabbix_agentd.general.conf

nano /etc/zabbix/zabbix_agentd.general.conf

    # Qnetix configuration include file
    LogFileSize=500
    Server=master-01.qnetix.cloud
    Hostname=<hostname>
    EnableRemoteCommands=1
    LogRemoteCommands=1

    # TLS Certificates
    #TLSConnect=cert
    #TLSAccept=cert
    #TLSCAFile=
    #TLSCertFile=
    #TLSKeyFile=

    # TLS Preshared

# Start service
# rc-service zabbix-agentd 

# Edit sbin interface setup 
nano /sbin/setup-interfaces

unconfigured_detect() {
        local i=
        for i in ${INTERFACES:-$(available_ifaces)}; do
            if [ "$i" != "lo" ]; then
                if [ "$i" != "docker0" ]; then
                        unconfigured_add $i
                fi
            fi
        done
}

# Set name
    setup-hostname   = zabbix-proxy
    setup-dns  =qnetix.cloud
    
# Setup alias file (runs at logon)
    nano /etc/profile.d/alias.sh

# Chrony
    nano /etc/chrony/chrony.conf
    pool pool.ntp.org iburst minpoll 12
    rc-service chronyd restart

# Install tcpdump   
    apk add tcpdump