#!/bin/bash

# File: set_zabbix_credentials.sh
# Description:
# This script updates the 'Hostname=' line in /etc/zabbix/zabbix_proxy.conf
# It uses 'dialog' to get the server address from the user and replaces the existing value.

CONFIG_FILE="/etc/zabbix/zabbix_proxy.conf"

# Check if the config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    dialog --msgbox "Zabbix proxy config file not found at $CONFIG_FILE." 6 50
    exit 1
fi

# Ask the user for the new Zabbix server address
dialog --inputbox "Enter the new Zabbix Proxy Name :" 8 50 2>/tmp/zabbix_server_input.txt
response=$?

# Handle cancel or escape
if [[ $response -ne 0 ]]; then
    rm -f /tmp/zabbix_server_input.txt
    exit 1
fi

NEW_SERVER=$(< /tmp/zabbix_server_input.txt)
rm -f /tmp/zabbix_server_input.txt

# If input is empty, warn and exit
if [[ -z "$NEW_SERVER" ]]; then
    dialog --msgbox "No server Proxy Name. No changes made." 6 50
    exit 1
fi

# Backup the original config file
# Create the backup directory if it doesn't exist
mkdir -p "/etc/zabbix/backup-conf"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
cp "$CONFIG_FILE" "/etc/zabbix/backup-conf/zabbix_proxy.conf.bak.$TIMESTAMP"

# Replace the Hostname= line with the new value using sed
sed -i "s/^Hostname=.*/Hostname=${NEW_SERVER}/" "$CONFIG_FILE"

# Replace the Hostname= line with the new value using sed
sed -i "s/^TLSPSKIdentity=.*/TLSPSKIdentity=${NEW_SERVER}/" "$CONFIG_FILE"

# Confirm success
dialog --msgbox "Zabbix proxy server updated to:\n$NEW_SERVER" 7 50


#------- Altering the Agent file ----------

CONFIG_FILE="/etc/zabbix/zabbix_agentd.conf"

# Backup the original config file
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
cp "$CONFIG_FILE" "/etc/zabbix/backup-conf/zabbix_agentd.conf.bak.$TIMESTAMP"

# Replace the Hostname= line with the new value using sed
sed -i "s/^Hostname=.*/Hostname=${NEW_SERVER}/" "$CONFIG_FILE"

# Confirm success
dialog --msgbox "Zabbix agent server updated to:\n$NEW_SERVER" 7 50
