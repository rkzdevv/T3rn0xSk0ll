#!/bin/bash

# ==========================================
# UTILS MODULE - AIRSKULL CORE
# ==========================================

# ==========================================
# COLORS
# ==========================================
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
WHITE="\033[1;37m"
RESET="\033[0m"

LOG_FILE="../logs/airskull.log"

# ==========================================
# LOGGER SAFE
# ==========================================
safe_log() {
    mkdir -p ../logs 2>/dev/null
    touch "$LOG_FILE" 2>/dev/null
    echo "[$(date '+%H:%M:%S')] [UTILS] $1" >> "$LOG_FILE" 2>/dev/null
}

# ==========================================
# SAFE EXEC
# ==========================================
safe_exec() {
    cmd="$1"
    eval "$cmd" 2>/dev/null

    if [ $? -ne 0 ]; then
        echo -e "${RED}[ERROR executing] $cmd${RESET}"
        safe_log "Failed: $cmd"
    else
        safe_log "Executed: $cmd"
    fi
}

# ==========================================
# CHECK COMMAND
# ==========================================
require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo -e "${RED}[MISSING] $1${RESET}"
        safe_log "Missing command: $1"
        return 1
    fi
    return 0
}

# ==========================================
# LOADING ANIMATION
# ==========================================
loading() {
    msg="$1"
    echo -ne "${CYAN}$msg${RESET}"

    for i in {1..5}; do
        echo -ne "."
        sleep 0.2
    done

    echo ""
    safe_log "Loading: $msg"
}

# ==========================================
# PROGRESS BAR
# ==========================================
progress_bar() {
    duration=$1

    for ((i=0; i<=duration; i++)); do
        percent=$(( (i * 100) / duration ))
        bar=$(printf "%-${percent}s" "#" | tr ' ' '#')

        echo -ne "\r[${bar:0:50}] $percent%"
        sleep 0.05
    done

    echo ""
    safe_log "Progress completed"
}

# ==========================================
# VALIDATE DOMAIN
# ==========================================
validate_domain() {
    domain="$1"
    [[ "$domain" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}

# ==========================================
# VALIDATE IP
# ==========================================
validate_ip() {
    ip="$1"
    [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]
}

# ==========================================
# NETWORK CHECK
# ==========================================
check_network() {
    ping -c 1 8.8.8.8 &>/dev/null

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[ONLINE]${RESET}"
        safe_log "Network OK"
        return 0
    else
        echo -e "${RED}[OFFLINE]${RESET}"
        safe_log "Network DOWN"
        return 1
    fi
}

# ==========================================
# CLEAR SCREEN SAFE
# ==========================================
safe_clear() {
    command -v clear >/dev/null && clear
}

# ==========================================
# RANDOM STRING
# ==========================================
random_string() {
    length=${1:-16}
    tr -dc 'A-Za-z0-9!@#$%&*' < /dev/urandom | head -c "$length"
    echo ""
    safe_log "Generated random string ($length)"
}

# ==========================================
# RANDOM PORT
# ==========================================
random_port() {
    port=$(( ( RANDOM % 65535 )  + 1 ))
    echo "$port"
    safe_log "Generated port $port"
}

# ==========================================
# SYSTEM INFO
# ==========================================
system_info() {
    echo -e "${CYAN}User:${RESET} $(whoami)"
    echo -e "${CYAN}Shell:${RESET} $SHELL"
    echo -e "${CYAN}Date:${RESET} $(date)"
    echo -e "${CYAN}Kernel:${RESET} $(uname -r)"

    safe_log "System info viewed"
}

# ==========================================
# CHECK DEPENDENCIES
# ==========================================
check_dependencies() {
    echo -e "${YELLOW}Checking dependencies...${RESET}"
    echo ""

    deps=("ip" "ping" "curl" "nmap")

    for d in "${deps[@]}"; do
        if command -v "$d" >/dev/null 2>&1; then
            echo -e "$d ${GREEN}✔${RESET}"
        else
            echo -e "$d ${RED}✖${RESET}"
        fi
    done

    safe_log "Dependency check"
}

# ==========================================
# ERROR HANDLER
# ==========================================
error_exit() {
    echo -e "${RED}[FATAL ERROR] $1${RESET}"
    safe_log "Fatal: $1"
    exit 1
}

# ==========================================
# SAFE READ INPUT
# ==========================================
safe_input() {
    read -rp "$1" input
    echo "$input"
}

# ==========================================
# FILE EXISTS CHECK
# ==========================================
file_check() {
    if [ ! -f "$1" ]; then
        echo -e "${RED}File not found: $1${RESET}"
        safe_log "Missing file: $1"
        return 1
    fi
    return 0
}

# ==========================================
# DIR EXISTS CHECK
# ==========================================
dir_check() {
    if [ ! -d "$1" ]; then
        echo -e "${RED}Directory not found: $1${RESET}"
        safe_log "Missing dir: $1"
        return 1
    fi
    return 0
}

# ==========================================
# TIME STAMP
# ==========================================
timestamp() {
    date "+%Y-%m-%d_%H-%M-%S"
}

# ==========================================
# EXPORT SAFE
# ==========================================
export_result() {
    file="result_$(timestamp).txt"
    echo "$1" > "$file"
    echo -e "${GREEN}Saved to $file${RESET}"

    safe_log "Exported result to $file"
}

# ==========================================
# CPU LOAD (SIMPLE)
# ==========================================
cpu_load() {
    uptime | awk -F'load average:' '{ print $2 }'
    safe_log "CPU load checked"
}

# ==========================================
# MEMORY USAGE
# ==========================================
memory_usage() {
    free -h
    safe_log "Memory checked"
}

# ==========================================
# END OF UTILS
# ==========================================
