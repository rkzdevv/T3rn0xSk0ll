#!/bin/bash

# ==========================================
# NETWORK MODULE - CLEAN VERSION
# ==========================================

# ==========================================
# BASE PATH
# ==========================================
BASE_DIR="$HOME/T3rn0xSk0ll"
TOOLS_DIR="$BASE_DIR/tools"

# ==========================================
# COLORS
# ==========================================
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# ==========================================
# HEADER
# ==========================================
show_header() {
    clear
    echo -e "${RED}=====================================${RESET}"
    echo -e "${CYAN}     T3rn0xSk0ll - Network${RESET}"
    echo -e "${RED}=====================================${RESET}"
    echo ""
}

# ==========================================
# NMAP TOOL
# ==========================================
nmap_tool() {
    while true; do
        show_header

        echo -e "${GREEN}Nmap Scanner${RESET}"
        echo ""
        echo "[1] Quick Scan"
        echo "[2] Full Scan"
        echo "[3] Port Scan"
        echo "[0] Back"
        echo ""

        read -p "Choose: " opt

        case $opt in
            1)
                read -p "Target: " t
                [ -z "$t" ] && echo "Invalid target" && sleep 1 && continue
                nmap -F "$t"
                ;;
            2)
                read -p "Target: " t
                [ -z "$t" ] && echo "Invalid target" && sleep 1 && continue
                nmap -A "$t"
                ;;
            3)
                read -p "Target: " t
                read -p "Port: " p
                [ -z "$t" ] || [ -z "$p" ] && echo "Invalid input" && sleep 1 && continue
                nmap -p "$p" "$t"
                ;;
            0) break ;;
            *) echo "Invalid"; sleep 1 ;;
        esac

        echo ""
        read -p "Press enter..."
    done
}

# ==========================================
# NETGHOST (FIXED)
# ==========================================
netghost() {
    show_header
    echo -e "${GREEN}Launching NetGhost...${RESET}"

    if [ -f "$TOOLS_DIR/NetGhost/netghost.sh" ]; then
        (cd "$TOOLS_DIR/NetGhost" && bash netghost.sh)
    else
        echo -e "${RED}NetGhost not found!${RESET}"
        echo -e "${CYAN}Expected: $TOOLS_DIR/NetGhost/netghost.sh${RESET}"
    fi

    echo ""
    read -p "Press enter..."
}

# ==========================================
# AIRSKULL (FIXED)
# ==========================================
airskull() {
    show_header
    echo -e "${GREEN}Launching AirSkull...${RESET}"

    if [ -f "$TOOLS_DIR/airskull/airskull.sh" ]; then
        (cd "$TOOLS_DIR/airskull" && bash airskull.sh)
    else
        echo -e "${RED}AirSkull not found!${RESET}"
        echo -e "${CYAN}Expected: $TOOLS_DIR/airskull/airskull.sh${RESET}"
    fi

    echo ""
    read -p "Press enter..."
}

# ==========================================
# IP TOOLS
# ==========================================
ip_tools() {
    while true; do
        show_header

        echo -e "${GREEN}IP Tools${RESET}"
        echo ""
        echo "[1] Public IP"
        echo "[2] Lookup IP"
        echo "[3] Resolve Domain"
        echo "[0] Back"
        echo ""

        read -p "Choose: " opt

        case $opt in
            1)
                curl -s ifconfig.me
                echo ""
                ;;
            2)
                read -p "IP: " ip
                [ -z "$ip" ] && echo "Invalid IP" && sleep 1 && continue
                curl -s ipinfo.io/"$ip"
                ;;
            3)
                read -p "Domain: " d
                [ -z "$d" ] && echo "Invalid domain" && sleep 1 && continue
                ping -c 1 "$d"
                ;;
            0) break ;;
            *) echo "Invalid"; sleep 1 ;;
        esac

        echo ""
        read -p "Press enter..."
    done
}

# ==========================================
# TOOL CHECK
# ==========================================
check_tools() {
    show_header

    echo -e "${CYAN}Checking tools...${RESET}"
    echo ""

    tools=("nmap" "curl" "ip")

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

# ==========================================
# MAIN MENU
# ==========================================
while true; do
    show_header

    echo -e "${WHITE}[1] Nmap${RESET}"
    echo -e "${WHITE}[2] NetGhost${RESET}"
    echo -e "${WHITE}[3] AirSkull${RESET}"
    echo -e "${WHITE}[4] IP Tools${RESET}"
    echo -e "${WHITE}[5] Tool Check${RESET}"
    echo -e "${RED}[0] Back${RESET}"
    echo ""

    read -p "Choose: " opt

    case $opt in
        1) nmap_tool ;;
        2) netghost ;;
        3) airskull ;;
        4) ip_tools ;;
        5) check_tools ;;
        0) break ;;
        *) echo -e "${RED}Invalid option${RESET}"; sleep 1 ;;
    esac

done
