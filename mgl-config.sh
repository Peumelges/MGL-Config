#!/bin/bash

# File: mgl-config.sh
# Description:
# This script provides a dialog-based interactive menu for managing system settings.
# The user can choose from the following options:
#   1. Configure Fixed IP
#   2. Set Zabbix Proxy
#   3. Check Zabbix Log
# Each option runs a separate script (to be created later).

# Function to display the menu using 'dialog'
show_menu() {
    dialog --clear \
           --backtitle "MGL Configuration Tool" \
           --title "Main Menu" \
           --menu "Select an option:" 15 50 5 \
           1 "Configure Fixed IP" \
           2 "Set Zabbix Proxy" \
           3 "Check Zabbix Log" \
           0 "Exit" 2>menu_choice.txt

    # Store the selected option in a variable
    choice=$(<menu_choice.txt)
    rm -f menu_choice.txt  # Delete the temporary file
}

# Main loop - shows the menu until the user chooses to exit
while true; do
    show_menu

    case $choice in
        1)
            # Run the script responsible for configuring a fixed IP
            bash configure_fixed_ip.sh
            ;;
        2)
            # Run the script responsible for setting the Zabbix proxy
            bash set_zabbix_proxy.sh
            ;;
        3)
            # Run the script that checks the Zabbix log file
            bash check_zabbix_log.sh
            ;;
        0)
            # Exit the script
            clear
            echo "Exiting MGL Configuration. Goodbye!"
            break
            ;;
        *)
            # Handle unexpected/invalid input
            dialog --msgbox "Invalid selection. Please try again." 6 40
            ;;
    esac
done
