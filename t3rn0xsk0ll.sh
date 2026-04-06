#!/bin/bash

# ==========================================
# T3rn0xSk0ll - MAIN CORE (INTERACTIVE)
# ==========================================

# ==========================================
# SAFE MODE (ANTI-CRASH)
# ==========================================
set +e

# ==========================================
# BASE PATH FIX
# ==========================================
BASE_DIR="$HOME/T3rn0xSk0ll"

cd "$BASE_DIR" || {
    echo "Project folder not found!"
    exit 1
}

# ==========================================
# INSTALL SYSTEM (TERMUX)
# ==========================================
INSTALL_FLAG=".installed"

install_system() {
echo "[+] First run detected..."
sleep 0.5

echo "[+] Updating system..."
pkg update -y && pkg upgrade -y

echo "[+] Installing core tools..."

TOOLS=(
    nmap
    curl
    whois
    openssl
    net-tools
)

for tool in "${TOOLS[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "[+] Installing $tool..."
        pkg install -y "$tool"
    else
        echo "[i] $tool already installed"
    fi
done

touch "$INSTALL_FLAG"
echo "[+] Setup complete"
sleep 1
}

if [[ ! -f "$INSTALL_FLAG" ]]; then
    install_system
fi

clear

# ==========================================
# AUTO PERMISSIONS
# ==========================================
auto_permissions() {
    echo "[+] Fixing permissions..."

    find . -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null
    chmod -R 755 . 2>/dev/null
}

auto_permissions

# ==========================================
# STRUCTURE FIX
# ==========================================
mkdir -p tools/HTMLMonster/output 2>/dev/null

# ==========================================
# COLORS
# ==========================================
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RESET="\033[0m"

# ==========================================
# LOADING
# ==========================================
loading() {
clear
echo -e "${RED}Initializing T3rn0xSk0ll...${RESET}"
sleep 0.3
echo -e "${RED}Loading modules...${RESET}"
sleep 0.3
echo -e "${RED}Checking integrity...${RESET}"
sleep 0.3
echo -e "${GREEN}System ready.${RESET}"
sleep 0.5
}

loading

# ==========================================
# CHECK MODULES
# ==========================================
check_modules() {

missing=0

modules=(
    "modules/network.sh"
    "modules/recon.sh"
    "modules/crypto.sh"
)

for mod in "${modules[@]}"; do
    if [ ! -f "$mod" ]; then
        echo -e "${RED}[ERROR] Missing module: $mod${RESET}"
        missing=1
    fi
done

# HTMLMonster check
if [ ! -f "tools/HTMLMonster/htmlmonster.sh" ]; then
    echo -e "${RED}[ERROR] HTMLMonster missing${RESET}"
    missing=1
fi

if [ $missing -eq 1 ]; then
    echo ""
    echo -e "${RED}System integrity compromised.${RESET}"
    echo -e "${RED}Fix missing files before running.${RESET}"
    exit 1
fi
}

check_modules

# ==========================================
# SAFE RUNNER
# ==========================================
run_safe() {
    if [ -f "$1" ]; then
        bash "$1"
    else
        echo -e "${RED}[ERROR] Script not found: $1${RESET}"
    fi
}

# ==========================================
# BANNER
# ==========================================
banner() {
clear
echo -e "\033[1;31m

                        *%@@@@%+=
                     @@@@@@@@@@@@@@@+
                  .@@@@@@@@@@@@@@@@@@@+
                 @@@@@@@@@@@@@@@@@@@@@@%-
                @@@@@@*-@@@@@@@%- :@@@@@+=
               *@@@.    .-@@@@@=      :@@==
               @@-       :@: @@+       -@=*=
              +@@@.      #*   @@.     :@@@#+
              #@@@@@@%@@@@     @@@@@#@@@@@#=:
              +*@@@*=#:@@@  -  @@@@@@@@@@@%*+
               @@@%=#@@@@@@@@@@@@@@%-:-%@@#*=
               +-@@::*@@@@@@@@@@@@@@   ::  +=
               @=:.   @@@#@@+@@*@@@-     : =
               .*@@   @@@%#%===@@@@-  * *- -
                #@@=@*@          :    @@+-@-
                %@@* -.  ..          -@@ %+
                  @@:.@=.@@#*-@==+*-:@@+
                  @@@@@@*++==:=+.-+@@@@
                  @@@@@@@=.-=-:+@@@@@@@
                   @@@@@@%@@%@%@@@@@@@*
                    #@@@@@@@=#@%@@@@+

\033[1;31m═══════════════════════════════════════\033[0m
\033[1;31m        Welcome to T3rn0xSk0ll\033[0m
\033[1;37m           (cybersecurity tool)\033[0m
\033[1;31m═══════════════════════════════════════\033[0m

\033[1;32mType 'help' to see commands\033[0m
"
}

# ==========================================
# HELP
# ==========================================
help_menu() {
echo ""
echo "Available commands:"
echo ""
echo " network       → open network module"
echo " recon         → open recon module"
echo " crypto        → open crypto module"
echo " htmlmonster   → open HTMLMonster"
echo " banner        → show skull"
echo " clear         → clear screen"
echo " help          → show help"
echo " exit          → quit tool"
echo ""
}

# ==========================================
# SYSTEM INFO
# ==========================================
system_info() {
echo ""
echo "User: $(whoami)"
echo "Shell: $SHELL"
echo "Date: $(date)"
echo ""
}

# ==========================================
# RUN HTMLMONSTER
# ==========================================
run_htmlmonster() {
    echo -e "${CYAN}[+] Launching HTMLMonster...${RESET}"

    if [ -d "tools/HTMLMonster" ]; then
        (cd tools/HTMLMonster && bash htmlmonster.sh)
    else
        echo -e "${RED}[ERROR] HTMLMonster directory missing${RESET}"
    fi

    echo -e "${GREEN}[+] Returned to T3rn0xSk0ll${RESET}"
    sleep 1
}

# ==========================================
# COMMAND HANDLER
# ==========================================
handle_command() {

case "$1" in

network)
    run_safe "modules/network.sh"
    ;;

recon)
    run_safe "modules/recon.sh"
    ;;

crypto)
    run_safe "modules/crypto.sh"
    ;;

htmlmonster)
    run_htmlmonster
    ;;

banner)
    banner
    ;;

clear)
    clear
    ;;

help)
    help_menu
    ;;

info)
    system_info
    ;;

exit)
    echo "Exiting..."
    exit 0
    ;;

*)
    echo "Unknown command. Type 'help'"
    ;;

esac

}

# ==========================================
# START
# ==========================================
banner

# ==========================================
# LOOP
# ==========================================
while true; do
read -rp "t3rn0xsk0ll> " cmd
handle_command "$cmd"
done
