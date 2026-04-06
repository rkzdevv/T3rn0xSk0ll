#!/bin/bash

# ==========================================
# INTERFACE MODULE - AIRSKULL
# ==========================================

# ==========================================
# COLORS
# ==========================================
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

LOG_FILE="../logs/airskull.log"

# ==========================================
# LOGGER
# ==========================================
log_action() {
    mkdir -p ../logs
    touch "$LOG_FILE"
    echo "[$(date '+%H:%M:%S')] [INTERFACE] $1" >> "$LOG_FILE" 2>/dev/null
}

# ==========================================
# HEADER
# ==========================================
iface_header() {
    clear
    echo -e "${CYAN}=====================================${RESET}"
    echo -e "${GREEN}        AirSkull - Interfaces${RESET}"
    echo -e "${CYAN}=====================================${RESET}"
    echo ""
}

# ==========================================
# CHECK COMMAND
# ==========================================
check_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo -e "${RED}[ERROR] Command not found: $1${RESET}"
        log_action "Missing command: $1"
        return 1
    fi
    return 0
}

# ==========================================
# SHOW ALL INTERFACES
# ==========================================
list_interfaces() {
    iface_header
    echo -e "${YELLOW}[+] Listing interfaces...${RESET}"
    echo ""

    if check_cmd ip; then
        ip -o link show | awk -F': ' '{print $2}' | while read iface; do
            echo -e "${GREEN}• $iface${RESET}"
        done
    else
        echo -e "${RED}ip command not available${RESET}"
    fi

    log_action "Listed interfaces"
    echo ""
    read -p "Press enter..."
}

# ==========================================
# SHOW DETAILED INFO
# ==========================================
show_interface_details() {
    iface_header
    read -p "Enter interface name: " iface

    if [ -z "$iface" ]; then
        echo -e "${RED}Invalid interface${RESET}"
        sleep 1
        return
    fi

    if check_cmd ip; then
        ip a show "$iface" 2>/dev/null || echo -e "${RED}Interface not found${RESET}"
    fi

    log_action "Viewed interface $iface"
    echo ""
    read -p "Press enter..."
}

# ==========================================
# CHECK STATUS
# ==========================================
check_status() {
    iface_header
    echo -e "${YELLOW}[+] Interface status:${RESET}"
    echo ""

    if check_cmd ip; then
        ip -o link show | while read line; do
            iface=$(echo "$line" | awk -F': ' '{print $2}')
            state=$(echo "$line" | grep -o "state [A-Z]*" | awk '{print $2}')
            echo -e "${CYAN}$iface${RESET} → ${GREEN}$state${RESET}"
        done
    fi

    log_action "Checked interface status"
    echo ""
    read -p "Press enter..."
}

# ==========================================
# SHOW MAC ADDRESS
# ==========================================
show_mac() {
    iface_header
    read -p "Interface: " iface

    if check_cmd ip; then
        mac=$(ip link show "$iface" 2>/dev/null | grep "link/" | awk '{print $2}')
        if [ -n "$mac" ]; then
            echo -e "${GREEN}MAC: $mac${RESET}"
        else
            echo -e "${RED}Interface not found${RESET}"
        fi
    fi

    log_action "MAC checked for $iface"
    echo ""
    read -p "Press enter..."
}

# ==========================================
# TERMUX WIFI INFO
# ==========================================
termux_wifi_info() {
    iface_header
    echo -e "${YELLOW}[+] Checking WiFi info...${RESET}"
    echo ""

    if command -v termux-wifi-connectioninfo >/dev/null 2>&1; then
        termux-wifi-connectioninfo
        log_action "WiFi info checked"
    else
        echo -e "${RED}Not supported on this device${RESET}"
        log_action "WiFi info not supported"
    fi

    echo ""
    read -p "Press enter..."
}

# ==========================================
# QUICK SUMMARY
# ==========================================
quick_summary() {
    iface_header
    echo -e "${YELLOW}[+] Quick Summary${RESET}"
    echo ""

    if check_cmd ip; then
        ip -brief a
    fi

    log_action "Quick summary viewed"
    echo ""
    read -p "Press enter..."
}

# ==========================================
# MAIN MENU
# ==========================================
show_interfaces() {

while true; do
    iface_header

    echo "[1] List Interfaces"
    echo "[2] Interface Details"
    echo "[3] Status Check"
    echo "[4] Show MAC Address"
    echo "[5] WiFi Info (Termux)"
    echo "[6] Quick Summary"
    echo "[0] Back"
    echo ""

    read -p "Choose: " opt

    case $opt in
        1) list_interfaces ;;
        2) show_interface_details ;;
        3) check_status ;;
        4) show_mac ;;
        5) termux_wifi_info ;;
        6) quick_summary ;;
        0) break ;;
        *) echo -e "${RED}Invalid option${RESET}"; sleep 1 ;;
    esac

done

}
