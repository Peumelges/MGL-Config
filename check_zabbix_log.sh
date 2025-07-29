#!/bin/bash

# File: check_zabbix_log.sh
# Description:
# This script displays:
#   - Zabbix proxy service status and last 5 lines of its log
#   - Zabbix agentd service status and last 5 lines of its log

# Define log file paths
PROXY_LOG="/var/log/zabbix/zabbix_proxy.log"
AGENT_LOG="/var/log/zabbix/zabbix_agentd.log"

# Get Zabbix proxy service status
PROXY_STATUS=$(systemctl is-active zabbix-proxy)
PROXY_STATUS_COLOR="OK"
[[ "$PROXY_STATUS" != "active" ]] && PROXY_STATUS_COLOR="NOT RUNNING"

# Get last 5 lines of proxy log
PROXY_LOG_OUTPUT="Log file not found."
[[ -f "$PROXY_LOG" ]] && PROXY_LOG_OUTPUT=$(tail -n 5 "$PROXY_LOG")

# Show proxy status and log
dialog --title "Zabbix Proxy Status" \
       --msgbox "Service status: $PROXY_STATUS_COLOR\n\nLast 5 log lines:\n$PROXY_LOG_OUTPUT" 15 70

# Get Zabbix agentd service status
AGENT_STATUS=$(systemctl is-active zabbix-agent)
AGENT_STATUS_COLOR="OK"
[[ "$AGENT_STATUS" != "active" ]] && AGENT_STATUS_COLOR="NOT RUNNING"

# Get last 5 lines of agent log
AGENT_LOG_OUTPUT="Log file not found."
[[ -f "$AGENT_LOG" ]] && AGENT_LOG_OUTPUT=$(tail -n 5 "$AGENT_LOG")

# Show agent status and log
dialog --title "Zabbix Agent Status" \
       --msgbox "Service status: $AGENT_STATUS_COLOR\n\nLast 5 log lines:\n$AGENT_LOG_OUTPUT" 15 70
