#!/bin/bash

# ==========================================
# IPINFO MODULE - AIRSKULL
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
    echo "[$(date '+%H:%M:%S')] [IPINFO] $1" >> "$LOG_FILE" 2>/dev/null
}

# ==========================================
# HEADER
# ==========================================
ip_header() {
    clear
    echo -e "${CYAN}=====================================${RESET}"
    echo -e "${GREEN}        AirSkull - IP Info${RESET}"
    echo -e "${CYAN}=====================================${RESET}"
    echo ""
}

# ==========================================
# CHECK INTERNET
# ==========================================
check_internet() {
    ping -c 1 8.8.8.8 &>/dev/null
    return $?
}

# ==========================================
# VALIDATE IP
# ==========================================
validate_ip() {
    local ip=$1
    [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]
}

# ==========================================
# LOCAL IP
# ==========================================
local_ip() {
    ip_header
    echo -e "${YELLOW}[+] Local IP:${RESET}"
    ip a
    log_action "Local IP checked"
    echo ""
    read -p "Press enter..."
}

# ==========================================
# PUBLIC IP
# ==========================================
public_ip() {
    ip_header
    echo -e "${YELLOW}[+] Public IP:${RESET}"

    if check_internet; then
        curl -s ifconfig.me
    else
        echo -e "${RED}No internet connection${RESET}"
    fi

    log_action "Public IP checked"
    echo ""
    read -p "Press enter..."
}

# ==========================================
# GEOLOCATION
# ==========================================
geo_lookup() {
    ip_header
    read -p "Enter IP: " ip

    if ! validate_ip "$ip"; then
        echo -e "${RED}Invalid IP${RESET}"
        sleep 1
        return
    fi

    echo -e "${YELLOW}[+] Fetching info...${RESET}"

    if check_internet; then
        curl -s ipinfo.io/"$ip"
    else
        echo -e "${RED}No internet${RESET}"
    fi

    log_action "Geo lookup $ip"
    echo ""
    read -p "Press enter..."
}

# ==========================================
# ISP / ASN
# ==========================================
isp_lookup() {
    ip_header
    read -p "Enter IP: " ip

    if ! validate_ip "$ip"; then
        echo -e "${RED}Invalid IP${RESET}"
        sleep 1
        return
    fi

    if check_internet; then
        curl -s ipinfo.io/"$ip"/org
    else
        echo -e "${RED}No internet${RESET}"
    fi

    log_action "ISP lookup $ip"
    echo ""
    read -p "Press enter..."
}

# ==========================================
# DNS LOOKUP
# ==========================================
dns_lookup() {
    ip_header
    read -p "Domain: " domain

    if command -v nslookup >/dev/null 2>&1; then
        nslookup "$domain"
    else
        ping -c 1 "$domain"
    fi

    log_action "DNS lookup $domain"
    echo ""
    read -p "Press enter..."
}

# ==========================================
# REVERSE IP
# ==========================================
reverse_ip() {
    ip_header
    read -p "Enter IP: " ip

    if ! validate_ip "$ip"; then
        echo -e "${RED}Invalid IP${RESET}"
        sleep 1
        return
    fi

    if check_internet; then
        echo -e "${YELLOW}[+] Reverse lookup:${RESET}"
        curl -s "https://api.hackertarget.com/reverseiplookup/?q=$ip"
    else
        echo -e "${RED}No internet${RESET}"
    fi

    log_action "Reverse IP $ip"
    echo ""
    read -p "Press enter..."
}

# ==========================================
# PORT CHECK (BASIC)
# ==========================================
port_check() {
    ip_header
    read -p "IP: " ip
    read -p "Port: " port

    timeout 2 bash -c "echo > /dev/tcp/$ip/$port" 2>/dev/null \
        && echo -e "${GREEN}Port OPEN${RESET}" \
        || echo -e "${RED}Port CLOSED${RESET}"

    log_action "Port check $ip:$port"
    echo ""
    read -p "Press enter..."
}

# ==========================================
# MAIN MENU
# ==========================================
show_ip() {

while true; do
    ip_header

    echo "[1] Local IP"
    echo "[2] Public IP"
    echo "[3] Geo Location"
    echo "[4] ISP / ASN"
    echo "[5] DNS Lookup"
    echo "[6] Reverse IP"
    echo "[7] Port Check"
    echo "[0] Back"
    echo ""

    read -p "Choose: " opt

    case $opt in
        1) local_ip ;;
        2) public_ip ;;
        3) geo_lookup ;;
        4) isp_lookup ;;
        5) dns_lookup ;;
        6) reverse_ip ;;
        7) port_check ;;
        0) break ;;
        *) echo -e "${RED}Invalid option${RESET}"; sleep 1 ;;
    esac

done

}
