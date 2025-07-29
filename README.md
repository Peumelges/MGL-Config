# Zabbix Proxy configuration for Debian 12

This repository contains an interactive Bash script that automates the installation and initial configuration of **Zabbix Proxy 7.0** using **SQLite3** on **Debian 12** systems.

The script uses the `dialog` utility to create a user-friendly, step-by-step guided installation process via text-based dialogs.

---

## Features

✅ Interactive `dialog`-based interface  
✅ Installs Zabbix Proxy 7.0 and Zabbix Agent  
✅ Automatically sets up Zabbix repository for Debian 12  
✅ Generates a secure PSK file for encrypted communication  
✅ Grants proper permissions to the `zabbix` user  
✅ Enables and starts the Zabbix Proxy and Agent services  

---

## Script Flow

The script performs the following steps:

1. **Checks for `dialog`** and installs it if not found.
2. **Downloads the official Zabbix repository package** for Debian 12.
3. **Installs the Zabbix release package** and updates the package list.
4. **Installs Zabbix Proxy with SQLite3 and Zabbix Agent**.
5. **Generates a 32-byte hex-encoded PSK** file at `/etc/zabbix/prxzbx.psk`.
6. **Sets correct read/write permissions** for the `zabbix` user on:
   - `/tmp/`
   - `/var/log/zabbix/`
   - `/etc/zabbix/`
7. **Restarts and enables the following services**:
   - `zabbix-proxy`
   - `zabbix-agent`
8. **Displays progress and status using dialog boxes**.

---

## Requirements

- Debian 12 (Bookworm)
- Root or `sudo` privileges
- Internet connection

---

## Usage

1. Clone the repository:

   ```bash
   git clone https://github.com/Peumelges/MGL-Config.git
2. Cd in to the repository:
   ```bash
   cd MGL-Config/
3. Run the main Script:
   ```bash
   sudo bash mgl-config.sh

