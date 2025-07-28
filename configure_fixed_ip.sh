#!/bin/bash

# File: configure_fixed_ip.sh
# Description: Asks for IP, Gateway, and DNS, then configures a fixed IP using nmcli.

# Define the name of the network connection
CONNECTION_NAME="Wired connection 1"

# Get IP address from user
dialog --inputbox "Enter the static IP address (e.g., 192.168.1.100/24):" 8 50 2>/tmp/ip_input.txt
[ $? -ne 0 ] && exit 1
IP_ADDRESS=$(< /tmp/ip_input.txt)

# Get gateway from user
dialog --inputbox "Enter the gateway IP (e.g., 192.168.1.1):" 8 50 2>/tmp/gateway_input.txt
[ $? -ne 0 ] && exit 1
GATEWAY=$(< /tmp/gateway_input.txt)

# Get DNS from user
dialog --inputbox "Enter the DNS server IP (e.g., 8.8.8.8):" 8 50 2>/tmp/dns_input.txt
[ $? -ne 0 ] && exit 1
DNS=$(< /tmp/dns_input.txt)

# Clean up temp files
rm -f /tmp/ip_input.txt /tmp/gateway_input.txt /tmp/dns_input.txt

# Apply the fixed IP settings using nmcli
nmcli connection modify "$CONNECTION_NAME" ipv4.addresses "$IP_ADDRESS"
nmcli connection modify "$CONNECTION_NAME" ipv4.gateway "$GATEWAY"
nmcli connection modify "$CONNECTION_NAME" ipv4.dns "$DNS"
nmcli connection modify "$CONNECTION_NAME" ipv4.method manual

# Restart the connection to apply changes
nmcli connection down "$CONNECTION_NAME"
nmcli connection up "$CONNECTION_NAME"

# Show confirmation
dialog --msgbox "Fixed IP configuration applied successfully:\n\nIP: $IP_ADDRESS\nGateway: $GATEWAY\nDNS: $DNS" 10 60
