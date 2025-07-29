#!/bin/bash

# File: mgl-config.sh
# Description: Interactive menu for MGL configuration using 'dialog'.
#              Submenu added under "Set Zabbix Proxy" for:
#              1. Set Zabbix server
#              2. Set Zabbix proxy credentials
#              3. Check zabbix log
#              4. Install zabbix proxy and agent




# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Installing dialog..."
    sudo apt update && sudo apt install -y dialog
fi


# Function to display the main menu
show_menu() {
    dialog --clear \
           --backtitle "MGL Configuration Tool" \
           --title "Main Menu" \
           --menu "Select an option:" 15 50 5 \
           1 "Configure Fixed IP" \
           2 "Set Zabbix Proxy" \
           3 "Check Zabbix Log" \
           4 "Install zabbix proxy and agent" \           
           0 "Exit" 2>menu_choice.txt

    choice=$(<menu_choice.txt)
    rm -f menu_choice.txt
}

# Function for the Zabbix Proxy submenu
zabbix_proxy_menu() {
    dialog --clear \
           --backtitle "Zabbix Proxy Configuration" \
           --title "Zabbix Proxy Options" \
           --menu "Select an action:" 15 50 4 \
           1 "Set Zabbix Server Address" \
           2 "Set Zabbix Proxy Credentials" \
           0 "Back to Main Menu" 2>zabbix_choice.txt

    zabbix_choice=$(<zabbix_choice.txt)
    rm -f zabbix_choice.txt

    case $zabbix_choice in
        1)
            # Run script to set Zabbix server address
            bash set_zabbix_proxy.sh
            ;;
        2)
            # Run script to set Zabbix proxy credentials
            bash set_zabbix_credentials.sh
            ;;
        3)
            # Run script to set Zabbix proxy credentials
            bash check_zabbix_log.sh
            ;;
        4)
            # Run script to set Zabbix proxy credentials
            bash install_zabbix.sh            
        0)
            # Do nothing, return to main menu
            ;;
        *)
            dialog --msgbox "Invalid selection. Try again." 6 40
            ;;
    esac
}

# Main menu loop
while true; do
    show_menu

    case $choice in
        1)
            bash configure_fixed_ip.sh
            ;;
        2)
            zabbix_proxy_menu  # Show submenu for Zabbix Proxy
            ;;
        3)
            bash check_zabbix_log.sh
            ;;
        4)
            bash install_zabbix.sh
            ;;
        0)
            clear
            echo "Exiting MGL Configuration."
            echo "--------Rede--------"
            ifconfig | grep -A2 "eth0:*"
            echo "--------Hostname_Proxy--------"
            cat /etc/zabbix/zabbix_proxy.conf | grep "^Hostname="
            echo "--------Server_Proxy--------"
            cat /etc/zabbix/zabbix_proxy.conf | grep "^Server="
            echo "--------Proxy_PSK--------"
            cat /etc/zabbix/prxzbx.psk
            echo "--------TLSPSKIdentity--------"
            cat /etc/zabbix/zabbix_proxy.conf | grep "^TLSPSKIdentity="          
            echo "--------Hostname_Agent--------"
            cat /etc/zabbix/zabbix_agentd.conf | grep "^Hostname="
            echo "--------Server_Agent--------"
            cat /etc/zabbix/zabbix_agentd.conf | grep "^ServerActive="
            echo "----------------"
            echo "Goodbye!"
            break
            ;;
        *)
            dialog --msgbox "Invalid selection. Please try again." 6 40
            ;;
    esac
done
