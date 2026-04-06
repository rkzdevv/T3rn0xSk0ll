#!/bin/bash

# ==========================================
# AIRSKULL - MAIN CORE
# ==========================================

# ==========================================
# BASE PATH
# ==========================================
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
MODULES="$BASE_DIR/modules"
LOG_DIR="$BASE_DIR/logs"
LOG_FILE="$LOG_DIR/airskull.log"

mkdir -p "$LOG_DIR"
touch "$LOG_FILE"

# ==========================================
# COLORS
# ==========================================
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
WHITE="\033[1;37m"
RESET="\033[0m"

# ==========================================
# LOGGER
# ==========================================
log_action() {
    echo "[$(date '+%H:%M:%S')] [AIRSKULL] $1" >> "$LOG_FILE" 2>/dev/null
}

# ==========================================
# ERROR HANDLER
# ==========================================
error_exit() {
    echo -e "${RED}[FATAL] $1${RESET}"
    log_action "FATAL: $1"
    exit 1
}

# ==========================================
# AUTO PERMISSIONS
# ==========================================
auto_permissions() {
    find "$BASE_DIR" -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null
    log_action "Permissions fixed"
}

auto_permissions

# ==========================================
# LOADING SYSTEM
# ==========================================
loading() {
    clear
    echo -e "${CYAN}Initializing AirSkull...${RESET}"
    sleep 0.3
    echo -e "${CYAN}Loading modules...${RESET}"
    sleep 0.3
    echo -e "${CYAN}Checking integrity...${RESET}"
    sleep 0.3
    echo -e "${GREEN}System ready.${RESET}"
    sleep 0.5
}

loading

# ==========================================
# CHECK STRUCTURE
# ==========================================
check_structure() {

    [ -d "$MODULES" ] || error_exit "Modules folder missing"
    [ -d "$LOG_DIR" ] || error_exit "Logs folder missing"

    required=(
        "interface.sh"
        "scan.sh"
        "ipinfo.sh"
        "utils.sh"
    )

    for f in "${required[@]}"; do
        if [ ! -f "$MODULES/$f" ]; then
            error_exit "Missing module: $f"
        fi
    done

    log_action "Structure OK"
}

check_structure

# ==========================================
# LOAD MODULES
# ==========================================
safe_source() {
    file="$1"

    if [ -f "$file" ]; then
        source "$file"
        log_action "Loaded $(basename $file)"
    else
        error_exit "Failed to load $file"
    fi
}

safe_source "$MODULES/utils.sh"
safe_source "$MODULES/interface.sh"
safe_source "$MODULES/scan.sh"
safe_source "$MODULES/ipinfo.sh"

# ==========================================
# DEPENDENCY CHECK
# ==========================================
check_dependencies() {

    tools=("ip" "ping" "curl")

    missing=0

    for t in "${tools[@]}"; do
        if ! command -v "$t" >/dev/null 2>&1; then
            echo -e "${RED}[MISSING] $t${RESET}"
            log_action "Missing tool: $t"
            missing=1
        fi
    done

    if [ $missing -eq 1 ]; then
        echo ""
        echo -e "${RED}Some tools are missing.${RESET}"
        echo -e "${YELLOW}Install them for full functionality.${RESET}"
    else
        echo -e "${GREEN}All core tools OK${RESET}"
    fi

    log_action "Dependency check done"
}

# ==========================================
# BANNER (SEU ORIGINAL)
# ==========================================
banner() {
clear
echo -e "${CYAN}"

cat << "EOF"

         _             _            _  _ 
        (_)           | |          | || |
   __ _  _  _ __  ___ | | __ _   _ | || |
  / _` || || '__|/ __|| |/ /| | | || || |
 | (_| || || |   \__ \|   < | |_| || || |
  \__,_||_||_|   |___/|_|\_\ \__,_||_||_|
                                         
                                         

EOF

echo -e "${GREEN}AirSkull - Network Tool${RESET}"
echo -e "${CYAN}Type 'help' to begin${RESET}"
echo ""
}

# ==========================================
# HELP MENU
# ==========================================
help_menu() {
echo ""
echo "Commands:"
echo ""
echo " interface   → manage interfaces"
echo " scan        → network scanning"
echo " ipinfo      → IP intelligence"
echo " check       → dependency check"
echo " clear       → clear screen"
echo " banner      → show banner"
echo " exit        → exit tool"
echo ""
}

# ==========================================
# SYSTEM INFO
# ==========================================
system_info() {
echo ""
echo "User: $(whoami)"
echo "Shell: $SHELL"
echo "Path: $BASE_DIR"
echo "Date: $(date)"
echo ""
log_action "Viewed system info"
}

# ==========================================
# COMMAND HANDLER
# ==========================================
handle_command() {

case "$1" in

interface)
    log_action "Opened Interface module"
    show_interfaces
    ;;

scan)
    log_action "Opened Scan module"
    scan_networks
    ;;

ipinfo)
    log_action "Opened IP module"
    show_ip
    ;;

check)
    check_dependencies
    ;;

clear)
    clear
    ;;

banner)
    banner
    ;;

help)
    help_menu
    ;;

info)
    system_info
    ;;

exit)
    echo "Exiting AirSkull..."
    log_action "Exited"
    exit 0
    ;;

*)
    echo -e "${RED}Unknown command${RESET}"
    ;;

esac

}

# ==========================================
# START
# ==========================================
banner

# ==========================================
# MAIN LOOP
# ==========================================
while true; do
read -rp "airskull> " cmd

if [ -z "$cmd" ]; then
    continue
fi

handle_command "$cmd"

done
