#!/bin/sh
# (c) Qnetix Ltd 2023 v1.2
# https://raw.githubusercontent.com/qnetix-io/qn-zprxy/main/appliance-gen1/init.sh


COL='\033[0;31m'
NCOL='\033[0m'

echo "  ";
echo -e " ${COL}

        ____                 __   _
       / __ \  ____   ___   / /_ (_)_  __
      / / / / / __ \ / _ \ / __// /| |/_/
     / /_/ / / / / //  __// /_ / /_>  <
     \___\_\/_/ /_/ \___/ \__//_//_/|_|

     ZABBIX PROXY APPLIANCE SETUP AND INIITIALISATION
     (c) Qnetix Ltd, 2023

     =========================================================
     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! |
     !!!!!!!!!!!!!!!!!!!!!!! WARNING !!!!!!!!!!!!!!!!!!!!!!! |
     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! |
     |                                                       |
     |      This process is destructive and irreversable     |
     |         Are you sure that you want to continue?       |
     |                                                       |
     |       NOTE, THIS WILL REMOVE ALL DOCKER CONTAINERS    |
     |             AND VOLUMES PRESENT ON THIS HOST          |
     |          ALONG WITH THE /var/lib/qnetix FOLDER        |
     |                                                       |
     =========================================================${NCOL}"

echo "   "
echo " Names must be set before running init"
echo " Type ctrl+c to abort script"
sleep 5

#
# Remove existing install
#

# Remove installed docker containers and point status files
docker kill $(docker ps -aq) 2> /dev/null
docker rm --force $(docker ps -aq) 2> /dev/null
docker rmi --force $(docker images -q) 2> /dev/null
docker volume rm --force $(docker volume ls -q) 2> /dev/null


#
# New install
#

## STARTUP ##
# Append common folders to the PATH to ensure that all basic commands are available.
# <add qnetix to path>
export PATH=':/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'


## DEPENDANCIES ##
# Check if dependancies are installed
if ! command -v git &> /dev/null
then
    echo "Git is not installed. Please install Git before running this script"
    exit 1
elif ! command -v docker &> /dev/null
then
    echo "Docker is not installed. Please install Docker before running this script"
    exit 1
else
    echo -e "All required dependencies are installed"
fi


## DOCKER ##
# Download the Zabbix-proxy-sqlite3 container
echo " "
echo " "
echo "Reconfiguring Proxy container"

echo "Downloading Zabbix Proxy container."
docker pull zabbix/zabbix-proxy-sqlite3:alpine-6.4-latest

# Load Variables
. /etc/zabbix/appliancesize
. /etc/zabbix/applianceconf

# Docker - Zabbix-proxy-sqlite3 

echo "Starting Zabbix Proxy container"

docker run -d --name zproxylite \
  -e ZBX_SERVER_HOST="monitor.qnetix.cloud:${CUSTOMERID}" \
  -e ZBX_HOSTNAME="${PROXYNAME}" \
  -e ZBX_TLSPSKIDENTITY="${TLSID}" \
  -e ZBX_TLSPSKFILE="/etc/zabbix/tlskey" \
  -e ZBX_TLSCONNECT="psk" \
  -e ZBA_TLSACCEPT="psk" \
  -e ZBX_STATSALLOWEDIP="monitor.qnetix.cloud" \
  -e ZBX_PROXYMODE="0" \
  -e ZBX_ENABLEREMOTECOMMANDS="1" \
  -e ZBX_LOGREMOTECOMMANDS="1" \
  -e ZBX_PINGERS="${ZBXPINGERS}" \
  -e ZBX_CACHESIZE="${ZBXCACHESIZE}" \
  -e ZBX_PROXYOFFLINEBUFFER="${ZBXPROXYOFFLINEBUFFER}" \
  -e ZBX_STARTPOLLERS="${ZBXSTARTPOLLERS}" \
  -e ZBX_STARTPREPROCESSORS="${ZBXSTARTPREPROCESSORS}" \
  -e ZBX_IPMIPOLLERS="${ZBXIPMIPOLLERS}" \
  -e ZBX_STARTPOLLERSUNREACHABLE="${ZBXSTARTPOLLERSUNREACHABLE}" \
  -e ZBX_STARTTRAPPERS="${ZBXSTARTTRAPPERS}" \
  -e ZBX_STARTPINGERS="${ZBXSTARTPINGERS}" \
  -e ZBX_STARTDISCOVERERS="${ZBXSTARTDISCOVERERS}" \
  -e ZBX_STARTHISTORYPOLLERS="${ZBXSTARTHISTORYPOLLERS}" \
  -e ZBX_STARTHTTPPOLLERS="${ZBXSTARTHTTPPOLLERS}" \
  -e ZBX_STARTVMWARECOLLECTORS="${ZBXSTARTVMWARECOLLECTORS}" \
  -e ZBX_VMWAREFREQUENCY="${ZBXVMWAREFREQUENCY}" \
  -e ZBX_VMWAREPERFFREQUENCY="${ZBXVMWAREPERFFREQUENCY}" \
  -e ZBX_VMWARECACHESIZE="${ZBXVMWARECACHESIZE}" \
  -e ZBX_VMWARETIMEOUT="${ZBXVMWARETIMEOUT}" \
  -e ZBX_LOGSLOWQUERIES="${ZBXLOGSLOWQUERIES}" \
  -v ${TLSFILE}:/etc/zabbix/tlskey \
  --restart always \
  zabbix/zabbix-proxy-sqlite3:alpine-6.4-latest

## DOCKER CHECKS ##
echo " "
echo " "
echo "Checking for errors"

# Define the container names
containers="zproxylite"

# Initialize a flag for tracking errors or warnings
errors_or_warnings=0

# Loop through each container
for container in $containers; do
    # Check if the container is running
    if docker ps --filter "name=${container}" --format '{{.Names}}' | grep -q -w "${container}"; then
        echo "Container '${container}' is running"

        # Check the container logs for errors or warnings
        log_output=$(docker logs "${container}" 2>&1)

        if echo "${log_output}" | grep -q -Ei "error|warning"; then
            echo "Found errors or warnings in '${container}' logs:"
            echo "${log_output}" | grep -Ei --color=always "error|warning"
            errors_or_warnings=1
        else
            echo "No errors or warnings found in '${container}' logs"
        fi
    else
        echo "Container '${container}' is not running"
        errors_or_warnings=1
    fi
done

# Echo the result based on the flag
if [ ${errors_or_warnings} -eq 1 ]; then
    #echo "One or more containers have errors or warnings"
    echo -e "One or more containers have errors or warnings"
else
    #echo "All containers are running correctly without errors or warnings."
    echo -e "All containers are running correctly without errors or warnings"
fi


## LOCAL ZABBIX AGENT ##
echo " "
echo " "
echo "Reconfiguring local agent"
rc-service zabbix-agentd stop
rm -r /var/log/zabbix/*
cp /var/lib/qnetix/vars/zabbix_agentd.general.conf /etc/zabbix/zabbix_agentd.general.conf

# Load Variables
. /etc/zabbix/applianceconf

# Set Config
sed -i "s/Hostname=<hostname>/Hostname=${PROXYNAME}/g" /etc/zabbix/zabbix_agentd.general.conf
sed -i "s/TLSPSKIdentity=<hostname>/TLSPSKIdentity=${TLSID}/g" /etc/zabbix/zabbix_agentd.general.conf

# Start service
rc-service zabbix-agentd restart
#rc-update add zabbix-agentd boot


## CLOSE ##
echo " "
echo " "
echo "All complete"

echo "Type 'menu' to return to menu"

