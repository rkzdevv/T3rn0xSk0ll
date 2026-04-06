#!/bin/bash

# ==============================
# BASE PATH
# ==============================
BASE_DIR="$HOME/T3rn0xSk0ll"
TOOLS_DIR="$BASE_DIR/tools"

# ==============================
# COLORS
# ==============================
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RESET="\033[0m"

# ==============================
# HEADER
# ==============================
show_header() {
    clear
    echo -e "${RED}=====================================${RESET}"
    echo -e "${CYAN}        T3rn0xSk0ll - Recon${RESET}"
    echo -e "${RED}=====================================${RESET}"
    echo ""
}

# ==============================
# SPIDER RECON
# ==============================
run_spiderrecon() {
    show_header
    echo -e "${GREEN}Running SpiderRecon...${RESET}"

    if [ -f "$TOOLS_DIR/SpiderRecon/spiderrecon.sh" ]; then
        (cd "$TOOLS_DIR/SpiderRecon" && bash spiderrecon.sh)
    else
        echo -e "${RED}SpiderRecon not found!${RESET}"
    fi

    echo ""
    read -p "Press enter..."
}

# ==============================
# CRACKFORGE
# ==============================
run_crackforge() {
    show_header
    echo -e "${GREEN}Running CrackForge...${RESET}"

    if [ -f "$TOOLS_DIR/CrackForge/crackforge.sh" ]; then
        (cd "$TOOLS_DIR/CrackForge" && bash crackforge.sh)
    else
        echo -e "${RED}CrackForge not found!${RESET}"
    fi

    echo ""
    read -p "Press enter..."
}

# ==============================
# WHOIS
# ==============================
whois_lookup() {
    show_header
    read -p "Domain: " domain
    whois "$domain"
    echo ""
    read -p "Press enter..."
}

# ==============================
# DNS
# ==============================
dns_lookup() {
    show_header
    read -p "Domain: " domain
    nslookup "$domain"
    echo ""
    read -p "Press enter..."
}

# ==============================
# HTTP HEADERS
# ==============================
http_headers() {
    show_header
    read -p "URL: " url
    curl -I "$url"
    echo ""
    read -p "Press enter..."
}

# ==============================
# IP RESOLVE
# ==============================
ip_resolve() {
    show_header
    read -p "Domain: " domain
    ping -c 1 "$domain"
    echo ""
    read -p "Press enter..."
}

# ==============================
# SUBDOMAIN CHECK
# ==============================
subdomain_check() {
    show_header
    read -p "Domain: " domain

    subs=("www" "mail" "ftp" "api" "dev")

    for sub in "${subs[@]}"; do
        host="$sub.$domain"
        ping -c 1 "$host" &>/dev/null && echo "[+] Found: $host"
    done

    echo ""
    read -p "Press enter..."
}

# ==============================
# WEB ANALYZER
# ==============================
web_analyzer() {
    show_header
    read -p "URL: " url

    echo "Status:"
    curl -o /dev/null -s -w "%{http_code}\n" "$url"

    echo ""
    echo "Server:"
    curl -sI "$url" | grep -i server

    echo ""
    echo "Response Time:"
    curl -o /dev/null -s -w "%{time_total}\n" "$url"

    echo ""
    read -p "Press enter..."
}

# ==============================
# TOOL CHECK
# ==============================
check_tools() {
    show_header
    echo -e "${CYAN}Checking tools...${RESET}"
    echo ""

    tools=("whois" "nslookup" "curl" "ping")

    for t in "${tools[@]}"; do
        if command -v "$t" &>/dev/null; then
            echo -e "$t ${GREEN}✔${RESET}"
        else
            echo -e "$t ${RED}✖${RESET}"
        fi
    done

    echo ""
    read -p "Press enter..."
}

# ==============================
# MENU
# ==============================
while true; do
    show_header

    echo -e "${WHITE}[1] SpiderRecon${RESET}"
    echo -e "${WHITE}[2] CrackForge${RESET}"
    echo -e "${WHITE}[3] Whois${RESET}"
    echo -e "${WHITE}[4] DNS${RESET}"
    echo -e "${WHITE}[5] HTTP Headers${RESET}"
    echo -e "${WHITE}[6] IP Resolve${RESET}"
    echo -e "${WHITE}[7] Subdomain${RESET}"
    echo -e "${WHITE}[8] Web Analyzer${RESET}"
    echo -e "${WHITE}[9] Tool Check${RESET}"
    echo -e "${RED}[0] Back${RESET}"
    echo ""

    read -p "Choose: " opt

    case $opt in
        1) run_spiderrecon ;;
        2) run_crackforge ;;
        3) whois_lookup ;;
        4) dns_lookup ;;
        5) http_headers ;;
        6) ip_resolve ;;
        7) subdomain_check ;;
        8) web_analyzer ;;
        9) check_tools ;;
        0) break ;;
        *) echo -e "${RED}Invalid${RESET}"; sleep 1 ;;
    esac
done
