#!/bin/bash

# ==========================================
# SCAN MODULE - AIRSKULL
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
    echo "[$(date '+%H:%M:%S')] [SCAN] $1" >> "$LOG_FILE" 2>/dev/null
}

# ==========================================
# HEADER
# ==========================================
scan_header() {
    clear
    echo -e "${CYAN}=====================================${RESET}"
    echo -e "${GREEN}        AirSkull - Scanner${RESET}"
    echo -e "${CYAN}=====================================${RESET}"
    echo ""
}

# ==========================================
# CHECK COMMAND
# ==========================================
check_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo -e "${RED}[ERROR] Missing: $1${RESET}"
        log_action "Missing command: $1"
        return 1
    fi
    return 0
}

# ==========================================
# GET LOCAL NETWORK RANGE
# ==========================================
get_network() {
    ip route 2>/dev/null | grep "src" | awk '{print $1}' | head -n1
}

# ==========================================
# PING SWEEP (HOST DISCOVERY)
# ==========================================
ping_sweep() {
    scan_header

    NET=$(get_network)

    if [ -z "$NET" ]; then
        echo -e "${RED}Could not detect network${RESET}"
        read -p "Press enter..."
        return
    fi

    echo -e "${YELLOW}[+] Scanning network: $NET${RESET}"
    echo ""

    BASE=$(echo $NET | cut -d'.' -f1-3)

    for i in {1..254}; do
        IP="$BASE.$i"
        ping -c 1 -W 1 "$IP" &>/dev/null && echo -e "${GREEN}[UP] $IP${RESET}" &
    done

    wait
    log_action "Ping sweep on $NET"
    echo ""
    read -p "Press enter..."
}

# ==========================================
# NMAP QUICK SCAN
# ==========================================
nmap_quick() {
    scan_header

    if ! check_cmd nmap; then
        read -p "Press enter..."
        return
    fi

    read -p "Target: " target

    echo -e "${YELLOW}[+] Running quick scan...${RESET}"
    nmap -F "$target"

    log_action "Nmap quick scan $target"
    echo ""
    read -p "Press enter..."
}

# ==========================================
# NMAP FULL SCAN
# ==========================================
nmap_full() {
    scan_header

    if ! check_cmd nmap; then
        read -p "Press enter..."
        return
    fi

    read -p "Target: " target

    echo -e "${YELLOW}[+] Running full scan...${RESET}"
    nmap -A "$target"

    log_action "Nmap full scan $target"
    echo ""
    read -p "Press enter..."
}

# ==========================================
# PORT SCAN (CUSTOM)
# ==========================================
port_scan() {
    scan_header

    if ! check_cmd nmap; then
        read -p "Press enter..."
        return
    fi

    read -p "Target: " target
    read -p "Ports (e.g. 80,443): " ports

    echo -e "${YELLOW}[+] Scanning ports...${RESET}"
    nmap -p "$ports" "$target"

    log_action "Port scan $target:$ports"
    echo ""
    read -p "Press enter..."
}

# ==========================================
# WIFI SCAN (TERMUX)
# ==========================================
wifi_scan() {
    scan_header

    if command -v termux-wifi-scaninfo >/dev/null 2>&1; then
        echo -e "${YELLOW}[+] Scanning WiFi networks...${RESET}"
        termux-wifi-scaninfo
        log_action "WiFi scan"
    else
        echo -e "${RED}WiFi scan not supported${RESET}"
        log_action "WiFi scan failed"
    fi

    echo ""
    read -p "Press enter..."
}

# ==========================================
# DNS LOOKUP
# ==========================================
dns_lookup() {
    scan_header

    read -p "Domain: " domain

    if check_cmd nslookup; then
        nslookup "$domain"
    else
        ping -c 1 "$domain"
    fi

    log_action "DNS lookup $domain"
    echo ""
    read -p "Press enter..."
}

# ==========================================
# MAIN MENU
# ==========================================
scan_networks() {

while true; do
    scan_header

    echo "[1] Ping Sweep (LAN)"
    echo "[2] Nmap Quick Scan"
    echo "[3] Nmap Full Scan"
    echo "[4] Port Scan"
    echo "[5] WiFi Scan (Termux)"
    echo "[6] DNS Lookup"
    echo "[0] Back"
    echo ""

    read -p "Choose: " opt

    case $opt in
        1) ping_sweep ;;
        2) nmap_quick ;;
        3) nmap_full ;;
        4) port_scan ;;
        5) wifi_scan ;;
        6) dns_lookup ;;
        0) break ;;
        *) echo -e "${RED}Invalid option${RESET}"; sleep 1 ;;
    esac

done

}
