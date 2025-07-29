#!/bin/bash

#!/bin/bash

# File: check_zabbix_log.sh
# Description: Check Zabbix log.
#              


# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Installing dialog..."
    sudo apt update && sudo apt install -y dialog
fi

# Function to display a message box
message_box() {
    dialog --title "$1" --msgbox "$2" 10 60
}

# Start dialog flow
dialog --title "Zabbix Proxy Installer" --yesno "This script will install Zabbix Proxy 7.0 with SQLite3 on Debian 12.\n\nContinue?" 10 60
response=$?
if [ $response -ne 0 ]; then
    clear
    echo "Installation cancelled."
    exit 1
fi

# Download Zabbix release package
message_box "Step 1" "Downloading Zabbix repository package..."
wget https://repo.zabbix.com/zabbix/7.0/raspbian/pool/main/z/zabbix-release/zabbix-release_latest_7.0+debian12_all.deb

# Install release package
message_box "Step 2" "Installing Zabbix repository..."
sudo dpkg -i zabbix-release_latest_7.0+debian12_all.deb

# Update package list
message_box "Step 3" "Updating package list..."
sudo apt update

# Install Zabbix proxy and agent
message_box "Step 4" "Installing Zabbix Proxy with SQLite3 and Zabbix Agent..."
sudo apt install -y zabbix-proxy-sqlite3 zabbix-agent

# Generate PSK
message_box "Step 5" "Generating PSK key for secure communication..."
sudo openssl rand -hex 32 | sudo tee /etc/zabbix/prxzbx.psk > /dev/null

# Permissions
message_box "Step 6" "Setting permissions for user zabbix..."
sudo mkdir -p /tmp /var/log/zabbix /etc/zabbix
sudo chown zabbix:zabbix /tmp /var/log/zabbix /etc/zabbix
sudo chmod 770 /tmp /var/log/zabbix /etc/zabbix

# Enable and restart services
message_box "Step 7" "Restarting and enabling Zabbix services..."
sudo systemctl restart zabbix-proxy
sudo systemctl enable zabbix-proxy

sudo systemctl restart zabbix-agent
sudo systemctl enable zabbix-agent

# Completion
message_box "Done" "Zabbix Proxy installation, configuration, and service setup complete!"

clear
echo "Zabbix Proxy installation complete!"
